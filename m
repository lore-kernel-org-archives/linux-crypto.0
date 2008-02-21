From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Thu, 21 Feb 2008 17:18:03 +0300
Message-ID: <20080221141803.GB24779@2ka.mipt.ru>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au> <47BB036D.7090701@trash.net> <20080220005329.GA21565@gondor.apana.org.au> <47BC1E12.9050201@trash.net> <20080220172620.GE27726@gondor.apana.org.au> <20080221091012.GA21291@2ka.mipt.ru> <20080221141013.GB32494@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56112 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbYBUOS4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2008 09:18:56 -0500
Content-Disposition: inline
In-Reply-To: <20080221141013.GB32494@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert.

On Thu, Feb 21, 2008 at 10:10:13PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> Yes by the time the request gets to hifn req->nbytes would have
> been decremented by 12 bytes which means that it is now the exact
> amount of data that needs to be encrypted.
> 
> However, if you follow the scatterlist then you will see more data
> available which is normal.

Argh, I see.

Then following patch should help.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index dfbf24c..81b8f2f 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1544,7 +1544,10 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 
 			kunmap_atomic(daddr, KM_SOFTIRQ0);
 		} else {
-			nbytes -= src->length;
+			if (src->length > nbytes)
+				nbytes = 0;
+			else
+				nbytes -= src->length;
 			idx++;
 		}
 

-- 
	Evgeniy Polyakov
