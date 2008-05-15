From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] crypto: rmd128: make it work on my prefered architecture
Date: Thu, 15 May 2008 22:07:06 +0200
Message-ID: <20080515200706.GA3081@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46187 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbYEOUHL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 May 2008 16:07:11 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sebastian Siewior <sebastian@breakpoint.cc>

Not everybody counts 10 as 01.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---

Adrian-Ken: I expect the other implementiation to be broken. Please fix
it :)

 crypto/rmd128.c |  316 +++++++++++++++++++++++++++----------------------------
 1 files changed, 153 insertions(+), 163 deletions(-)

diff --git a/crypto/rmd128.c b/crypto/rmd128.c
index 146a167..34e9e4a 100644
--- a/crypto/rmd128.c
+++ b/crypto/rmd128.c
@@ -7,6 +7,8 @@
  *
  * Copyright (c) 2008 Adrian-Ken Rueegsegger <rueegsegger (at) swiss-it.ch>
  *
+ * Sebastian Siewior tried to use this on PowerPC. Now it does work.
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
@@ -52,190 +54,178 @@ static void rmd128_transform(u32 *state, u32 const *in)
 	u32 aa, bb, cc, dd, aaa, bbb, ccc, ddd;
 
 	/* Initialize left lane */
-	aa = state[0];
-	bb = state[1];
-	cc = state[2];
-	dd = state[3];
+	aa = le32_to_cpu(state[0]);
+	bb = le32_to_cpu(state[1]);
+	cc = le32_to_cpu(state[2]);
+	dd = le32_to_cpu(state[3]);
 
 	/* Initialize right lane */
-	aaa = state[0];
-	bbb = state[1];
-	ccc = state[2];
-	ddd = state[3];
+	aaa = le32_to_cpu(state[0]);
+	bbb = le32_to_cpu(state[1]);
+	ccc = le32_to_cpu(state[2]);
+	ddd = le32_to_cpu(state[3]);
 
 	/* round 1: left lane */
-	ROUND(aa, bb, cc, dd, F1, K1, in[0],  11);
-	ROUND(dd, aa, bb, cc, F1, K1, in[1],  14);
-	ROUND(cc, dd, aa, bb, F1, K1, in[2],  15);
-	ROUND(bb, cc, dd, aa, F1, K1, in[3],  12);
-	ROUND(aa, bb, cc, dd, F1, K1, in[4],   5);
-	ROUND(dd, aa, bb, cc, F1, K1, in[5],   8);
-	ROUND(cc, dd, aa, bb, F1, K1, in[6],   7);
-	ROUND(bb, cc, dd, aa, F1, K1, in[7],   9);
-	ROUND(aa, bb, cc, dd, F1, K1, in[8],  11);
-	ROUND(dd, aa, bb, cc, F1, K1, in[9],  13);
-	ROUND(cc, dd, aa, bb, F1, K1, in[10], 14);
-	ROUND(bb, cc, dd, aa, F1, K1, in[11], 15);
-	ROUND(aa, bb, cc, dd, F1, K1, in[12],  6);
-	ROUND(dd, aa, bb, cc, F1, K1, in[13],  7);
-	ROUND(cc, dd, aa, bb, F1, K1, in[14],  9);
-	ROUND(bb, cc, dd, aa, F1, K1, in[15],  8);
+	ROUND(aa, bb, cc, dd, F1, K1, le32_to_cpu(in[ 0]),  11);
+	ROUND(dd, aa, bb, cc, F1, K1, le32_to_cpu(in[ 1]),  14);
+	ROUND(cc, dd, aa, bb, F1, K1, le32_to_cpu(in[ 2]),  15);
+	ROUND(bb, cc, dd, aa, F1, K1, le32_to_cpu(in[ 3]),  12);
+	ROUND(aa, bb, cc, dd, F1, K1, le32_to_cpu(in[ 4]),   5);
+	ROUND(dd, aa, bb, cc, F1, K1, le32_to_cpu(in[ 5]),   8);
+	ROUND(cc, dd, aa, bb, F1, K1, le32_to_cpu(in[ 6]),   7);
+	ROUND(bb, cc, dd, aa, F1, K1, le32_to_cpu(in[ 7]),   9);
+	ROUND(aa, bb, cc, dd, F1, K1, le32_to_cpu(in[ 8]),  11);
+	ROUND(dd, aa, bb, cc, F1, K1, le32_to_cpu(in[ 9]),  13);
+	ROUND(cc, dd, aa, bb, F1, K1, le32_to_cpu(in[10]), 14);
+	ROUND(bb, cc, dd, aa, F1, K1, le32_to_cpu(in[11]), 15);
+	ROUND(aa, bb, cc, dd, F1, K1, le32_to_cpu(in[12]),  6);
+	ROUND(dd, aa, bb, cc, F1, K1, le32_to_cpu(in[13]),  7);
+	ROUND(cc, dd, aa, bb, F1, K1, le32_to_cpu(in[14]),  9);
+	ROUND(bb, cc, dd, aa, F1, K1, le32_to_cpu(in[15]),  8);
 
 	/* round 2: left lane */
