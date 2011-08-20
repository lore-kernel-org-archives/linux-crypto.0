From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni-intel - Add ivsize to ablk_ecb_alg
Date: Sat, 20 Aug 2011 16:08:32 +0800
Message-ID: <20110820080832.GA15013@gondor.apana.org.au>
References: <20110811164040.GB2167@zod.bos.redhat.com> <20110815071528.GA29656@gondor.apana.org.au> <20110815115038.GA2227@zod.bos.redhat.com> <20110816123227.GB9413@gondor.apana.org.au> <20110818174425.GN2227@zod.bos.redhat.com> <20110819000229.GA1076@gondor.apana.org.au> <20110819021516.GU2227@zod.bos.redhat.com> <20110819073224.GA3658@gondor.apana.org.au> <20110819081207.GA3954@gondor.apana.org.au> <20110819121516.GA2270@zod.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Josh Boyer <jwboyer@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35000 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1HTIIg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Aug 2011 04:08:36 -0400
Content-Disposition: inline
In-Reply-To: <20110819121516.GA2270@zod.bos.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 19, 2011 at 08:15:16AM -0400, Josh Boyer wrote:
> On Fri, Aug 19, 2011 at 04:12:08PM +0800, Herbert Xu wrote:
> > On Fri, Aug 19, 2011 at 03:32:24PM +0800, Herbert Xu wrote:
> > > 
> > > Meanwhile I'll make a patch that ensures cryptd is registered
> > > before aesni.
> > 
> > Please try this patch.  Thanks!
> 
> This worked great.  I'm confused why adding ivsize to the ablk_ecb_alg
> "worked" as well, but looking at the traces again I agree this seems
> like the actual problem.

Thanks for testing! Patch applied and pushed.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
