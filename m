From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/13] ipsec: Replace seqniv with seqiv
Date: Thu, 13 Aug 2015 17:28:52 +0800
Message-ID: <E1ZPooe-0005p5-1O@gondolin.me.apana.org.au>
References: <20150813092520.GA22268@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38209 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbbHMJ2z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 05:28:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that seqniv is identical with seqiv we no longer need it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/xfrm/xfrm_algo.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 42f7c76..f07224d 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -31,7 +31,7 @@ static struct xfrm_algo_desc aead_list[] = {
 
 	.uinfo = {
 		.aead = {
-			.geniv = "seqniv",
+			.geniv = "seqiv",
 			.icv_truncbits = 64,
 		}
 	},
@@ -50,7 +50,7 @@ static struct xfrm_algo_desc aead_list[] = {
 
 	.uinfo = {
 		.aead = {
-			.geniv = "seqniv",
+			.geniv = "seqiv",
 			.icv_truncbits = 96,
 		}
 	},
@@ -69,7 +69,7 @@ static struct xfrm_algo_desc aead_list[] = {
 
 	.uinfo = {
 		.aead = {
-			.geniv = "seqniv",
+			.geniv = "seqiv",
 			.icv_truncbits = 128,
 		}
 	},
@@ -88,7 +88,7 @@ static struct xfrm_algo_desc aead_list[] = {
 
 	.uinfo = {
 		.aead = {
-			.geniv = "seqniv",
+			.geniv = "seqiv",
 			.icv_truncbits = 64,
 		}
 	},
@@ -107,7 +107,7 @@ static struct xfrm_algo_desc aead_list[] = {
 
 	.uinfo = {
 		.aead = {
-			.geniv = "seqniv",
+			.geniv = "seqiv",
 			.icv_truncbits = 96,
 		}
 	},
@@ -126,7 +126,7 @@ static struct xfrm_algo_desc aead_list[] = {
 
 	.uinfo = {
 		.aead = {
-			.geniv = "seqniv",
+			.geniv = "seqiv",
 			.icv_truncbits = 128,
 		}
 	},
@@ -164,7 +164,7 @@ static struct xfrm_algo_desc aead_list[] = {
 
 	.uinfo = {
 		.aead = {
-			.geniv = "seqniv",
+			.geniv = "seqiv",
 			.icv_truncbits = 128,
 		}
 	},
