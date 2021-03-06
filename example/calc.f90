program calc

    use calculate_fortran
    implicit none

    type(Expression) :: expr
    character(len=256) :: vars
    character(len=64) :: error
    real(kind=8), dimension(:), allocatable :: vals
    real(kind=8) :: result

    character(len=256) :: arg
    integer :: count
    integer :: i

    count = command_argument_count()
    if (mod(count, 2) == 1) then
        vars = ''
        do i = 2, count, 2
            call get_command_argument(i, arg)
            write(vars, '(3A)') trim(vars), ',', trim(arg)
        end do
        vars = vars(2 :)
        call get_command_argument(1, arg)

        expr = calculate%Expression(arg, vars=vars, error=error)

        if (expr%check()) then
            allocate (vals((count - 1) / 2))
            do i = 3, count, 2
                call get_command_argument(i, arg)
                read(arg, *) vals(i - (i + 1) / 2)
            end do

            result = expr%evaluate(vals, error=error)
            if (len(trim(error)) == 0) then
                print '(A)', 'Expression:'
                print '(A)', trim(expr%expression())
                print '(A)', 'Variables:'
                print '(A)', trim(expr%variables())
                print '(A)', 'Infix notation:'
                print '(A)', trim(expr%infix())
                print '(A)', 'Postfix notation:'
                print '(A)', trim(expr%postfix())
                print '(A)', 'Expression tree:'
                print '(A)', trim(expr%tree())
                print '(A)', 'Result:'
                print '(ES14.6E3)', result
            else
                print '(A)', error
            end if

            deallocate (vals)
            call expr%clear()
        else
            print '(A)', trim(error)
        end if
    end if

end program