-	ROUND(aa, bb, cc, dd, F2, K2, in[7],   7);
-	ROUND(dd, aa, bb, cc, F2, K2, in[4],   6);
-	ROUND(cc, dd, aa, bb, F2, K2, in[13],  8);
-	ROUND(bb, cc, dd, aa, F2, K2, in[1],  13);
-	ROUND(aa, bb, cc, dd, F2, K2, in[10], 11);
-	ROUND(dd, aa, bb, cc, F2, K2, in[6],   9);
-	ROUND(cc, dd, aa, bb, F2, K2, in[15],  7);
-	ROUND(bb, cc, dd, aa, F2, K2, in[3],  15);
-	ROUND(aa, bb, cc, dd, F2, K2, in[12],  7);
-	ROUND(dd, aa, bb, cc, F2, K2, in[0],  12);
-	ROUND(cc, dd, aa, bb, F2, K2, in[9],  15);
-	ROUND(bb, cc, dd, aa, F2, K2, in[5],   9);
-	ROUND(aa, bb, cc, dd, F2, K2, in[2],  11);
-	ROUND(dd, aa, bb, cc, F2, K2, in[14],  7);
-	ROUND(cc, dd, aa, bb, F2, K2, in[11], 13);
-	ROUND(bb, cc, dd, aa, F2, K2, in[8],  12);
+	ROUND(aa, bb, cc, dd, F2, K2, le32_to_cpu(in[ 7]),   7);
+	ROUND(dd, aa, bb, cc, F2, K2, le32_to_cpu(in[ 4]),   6);
+	ROUND(cc, dd, aa, bb, F2, K2, le32_to_cpu(in[13]),  8);
+	ROUND(bb, cc, dd, aa, F2, K2, le32_to_cpu(in[ 1]),  13);
+	ROUND(aa, bb, cc, dd, F2, K2, le32_to_cpu(in[10]), 11);
+	ROUND(dd, aa, bb, cc, F2, K2, le32_to_cpu(in[ 6]),   9);
+	ROUND(cc, dd, aa, bb, F2, K2, le32_to_cpu(in[15]),  7);
+	ROUND(bb, cc, dd, aa, F2, K2, le32_to_cpu(in[ 3]),  15);
+	ROUND(aa, bb, cc, dd, F2, K2, le32_to_cpu(in[12]),  7);
+	ROUND(dd, aa, bb, cc, F2, K2, le32_to_cpu(in[ 0]),  12);
+	ROUND(cc, dd, aa, bb, F2, K2, le32_to_cpu(in[ 9]),  15);
+	ROUND(bb, cc, dd, aa, F2, K2, le32_to_cpu(in[ 5]),   9);
+	ROUND(aa, bb, cc, dd, F2, K2, le32_to_cpu(in[ 2]),  11);
+	ROUND(dd, aa, bb, cc, F2, K2, le32_to_cpu(in[14]),  7);
+	ROUND(cc, dd, aa, bb, F2, K2, le32_to_cpu(in[11]), 13);
+	ROUND(bb, cc, dd, aa, F2, K2, le32_to_cpu(in[ 8]),  12);
 
 	/* round 3: left lane */
