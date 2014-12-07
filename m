From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 09/25] crypto: ansi_cprng - Make length types consistent
Date: Sun,  7 Dec 2014 07:26:17 -0500
Message-ID: <2ec76417ed0624a9b6e6fc4168f6198fd6d402e3.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:64925 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753161AbaLGM1B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:01 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The public crypto API uses "unsigned int", but the internals used
a mixture of that and size_t, which are different sizes on 64 bits.

This shuts up a GCC warning about printf format.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 62b8f958..d4106e54 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -152,11 +152,11 @@ static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 }
 
 /* Our exported functions */
-static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx,
-				bool do_cont_test)
+static int get_prng_bytes(char *buf, unsigned int nbytes,
+			  struct prng_context *ctx, bool do_cont_test)
 {
 	unsigned char *ptr = buf;
-	unsigned int byte_count = (unsigned int)nbytes;
+	unsigned int byte_count = nbytes;
 	int err;
 
 
@@ -244,7 +244,7 @@ static void free_prng_context(struct prng_context *ctx)
 }
 
 static int reset_prng_context(struct prng_context *ctx,
-			      unsigned char *key, size_t klen,
+			      unsigned char *key, unsigned int klen,
 			      unsigned char *V, unsigned char *DT)
 {
 	int ret;
-- 
2.1.3
