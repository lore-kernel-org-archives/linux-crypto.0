From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 10/25] crypto: ansi_cprng - Use u8 data types consistently internally
Date: Sun,  7 Dec 2014 07:26:18 -0500
Message-ID: <6f2794a61216aa69c5f4c0dafc6fafae48bd7874.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:13740 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753175AbaLGM1D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:03 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Yes, they're equivalent to "unsigned char", but let's stick with what
the crypto API uses externally.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index d4106e54..74ec151e 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -43,15 +43,15 @@ struct prng_context {
 	spinlock_t prng_lock;
 	u8 flags;
 	u8 rand_data_valid;
-	unsigned char rand_data[DEFAULT_BLK_SZ];
-	unsigned char DT[DEFAULT_BLK_SZ];
-	unsigned char V[DEFAULT_BLK_SZ];
+	u8 rand_data[DEFAULT_BLK_SZ];
+	u8 DT[DEFAULT_BLK_SZ];
+	u8 V[DEFAULT_BLK_SZ];
 	struct crypto_cipher *tfm;
 };
 
 static int dbg;
 
-static void hexdump(char const *note, const unsigned char buf[DEFAULT_BLK_SZ])
+static void hexdump(char const *note, const u8 buf[DEFAULT_BLK_SZ])
 {
 	if (dbg) {
 		printk(KERN_CRIT "%s = %" __stringify(DEFAULT_BLK_SZ) "phN",
@@ -64,8 +64,8 @@ if (dbg)\
 	printk(format, ##args);\
 } while (0)
 
-static void xor_vectors(unsigned char *in1, unsigned char *in2,
-			unsigned char *out, unsigned int size)
+static void xor_vectors(const u8 *in1, const u8 *in2,
+			u8 *out, unsigned int size)
 {
 	int i;
 
@@ -80,7 +80,7 @@ static void xor_vectors(unsigned char *in1, unsigned char *in2,
 static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 {
 	int i;
-	unsigned char tmp[DEFAULT_BLK_SZ];
+	u8 tmp[DEFAULT_BLK_SZ];
 
 	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
 		ctx);
@@ -152,10 +152,10 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 }
 
 /* Our exported functions */
-static int get_prng_bytes(char *buf, unsigned int nbytes,
+static int get_prng_bytes(u8 *buf, unsigned int nbytes,
 			  struct prng_context *ctx, bool do_cont_test)
 {
-	unsigned char *ptr = buf;
+	u8 *ptr = buf;
 	unsigned int byte_count = nbytes;
 	int err;
 
@@ -243,9 +243,8 @@ static void free_prng_context(struct prng_context *ctx)
 	crypto_free_cipher(ctx->tfm);
 }
 
-static int reset_prng_context(struct prng_context *ctx,
-			      unsigned char *key, unsigned int klen,
-			      unsigned char *V, unsigned char *DT)
+static int reset_prng_context(struct prng_context *ctx, const u8 *key,
+			      unsigned int klen, const u8 *V, const u8 *DT)
 {
 	int ret;
 
-- 
2.1.3
