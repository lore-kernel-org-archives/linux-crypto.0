From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] crypto: drop unnecessary return statements
Date: Mon, 28 Aug 2017 22:00:07 +0800
Message-ID: <b17223142fc680eb5cca9964ba9451f59cc16076.1502447442.git.geliangtang@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix checkpatch.pl warnings:

WARNING: void function return statements are not generally useful
FILE: crypto/rmd128.c:218:
FILE: crypto/rmd160.c:261:
FILE: crypto/rmd256.c:233:
FILE: crypto/rmd320.c:280:
FILE: crypto/tcrypt.c:385:
FILE: drivers/crypto/ixp4xx_crypto.c:538:
FILE: drivers/crypto/marvell/cesa.c:81:
FILE: drivers/crypto/ux500/cryp/cryp_core.c:1755:

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 crypto/rmd128.c                       | 2 --
 crypto/rmd160.c                       | 2 --
 crypto/rmd256.c                       | 2 --
 crypto/rmd320.c                       | 2 --
 crypto/tcrypt.c                       | 1 -
 drivers/crypto/ixp4xx_crypto.c        | 1 -
 drivers/crypto/marvell/cesa.c         | 2 --
 drivers/crypto/ux500/cryp/cryp_core.c | 1 -
 8 files changed, 13 deletions(-)

diff --git a/crypto/rmd128.c b/crypto/rmd128.c
index 049486e..40e053b 100644
--- a/crypto/rmd128.c
+++ b/crypto/rmd128.c
@@ -213,8 +213,6 @@ static void rmd128_transform(u32 *state, const __le32 *in)
 	state[2] = state[3] + aa + bbb;
 	state[3] = state[0] + bb + ccc;
 	state[0] = ddd;
-
-	return;
 }
 
 static int rmd128_init(struct shash_desc *desc)
diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index de585e5..5f3e6ea 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -256,8 +256,6 @@ static void rmd160_transform(u32 *state, const __le32 *in)
 	state[3] = state[4] + aa + bbb;
 	state[4] = state[0] + bb + ccc;
 	state[0] = ddd;
-
-	return;
 }
 
 static int rmd160_init(struct shash_desc *desc)
diff --git a/crypto/rmd256.c b/crypto/rmd256.c
index 4ec02a7..f50c025 100644
--- a/crypto/rmd256.c
+++ b/crypto/rmd256.c
@@ -228,8 +228,6 @@ static void rmd256_transform(u32 *state, const __le32 *in)
 	state[5] += bbb;
 	state[6] += ccc;
 	state[7] += ddd;
-
-	return;
 }
 
 static int rmd256_init(struct shash_desc *desc)
diff --git a/crypto/rmd320.c b/crypto/rmd320.c
index 770f2cb..e1315e4 100644
--- a/crypto/rmd320.c
+++ b/crypto/rmd320.c
@@ -275,8 +275,6 @@ static void rmd320_transform(u32 *state, const __le32 *in)
 	state[7] += ccc;
 	state[8] += ddd;
 	state[9] += eee;
-
-	return;
 }
 
 static int rmd320_init(struct shash_desc *desc)
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 0022a18..4b20d99 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -381,7 +381,6 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	testmgr_free_buf(xbuf);
 out_noxbuf:
 	kfree(iv);
-	return;
 }
 
 static void test_hash_sg_init(struct scatterlist *sg)
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index dadc4a8..8705b28 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -534,7 +534,6 @@ static void release_ixp_crypto(struct device *dev)
 			NPE_QLEN_TOTAL * sizeof( struct crypt_ctl),
 			crypt_virt, crypt_phys);
 	}
-	return;
 }
 
 static void reset_sa_dir(struct ix_sa_dir *dir)
diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 6e7a5c7..b657e7c 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -76,8 +76,6 @@ static void mv_cesa_rearm_engine(struct mv_cesa_engine *engine)
 
 	ctx = crypto_tfm_ctx(req->tfm);
 	ctx->ops->step(req);
-
-	return;
 }
 
 static int mv_cesa_std_process(struct mv_cesa_engine *engine, u32 status)
diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 790f7ca..765f53e 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1751,7 +1751,6 @@ static void __exit ux500_cryp_mod_fini(void)
 {
 	pr_debug("[%s] is called!", __func__);
 	platform_driver_unregister(&cryp_driver);
-	return;
 }
 
 module_init(ux500_cryp_mod_init);
-- 
2.9.3
