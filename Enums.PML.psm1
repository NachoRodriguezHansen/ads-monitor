# =========================
# PML / PackML ENUM DEFINITIONS
# =========================

$EnumMaps = @{
    "eStateV3" = @{
        0  = "UNDEFINED"
        1  = "CLEARING"
        2  = "STOPPED"
        3  = "STARTING"
        4  = "IDLE"
        5  = "SUSPENDED"
        6  = "EXECUTE"
        7  = "STOPPING"
        8  = "ABORTING"
        9  = "ABORTED"
        10 = "HOLDING"
        11 = "HELD"
        12 = "UNHOLDING"
        13 = "SUSPENDING"
        14 = "UNSUSPENDING"
        15 = "RESETTING"
        16 = "COMPLETING"
        17 = "COMPLETE"
    }

    "eModeV3" = @{
        0 = "Invalid"
        1 = "Production"
        2 = "Maintenance"
        3 = "Manual"
    }
}

Export-ModuleMember -Variable EnumMaps
