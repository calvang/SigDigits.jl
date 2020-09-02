import SigDigits.use_sigdigits
import SigDigits.count_sigdigits

@testset "Individual significant digits" begin
    @test count_sigdigits(0.0000007) == 1
    @test count_sigdigits(5.034001) == 7
    @test count_sigdigits(7000) == 1
    @test count_sigdigits(1.000) == 1
    @test count_sigdigits(6.983410) == 6
    @test count_sigdigits(14080.093149) == 11
end

@testset "Simple expression significant digits" begin
    @test use_sigdigits("5.4+3.5") == 8.9
    @test use_sigdigits("5.4-3.5") == 1.9
    @test use_sigdigits("5.4*3.5") == 19
    @test use_sigdigits("5.4/3.5") == 1.5
    @test use_sigdigits("5.402+3.5") == 8.9
    @test use_sigdigits("5.402-3.5") == 1.9
    @test use_sigdigits("5.402*3.5") == 19
    @test use_sigdigits("5.402/3.5") == 1.5
end

@testset "Compound expression significant digits" begin
    @test use_sigdigits("(8.958*1398.002/23.95)/(150.005)") == 3.486
    @test use_sigdigits("(8.958*1398.002/23.95)/(150.005/0.01 - 45.29*-3.59/-0.59)") == 0.04
    @test use_sigdigits("(8.958*1398.002+293.45/23.95)/(150.005/0.01 - 45.29*-3.59/-0.59)") == 0.9
end