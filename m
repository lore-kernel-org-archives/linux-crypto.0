From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 07/25] crypto: ansi_cprng - Shrink context some more
Date: Sun,  7 Dec 2014 07:26:15 -0500
Message-ID: <bd4d367a0a2f8b29bff985de395e2e09f9cd6a66.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:45061 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753147AbaLGM05 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:26:57 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ctx->flags only has 2 bits assigned, so there's no need for a
32-bit field.  Likewise, rand_data_valid is at most 16.

A typical x86 spinlock_t is 16 bits, so they fit very nicely
right next to it, shrinking the 64-bit context structure to
64 bytes.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 730e0857..022662d7 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -43,12 +43,12 @@
  */
 struct prng_context {
 	spinlock_t prng_lock;
+	u8 flags;
+	u8 rand_data_valid;
 	unsigned char rand_data[DEFAULT_BLK_SZ];
 	unsigned char DT[DEFAULT_BLK_SZ];
 	unsigned char V[DEFAULT_BLK_SZ];
-	u32 rand_data_valid;
 	struct crypto_cipher *tfm;
-	u32 flags;
 };
 
 static int dbg;
-- 
2.1.3
