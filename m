From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] DRBG: fix failure of generating multiple of 2**16 bytes
Date: Thu, 31 Jul 2014 21:47:33 +0200
Message-ID: <7159935.MYAcUzQ1Ny@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The function drbg_generate_long slices the request into 2**16 byte
or smaller chunks. However, the loop, however invokes the random number
generation function with zero bytes when the request size is a multiple
of 2**16 bytes. The fix prevents zero bytes requests.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ff975d9..7894db9 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1500,7 +1500,7 @@ static int drbg_generate_long(struct drbg_state *drbg,
 		if (0 >= tmplen)
 			return tmplen;
 		len += tmplen;
-	} while (slice > 0);
+	} while (slice > 0 && (len < buflen));
 	return len;
 }
 
-- 
1.9.3
