local test = {
	SomeFunc = function()
		print("Hello World")
	end
}

test.initial = false
test:SomeFunc()
