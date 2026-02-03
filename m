Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9AD359704
	for <linux-crypto@vger.kernel.org>; Tue,  3 Feb 2026 18:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770143183; cv=none; b=HNZpJgR1FokZbvWdPOUn+XCCu6eQmY/Klt52bCj1kBY6jXOj5Jx3H2T3PGU1A0HdsZDKGrkft3AYltcGXRgggSLxV3ol2+PKXsbFmT5kViQAaQEhDiTfEiebuQKsylgs2eblVypiiZYyT3n4bGmhT17vPYLnf5IrjHG24Pqdigc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770143183; c=relaxed/simple;
	bh=v8aX2M6ZUqcxtYxv8IcCnzdlPeQ1Urd7UgtbZGW7rL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jx4jLFCY2dxFVdYItgLrJEcH7sxrIm/1XuEzm6HNxMxEwRYQ4hzJgLSRrsIG/Nz45jDQApwMDPuN4qel8elQwiBEb+ZE0cVIRz/q0gSqWThrz6T6iOUx+OsR568lYYC8iOgiKqlqyeFin6sJxZZpI8Euuq6VSkWdfEqAyug/wCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=pzj1pFH8; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="pzj1pFH8"
Received: (wp-smtpd smtp.wp.pl 22497 invoked from network); 3 Feb 2026 19:26:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1770143177; bh=6aojxvEeqg3Hqbr6Ug4eHYjHVCYw+1Z0kW35rYwAJeM=;
          h=From:To:Cc:Subject;
          b=pzj1pFH8k1VUjGIj3fKwTvtUYRh9uelTCrfl2srWnMXmIdZbm5B63hpp/lEDJBmRa
           8/E5NVP2/gW58LSz8nFKEahGTx0snsQotTwGKwWHZPHdT4sgYN2r2gY9IPnYL295p+
           lAj/eEacfY+XX0hHyUa3IPQsPzGoHmRpNC+i9rHMT5q9OfRhrCs7Ig6fhmGWiBsmG7
           fZrGrYBpnVCM/jUNrLKOczuhSDdtl0tJs8htzhV4N0wCahb1mzmC7eLh2UhGKaMLuf
           nD2Okzq2eUzgftWKr+VoArAADzV4xI+rUDUCD+wp9dDOJjmWFbWjj/sYYLgoFRDBEx
           4MVisQtpigm7A==
Received: from 83.5.238.100.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.5.238.100])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <atenart@kernel.org>; 3 Feb 2026 19:26:16 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: atenart@kernel.org,
	herbert@gondor.apana.org.a,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH v2 2/2] crypto: safexcel - Add support for authenc(hmac(md5),*) suites
Date: Tue,  3 Feb 2026 19:21:52 +0100
Message-ID: <20260203182610.8672-2-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260203182610.8672-1-olek2@wp.pl>
References: <20260203182610.8672-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: 2baeeee1b5fa5334223f418a2d362ca7
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [cfq0]                               

This patch adds support for the following AEAD ciphersuites:
- authenc(hmac(md5),cbc(aes))
- authenc(hmac(md5),cbc(des)))
- authenc(hmac(md5),cbc(des3_ede))
- authenc(hmac(md5),rfc3686(ctr(aes)))

The first three ciphersuites were tested using testmgr and the recently
sent test vectors. They passed self-tests.

