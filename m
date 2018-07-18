From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: rmd320 - use swap macro in rmd320_transform
Date: Wed, 18 Jul 2018 12:19:08 -0500
Message-ID: <20180718171908.GA22962@embeddedor.com>
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
 crypto/rmd320.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/rmd320.c b/crypto/rmd320.c
index ab3cf93..3ae1df5 100644
--- a/crypto/rmd320.c
+++ b/crypto/rmd320.c
@@ -53,7 +53,7 @@ struct rmd320_ctx {
 
 static void rmd320_transform(u32 *state, const __le32 *in)
 {
-	u32 aa, bb, cc, dd, ee, aaa, bbb, ccc, ddd, eee, tmp;
+	u32 aa, bb, cc, dd, ee, aaa, bbb, ccc, ddd, eee;
 
 	/* Initialize left lane */
 	aa = state[0];
@@ -106,7 +106,7 @@ static void rmd320_transform(u32 *state, const __le32 *in)
 	ROUND(aaa, bbb, ccc, ddd, eee, F5, KK1, in[12],  6);
 
 	/* Swap contents of "a" registers */
-	tmp = aa; aa = aaa; aaa = tmp;
+	swap(aa, aaa);
 
 	/* round 2: left lane" */
 	ROUND(ee, aa, bb, cc, dd, F2, K2, in[7],   7);
@@ -145,7 +145,7 @@ static void rmd320_transform(u32 *state, const __le32 *in)
 	ROUND(eee, aaa, bbb, ccc, ddd, F4, KK2, in[2],  11);
 
 	/* Swap contents of "b" registers */
-	tmp = bb; bb = bbb; bbb = tmp;
+	swap(bb, bbb);
 
 	/* round 3: left lane" */
 	ROUND(dd, ee, aa, bb, cc, F3, K3, in[3],  11);
@@ -184,7 +184,7 @@ static void rmd320_transform(u32 *state, const __le32 *in)
 	ROUND(ddd, eee, aaa, bbb, ccc, F3, KK3, in[13],  5);
 
 	/* Swap contents of "c" registers */
-	tmp = cc; cc = ccc; ccc = tmp;
+	swap(cc, ccc);
 
 	/* round 4: left lane" */
 	ROUND(cc, dd, ee, aa, bb, F4, K4, in[1],  11);
@@ -223,7 +223,7 @@ static void rmd320_transform(u32 *state, const __le32 *in)
 	ROUND(ccc, ddd, eee, aaa, bbb, F2, KK4, in[14],  8);
 
 	/* Swap contents of "d" registers */
-	tmp = dd; dd = ddd; ddd = tmp;
+	swap(dd, ddd);
 
 	/* round 5: left lane" */
 	ROUND(bb, cc, dd, ee, aa, F5, K5, in[4],   9);
@@ -262,7 +262,7 @@ static void rmd320_transform(u32 *state, const __le32 *in)
 	ROUND(bbb, ccc, ddd, eee, aaa, F1, KK5, in[11], 11);
 
 	/* Swap contents of "e" registers */
-	tmp = ee; ee = eee; eee = tmp;
+	swap(ee, eee);
 
 	/* combine results */
 	state[0] += aa;
-- 
2.7.4
