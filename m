From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HW Accelerated IPSEC?
Date: Tue, 14 Jun 2011 16:56:52 -0400
Message-ID: <20110614205652.GA6048@gondor.apana.org.au>
References: <20110611011842.GA5222@gondor.apana.org.au> <4DF7C9C7.1000801@borg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kent Borg <kentborg@borg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:52429 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1FNU4z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 16:56:55 -0400
Content-Disposition: inline
In-Reply-To: <4DF7C9C7.1000801@borg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 14, 2011 at 04:51:19PM -0400, Kent Borg wrote:
> Herbert Xu wrote:
> > If that works then it's probably a bug in your driver, otherwise
> > we may have an issue in IPsec itself.
>
> I think I found my bug. I discovered DMA_API_DEBUG, and it complains  
> when my sha1 module loads. Looking it over it seems I can't do DMA from  
> an shash, I will have to figure out how to make an ahash. (Any pointers  
> on what code to crib from to best understand how an ahash works? Any  
> other documentation??)
>
> So, my sha1 module passes the self-test...just not safely.

mv_cesa uses ahash, right?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
