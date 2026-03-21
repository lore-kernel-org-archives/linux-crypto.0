Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF10E2D781E;
	Sat, 21 Mar 2026 23:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774134497; cv=none; b=L0AlP7guJv9hjXT5Ast79hQdHvNnFLsMk62wiX3yFCQ94PKPGRw14YBau1rchWmEhgcy/xhL+BBJFr7q1f4fMHxjrbIg4/bdMhcm9iUOlSu6h+tZcUm//l+tYj88EMSUjp83jsM1DARl+9n+kR9uYEOVPDuclN/fn+N0/5FxxWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774134497; c=relaxed/simple;
	bh=fetUNVRPZ93BnF6WOiUy1yEoGUwXT/nZAxjTTLMnlmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqqOndYRT7HWp2qSGGUOn7O3cp3wESPgMJ93iEa+7GHySN/gwMqjnNiX1GNFEl7ryxf0o1CxpcPjQugALD7xfW9Q/d2ZNcbzBAg6yyU/cq04RFZhHJHVJ/Nk/LURgAdWYggib1mmu4lVoXvjvSFqyZINixTBEU3cnoTEwnCJ0dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qNFfRA8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qNFfRA8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A917AC2BC9E;
	Sat, 21 Mar 2026 23:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774134496;
	bh=fetUNVRPZ93BnF6WOiUy1yEoGUwXT/nZAxjTTLMnlmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNFfRA8E2So1NzS7IYWfrhatmnehPTxFeNVZppCsgmxF+P1NbI1rfeCAsUAf1t5+c
	 TBw1/prEjWA9smW5MYe8o7gHqcYTY1BqmJOGMvusq9ILCCpOdEQptQ9Ih13JicivGx
	 sdx2zqHt2MGcQEdUz03O16QjjmXlHxBBCoROgjg+kgZ+jyizGY5lfJNBfjx7n43Uig
	 AfIUFM8gn9jtdy4AfJ+9PxTAE9zQ1NDSqBQKZEb0HMH2fMGVryK+kDp8Z0U8GscAOR
	 r9jVpR1NRTV/RS1MYp+Y4nlGFIREsr/BATwoQ6PgEowTP8eVxXublxyrVB85KlpNIJ
	 cq7h2THtYFuJw==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/2] dm-crypt: Reimplement elephant diffuser using AES library
Date: Sat, 21 Mar 2026 16:06:50 -0700
Message-ID: <20260321230651.89081-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321230651.89081-1-ebiggers@kernel.org>
References: <20260321230651.89081-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify and optimize dm-crypt's implementation of Bitlocker's "elephant
diffuser" to use the AES library instead of an "ecb(aes)"
crypto_skcipher.

Note: struct aes_enckey is fixed-size, so it could be embedded directly
in struct iv_elephant_private.  But I kept it as a separate allocation
so that the size of struct crypt_config doesn't increase.  The elephant
diffuser is rarely used in dm-crypt.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/Kconfig    |  1 +
 drivers/md/dm-crypt.c | 85 +++++++++++++++----------------------------
 2 files changed, 31 insertions(+), 55 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 53351048d3ec..a3fcdca7e6db 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -298,10 +298,11 @@ config DM_CRYPT
 	depends on (TRUSTED_KEYS || TRUSTED_KEYS=n)
 	select CRC32
 	select CRYPTO
 	select CRYPTO_CBC
 	select CRYPTO_ESSIV
+	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_MD5 # needed by lmk IV mode
 	help
 	  This device-mapper target allows you to create a device that
 	  transparently encrypts the data on it. You'll need to activate
 	  the ciphers you're going to use in the cryptoapi configuration.
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 54823341c9fd..76b0c6bfd45c 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -30,10 +30,11 @@
 #include <linux/scatterlist.h>
 #include <linux/rbtree.h>
 #include <linux/ctype.h>
 #include <asm/page.h>
 #include <linux/unaligned.h>
