#Script Creado por Pablo Torrejón - Marzo 2021
#Permite cambiar rapidamente el maximo uso de procesador en el plan de energia
#Util para bajar la temperatura de los procesadores Ryzen


$DATA_RAW_ALTERNA = powercfg -Q SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX | Select-String -Pattern "corriente alterna actual"
$DATA_RAW_CONTINUA = powercfg -Q SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX | Select-String -Pattern "corriente continua actual"

$GET_LINEA_ALTERNA = $DATA_RAW_ALTERNA.Line
$GET_LINEA_CONTINUA = $DATA_RAW_CONTINUA.Line

$GET_LINEA_ALTERNA_LIMPIAR = $GET_LINEA_ALTERNA.Split(':')[1]
$GET_LINEA_CONTINUA_LIMPIAR = $GET_LINEA_CONTINUA.Split(':')[1]

$CURRENT_PROCTHROTTLEMAX_ALTERNA = [INT]$GET_LINEA_ALTERNA_LIMPIAR.Split('')[1]
$CURRENT_PROCTHROTTLEMAX_CONTINUA = [INT]$GET_LINEA_CONTINUA_LIMPIAR.Split('')[1]

Write-Host "--- Estado actual maximo uso de procesador ---"
Write-Host "Valor corriente alterna : " $CURRENT_PROCTHROTTLEMAX_ALTERNA
Write-Host "Valor corriente continua : " $CURRENT_PROCTHROTTLEMAX_CONTINUA
Write-Host "----------------------------------------------"



if ( $CURRENT_PROCTHROTTLEMAX_ALTERNA -eq 100 ) {
    $confirmation = Read-Host "¿Desea Disminuir el maximo a 99% ? (presiones 'y' para proceder) "
    if ($confirmation -eq 'y') 
        {
        powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99
        powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99
        }
    else
        {
        Write-Host " Se mantienen valores actuales de 100%"
        }
}
ElseIf ( $CURRENT_PROCTHROTTLEMAX_ALTERNA -eq 99 ) {

    $confirmation = Read-Host "¿Desea Aumentar el maximo a 100% ? (presiones 'y' para proceder) "
    if ($confirmation -eq 'y') 
        {
        powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
        powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
        }
    else
        {
        Write-Host " Se mantienen valores actuales de 99%"
        }
}
Else {
    Write-Host "No se realiza acción"
}

