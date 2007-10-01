From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Tcrypt output for HIFN 795x driver.
Date: Mon, 1 Oct 2007 16:51:06 +0400
Message-ID: <20071001125105.GA19945@2ka.mipt.ru>
References: <20071001124822.GA16017@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53498 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbXJAMvZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Oct 2007 08:51:25 -0400
Content-Disposition: inline
In-Reply-To: <20071001124822.GA16017@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Notice that 'testing ecb(aes) decryption across pages (chunking)' fails.
I will investigate this further.

[  628.851890] testing ecb(aes) encryption
[  628.857498] hifn_cra_init: tfm: ffff81003a8739c8, dev: hifn0 [ffff81003dd7c2c8].
[  628.865046] test 1 (128 bit key):
[  628.868505] hifn_setkey: tfm: ffff81003a8739c8, ctx: ffff81003a873a08, dev: hifn0 [ffff81003dd7c2c8], len: 16.
[  628.878679] hifn_setup_crypto: req: ffff81003a873f20, tfm: ffff81003a8739c8, ctx: ffff81003a873a08, keylen: 16.
[  628.888943] hifn_setup_session: start
[  628.892652] cmd: i=1, u=0, k=1
[  628.895752] src: i=1, u=1, k=0
[  628.898852] dst: i=1, u=1, k=0
[  628.901952] res: i=1, u=0, k=1
[  628.905054] hifn0: iv: 0000000000000000 [0], key: ffff81003a873a08 [16], mode: 0, op: 1, type: 0.
[  628.913996] hifn0: 1 dmacsr: 8898888c, dmareg: 22322023, res: 00100000 [2], i: 1.2.2.1, u: 2.2.2.2.
[  628.923104] hifn0: ring cleanup 1: i: 2.2.2.2, u: 1.2.2.1, k: 1.0.0.1.
[  628.929676] hifn0: ring cleanup 2: i: 2.2.2.2, u: 0.2.2.0, k: 2.0.0.2.
[  628.937082] 69c4e0d86a7b0430d8cdb78070b4c55a
[  628.942302] pass
[  628.944280] test 2 (192 bit key):
[  628.947732] hifn_setkey: tfm: ffff81003a8739c8, ctx: ffff81003a873a08, dev: hifn0 [ffff81003dd7c2c8], len: 24.
[  628.957917] hifn_setup_crypto: req: ffff81003a873f20, tfm: ffff81003a8739c8, ctx: ffff81003a873a08, keylen: 24.
[  628.968159] hifn_setup_session: start
[  628.971870] cmd: i=2, u=0, k=2
[  628.974969] src: i=2, u=2, k=0
[  628.978069] dst: i=2, u=2, k=0
[  628.981169] res: i=2, u=0, k=2
[  628.984271] hifn0: iv: 0000000000000000 [0], key: ffff81003a873a08 [24], mode: 0, op: 1, type: 1.
[  628.993214] hifn0: 1 dmacsr: 8898888c, dmareg: 22322023, res: 00100000 [3], i: 1.3.3.1, u: 3.3.3.3.
[  629.002321] hifn0: ring cleanup 1: i: 3.3.3.3, u: 1.3.3.1, k: 2.0.0.2.
[  629.008894] hifn0: ring cleanup 2: i: 3.3.3.3, u: 0.3.3.0, k: 3.0.0.3.
[  629.016167] dda97ca4864cdfe06eaf70a0ec0d7191
[  629.021398] pass
[  629.023376] test 3 (256 bit key):
[  629.026827] hifn_setkey: tfm: ffff81003a8739c8, ctx: ffff81003a873a08, dev: hifn0 [ffff81003dd7c2c8], len: 32.
[  629.037001] hifn_setup_crypto: req: ffff81003a873f20, tfm: ffff81003a8739c8, ctx: ffff81003a873a08, keylen: 32.
[  629.047247] hifn_setup_session: start
[  629.050956] cmd: i=3, u=0, k=3
[  629.054055] src: i=3, u=3, k=0
[  629.057158] dst: i=3, u=3, k=0
[  629.060258] res: i=3, u=0, k=3
[  629.063359] hifn0: iv: 0000000000000000 [0], key: ffff81003a873a08 [32], mode: 0, op: 1, type: 2.
[  629.072302] hifn0: 1 dmacsr: 8898888c, dmareg: 22322023, res: 00100000 [4], i: 1.4.4.1, u: 4.4.4.4.
[  629.081408] hifn0: ring cleanup 1: i: 4.4.4.4, u: 1.4.4.1, k: 3.0.0.3.
[  629.087980] hifn0: ring cleanup 2: i: 4.4.4.4, u: 0.4.4.0, k: 4.0.0.4.
[  629.095353] 8ea2b7ca516745bfeafc49904b496089
[  629.100581] pass
[  629.102558] 
[  629.102558] testing ecb(aes) encryption across pages (chunking)
[  629.110232] 
[  629.110233] testing ecb(aes) decryption
[  629.115822] hifn_cra_init: tfm: ffff81003a873f20, dev: hifn0 [ffff81003dd7c2c8].
[  629.123369] test 1 (128 bit key):
[  629.126833] hifn_setkey: tfm: ffff81003a873f20, ctx: ffff81003a873f60, dev: hifn0 [ffff81003dd7c2c8], len: 16.
[  629.136996] hifn_setup_crypto: req: ffff81003a8739c8, tfm: ffff81003a873f20, ctx: ffff81003a873f60, keylen: 16.
[  629.147271] hifn_setup_session: start
[  629.150976] cmd: i=4, u=0, k=4
[  629.154076] src: i=4, u=4, k=0
[  629.157176] dst: i=4, u=4, k=0
[  629.160277] res: i=4, u=0, k=4
[  629.163379] hifn0: iv: 0000000000000000 [0], key: ffff81003a873f60 [16], mode: 0, op: 0, type: 0.
[  629.172322] hifn0: 1 dmacsr: 8898888c, dmareg: 22322023, res: 00100000 [5], i: 1.5.5.1, u: 5.5.5.5.
[  629.181428] hifn0: ring cleanup 1: i: 5.5.5.5, u: 1.5.5.1, k: 4.0.0.4.
[  629.188000] hifn0: ring cleanup 2: i: 5.5.5.5, u: 0.5.5.0, k: 5.0.0.5.
[  629.195404] 00112233445566778899aabbccddeeff
[  629.200642] pass
[  629.207471] test 2 (192 bit key):
[  629.210924] hifn_setkey: tfm: ffff81003a873f20, ctx: ffff81003a873f60, dev: hifn0 [ffff81003dd7c2c8], len: 24.
[  629.221079] hifn_setup_crypto: req: ffff81003a8739c8, tfm: ffff81003a873f20, ctx: ffff81003a873f60, keylen: 24.
[  629.231323] hifn_setup_session: start
[  629.235034] cmd: i=5, u=0, k=5
[  629.238135] src: i=5, u=5, k=0
[  629.241235] dst: i=5, u=5, k=0
[  629.244336] res: i=5, u=0, k=5
[  629.247437] hifn0: iv: 0000000000000000 [0], key: ffff81003a873f60 [24], mode: 0, op: 0, type: 1.
[  629.256379] hifn0: 1 dmacsr: 8898888c, dmareg: 22322023, res: 00100000 [6], i: 1.6.6.1, u: 6.6.6.6.
[  629.265486] hifn0: ring cleanup 1: i: 6.6.6.6, u: 1.6.6.1, k: 5.0.0.5.
[  629.272059] hifn0: ring cleanup 2: i: 6.6.6.6, u: 0.6.6.0, k: 6.0.0.6.
[  629.279309] 00112233445566778899aabbccddeeff
[  629.284545] pass
[  629.286543] test 3 (256 bit key):
[  629.290001] hifn_setkey: tfm: ffff81003a873f20, ctx: ffff81003a873f60, dev: hifn0 [ffff81003dd7c2c8], len: 32.
[  629.300171] hifn_setup_crypto: req: ffff81003a8739c8, tfm: ffff81003a873f20, ctx: ffff81003a873f60, keylen: 32.
[  629.310424] hifn_setup_session: start
[  629.314131] cmd: i=6, u=0, k=6
[  629.317231] src: i=6, u=6, k=0
[  629.320330] dst: i=6, u=6, k=0
[  629.323430] res: i=6, u=0, k=6
[  629.326532] hifn0: iv: 0000000000000000 [0], key: ffff81003a873f60 [32], mode: 0, op: 0, type: 2.
[  629.335473] hifn0: 1 dmacsr: 8898888c, dmareg: 22322023, res: 00100000 [7], i: 1.7.7.1, u: 7.7.7.7.
[  629.344573] hifn0: ring cleanup 1: i: 7.7.7.7, u: 1.7.7.1, k: 6.0.0.6.
[  629.351146] hifn0: ring cleanup 2: i: 7.7.7.7, u: 0.7.7.0, k: 7.0.0.7.
[  629.358529] 00112233445566778899aabbccddeeff
[  629.363762] pass
[  629.365742] 
[  629.365743] testing ecb(aes) decryption across pages (chunking)
[  629.373421] 
[  629.373422] testing cbc(aes) encryption
[  629.379011] hifn_cra_init: tfm: ffff81003a8739c8, dev: hifn0 [ffff81003dd7c2c8].
[  629.386560] test 1 (128 bit key):
[  629.390012] hifn_setkey: tfm: ffff81003a8739c8, ctx: ffff81003a873a08, dev: hifn0 [ffff81003dd7c2c8], len: 16.
[  629.400170] hifn_setup_crypto: req: ffff81003a873f20, tfm: ffff81003a8739c8, ctx: ffff81003a873a08, keylen: 16.
[  629.410430] hifn_setup_session: start
[  629.414143] cmd: i=7, u=0, k=7
[  629.417241] src: i=7, u=7, k=0
[  629.420342] dst: i=7, u=7, k=0
[  629.423442] res: i=7, u=0, k=7
[  629.426543] hifn0: iv: 0000000000000000 [0], key: ffff81003a873a08 [16], mode: 1, op: 1, type: 0.
[  629.435484] hifn0: 1 dmacsr: 8898888c, dmareg: 22322023, res: 00100000 [8], i: 1.8.8.1, u: 8.8.8.8.
[  629.444585] hifn0: ring cleanup 1: i: 8.8.8.8, u: 1.8.8.1, k: 7.0.0.7.
[  629.451156] hifn0: ring cleanup 2: i: 8.8.8.8, u: 0.8.8.0, k: 8.0.0.8.
[  629.458574] 3b629d77f45eff9817c5849f9a0aba71
[  629.463817] fail
[  629.465795] test 2 (128 bit key):
[  629.469246] hifn_setkey: tfm: ffff81003a8739c8, ctx: ffff81003a873a08, dev: hifn0 [ffff81003dd7c2c8], len: 16.
[  629.479405] hifn_setup_crypto: req: ffff81003a873f20, tfm: ffff81003a8739c8, ctx: ffff81003a873a08, keylen: 16.
[  629.489649] hifn_setup_session: start
[  629.493359] cmd: i=8, u=0, k=8
[  629.496458] src: i=8, u=8, k=0
[  629.499558] dst: i=8, u=8, k=0
[  629.502661] res: i=8, u=0, k=8
[  629.505760] hifn0: iv: 0000000000000000 [0], key: ffff81003a873a08 [16], mode: 1, op: 1, type: 0.
[  629.514704] hifn0: 1 dmacsr: 8898888c, dmareg: 22322023, res: 00100000 [9], i: 1.9.9.1, u: 9.9.9.9.
[  629.523810] hifn0: ring cleanup 1: i: 9.9.9.9, u: 1.9.9.1, k: 8.0.0.8.
[  629.530383] hifn0: ring cleanup 2: i: 9.9.9.9, u: 0.9.9.0, k: 9.0.0.9.
[  629.537784] bd0cb8b2220fab0cf10079d1b48ffde82b8bae025030fb5245010d5b7f1fc8c4
[  629.546619] fail
[  629.548600] 
[  629.548601] testing cbc(aes) encryption across pages (chunking)
[  629.556264] 
[  629.556265] testing cbc(aes) decryption
[  629.561849] hifn_cra_init: tfm: ffff81003a873f20, dev: hifn0 [ffff81003dd7c2c8].
[  629.569412] test 1 (128 bit key):
[  629.572868] hifn_setkey: tfm: ffff81003a873f20, ctx: ffff81003a873f60, dev: hifn0 [ffff81003dd7c2c8], len: 16.
[  629.583026] hifn_setup_crypto: req: ffff81003a8739c8, tfm: ffff81003a873f20, ctx: ffff81003a873f60, keylen: 16.
[  629.593270] hifn_setup_session: start
[  629.596981] cmd: i=9, u=0, k=9
[  629.600081] src: i=9, u=9, k=0
[  629.603181] dst: i=9, u=9, k=0
[  629.606283] res: i=9, u=0, k=9
[  629.609384] hifn0: iv: 0000000000000000 [0], key: ffff81003a873f60 [16], mode: 1, op: 0, type: 0.
[  629.618327] hifn0: 1 dmacsr: 8898888c, dmareg: 22322023, res: 00100000 [10], i: 1.10.10.1, u: 10.10.10.10.
[  629.628039] hifn0: ring cleanup 1: i: 10.10.10.10, u: 1.10.10.1, k: 9.0.0.9.
[  629.635131] hifn0: ring cleanup 2: i: 10.10.10.10, u: 0.10.10.0, k: 10.0.0.10.
[  629.643103] 8d95a3b9e1823aeaff452dc6b285c73c
[  629.648346] fail
[  629.650323] test 2 (128 bit key):
[  629.653776] hifn_setkey: tfm: ffff81003a873f20, ctx: ffff81003a873f60, dev: hifn0 [ffff81003dd7c2c8], len: 16.
[  629.663960] hifn_setup_crypto: req: ffff81003a8739c8, tfm: ffff81003a873f20, ctx: ffff81003a873f60, keylen: 16.
[  629.674202] hifn_setup_session: start
[  629.677914] cmd: i=10, u=0, k=10
[  629.681186] src: i=10, u=10, k=0
[  629.684460] dst: i=10, u=10, k=0
[  629.687734] res: i=10, u=0, k=10
[  629.691008] hifn0: iv: 0000000000000000 [0], key: ffff81003a873f60 [16], mode: 1, op: 0, type: 0.
[  629.699951] hifn0: 1 dmacsr: 8898888c, dmareg: 22322023, res: 00100000 [11], i: 1.11.11.1, u: 11.11.11.11.
[  629.709663] hifn0: ring cleanup 1: i: 11.11.11.11, u: 1.11.11.1, k: 10.0.0.10.
[  629.716946] hifn0: ring cleanup 2: i: 11.11.11.11, u: 0.11.11.0, k: 11.0.0.11.
[  629.725063] 23a975b74c30c4d6ce38d6dcf0f57be6101112131415161718191a1b1c1d1e1f
[  629.733895] fail
-- 
	Evgeniy Polyakov
