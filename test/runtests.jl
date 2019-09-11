using Test

using ABIF
using FormatSpecimens

@testset "ABIF Reader" begin

    function check_abif_parse(filename)
        stream = open(ABIF.Reader, filename)

        for record in stream end
        for (a,b) in collect(stream[1]) end
        for (a,b) in getindex(stream, ABIF.get_tags(stream)) end
        @test typeof(stream) == ABIF.Reader{IOStream}
        @test ABIF.get_tags(stream)[1].name == "AEPt"
        @test ABIF.get_tags(stream, "DATA")[1].name == "DATA"
        @test length(stream["DATA"]) == 12
        @test length(stream[1]) == 1

        @test typeof(getindex(stream, ABIF.get_tags(stream))) == Dict{String,Any}
        @test ABIF.tagelements(stream, "DATA") == 12
    end

    println("Good ab1:")
    for file in list_valid_specimens("ABI")
        filepath = joinpath(path_of_format("ABI"), filename(file))
        println("\t",filepath)
        check_abif_parse(filepath)
    end
    println("Bad ab1:")
    for file in list_invalid_specimens("ABI")
        filepath = joinpath(path_of_format("ABI"), filename(file))
        println("\t",filepath)
        @test_throws Exception check_abif_parse(filepath)
    end

end
