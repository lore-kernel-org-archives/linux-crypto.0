From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 03/25] crypto: ansi_cprng - Use %phN rather than print_hex_dump for debug
Date: Sun,  7 Dec 2014 07:26:11 -0500
Message-ID: <4999a01f546537ea4ebc37207cdeb151a52c9eab.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:24847 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753120AbaLGM04 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:26:56 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since the goal is to compare to NIST test vectors, which are printed
on a single like without spaces, this comes much closer.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 143e0cfa..b54e4e75 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -60,10 +60,7 @@ static int dbg;
 static void hexdump(char *note, unsigned char *buf, unsigned int len)
 {
 	if (dbg) {
-		printk(KERN_CRIT "%s", note);
-		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
-				16, 1,
-				buf, len, false);
+		printk(KERN_CRIT "%s%*phN", note, (int)len, buf);
 	}
 }
 
-- 
2.1.3