-	ROUND(aa, bb, cc, dd, F3, K3, in[3],  11);
-	ROUND(dd, aa, bb, cc, F3, K3, in[10], 13);
-	ROUND(cc, dd, aa, bb, F3, K3, in[14],  6);
-	ROUND(bb, cc, dd, aa, F3, K3, in[4],   7);
-	ROUND(aa, bb, cc, dd, F3, K3, in[9],  14);
-	ROUND(dd, aa, bb, cc, F3, K3, in[15],  9);
-	ROUND(cc, dd, aa, bb, F3, K3, in[8],  13);
-	ROUND(bb, cc, dd, aa, F3, K3, in[1],  15);
-	ROUND(aa, bb, cc, dd, F3, K3, in[2],  14);
-	ROUND(dd, aa, bb, cc, F3, K3, in[7],   8);
-	ROUND(cc, dd, aa, bb, F3, K3, in[0],  13);
-	ROUND(bb, cc, dd, aa, F3, K3, in[6],   6);
-	ROUND(aa, bb, cc, dd, F3, K3, in[13],  5);
-	ROUND(dd, aa, bb, cc, F3, K3, in[11], 12);
-	ROUND(cc, dd, aa, bb, F3, K3, in[5],   7);
-	ROUND(bb, cc, dd, aa, F3, K3, in[12],  5);
+	ROUND(aa, bb, cc, dd, F3, K3, le32_to_cpu(in[ 3]),  11);
+	ROUND(dd, aa, bb, cc, F3, K3, le32_to_cpu(in[10]), 13);
+	ROUND(cc, dd, aa, bb, F3, K3, le32_to_cpu(in[14]),  6);
+	ROUND(bb, cc, dd, aa, F3, K3, le32_to_cpu(in[ 4]),   7);
+	ROUND(aa, bb, cc, dd, F3, K3, le32_to_cpu(in[ 9]),  14);
+	ROUND(dd, aa, bb, cc, F3, K3, le32_to_cpu(in[15]),  9);
+	ROUND(cc, dd, aa, bb, F3, K3, le32_to_cpu(in[ 8]),  13);
+	ROUND(bb, cc, dd, aa, F3, K3, le32_to_cpu(in[ 1]),  15);
+	ROUND(aa, bb, cc, dd, F3, K3, le32_to_cpu(in[ 2]),  14);
+	ROUND(dd, aa, bb, cc, F3, K3, le32_to_cpu(in[ 7]),   8);
+	ROUND(cc, dd, aa, bb, F3, K3, le32_to_cpu(in[ 0]),  13);
+	ROUND(bb, cc, dd, aa, F3, K3, le32_to_cpu(in[ 6]),   6);
+	ROUND(aa, bb, cc, dd, F3, K3, le32_to_cpu(in[13]),  5);
+	ROUND(dd, aa, bb, cc, F3, K3, le32_to_cpu(in[11]), 12);
+	ROUND(cc, dd, aa, bb, F3, K3, le32_to_cpu(in[ 5]),   7);
+	ROUND(bb, cc, dd, aa, F3, K3, le32_to_cpu(in[12]),  5);
 
 	/* round 4: left lane */
