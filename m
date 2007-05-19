From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [Patch] [CRYPTO] add alignment for setkey() (rev 3)
Date: Sat, 19 May 2007 19:51:38 +1000
Message-ID: <20070519095138.GA7460@gondor.apana.org.au>
References: <20070519094518.GB26696@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3517 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754746AbXESJvm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 May 2007 05:51:42 -0400
Content-Disposition: inline
In-Reply-To: <20070519094518.GB26696@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, May 19, 2007 at 11:45:18AM +0200, Sebastian Siewior wrote:
> setkey() in {cipher,blkcipher,ablkcipher,hash}.c does not respect the
> requested alignment by the algorithm. This patch fixes it. The extra
> memory is allocated by kmalloc() with GFP_ATOMIC flag.
> 
> Signed-off-by: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
