From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix gcc 4.6 warning
Date: Thu, 26 Jan 2012 13:37:55 +1100
Message-ID: <20120126023755.GC10696@gondor.apana.org.au>
References: <20120109102740.82e4ac0f8425930b6a34ac1c@freescale.com> <20120113053918.GG13918@gondor.apana.org.au> <20120118183434.16fc1a747ab6c79ee68076a2@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:55200 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2AZCh7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jan 2012 21:37:59 -0500
Content-Disposition: inline
In-Reply-To: <20120118183434.16fc1a747ab6c79ee68076a2@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 18, 2012 at 06:34:34PM -0600, Kim Phillips wrote:
> On Fri, 13 Jan 2012 16:39:18 +1100
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > On Mon, Jan 09, 2012 at 10:27:40AM -0600, Kim Phillips wrote:
> > > drivers/crypto/caam/ctrl.c: In function 'caam_probe':
> > > drivers/crypto/caam/ctrl.c:49:6: warning: unused variable 'd' [-Wunused-variable]
> > > 
> > > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> > 
> > Both patches applied.
> 
> Hi Herbert, I see you've applied:
> 
> e863f9c crypto: caam - add sha224 and sha384 variants to existing AEAD algorithm
> 0113529 crypto: caam - be less noisy on startup
> 
> to the cryptodev tree, but not the one at the start of this thread,
> which needs to go into your crypto tree (it's a fix for v3.3).  I'm
> resending it below in case it was lost.

I've applied it to cryptodev as I don't think this is important
enough to warrant going into crypto right away.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
