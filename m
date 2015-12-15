From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 1/4] crypto: hash: add zero length message hash for shax and md5
Date: Tue, 15 Dec 2015 14:00:20 +0100
Message-ID: <1450184423-31155-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1450184423-31155-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450184423-31155-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Some crypto drivers cannot process empty data message and return a
precalculated hash for md5/sha1/sha224/sha256.

This patch add thoses precalculated hash in include/crypto.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 crypto/md5.c            |  6 ++++++
 crypto/sha1_generic.c   |  7 +++++++
 crypto/sha256_generic.c | 16 ++++++++++++++++
 include/crypto/md5.h    |  2 ++
 include/crypto/sha.h    |  6 ++++++
 5 files changed, 37 insertions(+)

diff --git a/crypto/md5.c b/crypto/md5.c
index 33d17e9..2355a7c 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -24,6 +24,12 @@
 #include <linux/cryptohash.h>
 #include <asm/byteorder.h>
 
+const u8 md5_zero_message_hash[MD5_DIGEST_SIZE] = {
+	0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
+	0xe9, 0x80, 0x09, 0x98, 0xec, 0xf8, 0x42, 0x7e,
+};
+EXPORT_SYMBOL_GPL(md5_zero_message_hash);
+
 /* XXX: this stuff can be optimized */
 static inline void le32_to_cpu_array(u32 *buf, unsigned int words)
 {
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 39e3acc..6877cbb 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -26,6 +26,13 @@
 #include <crypto/sha1_base.h>
 #include <asm/byteorder.h>
 
+const u8 sha1_zero_message_hash[SHA1_DIGEST_SIZE] = {
+	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d,
+	0x32, 0x55, 0xbf, 0xef, 0x95, 0x60, 0x18, 0x90,
+	0xaf, 0xd8, 0x07, 0x09
+};
+EXPORT_SYMBOL_GPL(sha1_zero_message_hash);
+
 static void sha1_generic_block_fn(struct sha1_state *sst, u8 const *src,
 				  int blocks)
 {
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 7843116..8f9c47e 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -27,6 +27,22 @@
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
+const u8 sha224_zero_message_hash[SHA224_DIGEST_SIZE] = {
+	0xd1, 0x4a, 0x02, 0x8c, 0x2a, 0x3a, 0x2b, 0xc9, 0x47,
+	0x61, 0x02, 0xbb, 0x28, 0x82, 0x34, 0xc4, 0x15, 0xa2,
+	0xb0, 0x1f, 0x82, 0x8e, 0xa6, 0x2a, 0xc5, 0xb3, 0xe4,
+	0x2f
+};
+EXPORT_SYMBOL_GPL(sha224_zero_message_hash);
+
+const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE] = {
+	0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14,
+	0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24,
+	0x27, 0xae, 0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c,
+	0xa4, 0x95, 0x99, 0x1b, 0x78, 0x52, 0xb8, 0x55
+};
+EXPORT_SYMBOL_GPL(sha256_zero_message_hash);
+
 static inline u32 Ch(u32 x, u32 y, u32 z)
 {
 	return z ^ (x & (y ^ z));
diff --git a/include/crypto/md5.h b/include/crypto/md5.h
index 146af82..327deac 100644
--- a/include/crypto/md5.h
+++ b/include/crypto/md5.h
@@ -13,6 +13,8 @@
 #define MD5_H2	0x98badcfeUL
 #define MD5_H3	0x10325476UL
 
+extern const u8 md5_zero_message_hash[MD5_DIGEST_SIZE];
+
 struct md5_state {
 	u32 hash[MD5_HASH_WORDS];
 	u32 block[MD5_BLOCK_WORDS];
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index dd7905a..c94d3eb 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -64,6 +64,12 @@
 #define SHA512_H6	0x1f83d9abfb41bd6bULL
 #define SHA512_H7	0x5be0cd19137e2179ULL
 
+extern const u8 sha1_zero_message_hash[SHA1_DIGEST_SIZE];
+
+extern const u8 sha224_zero_message_hash[SHA224_DIGEST_SIZE];
+
+extern const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE];
+
 struct sha1_state {
 	u32 state[SHA1_DIGEST_SIZE / 4];
 	u64 count;
-- 
2.4.10
