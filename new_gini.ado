

program define new_gini, rclass
    version 14.0

    syntax , Income(varname) Weight(varname) [State(varname) Rural(varname)]

    // Gini nacional
    preserve
    quietly sort `income'
    quietly gen income_w = `income' * `weight'
    quietly sum income_w
    quietly scalar total_income = r(sum)
    quietly sum `weight'
    quietly scalar total_pop = r(sum)
    quietly gen wgt_cum = sum(`weight')
    quietly gen pop_share = `weight' / total_pop
    quietly gen pop_cum = wgt_cum / total_pop
    quietly gen income_cum = sum(income_w)
    quietly gen income_share = income_w / total_income
    quietly gen income_cumshare = income_cum / total_income
    quietly gen gini_component = (pop_cum - pop_cum[_n-1])*(income_cumshare + income_cumshare[_n-1]) if _n > 1
    quietly replace gini_component = pop_cum * income_cumshare if _n == 1
    quietly egen gini_sum = total(gini_component)
    quietly gen ginix = 1 - gini_sum
    quietly sum ginix
    quietly scalar gini_result = r(mean)

    display as text "Gini coefficient (national): " as result %6.4f gini_result
    return scalar gini = gini_result

    // Guardar archivo temporal
    tempfile original
    capture quietly save `original', replace

    // Gini por estado si se especifica
    if "`state'" != "" {
        display ""
        display as text "Gini coefficient by state:"
        levelsof `state', local(states)
        foreach s of local states {
            use `original', clear
            quietly keep if `state' == `s'
            quietly capture drop income_w wgt_cum income_cum income_share income_cumshare gini_component ginix gini_sum pop_share pop_cum
            quietly sort `income'
            quietly gen income_w = `income' * `weight'
            quietly sum income_w
            scalar total_income = r(sum)
            quietly sum `weight'
            scalar total_pop = r(sum)
            quietly gen wgt_cum = sum(`weight')
            quietly gen pop_cum = wgt_cum / total_pop
            quietly gen income_cum = sum(income_w)
            quietly gen income_cumshare = income_cum / total_income
            quietly gen gini_component = (pop_cum - pop_cum[_n-1])*(income_cumshare + income_cumshare[_n-1]) if _n > 1
            quietly replace gini_component = pop_cum * income_cumshare if _n == 1
            quietly egen gini_sum = total(gini_component)
            quietly gen ginix = 1 - gini_sum
            quietly sum ginix
            scalar gini_state = r(mean)
            display as text "`state' = `s': " as result %6.4f gini_state
        }
    }

    // Gini por rural/urbano si se especifica
    if "`rural'" != "" {
        display ""
        display as text "Gini coefficient by rural/urban (or other group):"
        levelsof `rural', local(areas)
        foreach a of local areas {
            use `original', clear
            quietly keep if `rural' == `a'
            quietly capture drop income_w wgt_cum income_cum income_share income_cumshare gini_component ginix gini_sum pop_share pop_cum
            quietly sort `income'
            quietly gen income_w = `income' * `weight'
            quietly sum income_w
            scalar total_income = r(sum)
            quietly sum `weight'
            scalar total_pop = r(sum)
            quietly gen wgt_cum = sum(`weight')
            quietly gen pop_cum = wgt_cum / total_pop
            quietly gen income_cum = sum(income_w)
            quietly gen income_cumshare = income_cum / total_income
            quietly gen gini_component = (pop_cum - pop_cum[_n-1])*(income_cumshare + income_cumshare[_n-1]) if _n > 1
            quietly replace gini_component = pop_cum * income_cumshare if _n == 1
            quietly egen gini_sum = total(gini_component)
            quietly gen ginix = 1 - gini_sum
            quietly sum ginix
            scalar gini_area = r(mean)
            display as text "`rural' = `a': " as result %6.4f gini_area
        }
    }

    use `original', clear
    restore
end





















