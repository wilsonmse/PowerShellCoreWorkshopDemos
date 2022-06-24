[CmdletBinding()]
param (
    [int]$raio
)
begin {
    $pi = [math]::PI
}

process {
    $circunferencia = 2*$pi*$raio
}

end {
    return $circunferencia
}