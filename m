From: Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] crypto: blkcipher_get_spot() handling of buffer at end of page
Date: Mon, 10 Sep 2007 21:46:46 +0200
Message-ID: <200709102146.47655.ioe-lkml@rameria.de>
References: <5562608.649291189210157514.JavaMail.root@tahiti.vyatta.com> <20070908041423.GA8961@gondor.apana.org.au> <20070910075829.GA25851@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Bob Gilligan <gilligan@vyatta.com>, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay07.ispgateway.de ([80.67.29.7]:37895 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbXIJTwq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Sep 2007 15:52:46 -0400
In-Reply-To: <20070910075829.GA25851@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Monday 10 September 2007, Herbert Xu wrote:
> On Sat, Sep 08, 2007 at 12:14:23PM +0800, Herbert Xu wrote:
> > 
> > [CRYPTO] blkcipher: Fix handling of kmalloc page straddling
> 
> As Bob correctly noted, I had the boolean test inverted.
> Here is the correction:
> 
> [CRYPTO] blkcipher: Fix inverted test in blkcipher_get_spot
> 
> The previous patch had the conditional inverted.  This patch fixes it
> so that we return the original position if it does not straddle a page.

What about using max() for this to make your intention obvious?

static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
{
	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK); 
	return max(start, end_page);
}


Best Regards

Ingo Oeser 