-	ROUND(aa, bb, cc, dd, F4, K4, in[1],  11);
-	ROUND(dd, aa, bb, cc, F4, K4, in[9],  12);
-	ROUND(cc, dd, aa, bb, F4, K4, in[11], 14);
-	ROUND(bb, cc, dd, aa, F4, K4, in[10], 15);
-	ROUND(aa, bb, cc, dd, F4, K4, in[0],  14);
-	ROUND(dd, aa, bb, cc, F4, K4, in[8],  15);
-	ROUND(cc, dd, aa, bb, F4, K4, in[12],  9);
-	ROUND(bb, cc, dd, aa, F4, K4, in[4],   8);
-	ROUND(aa, bb, cc, dd, F4, K4, in[13],  9);
-	ROUND(dd, aa, bb, cc, F4, K4, in[3],  14);
-	ROUND(cc, dd, aa, bb, F4, K4, in[7],   5);
-	ROUND(bb, cc, dd, aa, F4, K4, in[15],  6);
-	ROUND(aa, bb, cc, dd, F4, K4, in[14],  8);
-	ROUND(dd, aa, bb, cc, F4, K4, in[5],   6);
-	ROUND(cc, dd, aa, bb, F4, K4, in[6],   5);
-	ROUND(bb, cc, dd, aa, F4, K4, in[2],  12);
+	ROUND(aa, bb, cc, dd, F4, K4, le32_to_cpu(in[ 1]),  11);
+	ROUND(dd, aa, bb, cc, F4, K4, le32_to_cpu(in[ 9]),  12);
+	ROUND(cc, dd, aa, bb, F4, K4, le32_to_cpu(in[11]), 14);
+	ROUND(bb, cc, dd, aa, F4, K4, le32_to_cpu(in[10]), 15);
+	ROUND(aa, bb, cc, dd, F4, K4, le32_to_cpu(in[ 0]),  14);
+	ROUND(dd, aa, bb, cc, F4, K4, le32_to_cpu(in[ 8]),  15);
+	ROUND(cc, dd, aa, bb, F4, K4, le32_to_cpu(in[12]),  9);
+	ROUND(bb, cc, dd, aa, F4, K4, le32_to_cpu(in[ 4]),   8);
+	ROUND(aa, bb, cc, dd, F4, K4, le32_to_cpu(in[13]),  9);
+	ROUND(dd, aa, bb, cc, F4, K4, le32_to_cpu(in[ 3]),  14);
+	ROUND(cc, dd, aa, bb, F4, K4, le32_to_cpu(in[ 7]),   5);
+	ROUND(bb, cc, dd, aa, F4, K4, le32_to_cpu(in[15]),  6);
+	ROUND(aa, bb, cc, dd, F4, K4, le32_to_cpu(in[14]),  8);
+	ROUND(dd, aa, bb, cc, F4, K4, le32_to_cpu(in[ 5]),   6);
+	ROUND(cc, dd, aa, bb, F4, K4, le32_to_cpu(in[ 6]),   5);
+	ROUND(bb, cc, dd, aa, F4, K4, le32_to_cpu(in[ 2]),  12);
 
 	/* round 1: right lane */
