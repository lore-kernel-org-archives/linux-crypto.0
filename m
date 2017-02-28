From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Problem with RSA test from testmgr
Date: Tue, 28 Feb 2017 16:59:53 +0100
Message-ID: <20170228155953.GA1732@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

hello

I work on the sun8i-ce crypto accelerator and I have some problem with the RSA part.

The RSA register fail at the first RSA test (encrypt 512bit) with this output:
[ 8480.146843] alg: akcipher: encrypt test failed. Invalid output
[ 8480.146871] 00000000: 6e 7c 8a 75 e7 30 80 d1 5e ab 9b db a2 cf ed db
[ 8480.146897] 00000010: c9 b2 db 43 bd 9a b9 75 27 f3 73 d9 73 b7 81 8c
[ 8480.146921] 00000020: 49 e8 45 fc 43 44 f5 6d f0 f7 b8 f2 ae 6b ae 49
[ 8480.146946] 00000030: 1b 8e 50 c6 88 4e 99 09 78 14 f2 5d 99 c3 7f f9
[ 8480.146995] alg: akcipher: test 1 failed for rsa-sun8i-ce, err=-22

But with the same parameters (msg, n, e) openssl give me exactly this output.

So what I miss for made it work ?
In which format testmgr expect the output data ?

Thanks
Regards
Corentin Labbe
