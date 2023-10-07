contract pathchTran() {

    address[3] ab = {[0xFd0118047d6d489Cb21b327F4084AFCE06f0bAf9],
                    [0xF473801F2CCA7c18DABf068a494CF88387779326],
                    [0x23db1cfa010D387Ca9B9C4FeA42a506171A5a2c9]}


    function ai() {
        for (i = 0; i < 3; i++) {
            usdtToken.transfer(ab[i], 10000);
        }
    }
}