-	ROUND(aaa, bbb, ccc, ddd, F4, KK1, in[5],   8);
-	ROUND(ddd, aaa, bbb, ccc, F4, KK1, in[14],  9);
-	ROUND(ccc, ddd, aaa, bbb, F4, KK1, in[7],   9);
-	ROUND(bbb, ccc, ddd, aaa, F4, KK1, in[0],  11);
-	ROUND(aaa, bbb, ccc, ddd, F4, KK1, in[9],  13);
-	ROUND(ddd, aaa, bbb, ccc, F4, KK1, in[2],  15);
-	ROUND(ccc, ddd, aaa, bbb, F4, KK1, in[11], 15);
-	ROUND(bbb, ccc, ddd, aaa, F4, KK1, in[4],   5);
-	ROUND(aaa, bbb, ccc, ddd, F4, KK1, in[13],  7);
-	ROUND(ddd, aaa, bbb, ccc, F4, KK1, in[6],   7);
-	ROUND(ccc, ddd, aaa, bbb, F4, KK1, in[15],  8);
-	ROUND(bbb, ccc, ddd, aaa, F4, KK1, in[8],  11);
-	ROUND(aaa, bbb, ccc, ddd, F4, KK1, in[1],  14);
-	ROUND(ddd, aaa, bbb, ccc, F4, KK1, in[10], 14);
-	ROUND(ccc, ddd, aaa, bbb, F4, KK1, in[3],  12);
-	ROUND(bbb, ccc, ddd, aaa, F4, KK1, in[12],  6);
+	ROUND(aaa, bbb, ccc, ddd, F4, KK1, le32_to_cpu(in[ 5]),   8);
+	ROUND(ddd, aaa, bbb, ccc, F4, KK1, le32_to_cpu(in[14]),  9);
+	ROUND(ccc, ddd, aaa, bbb, F4, KK1, le32_to_cpu(in[ 7]),   9);
+	ROUND(bbb, ccc, ddd, aaa, F4, KK1, le32_to_cpu(in[ 0]),  11);
+	ROUND(aaa, bbb, ccc, ddd, F4, KK1, le32_to_cpu(in[ 9]),  13);
+	ROUND(ddd, aaa, bbb, ccc, F4, KK1, le32_to_cpu(in[ 2]),  15);
+	ROUND(ccc, ddd, aaa, bbb, F4, KK1, le32_to_cpu(in[11]), 15);
+	ROUND(bbb, ccc, ddd, aaa, F4, KK1, le32_to_cpu(in[ 4]),   5);
+	ROUND(aaa, bbb, ccc, ddd, F4, KK1, le32_to_cpu(in[13]),  7);
+	ROUND(ddd, aaa, bbb, ccc, F4, KK1, le32_to_cpu(in[ 6]),   7);
+	ROUND(ccc, ddd, aaa, bbb, F4, KK1, le32_to_cpu(in[15]),  8);
+	ROUND(bbb, ccc, ddd, aaa, F4, KK1, le32_to_cpu(in[ 8]),  11);
+	ROUND(aaa, bbb, ccc, ddd, F4, KK1, le32_to_cpu(in[ 1]),  14);
+	ROUND(ddd, aaa, bbb, ccc, F4, KK1, le32_to_cpu(in[10]), 14);
+	ROUND(ccc, ddd, aaa, bbb, F4, KK1, le32_to_cpu(in[ 3]),  12);
+	ROUND(bbb, ccc, ddd, aaa, F4, KK1, le32_to_cpu(in[12]),  6);
 
 	/* round 2: right lane */
