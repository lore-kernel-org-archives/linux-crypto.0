From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] crypto: Partial revert of whitespace changes
Date: Sat, 20 Feb 2010 23:05:09 +0100
Message-ID: <1266703515-6329-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jarod Wilson <jarod@redhat.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Shane Wang <shane.wang@intel.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This commit fixes my previous patches in the way Herbert Xu asked me to.

Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/seed.c   |    2 +-
 crypto/tcrypt.c |    4 +-
 crypto/wp512.c  |  114 +++++++++++++++++++++++++++---------------------------
 crypto/xcbc.c   |    4 +-
 4 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/crypto/seed.c b/crypto/seed.c
index 3c0afae..0a3bb3f 100644
--- a/crypto/seed.c
+++ b/crypto/seed.c
@@ -329,7 +329,7 @@ static const u32 KC[SEED_NUM_KCONSTANTS] = {
 	X2 ^= t1;
 
 static int seed_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-                        unsigned int key_len)
+			unsigned int key_len)
 {
 	struct seed_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *keyout = ctx->keysched;
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 7022d6b..a76a6a2 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -135,8 +135,8 @@ out:
 static u32 block_sizes[] = { 16, 64, 256, 1024, 8192, 0 };
 
 static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
-                              struct cipher_speed_template *template,
-                              unsigned int tcount, u8 *keysize)
+			      struct cipher_speed_template *template,
+			      unsigned int tcount, u8 *keysize)
 {
 	unsigned int ret, i, j, iv_len;
 	const char *key, iv[128];
diff --git a/crypto/wp512.c b/crypto/wp512.c
index a8e4c94..357576c 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -889,74 +889,74 @@ static void wp512_process_buffer(struct wp512_ctx *wctx)
 		       K[0];
 
 		L[1] = C0[(int)(state[1] >> 56)] ^
-		           C1[(int)(state[0] >> 48) & 0xff] ^
-		           C2[(int)(state[7] >> 40) & 0xff] ^
-		           C3[(int)(state[6] >> 32) & 0xff] ^
-		           C4[(int)(state[5] >> 24) & 0xff] ^
-		           C5[(int)(state[4] >> 16) & 0xff] ^
-		           C6[(int)(state[3] >>  8) & 0xff] ^
-		           C7[(int)(state[2]) & 0xff] ^
-		           K[1];
+			   C1[(int)(state[0] >> 48) & 0xff] ^
+			   C2[(int)(state[7] >> 40) & 0xff] ^
+			   C3[(int)(state[6] >> 32) & 0xff] ^
+			   C4[(int)(state[5] >> 24) & 0xff] ^
+			   C5[(int)(state[4] >> 16) & 0xff] ^
+			   C6[(int)(state[3] >>  8) & 0xff] ^
+			   C7[(int)(state[2]) & 0xff] ^
+			   K[1];
 
 		L[2] = C0[(int)(state[2] >> 56)] ^
-		           C1[(int)(state[1] >> 48) & 0xff] ^
-		           C2[(int)(state[0] >> 40) & 0xff] ^
-		           C3[(int)(state[7] >> 32) & 0xff] ^
-		           C4[(int)(state[6] >> 24) & 0xff] ^
-		           C5[(int)(state[5] >> 16) & 0xff] ^
-		           C6[(int)(state[4] >>  8) & 0xff] ^
-		           C7[(int)(state[3]) & 0xff] ^
-		           K[2];
+			   C1[(int)(state[1] >> 48) & 0xff] ^
+			   C2[(int)(state[0] >> 40) & 0xff] ^
+			   C3[(int)(state[7] >> 32) & 0xff] ^
+			   C4[(int)(state[6] >> 24) & 0xff] ^
+			   C5[(int)(state[5] >> 16) & 0xff] ^
+			   C6[(int)(state[4] >>  8) & 0xff] ^
+			   C7[(int)(state[3]) & 0xff] ^
+			   K[2];
 
 		L[3] = C0[(int)(state[3] >> 56)] ^
-		           C1[(int)(state[2] >> 48) & 0xff] ^
-		           C2[(int)(state[1] >> 40) & 0xff] ^
-		           C3[(int)(state[0] >> 32) & 0xff] ^
-		           C4[(int)(state[7] >> 24) & 0xff] ^
-		           C5[(int)(state[6] >> 16) & 0xff] ^
-		           C6[(int)(state[5] >>  8) & 0xff] ^
-		           C7[(int)(state[4]) & 0xff] ^
-		           K[3];
+			   C1[(int)(state[2] >> 48) & 0xff] ^
+			   C2[(int)(state[1] >> 40) & 0xff] ^
+			   C3[(int)(state[0] >> 32) & 0xff] ^
+			   C4[(int)(state[7] >> 24) & 0xff] ^
+			   C5[(int)(state[6] >> 16) & 0xff] ^
+			   C6[(int)(state[5] >>  8) & 0xff] ^
+			   C7[(int)(state[4]) & 0xff] ^
+			   K[3];
 
 		L[4] = C0[(int)(state[4] >> 56)] ^
-		           C1[(int)(state[3] >> 48) & 0xff] ^
-		           C2[(int)(state[2] >> 40) & 0xff] ^
-		           C3[(int)(state[1] >> 32) & 0xff] ^
-		           C4[(int)(state[0] >> 24) & 0xff] ^
-		           C5[(int)(state[7] >> 16) & 0xff] ^
-		           C6[(int)(state[6] >>  8) & 0xff] ^
-		           C7[(int)(state[5]) & 0xff] ^
-		           K[4];
+			   C1[(int)(state[3] >> 48) & 0xff] ^
+			   C2[(int)(state[2] >> 40) & 0xff] ^
+			   C3[(int)(state[1] >> 32) & 0xff] ^
+			   C4[(int)(state[0] >> 24) & 0xff] ^
+			   C5[(int)(state[7] >> 16) & 0xff] ^
+			   C6[(int)(state[6] >>  8) & 0xff] ^
+			   C7[(int)(state[5]) & 0xff] ^
+			   K[4];
 
 		L[5] = C0[(int)(state[5] >> 56)] ^
-		           C1[(int)(state[4] >> 48) & 0xff] ^
-		           C2[(int)(state[3] >> 40) & 0xff] ^
-		           C3[(int)(state[2] >> 32) & 0xff] ^
-		           C4[(int)(state[1] >> 24) & 0xff] ^
-		           C5[(int)(state[0] >> 16) & 0xff] ^
-		           C6[(int)(state[7] >>  8) & 0xff] ^
-		           C7[(int)(state[6]) & 0xff] ^
-		           K[5];
+			   C1[(int)(state[4] >> 48) & 0xff] ^
+			   C2[(int)(state[3] >> 40) & 0xff] ^
+			   C3[(int)(state[2] >> 32) & 0xff] ^
+			   C4[(int)(state[1] >> 24) & 0xff] ^
+			   C5[(int)(state[0] >> 16) & 0xff] ^
+			   C6[(int)(state[7] >>  8) & 0xff] ^
+			   C7[(int)(state[6]) & 0xff] ^
+			   K[5];
 
 		L[6] = C0[(int)(state[6] >> 56)] ^
-		           C1[(int)(state[5] >> 48) & 0xff] ^
-		           C2[(int)(state[4] >> 40) & 0xff] ^
-		           C3[(int)(state[3] >> 32) & 0xff] ^
-		           C4[(int)(state[2] >> 24) & 0xff] ^
-		           C5[(int)(state[1] >> 16) & 0xff] ^
-		           C6[(int)(state[0] >>  8) & 0xff] ^
-		           C7[(int)(state[7]) & 0xff] ^
-		           K[6];
+			   C1[(int)(state[5] >> 48) & 0xff] ^
+			   C2[(int)(state[4] >> 40) & 0xff] ^
+			   C3[(int)(state[3] >> 32) & 0xff] ^
+			   C4[(int)(state[2] >> 24) & 0xff] ^
+			   C5[(int)(state[1] >> 16) & 0xff] ^
+			   C6[(int)(state[0] >>  8) & 0xff] ^
+			   C7[(int)(state[7]) & 0xff] ^
+			   K[6];
 
 		L[7] = C0[(int)(state[7] >> 56)] ^
-		           C1[(int)(state[6] >> 48) & 0xff] ^
-		           C2[(int)(state[5] >> 40) & 0xff] ^
-		           C3[(int)(state[4] >> 32) & 0xff] ^
-		           C4[(int)(state[3] >> 24) & 0xff] ^
-		           C5[(int)(state[2] >> 16) & 0xff] ^
-		           C6[(int)(state[1] >>  8) & 0xff] ^
-		           C7[(int)(state[0]) & 0xff] ^
-		           K[7];
+			   C1[(int)(state[6] >> 48) & 0xff] ^
+			   C2[(int)(state[5] >> 40) & 0xff] ^
+			   C3[(int)(state[4] >> 32) & 0xff] ^
+			   C4[(int)(state[3] >> 24) & 0xff] ^
+			   C5[(int)(state[2] >> 16) & 0xff] ^
+			   C6[(int)(state[1] >>  8) & 0xff] ^
+			   C7[(int)(state[0]) & 0xff] ^
+			   K[7];
 
 		state[0] = L[0];
 		state[1] = L[1];
@@ -996,7 +996,7 @@ static int wp512_init(struct shash_desc *desc)
 }
 
 static int wp512_update(struct shash_desc *desc, const u8 *source,
-                        unsigned int len)
+			unsigned int len)
 {
 	struct wp512_ctx *wctx = shash_desc_ctx(desc);
 	int sourcePos    = 0;
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 63e9181..8030499 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -24,8 +24,8 @@
 #include <linux/kernel.h>
 
 static u_int32_t ks[12] = {0x01010101, 0x01010101, 0x01010101, 0x01010101,
-                           0x02020202, 0x02020202, 0x02020202, 0x02020202,
-                           0x03030303, 0x03030303, 0x03030303, 0x03030303};
+			   0x02020202, 0x02020202, 0x02020202, 0x02020202,
+			   0x03030303, 0x03030303, 0x03030303, 0x03030303};
 
 /*
  * +------------------------
-- 
1.6.6.1
