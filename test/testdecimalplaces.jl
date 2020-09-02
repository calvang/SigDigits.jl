import SigDigits.count_digits
import SigDigits.count_decimalplaces
import SigDigits.count_nonzero_decimalplaces

@testset "Total digits" begin
    @test count_digits(0.0000007) == 8
    @test count_digits(5.034001) == 7
    @test count_digits(7000) == 4
    @test count_digits(1.000) == 1
    @test count_digits(6.983410) == 6
    @test count_digits(14080.093149) == 11
end

@testset "Decimal places" begin
    @test count_decimalplaces(0.0000007) == 7
    @test count_decimalplaces(5.034001) == 6
    @test count_decimalplaces(7000) == 0
    @test count_decimalplaces(1.000) == 0
    @test count_decimalplaces(6.983410) == 5
    @test count_decimalplaces(14080.093149) == 6
end

@testset "Nonzero decimal places" begin
    @test count_nonzero_decimalplaces(0.0000007) == 1
    @test count_nonzero_decimalplaces(5.034001) == 3
    @test count_nonzero_decimalplaces(7000) == 0
    @test count_nonzero_decimalplaces(1.000) == 0
    @test count_nonzero_decimalplaces(6.983410) == 5
    @test count_nonzero_decimalplaces(14080.093149) == 5
end