-	ROUND(aaa, bbb, ccc, ddd, F3, KK2, in[6],   9);
-	ROUND(ddd, aaa, bbb, ccc, F3, KK2, in[11], 13);
-	ROUND(ccc, ddd, aaa, bbb, F3, KK2, in[3],  15);
-	ROUND(bbb, ccc, ddd, aaa, F3, KK2, in[7],   7);
-	ROUND(aaa, bbb, ccc, ddd, F3, KK2, in[0],  12);
-	ROUND(ddd, aaa, bbb, ccc, F3, KK2, in[13],  8);
-	ROUND(ccc, ddd, aaa, bbb, F3, KK2, in[5],   9);
-	ROUND(bbb, ccc, ddd, aaa, F3, KK2, in[10], 11);
-	ROUND(aaa, bbb, ccc, ddd, F3, KK2, in[14],  7);
-	ROUND(ddd, aaa, bbb, ccc, F3, KK2, in[15],  7);
-	ROUND(ccc, ddd, aaa, bbb, F3, KK2, in[8],  12);
-	ROUND(bbb, ccc, ddd, aaa, F3, KK2, in[12],  7);
-	ROUND(aaa, bbb, ccc, ddd, F3, KK2, in[4],   6);
-	ROUND(ddd, aaa, bbb, ccc, F3, KK2, in[9],  15);
-	ROUND(ccc, ddd, aaa, bbb, F3, KK2, in[1],  13);
-	ROUND(bbb, ccc, ddd, aaa, F3, KK2, in[2],  11);
+	ROUND(aaa, bbb, ccc, ddd, F3, KK2, le32_to_cpu(in[ 6]),   9);
+	ROUND(ddd, aaa, bbb, ccc, F3, KK2, le32_to_cpu(in[11]), 13);
+	ROUND(ccc, ddd, aaa, bbb, F3, KK2, le32_to_cpu(in[ 3]),  15);
+	ROUND(bbb, ccc, ddd, aaa, F3, KK2, le32_to_cpu(in[ 7]),   7);
+	ROUND(aaa, bbb, ccc, ddd, F3, KK2, le32_to_cpu(in[ 0]),  12);
+	ROUND(ddd, aaa, bbb, ccc, F3, KK2, le32_to_cpu(in[13]),  8);
+	ROUND(ccc, ddd, aaa, bbb, F3, KK2, le32_to_cpu(in[ 5]),   9);
+	ROUND(bbb, ccc, ddd, aaa, F3, KK2, le32_to_cpu(in[10]), 11);
+	ROUND(aaa, bbb, ccc, ddd, F3, KK2, le32_to_cpu(in[14]),  7);
+	ROUND(ddd, aaa, bbb, ccc, F3, KK2, le32_to_cpu(in[15]),  7);
+	ROUND(ccc, ddd, aaa, bbb, F3, KK2, le32_to_cpu(in[ 8]),  12);
+	ROUND(bbb, ccc, ddd, aaa, F3, KK2, le32_to_cpu(in[12]),  7);
+	ROUND(aaa, bbb, ccc, ddd, F3, KK2, le32_to_cpu(in[ 4]),   6);
+	ROUND(ddd, aaa, bbb, ccc, F3, KK2, le32_to_cpu(in[ 9]),  15);
+	ROUND(ccc, ddd, aaa, bbb, F3, KK2, le32_to_cpu(in[ 1]),  13);
+	ROUND(bbb, ccc, ddd, aaa, F3, KK2, le32_to_cpu(in[ 2]),  11);
 
 	/* round 3: right lane */
-	ROUND(aaa, bbb, ccc, ddd, F2, KK3, in[15],  9);
-	ROUND(ddd, aaa, bbb, ccc, F2, KK3, in[5],   7);
-	ROUND(ccc, ddd, aaa, bbb, F2, KK3, in[1],  15);
-	ROUND(bbb, ccc, ddd, aaa, F2, KK3, in[3],  11);
-	ROUND(aaa, bbb, ccc, ddd, F2, KK3, in[7],   8);
-	ROUND(ddd, aaa, bbb, ccc, F2, KK3, in[14],  6);
-	ROUND(ccc, ddd, aaa, bbb, F2, KK3, in[6],   6);
-	ROUND(bbb, ccc, ddd, aaa, F2, KK3, in[9],  14);
-	ROUND(aaa, bbb, ccc, ddd, F2, KK3, in[11], 12);
-	ROUND(ddd, aaa, bbb, ccc, F2, KK3, in[8],  13);
-	ROUND(ccc, ddd, aaa, bbb, F2, KK3, in[12],  5);
-	ROUND(bbb, ccc, ddd, aaa, F2, KK3, in[2],  14);
-	ROUND(aaa, bbb, ccc, ddd, F2, KK3, in[10], 13);
-	ROUND(ddd, aaa, bbb, ccc, F2, KK3, in[0],  13);
-	ROUND(ccc, ddd, aaa, bbb, F2, KK3, in[4],   7);
-	ROUND(bbb, ccc, ddd, aaa, F2, KK3, in[13],  5);
+	ROUND(aaa, bbb, ccc, ddd, F2, KK3, le32_to_cpu(in[15]),  9);
+	ROUND(ddd, aaa, bbb, ccc, F2, KK3, le32_to_cpu(in[ 5]),   7);
+	ROUND(ccc, ddd, aaa, bbb, F2, KK3, le32_to_cpu(in[ 1]),  15);
+	ROUND(bbb, ccc, ddd, aaa, F2, KK3, le32_to_cpu(in[ 3]),  11);
+	ROUND(aaa, bbb, ccc, ddd, F2, KK3, le32_to_cpu(in[ 7]),   8);
+	ROUND(ddd, aaa, bbb, ccc, F2, KK3, le32_to_cpu(in[14]),  6);
+	ROUND(ccc, ddd, aaa, bbb, F2, KK3, le32_to_cpu(in[ 6]),   6);
+	ROUND(bbb, ccc, ddd, aaa, F2, KK3, le32_to_cpu(in[ 9]),  14);
+	ROUND(aaa, bbb, ccc, ddd, F2, KK3, le32_to_cpu(in[11]), 12);
+	ROUND(ddd, aaa, bbb, ccc, F2, KK3, le32_to_cpu(in[ 8]),  13);
+	ROUND(ccc, ddd, aaa, bbb, F2, KK3, le32_to_cpu(in[12]),  5);
+	ROUND(bbb, ccc, ddd, aaa, F2, KK3, le32_to_cpu(in[ 2]),  14);
+	ROUND(aaa, bbb, ccc, ddd, F2, KK3, le32_to_cpu(in[10]), 13);
+	ROUND(ddd, aaa, bbb, ccc, F2, KK3, le32_to_cpu(in[ 0]),  13);
+	ROUND(ccc, ddd, aaa, bbb, F2, KK3, le32_to_cpu(in[ 4]),   7);
+	ROUND(bbb, ccc, ddd, aaa, F2, KK3, le32_to_cpu(in[13]),  5);
 
 	/* round 4: right lane */
