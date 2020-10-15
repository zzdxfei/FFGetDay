function! IsLeapYear(year)
    let year = a:year
    if year % 400 == 0
        return v:true
    endif
    if year % 100 != 0 && year % 4 == 0
        return v:true
    endif
    return v:false
endfunction

function! GetDaysFromYearMouth(y, m)
    let year = a:y
    let mouth = a:m
    let day31 = [1, 3, 5, 7, 8, 10, 12]
    if count(day31, mouth) == 1
        return 31
    endif
    if mouth == 2
        return 28 + IsLeapYear(year)
    endif
    return 30
endfunction

function! GetDayAfterDuring(begin_date, during)
    let begin_date = a:begin_date
    let during = a:during
    let end_date = begin_date
    while during > 0
        let end_date[2] = end_date[2] + 1
        if end_date[2] > GetDaysFromYearMouth(end_date[0], end_date[1])
            let end_date[1] += 1
            let end_date[2] = 1
            if end_date[1] > 12
                let end_date[0] += 1
                let end_date[1] = 1
            endif
        endif
        let during -= 1
    endwhile
    return end_date
endfunction

let s:begin_date = [2020, 8, 17]
command! -nargs=1 FFGetDay :echo GetDayAfterDuring(deepcopy(s:begin_date), <args>)
