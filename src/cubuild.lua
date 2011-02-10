print("Welcome to cubuild!")
print("Current directory: " .. lfs.currentdir())

testobj = {}
testobj.target = "awesome"
testobj.defines = {"NDEBUG", "RELEASE"}
testobj.options = {"-Wall", "-O2"}

print(json.stringify(testobj))
