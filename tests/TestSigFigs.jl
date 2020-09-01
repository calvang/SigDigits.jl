using Test
import SigFigs.count_sigdigits

@testset "Individual significant figures" begin
    @test count_sigdigits(0.0000007) == 1
    @test count_sigdigits(5.034001) == 7
    @test count_sigdigits(7000) == 1
    @test count_sigdigits(1.000) == 1
    @test count_sigdigits(6.983410) == 6
    @test count_sigdigits(14080.093149) == 11
end

