From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 07/10] crypto: sha512_generic - add a sha384 0-length pre-computed hash
Date: Tue, 29 May 2018 14:13:49 +0200
Message-ID: <20180529121352.19490-8-antoine.tenart@bootlin.com>
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

This patch adds the sha384 pre-computed 0-length hash so that device
drivers can use it when an hardware engine does not support computing a
hash from a 0 length input.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 crypto/sha512_generic.c | 10 ++++++++++
 include/crypto/sha.h    |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 439723d9273e..0b805d03b5e5 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -23,6 +23,16 @@
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
+const u8 sha384_zero_message_hash[SHA384_DIGEST_SIZE] = {
+	0x38, 0xb0, 0x60, 0xa7, 0x51, 0xac, 0x96, 0x38,
+	0x4c, 0xd9, 0x32, 0x7e, 0xb1, 0xb1, 0xe3, 0x6a,
+	0x21, 0xfd, 0xb7, 0x11, 0x14, 0xbe, 0x07, 0x43,
+	0x4c, 0x0c, 0xc7, 0xbf, 0x63, 0xf6, 0xe1, 0xda,
+	0x27, 0x4e, 0xde, 0xbf, 0xe7, 0x6f, 0x65, 0xfb,
+	0xd5, 0x1a, 0xd2, 0xf1, 0x48, 0x98, 0xb9, 0x5b
+};
+EXPORT_SYMBOL_GPL(sha384_zero_message_hash);
+
 const u8 sha512_zero_message_hash[SHA512_DIGEST_SIZE] = {
 	0xcf, 0x83, 0xe1, 0x35, 0x7e, 0xef, 0xb8, 0xbd,
 	0xf1, 0x54, 0x28, 0x50, 0xd6, 0x6d, 0x80, 0x07,
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 799f071b93df..8a46202b1857 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -71,6 +71,8 @@ extern const u8 sha224_zero_message_hash[SHA224_DIGEST_SIZE];
 
 extern const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE];
 
+extern const u8 sha384_zero_message_hash[SHA384_DIGEST_SIZE];
+
 extern const u8 sha512_zero_message_hash[SHA512_DIGEST_SIZE];
 
 struct sha1_state {
-- 
2.17.0
