# Tests de la Tarea1 (`intervalos.jl`), sin usar redondeo.

using Test

# include("../intervalos.jl")

using .Intervalos

u = Intervalo(1.0)
z = Intervalo(0.0)
a = Intervalo(1.5, 2.5)
b = Intervalo(1, 3)
c = Intervalo(BigFloat("0.1"), big(0.1))
d = Intervalo(-1, 1)
emptyFl = intervalo_vacio(Float64)
emptyB = intervalo_vacio(BigFloat)

@testset "Creación de intervalos" begin
    @test typeof(a) == Intervalo{Float64}
    @test getfield(a, :infimo) == 1.5
    @test getfield(a, :supremo) == 2.5

    @test typeof(b) == Intervalo{Float64}
    @test getfield(b, :infimo) == 1.0
    @test getfield(b, :supremo) == 3.0

    @test typeof(c) == Intervalo{BigFloat}
    @test getfield(c, :infimo) == BigFloat("0.1")
    @test getfield(c, :supremo) == big(0.1)

    @test typeof(emptyFl) == Intervalo{Float64}
    @test typeof(emptyB) == Intervalo{BigFloat}

    @test u == Intervalo(1.0)
    @test z == Intervalo(0.0)
    @test z == Intervalo(big(0.0))
end

@testset "Operaciones de conjuntos" begin
    @test a == a
    @test a !== b
    @test c == c
    @test emptyFl == emptyB
    @test a ⊆ a
    @test a ⊆ b
    @test emptyFl ⊆ b
    @test b ⊇ a
    @test c ⊆ c
    @test !(c ⊆ b) && !(b ⊆ c)
    @test a ⪽ b
    @test emptyFl ⪽ b
    @test !(c ⪽ c)
    @test a ∪ b == b
    @test a ⊔ b == b
    @test a ∪ emptyFl == a
    @test c ⊔ emptyB == c
    @test a ∩ b == a
    @test a ∩ emptyFl == emptyFl
    @test a ∩ c == emptyB
    @test 0 ∈ z
    @test 2 ∈ a
    @test 3 ∉ a
    @test 0.1 ∈ c
end

@testset "Operaciones aritméticas" begin
    @test emptyFl + z == emptyFl
    @test z + z == Intervalo(prevfloat(0.0), nextfloat(0.0))
    @test u + z == u + 0.0
    @test z - u == 0.0-u
    @test -u ⪽ z - u
    @test b + 1 == 1.0 + b == Intervalo(prevfloat(2.0), nextfloat(4.0))
    @test d ⪽ 2*(a - 2)
    @test c - 0.1 !== z
    @test emptyFl * z == emptyFl
    @test Intervalo(0.1, 0.1) ⪽ 0.1 * u
    @test Intervalo(-0.1, 0.1) ⪽ d * 0.1
    @test d * (a + b) ⊆ d*a + d*b
    @test d^1 == d
    @test d^2 == Intervalo(0, nextfloat(1.0))
    @test emptyB^2 == emptyB
    @test emptyFl^3 == emptyFl
    @test Intervalo(0,Inf) * u == Intervalo(prevfloat(0.0), Inf)
    @test Intervalo(-Inf,Inf) * z == z
    @test emptyFl * z == emptyFl
    @test d ⪽ d*d
    @test d ⪽ d^3
    @test d^4 == d^2
    @test a / emptyFl == emptyFl
    @test emptyB / c == emptyB
    @test emptyFl / emptyFl == emptyFl
    @test u/d == Intervalo(-Inf, Inf)
    @test inv(Intervalo(0.0)) == emptyFl
    @test 0.5 ∈ u/a
    @test 1 ∈ a/a
    @test c^-1 == 1/c
    @test inv(a) == 1/a
    @test (a-1)*(a-2) ⪽ (a*a -3*a + 3)
    @test a/d == Intervalo(-Inf, Inf)
    @test z/z == intervalo_vacio(z)
    @test u ⪽ 1/u
    @test all(division_extendida(u,z) .== (emptyFl,))
    @test all(division_extendida(z,z) .== (Intervalo(-Inf,Inf),))
    @test all(division_extendida(u,u) .== (u/u,))
    @test all(division_extendida(u, Intervalo(0,1)) .== (u/Intervalo(0,1),))
    @test all(division_extendida(u,d) .== (u/Intervalo(-1,0), u/Intervalo(0,1)))
end