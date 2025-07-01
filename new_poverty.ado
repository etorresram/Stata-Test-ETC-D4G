

program define new_poverty, rclass

    version 14.0

    syntax , Income(varname) Weight(varname) [Line(real 3) State(varname) Rural(varname)]

    preserve

    quietly gen poor1 = `income' < `line'
    quietly label variable poor1 "Poverty rate $`line'/day (2021 PPP)"
  

    display as text "Poverty line: $" %4.2f `line' " (2021 PPP)"
    display as text "Poverty rate (national):"
    mean poor1 [aw=`weight']

    if "`state'" != "" {
    display ""
    display as text "Poverty rate by state:"
    mean poor1 [aw=`weight'], over(`state')
    }

    if "`rural'" != "" {
    display ""
    display as text "Poverty rate by rural/urban (or other):"
    mean poor1 [aw=`weight'], over(`rural')
    }

    restore
end







