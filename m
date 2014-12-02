From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 07/17] crypto: ansi_cprng - Shrink rand_read_pos & flags
Date: 2 Dec 2014 03:43:13 -0500
Message-ID: <20141202084313.18411.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:53399 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751021AbaLBInP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:43:15 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

rand_read_pos is never more than 16, while there's only 1 flag
bit allocated, so we can shrink the context a little.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

They're also reordered to avoid alignment holes.

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 93ed00f6..f40f54cd 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -51,9 +51,9 @@ struct prng_context {
 	unsigned char rand_data[DEFAULT_BLK_SZ];
 	unsigned char DT[DEFAULT_BLK_SZ];
 	unsigned char V[DEFAULT_BLK_SZ];
-	u32 rand_read_pos;	/* Offset into rand_data[] */
+	unsigned char rand_read_pos;	/* Offset into rand_data[] */
+	unsigned char flags;
 	struct crypto_cipher *tfm;
-	u32 flags;
 };
 
 static int dbg;
-- 
2.1.3
