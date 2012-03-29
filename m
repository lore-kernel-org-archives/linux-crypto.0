From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] powerpc/crypto: caam - add backward compatible string
	sec4.0
Date: Thu, 29 Mar 2012 16:36:19 +0800
Message-ID: <20120329083619.GA17727@gondor.apana.org.au>
References: <1332310150-8274-1-git-send-email-Shengzhou.Liu@freescale.com> <20120322191509.9e049a78b87a10f71bc6ebeb@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shengzhou Liu <Shengzhou.Liu@freescale.com>,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:42850 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751731Ab2C2IgV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Mar 2012 04:36:21 -0400
Content-Disposition: inline
In-Reply-To: <20120322191509.9e049a78b87a10f71bc6ebeb@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 22, 2012 at 07:15:09PM -0500, Kim Phillips wrote:
> On Wed, 21 Mar 2012 14:09:10 +0800
> Shengzhou Liu <Shengzhou.Liu@freescale.com> wrote:
> 
> > In some device trees of previous version, there were string "fsl,sec4.0".
> > To be backward compatible with device trees, we have CAAM driver first
> > check "fsl,sec-v4.0", if it fails, then check for "fsl,sec4.0".
> > 
> > Signed-off-by: Shengzhou Liu <Shengzhou.Liu@freescale.com>
> > ---
> 
> Acked-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
