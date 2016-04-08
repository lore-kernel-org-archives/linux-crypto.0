From: "Jonas Eymann" <J.Eymann@gmx.net>
Subject: ppc/talitos oops on call to crypto_alloc_aead
Date: Fri, 8 Apr 2016 15:40:12 +0200
Message-ID: <trinity-775586e1-fc1a-4b40-97c7-bdf9f609c0cd-1460122812303@3capp-gmx-bs64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55773 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbcDHNkQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Apr 2016 09:40:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

running a current 4.4.6 kernel on a board using a Freescale P1020, I ran into an oops when calling crypto_alloc_aead using the talitos driver. I could also reproduce this using the run-time self tests:

[...]
[    1.141095] talitos ffe30000.crypto: hwrng
[    1.145381] Unable to handle kernel paging request for data at address 0x00000058
[    1.152913] Faulting instruction address: 0xc02accc0
[    1.157910] Oops: Kernel access of bad area, sig: 11 [#1]
[    1.163315] SMP NR_CPUS=2 P1020 RDB
[    1.166810] Modules linked in:
[    1.169875] CPU: 0 PID: 1007 Comm: cryptomgr_test Not tainted 4.4.6 #1
[    1.176415] task: db5ec200 ti: db4d6000 task.ti: db4d6000
[    1.181821] NIP: c02accc0 LR: c02acd18 CTR: c02acd04
[    1.186793] REGS: db4d7d30 TRAP: 0300   Not tainted  (4.4.6)
[    1.192457] MSR: 00029000 <CE,EE,ME>  CR: 95009359  XER: e0000000
[    1.198585] DEAR: 00000058 ESR: 00000000 
GPR00: c017bdc0 db4d7de0 db5ec200 df424b48 00000000 00000000 df424bfc db75a600 
GPR08: df424b48 00000000 db75a628 db4d6000 00000149 00000000 c0044cac db5acda0 
GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00000400 df424940 
GPR24: df424900 00003083 00000400 c0180000 db75a640 c03e9f84 df424b40 df424b48 
[    1.230978] NIP [c02accc0] talitos_cra_init+0x28/0x6c
[    1.236039] LR [c02acd18] talitos_cra_init_aead+0x14/0x28
[    1.241443] Call Trace:
[    1.243894] [db4d7de0] [c03e9f84] 0xc03e9f84 (unreliable)
[    1.249322] [db4d7df0] [c017bdc0] crypto_create_tfm+0x5c/0xf0
[    1.255083] [db4d7e10] [c017beec] crypto_alloc_tfm+0x98/0xf8
[    1.260769] [db4d7e40] [c0186a20] alg_test_aead+0x28/0xc8
[    1.266181] [db4d7e60] [c0186718] alg_test+0x260/0x2e0
[    1.271333] [db4d7ee0] [c0183860] cryptomgr_test+0x30/0x54
[    1.276843] [db4d7ef0] [c0044d80] kthread+0xd4/0xd8
[    1.281741] [db4d7f40] [c000e4a4] ret_from_kernel_thread+0x5c/0x64
[    1.287930] Instruction dump:
[    1.290902] 38600000 4e800020 81230028 7c681b78 81490010 38e9ffc0 3929ffe8 554a073e 
[    1.298691] 2b8a000a 7d474f9e 812a0008 91230030 <80e90058> 39270060 7c0004ac 7cc04828 
[    1.306676] ---[ end trace 4b725069552c2912 ]---
[    1.311298] 

In a first attempt to fix this problem using the patch further below, I could prevent the oops, though the self tests still fail:

[...]
[    1.145414] alg: aead: Test 1 failed on encryption for authenc-hmac-sha1-cbc-aes-talitos
[    1.153564] 00000000: 53 69 6e 67 6c 65 20 62 6c 6f 63 6b 20 6d 73 67
[    1.160041] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.166509] 00000020: 00 00 00 00
[    1.170041] alg: aead: Test 1 failed on encryption for authenc-hmac-sha1-cbc-3des-talitos
[    1.178276] 00000000: 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72 73 74
[    1.184751] 00000010: 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63 74 65
[    1.191220] 00000020: 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72
[    1.197689] 00000030: 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63
[    1.204158] 00000040: 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65
[    1.210626] 00000050: 65 72 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53
[    1.217095] 00000060: 72 63 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20
[    1.223563] 00000070: 63 65 65 72 73 74 54 20 6f 6f 4d 20 6e 61 0a 79
[    1.230038] 00000080: de ad be ef de ad be ef de ad be ef de ad be ef
[    1.236515] 00000090: de ad be ef
[...]
[    1.651807] alg: No test for authenc(hmac(md5),cbc(aes)) (authenc-hmac-md5-cbc-aes-talitos)
[    1.660371] alg: No test for authenc(hmac(md5),cbc(des3_ede)) (authenc-hmac-md5-cbc-3des-talitos)
[    1.669576] talitos ffe30000.crypto: md5-talitos alg registration failed
[    1.676331] talitos ffe30000.crypto: sha1-talitos alg registration failed
[    1.683155] talitos ffe30000.crypto: sha224-talitos alg registration failed
[    1.690153] talitos ffe30000.crypto: sha256-talitos alg registration failed
[    1.697150] talitos ffe30000.crypto: sha384-talitos alg registration failed
[    1.704148] talitos ffe30000.crypto: sha512-talitos alg registration failed
[    1.711146] talitos ffe30000.crypto: hmac-md5-talitos alg registration failed
[    1.718317] talitos ffe30000.crypto: hmac-sha1-talitos alg registration failed
[    1.725581] talitos ffe30000.crypto: hmac-sha224-talitos alg registration failed
[    1.733014] talitos ffe30000.crypto: hmac-sha256-talitos alg registration failed
[    1.740446] talitos ffe30000.crypto: hmac-sha384-talitos alg registration failed
[    1.747878] talitos ffe30000.crypto: hmac-sha512-talitos alg registration failed
[    1.755310] talitos ffe30000.crypto: fsl,sec3.3 algorithms registered in /proc/crypto


