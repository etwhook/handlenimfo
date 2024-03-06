import winim

type
    SYSTEM_HANDLE_TABLE_ENTRY_INFO* = object
     UniqueProcessId: USHORT
     CreatorBackTraceIndex: USHORT
     ObjectTypeIndex: UCHAR
     HandleAttributes: UCHAR
     HandleValue: USHORT
     Object: PVOID
     GrantedAccess: ULONG

    SYSTEM_HANDLE_INFORMATION* = object
     NumberOfHandles: ULONG
     Handles: array[1000_000_0,SYSTEM_HANDLE_TABLE_ENTRY_INFO]


var retlen: ULONG = 0.ULONG

var hti: ptr SYSTEM_HANDLE_INFORMATION = cast[ptr SYSTEM_HANDLE_INFORMATION](HeapAlloc(GetProcessHeap(),HEAP_ZERO_MEMORY,1024*1024*2))

NtQuerySystemInformation(
    0x10,
    hti,
    1024*1024*2,
    &retlen
)

echo(hti.NumberOfHandles)

for i in 0..hti.NumberOfHandles:
    var hInfo: SYSTEM_HANDLE_TABLE_ENTRY_INFO = cast[SYSTEM_HANDLE_TABLE_ENTRY_INFO](hti.Handles[i])
    let addrs = cast[PVOID](hInfo.Object)
    let PID = cast[DWORD](hInfo.UniqueProcessId)
    echo("Handle at 0x" & repr(addrs) & " PID: " & $PID)
