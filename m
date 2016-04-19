From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 1/2] crypto: talitos - fix crash in talitos_cra_init()
Date: Tue, 19 Apr 2016 20:33:47 +0300
Message-ID: <1461087228-19359-2-git-send-email-horia.geanta@nxp.com>
References: <AM2PR04MB067377F55DDE5D5EE126EBF3986B0@AM2PR04MB0673.eurprd04.prod.outlook.com>
 <1461087228-19359-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, Jonas Eymann <J.Eymann@gmx.net>,
	"David S. Miller" <davem@davemloft.net>, <stable@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0086.outbound.protection.outlook.com ([207.46.100.86]:1856
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932129AbcDSSIQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2016 14:08:16 -0400
In-Reply-To: <1461087228-19359-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Jonas Eymann <J.Eymann@gmx.net>

Conversion of talitos driver to the new AEAD interface
hasn't been properly tested.

AEAD algorithms crash in talitos_cra_init as follows:

[...]
[    1.141095] talitos ffe30000.crypto: hwrng
[    1.145381] Unable to handle kernel paging request for data at addre=
ss 0x00000058
[    1.152913] Faulting instruction address: 0xc02accc0
[    1.157910] Oops: Kernel access of bad area, sig: 11 [#1]
[    1.163315] SMP NR_CPUS=3D2 P1020 RDB
[    1.166810] Modules linked in:
[    1.169875] CPU: 0 PID: 1007 Comm: cryptomgr_test Not tainted 4.4.6 =
#1
[    1.176415] task: db5ec200 ti: db4d6000 task.ti: db4d6000
[    1.181821] NIP: c02accc0 LR: c02acd18 CTR: c02acd04
[    1.186793] REGS: db4d7d30 TRAP: 0300   Not tainted  (4.4.6)
[    1.192457] MSR: 00029000 <CE,EE,ME>  CR: 95009359  XER: e0000000
[    1.198585] DEAR: 00000058 ESR: 00000000
GPR00: c017bdc0 db4d7de0 db5ec200 df424b48 00000000 00000000 df424bfc d=
b75a600
GPR08: df424b48 00000000 db75a628 db4d6000 00000149 00000000 c0044cac d=
b5acda0
GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00000400 d=
f424940
GPR24: df424900 00003083 00000400 c0180000 db75a640 c03e9f84 df424b40 d=
f424b48
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
[    1.290902] 38600000 4e800020 81230028 7c681b78 81490010 38e9ffc0 39=
29ffe8 554a073e
[    1.298691] 2b8a000a 7d474f9e 812a0008 91230030 <80e90058> 39270060 =
7c0004ac 7cc04828

Cc: <stable@vger.kernel.org> # 4.3+
=46ixes: aeb4c132f33d ("crypto: talitos - Convert to new AEAD interface=
")
Signed-off-by: Jonas Eymann <J.Eymann@gmx.net>

=46ix typo - replaced parameter of __crypto_ahash_alg(): s/tfm/alg
Remove checkpatch warnings.
Add commit message.

Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
---
 drivers/crypto/talitos.c | 41 +++++++++++++++++++++++++++-------------=
-
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a0d4a08313ae..35198804d6d3 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2629,21 +2629,11 @@ struct talitos_crypto_alg {
 	struct talitos_alg_template algt;
 };
=20
-static int talitos_cra_init(struct crypto_tfm *tfm)
+static int talitos_init_common(struct talitos_ctx *ctx,
+			       struct talitos_crypto_alg *talitos_alg)
 {
-	struct crypto_alg *alg =3D tfm->__crt_alg;
-	struct talitos_crypto_alg *talitos_alg;
-	struct talitos_ctx *ctx =3D crypto_tfm_ctx(tfm);
 	struct talitos_private *priv;
=20
-	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) =3D=3D CRYPTO_ALG_TYPE_AH=
ASH)
-		talitos_alg =3D container_of(__crypto_ahash_alg(alg),
-					   struct talitos_crypto_alg,
-					   algt.alg.hash);
-	else
-		talitos_alg =3D container_of(alg, struct talitos_crypto_alg,
-					   algt.alg.crypto);
-
 	/* update context with ptr to dev */
 	ctx->dev =3D talitos_alg->dev;
=20
@@ -2661,10 +2651,33 @@ static int talitos_cra_init(struct crypto_tfm *=
tfm)
 	return 0;
 }
=20
+static int talitos_cra_init(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg =3D tfm->__crt_alg;
+	struct talitos_crypto_alg *talitos_alg;
+	struct talitos_ctx *ctx =3D crypto_tfm_ctx(tfm);
+
+	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) =3D=3D CRYPTO_ALG_TYPE_AH=
ASH)
+		talitos_alg =3D container_of(__crypto_ahash_alg(alg),
+					   struct talitos_crypto_alg,
+					   algt.alg.hash);
+	else
+		talitos_alg =3D container_of(alg, struct talitos_crypto_alg,
+					   algt.alg.crypto);
+
+	return talitos_init_common(ctx, talitos_alg);
+}
+
 static int talitos_cra_init_aead(struct crypto_aead *tfm)
 {
-	talitos_cra_init(crypto_aead_tfm(tfm));
-	return 0;
+	struct aead_alg *alg =3D crypto_aead_alg(tfm);
+	struct talitos_crypto_alg *talitos_alg;
+	struct talitos_ctx *ctx =3D crypto_aead_ctx(tfm);
+
+	talitos_alg =3D container_of(alg, struct talitos_crypto_alg,
+				   algt.alg.aead);
+
+	return talitos_init_common(ctx, talitos_alg);
 }
=20
 static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
--=20
2.4.4
