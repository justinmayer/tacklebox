function _increment -d "Increment an integer variable by one"
    set $argv[1] (math $$argv[1]+1)
end