This is enhanced version of the patch found in the mtk-openwrt-feeds repo.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
- fix copy-paste mistake for the rfc3686(ctr(aes)) variant
- mention performed tests
---
 drivers/crypto/inside-secure/safexcel.c       |   4 +
 drivers/crypto/inside-secure/safexcel.h       |   4 +
 .../crypto/inside-secure/safexcel_cipher.c    | 149 ++++++++++++++++++
 3 files changed, 157 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 9c00573abd8c..b6a87cca2c62 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1204,11 +1204,13 @@ static struct safexcel_alg_template *safexcel_algs[] = {
 	&safexcel_alg_hmac_sha256,
 	&safexcel_alg_hmac_sha384,
 	&safexcel_alg_hmac_sha512,
+	&safexcel_alg_authenc_hmac_md5_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha1_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha224_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha256_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha384_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha512_cbc_aes,
+	&safexcel_alg_authenc_hmac_md5_ctr_aes,
 	&safexcel_alg_authenc_hmac_sha1_ctr_aes,
 	&safexcel_alg_authenc_hmac_sha224_ctr_aes,
 	&safexcel_alg_authenc_hmac_sha256_ctr_aes,
@@ -1240,11 +1242,13 @@ static struct safexcel_alg_template *safexcel_algs[] = {
 	&safexcel_alg_hmac_sha3_256,
 	&safexcel_alg_hmac_sha3_384,
 	&safexcel_alg_hmac_sha3_512,
+	&safexcel_alg_authenc_hmac_md5_cbc_des3_ede,
 	&safexcel_alg_authenc_hmac_sha1_cbc_des3_ede,
 	&safexcel_alg_authenc_hmac_sha256_cbc_des3_ede,
 	&safexcel_alg_authenc_hmac_sha224_cbc_des3_ede,
 	&safexcel_alg_authenc_hmac_sha512_cbc_des3_ede,
 	&safexcel_alg_authenc_hmac_sha384_cbc_des3_ede,
+	&safexcel_alg_authenc_hmac_md5_cbc_des,
 	&safexcel_alg_authenc_hmac_sha1_cbc_des,
 	&safexcel_alg_authenc_hmac_sha256_cbc_des,
 	&safexcel_alg_authenc_hmac_sha224_cbc_des,
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index ca012e2845f7..52fd460c0e9b 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -945,11 +945,13 @@ extern struct safexcel_alg_template safexcel_alg_hmac_sha224;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha256;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha384;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha512;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_md5_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_md5_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes;
@@ -981,11 +983,13 @@ extern struct safexcel_alg_template safexcel_alg_hmac_sha3_224;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_256;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_384;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_512;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_md5_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des3_ede;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_md5_cbc_des;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des;
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 919e5a2cab95..be480e0c0ebf 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -17,6 +17,7 @@
 #include <crypto/internal/des.h>
 #include <crypto/gcm.h>
 #include <crypto/ghash.h>
+#include <crypto/md5.h>
 #include <crypto/poly1305.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
@@ -462,6 +463,9 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	/* Auth key */
 	switch (ctx->hash_alg) {
+	case CONTEXT_CONTROL_CRYPTO_ALG_MD5:
+		alg = "safexcel-md5";
+		break;
 	case CONTEXT_CONTROL_CRYPTO_ALG_SHA1:
 		alg = "safexcel-sha1";
 		break;
@@ -1662,6 +1666,42 @@ static int safexcel_aead_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int safexcel_aead_md5_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_cra_init(tfm);
+	ctx->hash_alg = CONTEXT_CONTROL_CRYPTO_ALG_MD5;
+	ctx->state_sz = MD5_DIGEST_SIZE;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_md5_cbc_aes = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_MD5,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = AES_BLOCK_SIZE,
+		.maxauthsize = MD5_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(md5),cbc(aes))",
+			.cra_driver_name = "safexcel-authenc-hmac-md5-cbc-aes",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_md5_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
 static int safexcel_aead_sha1_cra_init(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -1842,6 +1882,43 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes = {
 	},
 };
 
+static int safexcel_aead_md5_des3_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_md5_cra_init(tfm);
+	ctx->alg = SAFEXCEL_3DES; /* override default */
+	ctx->blocksz = DES3_EDE_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_md5_cbc_des3_ede = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_MD5,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES3_EDE_BLOCK_SIZE,
+		.maxauthsize = MD5_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
+			.cra_driver_name = "safexcel-authenc-hmac-md5-cbc-des3_ede",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_md5_des3_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
 static int safexcel_aead_sha1_des3_cra_init(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -2027,6 +2104,43 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des3_ede = {
 	},
 };
 
+static int safexcel_aead_md5_des_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_md5_cra_init(tfm);
+	ctx->alg = SAFEXCEL_DES; /* override default */
+	ctx->blocksz = DES_BLOCK_SIZE;
+	ctx->ivmask = EIP197_OPTION_2_TOKEN_IV_CMD;
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_md5_cbc_des = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_DES | SAFEXCEL_ALG_MD5,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = DES_BLOCK_SIZE,
+		.maxauthsize = MD5_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(md5),cbc(des))",
+			.cra_driver_name = "safexcel-authenc-hmac-md5-cbc-des",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_md5_des_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
 static int safexcel_aead_sha1_des_cra_init(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -2212,6 +2326,41 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des = {
 	},
 };
 
+static int safexcel_aead_md5_ctr_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	safexcel_aead_md5_cra_init(tfm);
+	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD; /* override default */
+	return 0;
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_md5_ctr_aes = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_MD5,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt,
+		.decrypt = safexcel_aead_decrypt,
+		.ivsize = CTR_RFC3686_IV_SIZE,
+		.maxauthsize = MD5_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(md5),rfc3686(ctr(aes)))",
+			.cra_driver_name = "safexcel-authenc-hmac-md5-ctr-aes",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_ALLOCATES_MEMORY |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_md5_ctr_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
+
 static int safexcel_aead_sha1_ctr_cra_init(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-- 
2.47.3