-	ROUND(aaa, bbb, ccc, ddd, F1, KK4, in[8],  15);
-	ROUND(ddd, aaa, bbb, ccc, F1, KK4, in[6],   5);
-	ROUND(ccc, ddd, aaa, bbb, F1, KK4, in[4],   8);
-	ROUND(bbb, ccc, ddd, aaa, F1, KK4, in[1],  11);
-	ROUND(aaa, bbb, ccc, ddd, F1, KK4, in[3],  14);
-	ROUND(ddd, aaa, bbb, ccc, F1, KK4, in[11], 14);
-	ROUND(ccc, ddd, aaa, bbb, F1, KK4, in[15],  6);
-	ROUND(bbb, ccc, ddd, aaa, F1, KK4, in[0],  14);
-	ROUND(aaa, bbb, ccc, ddd, F1, KK4, in[5],   6);
-	ROUND(ddd, aaa, bbb, ccc, F1, KK4, in[12],  9);
-	ROUND(ccc, ddd, aaa, bbb, F1, KK4, in[2],  12);
-	ROUND(bbb, ccc, ddd, aaa, F1, KK4, in[13],  9);
-	ROUND(aaa, bbb, ccc, ddd, F1, KK4, in[9],  12);
-	ROUND(ddd, aaa, bbb, ccc, F1, KK4, in[7],   5);
-	ROUND(ccc, ddd, aaa, bbb, F1, KK4, in[10], 15);
-	ROUND(bbb, ccc, ddd, aaa, F1, KK4, in[14],  8);
+	ROUND(aaa, bbb, ccc, ddd, F1, KK4, le32_to_cpu(in[ 8]),  15);
+	ROUND(ddd, aaa, bbb, ccc, F1, KK4, le32_to_cpu(in[ 6]),   5);
+	ROUND(ccc, ddd, aaa, bbb, F1, KK4, le32_to_cpu(in[ 4]),   8);
+	ROUND(bbb, ccc, ddd, aaa, F1, KK4, le32_to_cpu(in[ 1]),  11);
+	ROUND(aaa, bbb, ccc, ddd, F1, KK4, le32_to_cpu(in[ 3]),  14);
+	ROUND(ddd, aaa, bbb, ccc, F1, KK4, le32_to_cpu(in[11]), 14);
+	ROUND(ccc, ddd, aaa, bbb, F1, KK4, le32_to_cpu(in[15]),  6);
+	ROUND(bbb, ccc, ddd, aaa, F1, KK4, le32_to_cpu(in[ 0]),  14);
+	ROUND(aaa, bbb, ccc, ddd, F1, KK4, le32_to_cpu(in[ 5]),   6);
+	ROUND(ddd, aaa, bbb, ccc, F1, KK4, le32_to_cpu(in[12]),  9);
+	ROUND(ccc, ddd, aaa, bbb, F1, KK4, le32_to_cpu(in[ 2]),  12);
+	ROUND(bbb, ccc, ddd, aaa, F1, KK4, le32_to_cpu(in[13]),  9);
+	ROUND(aaa, bbb, ccc, ddd, F1, KK4, le32_to_cpu(in[ 9]),  12);
+	ROUND(ddd, aaa, bbb, ccc, F1, KK4, le32_to_cpu(in[ 7]),   5);
+	ROUND(ccc, ddd, aaa, bbb, F1, KK4, le32_to_cpu(in[10]), 15);
+	ROUND(bbb, ccc, ddd, aaa, F1, KK4, le32_to_cpu(in[14]),  8);
 
 	/* combine results */
