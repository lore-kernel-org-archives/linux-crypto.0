From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 25/25] crypto: ansi_cprng - If non-deterministic, don't buffer old output
Date: Sun,  7 Dec 2014 07:26:33 -0500
Message-ID: <6f29805d8bbde1af112d48201d5fde9a7776027f.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:35811 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753216AbaLGM1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:07 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The standards documents are silent on how to handle multi-part
output, so this is an RFC for something in the spirit of the
source specifications, but not actually required by them.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index d39ce301..b88d3446 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -198,12 +198,14 @@ static int get_prng_bytes(u8 *buf, unsigned int nbytes,
 
 	read_pos = ctx->rand_read_pos;
 	if (byte_count > DEFAULT_BLK_SZ - read_pos) {
-		/* Leading partial block */
-		unsigned int avail = DEFAULT_BLK_SZ - read_pos;
+		if (ctx->flags & PRNG_DETERMINISTIC) {
+			/* Return leftover data from previous call */
+			unsigned int avail = DEFAULT_BLK_SZ - read_pos;
 
-		memcpy(ptr, ctx->rand_data.b + read_pos, avail);
-		ptr += avail;
-		byte_count -= avail;
+			memcpy(ptr, ctx->rand_data.b + read_pos, avail);
+			ptr += avail;
+			byte_count -= avail;
+		}
 		read_pos = 0;
 
 		/* Intermediate full blocks */
-- 
2.1.3
