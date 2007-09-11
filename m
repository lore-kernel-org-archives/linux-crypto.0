From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: blkcipher_get_spot() handling of buffer at end of page
Date: Tue, 11 Sep 2007 16:40:58 +0800
Message-ID: <20070911084058.GA4469@gondor.apana.org.au>
References: <5562608.649291189210157514.JavaMail.root@tahiti.vyatta.com> <20070908041423.GA8961@gondor.apana.org.au> <20070910075829.GA25851@gondor.apana.org.au> <200709102146.47655.ioe-lkml@rameria.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bob Gilligan <gilligan@vyatta.com>, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Ingo Oeser <ioe-lkml@rameria.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3238 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759348AbXIKIlZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Sep 2007 04:41:25 -0400
Content-Disposition: inline
In-Reply-To: <200709102146.47655.ioe-lkml@rameria.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 10, 2007 at 09:46:46PM +0200, Ingo Oeser wrote:
>
> What about using max() for this to make your intention obvious?
> 
> static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
> {
> 	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK); 
> 	return max(start, end_page);
> }

Yes that looks sane.  Could you please send a patch?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
