package jbwj

import org.kohsuke.args4j.Option
import org.kohsuke.args4j.spi.BooleanOptionHandler
import java.nio.file.Paths


object Args {

    @Option(name = "-jar", usage = "JarInput", required = true)
    var jarFileName: String = ""

    @Option(name = "-f", usage = "FunctionNameForFuzz", required = true)
    var funcName: String = ""

    @Option(name = "-t", usage = "TimeForTimeOutTargetOnTests", required = false)
    var timeOut: String = "5000"

    @Option(name = "-i", usage = "inputDirectory", required = false)
    var inputDir: String = ".\\input"

    @Option(name = "-o", usage = "outputDirectory", required = false)
    var outDir: String = ".\\out"

    @Option(name = "-cores", usage = "NumberOfCores", required = false)
    var cores: Int = 1

    @Option(name = "-D", usage = "DynamoRIODirectory", required = false)
    var DRIO: String = ".\\DynamoRIO-Windows-8.0.18712\\bin64"

    @Option(name = "-rsi", usage = "RegexToIncludeSortOutputExceptions", required = false)
    var regexToIncludeSort: String = ""

    @Option(name = "-rse", usage = "RegexToExcludeSortOutputExceptions", required = false)
    var regexToExcludeSort: String = ""

    @Option(name = "-dllAs", handler = BooleanOptionHandler::class, usage = "OnDLLAssemble", required = false)
    var dllAs = false

    val jarName: String by lazy {
        Paths.get(jarFileName).fileName.toString().split(".")[0]
    }

}
