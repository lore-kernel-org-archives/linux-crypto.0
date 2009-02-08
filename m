From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 02/10] crypto/des_generic: simplify ROUND() macro
Date: Sun, 08 Feb 2009 06:51:31 -0500
Message-ID: <20090208115131.4644.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux@horizon.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:17632 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752541AbZBHL6N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Feb 2009 06:58:13 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Did that mixture of shifting by 8 and 16 generate better code
on some architecture?  This is easier to read.
---
 crypto/des_generic.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index afde5b4..1b74adf 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -553,17 +553,17 @@ static const u32 S8[64] = {
 	ROR(R, 4);
 
 #define ROUND(L, R, A, B, K, d)					\
-	B = K[0];			A = K[1];	K += d;	\
-	B ^= R;				A ^= R;			\
-	B &= 0x3f3f3f3f;		ROR(A, 4);		\
-	L ^= S8[0xff & B];		A &= 0x3f3f3f3f;	\
-	L ^= S6[0xff & (B >> 8)];	B >>= 16;		\
-	L ^= S7[0xff & A];					\
-	L ^= S5[0xff & (A >> 8)];	A >>= 16;		\
-	L ^= S4[0xff & B];					\
-	L ^= S2[0xff & (B >> 8)];				\
-	L ^= S3[0xff & A];					\
-	L ^= S1[0xff & (A >> 8)];
+	B = K[0];		A = K[1];		K += d;	\
+	B ^= R;			A ^= R;				\
+	B &= 0x3f3f3f3f;	ROR(A, 4);			\
+	A &= 0x3f3f3f3f;	L ^= S8[0xff & B];	B >>= 8;\
+	L ^= S7[0xff & A];	A >>= 8;			\
+	L ^= S6[0xff & B];	B >>= 8;			\
+	L ^= S5[0xff & A];	A >>= 8;			\
+	L ^= S4[0xff & B];	B >>= 8;			\
+	L ^= S3[0xff & A];	A >>= 8;			\
+	L ^= S2[0xff & B];					\
+	L ^= S1[0xff & A];
 
 /*
  * PC2 lookup tables are organized as 2 consecutive sets of 4 interleaved
-- 
1.6.0.6