-	ddd += cc + state[1];		/* final result for state[0] */
-	state[1] = state[2] + dd + aaa;
-	state[2] = state[3] + aa + bbb;
-	state[3] = state[0] + bb + ccc;
-	state[0] = ddd;
+	ddd += cc + le32_to_cpu(state[1]);		/* final result for state[0] */
+	le32_add_cpu(&state[2], dd + aaa);
+	state[1] = state[2];
 
-	return;
-}
+	le32_add_cpu(&state[3], aa + bbb);
+	state[2] = state[3];
 
-static inline void le32_to_cpu_array(u32 *buf, unsigned int words)
-{
-	while (words--) {
-		le32_to_cpus(buf);
-		buf++;
-	}
-}
+	le32_add_cpu(&state[0], bb + ccc);
+	state[3] = state[0];
 
-static inline void cpu_to_le32_array(u32 *buf, unsigned int words)
-{
-	while (words--) {
-		cpu_to_le32s(buf);
-		buf++;
-	}
+	state[0] = cpu_to_le32(ddd);
+	return;
 }
 
-static inline void rmd128_transform_helper(struct rmd128_ctx *ctx)
+static void rmd128_transform_helper(struct rmd128_ctx *ctx)
 {
-	le32_to_cpu_array(ctx->buffer, sizeof(ctx->buffer) / sizeof(u32));
 	rmd128_transform(ctx->state, ctx->buffer);
 }
 
@@ -245,10 +235,10 @@ static void rmd128_init(struct crypto_tfm *tfm)
 
 	rctx->byte_count = 0;
 
-	rctx->state[0] = RMD_H0;
-	rctx->state[1] = RMD_H1;
-	rctx->state[2] = RMD_H2;
-	rctx->state[3] = RMD_H3;
+	rctx->state[0] = __constant_cpu_to_le32(RMD_H0);
+	rctx->state[1] = __constant_cpu_to_le32(RMD_H1);
+	rctx->state[2] = __constant_cpu_to_le32(RMD_H2);
+	rctx->state[3] = __constant_cpu_to_le32(RMD_H3);
 
 	memset(rctx->buffer, 0, sizeof(rctx->buffer));
 }
@@ -292,8 +282,8 @@ static void rmd128_final(struct crypto_tfm *tfm, u8 *out)
 	u32 index, padlen;
 	u64 bits;
 	static const u8 padding[64] = { 0x80, };
-	bits = rctx->byte_count << 3;
 
+	bits = cpu_to_le64(rctx->byte_count << 3);
 	/* Pad out to 56 mod 64 */
 	index = rctx->byte_count & 0x3f;
 	padlen = (index < 56) ? (56 - index) : ((64+56) - index);
-- 
1.5.4.3

