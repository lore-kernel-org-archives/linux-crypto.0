From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 2/4] crypto: niagara: Use precalculated hash from headers
Date: Thu, 17 Dec 2015 13:45:40 +0100
Message-ID: <1450356342-12971-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1450356342-12971-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450356342-12971-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Precalculated hash for empty message are now present in hash headers.
This patch just use them.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/Kconfig   |  3 +++
 drivers/crypto/n2_core.c | 33 ++++++---------------------------
 2 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 2569e04..721cc4a 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -194,6 +194,9 @@ config CRYPTO_DEV_NIAGARA2
        select CRYPTO_DES
        select CRYPTO_BLKCIPHER
        select CRYPTO_HASH
+       select CRYPTO_MD5
+       select CRYPTO_SHA1
+       select CRYPTO_SHA256
        depends on SPARC64
        help
 	  Each core of a Niagara2 processor contains a Stream
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 5450880..febbd5e 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -241,7 +241,7 @@ static inline bool n2_should_run_async(struct spu_queue *qp, int this_len)
 
 struct n2_ahash_alg {
 	struct list_head	entry;
-	const char		*hash_zero;
+	const u8		*hash_zero;
 	const u32		*hash_init;
 	u8			hw_op_hashsz;
 	u8			digest_size;
@@ -1267,7 +1267,7 @@ static LIST_HEAD(cipher_algs);
 
 struct n2_hash_tmpl {
 	const char	*name;
-	const char	*hash_zero;
+	const u8	*hash_zero;
 	const u32	*hash_init;
 	u8		hw_op_hashsz;
 	u8		digest_size;
@@ -1276,40 +1276,19 @@ struct n2_hash_tmpl {
 	u8		hmac_type;
 };
 
-static const char md5_zero[MD5_DIGEST_SIZE] = {
-	0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
-	0xe9, 0x80, 0x09, 0x98, 0xec, 0xf8, 0x42, 0x7e,
-};
 static const u32 md5_init[MD5_HASH_WORDS] = {
 	cpu_to_le32(MD5_H0),
 	cpu_to_le32(MD5_H1),
 	cpu_to_le32(MD5_H2),
 	cpu_to_le32(MD5_H3),
 };
-static const char sha1_zero[SHA1_DIGEST_SIZE] = {
-	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d, 0x32,
-	0x55, 0xbf, 0xef, 0x95, 0x60, 0x18, 0x90, 0xaf, 0xd8,
-	0x07, 0x09
-};
 static const u32 sha1_init[SHA1_DIGEST_SIZE / 4] = {
 	SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4,
 };
-static const char sha256_zero[SHA256_DIGEST_SIZE] = {
-	0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14, 0x9a,
-	0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24, 0x27, 0xae,
-	0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c, 0xa4, 0x95, 0x99,
-	0x1b, 0x78, 0x52, 0xb8, 0x55
-};
 static const u32 sha256_init[SHA256_DIGEST_SIZE / 4] = {
 	SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
 	SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7,
 };
-static const char sha224_zero[SHA224_DIGEST_SIZE] = {
-	0xd1, 0x4a, 0x02, 0x8c, 0x2a, 0x3a, 0x2b, 0xc9, 0x47,
-	0x61, 0x02, 0xbb, 0x28, 0x82, 0x34, 0xc4, 0x15, 0xa2,
-	0xb0, 0x1f, 0x82, 0x8e, 0xa6, 0x2a, 0xc5, 0xb3, 0xe4,
-	0x2f
-};
 static const u32 sha224_init[SHA256_DIGEST_SIZE / 4] = {
 	SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
 	SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7,
@@ -1317,7 +1296,7 @@ static const u32 sha224_init[SHA256_DIGEST_SIZE / 4] = {
 
 static const struct n2_hash_tmpl hash_tmpls[] = {
 	{ .name		= "md5",
-	  .hash_zero	= md5_zero,
+	  .hash_zero	= md5_zero_message_hash,
 	  .hash_init	= md5_init,
 	  .auth_type	= AUTH_TYPE_MD5,
 	  .hmac_type	= AUTH_TYPE_HMAC_MD5,
@@ -1325,7 +1304,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .digest_size	= MD5_DIGEST_SIZE,
 	  .block_size	= MD5_HMAC_BLOCK_SIZE },
 	{ .name		= "sha1",
-	  .hash_zero	= sha1_zero,
+	  .hash_zero	= sha1_zero_message_hash,
 	  .hash_init	= sha1_init,
 	  .auth_type	= AUTH_TYPE_SHA1,
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA1,
@@ -1333,7 +1312,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .digest_size	= SHA1_DIGEST_SIZE,
 	  .block_size	= SHA1_BLOCK_SIZE },
 	{ .name		= "sha256",
-	  .hash_zero	= sha256_zero,
+	  .hash_zero	= sha256_zero_message_hash,
 	  .hash_init	= sha256_init,
 	  .auth_type	= AUTH_TYPE_SHA256,
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA256,
@@ -1341,7 +1320,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .digest_size	= SHA256_DIGEST_SIZE,
 	  .block_size	= SHA256_BLOCK_SIZE },
 	{ .name		= "sha224",
-	  .hash_zero	= sha224_zero,
+	  .hash_zero	= sha224_zero_message_hash,
 	  .hash_init	= sha224_init,
 	  .auth_type	= AUTH_TYPE_SHA256,
 	  .hmac_type	= AUTH_TYPE_RESERVED,
-- 
2.4.10
