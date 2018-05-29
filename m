From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 03/10] crypto: sha512_generic - add a sha512 0-length pre-computed hash
Date: Tue, 29 May 2018 14:13:45 +0200
Message-ID: <20180529121352.19490-4-antoine.tenart@bootlin.com>
References: <20180529121352.19490-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529121352.19490-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds the sha512 pre-computed 0-length hash so that device
drivers can use it when an hardware engine does not support computing a
hash from a 0 length input.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 crypto/sha512_generic.c | 12 ++++++++++++
 include/crypto/sha.h    |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index eba965d18bfc..439723d9273e 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -23,6 +23,18 @@
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
+const u8 sha512_zero_message_hash[SHA512_DIGEST_SIZE] = {
+	0xcf, 0x83, 0xe1, 0x35, 0x7e, 0xef, 0xb8, 0xbd,
+	0xf1, 0x54, 0x28, 0x50, 0xd6, 0x6d, 0x80, 0x07,
+	0xd6, 0x20, 0xe4, 0x05, 0x0b, 0x57, 0x15, 0xdc,
+	0x83, 0xf4, 0xa9, 0x21, 0xd3, 0x6c, 0xe9, 0xce,
+	0x47, 0xd0, 0xd1, 0x3c, 0x5d, 0x85, 0xf2, 0xb0,
+	0xff, 0x83, 0x18, 0xd2, 0x87, 0x7e, 0xec, 0x2f,
+	0x63, 0xb9, 0x31, 0xbd, 0x47, 0x41, 0x7a, 0x81,
+	0xa5, 0x38, 0x32, 0x7a, 0xf9, 0x27, 0xda, 0x3e
+};
+EXPORT_SYMBOL_GPL(sha512_zero_message_hash);
+
 static inline u64 Ch(u64 x, u64 y, u64 z)
 {
         return z ^ (x & (y ^ z));
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 0555b571dd34..799f071b93df 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -71,6 +71,8 @@ extern const u8 sha224_zero_message_hash[SHA224_DIGEST_SIZE];
 
 extern const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE];
 
+extern const u8 sha512_zero_message_hash[SHA512_DIGEST_SIZE];
+
 struct sha1_state {
 	u32 state[SHA1_DIGEST_SIZE / 4];
 	u64 count;
-- 
2.17.0