I'm unsure whether or not this is related to the talitos driver not being able to register the hash algorithms (as it does not yet implement state import/export functions).
Can anyone generally confirm the problem on a P1020 or other CPU using the talitos driver and/or knows how to fix the remaining issues?
 
Thanks a lot in advance,
Jonas


---
Patch:

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2519,21 +2519,10 @@ struct talitos_crypto_alg {
 	struct talitos_alg_template algt;
 };
 
-static int talitos_cra_init(struct crypto_tfm *tfm)
+static int talitos_init_common(struct talitos_ctx *ctx, struct talitos_crypto_alg *talitos_alg)
 {
-	struct crypto_alg *alg = tfm->__crt_alg;
-	struct talitos_crypto_alg *talitos_alg;
-	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct talitos_private *priv;
 
-	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_AHASH)
-		talitos_alg = container_of(__crypto_ahash_alg(alg),
-					   struct talitos_crypto_alg,
-					   algt.alg.hash);
-	else
-		talitos_alg = container_of(alg, struct talitos_crypto_alg,
-					   algt.alg.crypto);
-
 	/* update context with ptr to dev */
 	ctx->dev = talitos_alg->dev;
 
@@ -2551,10 +2540,33 @@ static int talitos_cra_init(struct crypt
 	return 0;
 }
 
+static int talitos_cra_init(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct talitos_crypto_alg *talitos_alg;
+	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_AHASH)
+		talitos_alg = container_of(__crypto_ahash_alg(tfm),
+					   struct talitos_crypto_alg,
+					   algt.alg.hash);
+	else
+		talitos_alg = container_of(alg, struct talitos_crypto_alg,
+					   algt.alg.crypto);
+
+	return talitos_init_common(ctx, talitos_alg);
+}
+
 static int talitos_cra_init_aead(struct crypto_aead *tfm)
 {
-	talitos_cra_init(crypto_aead_tfm(tfm));
-	return 0;
+	struct aead_alg *alg = crypto_aead_alg(tfm);
+	struct talitos_crypto_alg *talitos_alg;
+	talitos_alg = container_of(alg,
+				struct talitos_crypto_alg,
+				algt.alg.aead);
+	struct talitos_ctx *ctx = crypto_aead_ctx(tfm);
+	
+	return talitos_init_common(ctx, talitos_alg);
 }
 
 static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
