From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 3/8] DRBG: remove superflowous checks
Date: Sun, 17 Aug 2014 17:38:29 +0200
Message-ID: <2680437.d0CEplkviS@myon.chronox.de>
References: <7044529.FG2KhbPc9P@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7044529.FG2KhbPc9P@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The crypto_init and crypto_fini functions are always implemented. Thus,
there is no need for a protecting check.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 8a95ca8..89d732b 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1381,11 +1381,9 @@ static int drbg_generate(struct drbg_state *drbg,
 		shadow->seeded = false;
 
 	/* allocate cipher handle */
-	if (shadow->d_ops->crypto_init) {
-		len = shadow->d_ops->crypto_init(shadow);
-		if (len)
-			goto err;
-	}
+	len = shadow->d_ops->crypto_init(shadow);
+	if (len)
+		goto err;
 
 	if (shadow->pr || !shadow->seeded) {
 		pr_devel("DRBG: reseeding before generation (prediction "
@@ -1467,8 +1465,7 @@ static int drbg_generate(struct drbg_state *drbg,
 #endif
 
 err:
-	if (shadow->d_ops->crypto_fini)
-		shadow->d_ops->crypto_fini(shadow);
+	shadow->d_ops->crypto_fini(shadow);
 	drbg_restore_shadow(drbg, &shadow);
 	return len;
 }
@@ -1562,11 +1559,10 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 		return ret;
 
 	ret = -EFAULT;
-	if (drbg->d_ops->crypto_init && drbg->d_ops->crypto_init(drbg))
+	if (drbg->d_ops->crypto_init(drbg))
 		goto err;
 	ret = drbg_seed(drbg, pers, false);
-	if (drbg->d_ops->crypto_fini)
-		drbg->d_ops->crypto_fini(drbg);
+	drbg->d_ops->crypto_fini(drbg);
 	if (ret)
 		goto err;
 
-- 
1.9.3