+#include <crypto/aes.h>
 #include <crypto/hash.h>
 #include <crypto/md5.h>
 #include <crypto/skcipher.h>
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
@@ -131,11 +132,11 @@ struct iv_tcw_private {
 	u8 *whitening;
 };
 
 #define ELEPHANT_MAX_KEY_SIZE 32
 struct iv_elephant_private {
-	struct crypto_skcipher *tfm;
+	struct aes_enckey *key;
 };
 
 /*
  * Crypt: maps a linear range of a block device
  * and encrypts / decrypts at the same time.
@@ -765,27 +766,23 @@ static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
 
 static void crypt_iv_elephant_dtr(struct crypt_config *cc)
 {
 	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
 
-	crypto_free_skcipher(elephant->tfm);
-	elephant->tfm = NULL;
+	kfree_sensitive(elephant->key);
+	elephant->key = NULL;
 }
 
 static int crypt_iv_elephant_ctr(struct crypt_config *cc, struct dm_target *ti,
 			    const char *opts)
 {
 	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
 	int r;
 
-	elephant->tfm = crypto_alloc_skcipher("ecb(aes)", 0,
-					      CRYPTO_ALG_ALLOCATES_MEMORY);
-	if (IS_ERR(elephant->tfm)) {
-		r = PTR_ERR(elephant->tfm);
-		elephant->tfm = NULL;
-		return r;
-	}
+	elephant->key = kmalloc_obj(*elephant->key);
+	if (!elephant->key)
+		return -ENOMEM;
 
 	r = crypt_iv_eboiv_ctr(cc, ti, NULL);
 	if (r)
 		crypt_iv_elephant_dtr(cc);
 	return r;
@@ -933,45 +930,32 @@ static void diffuser_b_encrypt(u32 *d, size_t n)
 			i1--; i2--; i3--;
 		}
 	}
 }
 
-static int crypt_iv_elephant(struct crypt_config *cc, struct dm_crypt_request *dmreq)
+static void crypt_iv_elephant(struct crypt_config *cc,
+			      struct dm_crypt_request *dmreq)
 {
 	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
-	u8 *es, *ks, *data, *data2, *data_offset;
-	struct skcipher_request *req;
-	struct scatterlist *sg, *sg2, src, dst;
-	DECLARE_CRYPTO_WAIT(wait);
-	int i, r;
-
-	req = skcipher_request_alloc(elephant->tfm, GFP_NOIO);
-	es = kzalloc(16, GFP_NOIO); /* Key for AES */
-	ks = kzalloc(32, GFP_NOIO); /* Elephant sector key */
-
-	if (!req || !es || !ks) {
-		r = -ENOMEM;
-		goto out;
-	}
+	u8 *data, *data2, *data_offset;
+	struct scatterlist *sg, *sg2;
+	union {
+		__le64 w[2];
+		u8 b[16];
+	} es;
+	u8 ks[32] __aligned(__alignof(long)); /* Elephant sector key */
+	int i;
 
-	*(__le64 *)es = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
+	es.w[0] = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
+	es.w[1] = 0;
 
 	/* E(Ks, e(s)) */
-	sg_init_one(&src, es, 16);
-	sg_init_one(&dst, ks, 16);
-	skcipher_request_set_crypt(req, &src, &dst, 16, NULL);
-	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
-	r = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
-	if (r)
-		goto out;
+	aes_encrypt(elephant->key, &ks[0], es.b);
 
 	/* E(Ks, e'(s)) */
-	es[15] = 0x80;
-	sg_init_one(&dst, &ks[16], 16);
-	r = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
-	if (r)
-		goto out;
+	es.b[15] = 0x80;
+	aes_encrypt(elephant->key, &ks[16], es.b);
 
 	sg = crypt_get_sg_data(cc, dmreq->sg_out);
 	data = kmap_local_page(sg_page(sg));
 	data_offset = data + sg->offset;
 
@@ -999,55 +983,46 @@ static int crypt_iv_elephant(struct crypt_config *cc, struct dm_crypt_request *d
 		diffuser_b_encrypt((u32 *)data_offset, cc->sector_size / sizeof(u32));
 		diffuser_cpu_to_disk((__le32 *)data_offset, cc->sector_size / sizeof(u32));
 	}
 
 	kunmap_local(data);
-out:
-	kfree_sensitive(ks);
-	kfree_sensitive(es);
-	skcipher_request_free(req);
-	return r;
+	memzero_explicit(ks, sizeof(ks));
+	memzero_explicit(&es, sizeof(es));
 }
 
 static int crypt_iv_elephant_gen(struct crypt_config *cc, u8 *iv,
 			    struct dm_crypt_request *dmreq)
 {
-	int r;
-
-	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
-		r = crypt_iv_elephant(cc, dmreq);
-		if (r)
-			return r;
-	}
+	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
+		crypt_iv_elephant(cc, dmreq);
 
 	return crypt_iv_eboiv_gen(cc, iv, dmreq);
 }
 
 static int crypt_iv_elephant_post(struct crypt_config *cc, u8 *iv,
 				  struct dm_crypt_request *dmreq)
 {
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
-		return crypt_iv_elephant(cc, dmreq);
+		crypt_iv_elephant(cc, dmreq);
 
 	return 0;
 }
 
 static int crypt_iv_elephant_init(struct crypt_config *cc)
 {
 	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
 	int key_offset = cc->key_size - cc->key_extra_size;
 
-	return crypto_skcipher_setkey(elephant->tfm, &cc->key[key_offset], cc->key_extra_size);
+	return aes_prepareenckey(elephant->key, &cc->key[key_offset], cc->key_extra_size);
 }
 
 static int crypt_iv_elephant_wipe(struct crypt_config *cc)
 {
 	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
-	u8 key[ELEPHANT_MAX_KEY_SIZE];
 
-	memset(key, 0, cc->key_extra_size);
-	return crypto_skcipher_setkey(elephant->tfm, key, cc->key_extra_size);
+	memzero_explicit(elephant->key, sizeof(*elephant->key));
+	return 0;
 }
 
 static const struct crypt_iv_operations crypt_iv_plain_ops = {
 	.generator = crypt_iv_plain_gen
 };
-- 
2.53.0

