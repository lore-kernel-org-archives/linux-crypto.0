From: "Shasi Pulijala" <spulijala@amcc.com>
Subject: [PATCH 3/3] AMCC Crypto4xx Device Driver v7
Date: Mon, 15 Jun 2009 10:28:03 -0700
Message-ID: <DB599F406D04E34389140B7D99C71B1B07D83E99@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: <kim.phillips@freescale.com>, <jwboyer@linux.vnet.ibm.com>,
	<linux-crypto@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.90]:9821 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbZFORde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2009 13:33:34 -0400
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


From: Shasi Pulijala <spulijala@amcc.com>

This patch further adds immediate hash functions to md5/sha1/sha2 algs.
These immediate hash functions are used in hmac key generation in PPC Crypto4xx driver.

Signed-off-by: Shasi Pulijala <spulijala@amcc.com>
Acked-by: Loc Ho <lho@amcc.com>
---
 crypto/md5.c            |   15 +++++++++++++++
 crypto/sha1_generic.c   |   15 +++++++++++++++
 crypto/sha256_generic.c |   15 +++++++++++++++
 crypto/sha512_generic.c |   19 +++++++++++++++++++
 include/crypto/sha.h    |    7 +++++++
 5 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/crypto/md5.c b/crypto/md5.c
index 83eb529..0c74b84 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -220,6 +220,21 @@ static int md5_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
+void md5_get_immediate_hash(struct crypto_tfm *tfm, u8 *data)
+{
+	struct shash_desc *desc = crypto_tfm_ctx(tfm);
+	struct md5_ctx *mctx = shash_desc_ctx(desc);
+	int i;
+
+	for (i = 0; i < MD5_HASH_WORDS; i++) {
+		*data++ = mctx->hash[i] & 0xFF;
+		*data++ = (mctx->hash[i] >> 8) & 0xFF;
+		*data++ = (mctx->hash[i] >> 16) & 0xFF;
+		*data++ = (mctx->hash[i] >> 24) & 0xFF;
+	}
+}
+EXPORT_SYMBOL_GPL(md5_get_immediate_hash);
+
 static struct shash_alg alg = {
 	.digestsize	=	MD5_DIGEST_SIZE,
 	.init		=	md5_init,
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 9efef20..e77b591 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -111,6 +111,21 @@ static int sha1_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
+void sha1_get_immediate_hash(struct crypto_tfm *tfm, u8 *data)
+{
+	struct shash_desc *desc = crypto_tfm_ctx(tfm);
+	struct sha1_ctx *sctx = shash_desc_ctx(desc);
+	int i;
+
+	for (i = 0; i < 5; i++) {
+		*data++ = sctx->state[i] & 0xFF;
+		*data++ = (sctx->state[i] >> 8) & 0xFF;
+		*data++ = (sctx->state[i] >> 16) & 0xFF;
+		*data++ = (sctx->state[i] >> 24) & 0xFF;
+	}
+}
+EXPORT_SYMBOL_GPL(sha1_get_immediate_hash);
+
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_init,
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 6349d83..0f5a66b 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -331,6 +331,21 @@ static int sha224_final(struct shash_desc *desc, u8 *hash)
 	return 0;
 }
 
+void sha256_get_immediate_hash(struct crypto_tfm *tfm, u8 *data)
+{
+	struct shash_desc *desc = crypto_tfm_ctx(tfm);
+	struct sha256_ctx *sctx = shash_desc_ctx(desc);
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		*data++ = sctx->state[i] & 0xFF;
+		*data++ = (sctx->state[i] >> 8) & 0xFF;
+		*data++ = (sctx->state[i] >> 16) & 0xFF;
+		*data++ = (sctx->state[i] >> 24) & 0xFF;
+	}
+}
+EXPORT_SYMBOL_GPL(sha256_get_immediate_hash);
+
 static struct shash_alg sha256 = {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_init,
diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 3bea38d..c329903 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -257,6 +257,25 @@ static int sha384_final(struct shash_desc *desc, u8 *hash)
 	return 0;
 }
 
+void sha512_get_immediate_hash(struct crypto_tfm *tfm, u8 *data)
+{
+	struct shash_desc *desc = crypto_tfm_ctx(tfm);
+	struct sha512_ctx *sctx = shash_desc_ctx(desc);
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		*data++ = (sctx->state[i] >> 32) & 0xFF;
+		*data++ = (sctx->state[i] >> 40) & 0xFF;
+		*data++ = (sctx->state[i] >> 48) & 0xFF;
+		*data++ = (sctx->state[i] >> 56) & 0xFF;
+		*data++ = sctx->state[i] & 0xFF;
+		*data++ = (sctx->state[i] >> 8) & 0xFF;
+		*data++ = (sctx->state[i] >> 16) & 0xFF;
+		*data++ = (sctx->state[i] >> 24) & 0xFF;
+	}
+}
+EXPORT_SYMBOL_GPL(sha512_get_immediate_hash);
+
 static struct shash_alg sha512 = {
 	.digestsize	=	SHA512_DIGEST_SIZE,
 	.init		=	sha512_init,
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index c0ccc2b..8894c2f 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -62,4 +62,11 @@
 #define SHA512_H6	0x1f83d9abfb41bd6bULL
 #define SHA512_H7	0x5be0cd19137e2179ULL
 
+/* From crypto/sha1_generic.c */
+void sha1_get_immediate_hash(struct crypto_tfm *tfm, u8 *data);
+/* From crypto/sha256_generic.c */
+void sha256_get_immediate_hash(struct crypto_tfm *tfm, u8 *data);
+/* From crypto/sha512_generic.c */
+void sha512_get_immediate_hash(struct crypto_tfm *tfm, u8 *data);
+
 #endif
-- 
1.5.5

