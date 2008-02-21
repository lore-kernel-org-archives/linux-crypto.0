From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Thu, 21 Feb 2008 17:37:21 +0300
Message-ID: <20080221143721.GB9140@2ka.mipt.ru>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au> <47BB036D.7090701@trash.net> <20080220005329.GA21565@gondor.apana.org.au> <47BC1E12.9050201@trash.net> <20080220172620.GE27726@gondor.apana.org.au> <20080221091012.GA21291@2ka.mipt.ru> <20080221141013.GB32494@gondor.apana.org.au> <20080221141803.GB24779@2ka.mipt.ru> <47BD88BD.2030305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48672 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbYBUOiI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2008 09:38:08 -0500
Content-Disposition: inline
In-Reply-To: <47BD88BD.2030305@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 21, 2008 at 03:20:45PM +0100, Patrick McHardy (kaber@trash.net) wrote:
> Almost I guess :) There are similar loops in hifn_setup_session().
> Additionally we need to check that the return value of ablkcipher_walk()
> is not a negative errno code.

Yep. Kind of this one:

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index dfbf24c..c88b4d9 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1544,7 +1544,10 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 
 			kunmap_atomic(daddr, KM_SOFTIRQ0);
 		} else {
-			nbytes -= src->length;
+			if (src->length >= nbytes)
+				nbytes = 0;
+			else
+				nbytes -= src->length;
 			idx++;
 		}
 
@@ -1588,7 +1591,10 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 			ctx->walk.flags |= ASYNC_FLAGS_MISALIGNED;
 		}
 
-		nbytes -= src->length;
+		if (src->length > nbytes)
+			nbytes = 0;
+		else
+			nbytes -= src->length;
 		idx++;
 	}
 
@@ -1602,6 +1608,10 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 	idx = 0;
 
 	sg_num = ablkcipher_walk(req, &ctx->walk);
+	if (sg_num < 0) {
+		err = sg_num;
+		goto err_out_exit;
+	}
 
 	atomic_set(&ctx->sg_num, sg_num);
 
@@ -1640,7 +1650,10 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 		if (err)
 			goto err_out;
 
-		nbytes -= len;
+		if (len > nbytes)
+			nbytes = 0;
+		else
+			nbytes -= len;
 	}
 
 	dev->active = HIFN_DEFAULT_ACTIVE_NUM;
@@ -1803,7 +1816,10 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 					sg_page(dst), dst->length, nbytes);
 
 				if (!t->length) {
-					nbytes -= dst->length;
+					if (dst->length > nbytes)
+						nbytes = 0;
+					else
+						nbytes -= dst->length;
 					idx++;
 					continue;
 				}



-- 
	Evgeniy Polyakov
