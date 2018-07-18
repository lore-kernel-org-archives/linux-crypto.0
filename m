From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: rmd256 - use swap macro in rmd256_transform
Date: Wed, 18 Jul 2018 12:12:00 -0500
Message-ID: <20180718171200.GA20997@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Make use of the swap macro and remove unnecessary variable *tmp*.
This makes the code easier to read and maintain.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 crypto/rmd256.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/rmd256.c b/crypto/rmd256.c
index 0afbb5a..0e9d306 100644
--- a/crypto/rmd256.c
+++ b/crypto/rmd256.c
@@ -49,7 +49,7 @@ struct rmd256_ctx {
 
 static void rmd256_transform(u32 *state, const __le32 *in)
 {
-	u32 aa, bb, cc, dd, aaa, bbb, ccc, ddd, tmp;
+	u32 aa, bb, cc, dd, aaa, bbb, ccc, ddd;
 
 	/* Initialize left lane */
 	aa = state[0];
@@ -100,7 +100,7 @@ static void rmd256_transform(u32 *state, const __le32 *in)
 	ROUND(bbb, ccc, ddd, aaa, F4, KK1, in[12],  6);
 
 	/* Swap contents of "a" registers */
-	tmp = aa; aa = aaa; aaa = tmp;
+	swap(aa, aaa);
 
 	/* round 2: left lane */
 	ROUND(aa, bb, cc, dd, F2, K2, in[7],   7);
@@ -139,7 +139,7 @@ static void rmd256_transform(u32 *state, const __le32 *in)
 	ROUND(bbb, ccc, ddd, aaa, F3, KK2, in[2],  11);
 
 	/* Swap contents of "b" registers */
-	tmp = bb; bb = bbb; bbb = tmp;
+	swap(bb, bbb);
 
 	/* round 3: left lane */
 	ROUND(aa, bb, cc, dd, F3, K3, in[3],  11);
@@ -178,7 +178,7 @@ static void rmd256_transform(u32 *state, const __le32 *in)
 	ROUND(bbb, ccc, ddd, aaa, F2, KK3, in[13],  5);
 
 	/* Swap contents of "c" registers */
-	tmp = cc; cc = ccc; ccc = tmp;
+	swap(cc, ccc);
 
 	/* round 4: left lane */
 	ROUND(aa, bb, cc, dd, F4, K4, in[1],  11);
@@ -217,7 +217,7 @@ static void rmd256_transform(u32 *state, const __le32 *in)
 	ROUND(bbb, ccc, ddd, aaa, F1, KK4, in[14],  8);
 
 	/* Swap contents of "d" registers */
-	tmp = dd; dd = ddd; ddd = tmp;
+	swap(dd, ddd);
 
 	/* combine results */
 	state[0] += aa;
-- 
2.7.4
