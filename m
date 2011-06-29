From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix operator precedence in shared
	descriptor allocation
Date: Thu, 30 Jun 2011 07:44:46 +0800
Message-ID: <20110629234446.GA16511@gondor.apana.org.au>
References: <20110523184523.62654cb1.kim.phillips@freescale.com> <20110526033044.GB14500@gondor.apana.org.au> <20110629111226.0ffca866.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Kumar Gala <kumar.gala@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:42839 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab1F2XpJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2011 19:45:09 -0400
Content-Disposition: inline
In-Reply-To: <20110629111226.0ffca866.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 29, 2011 at 11:12:26AM -0500, Kim Phillips wrote:
> On Thu, 26 May 2011 13:30:44 +1000
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > On Mon, May 23, 2011 at 06:45:23PM -0500, Kim Phillips wrote:
> > > setkey allocates 16 bytes (CAAM_CMD_SZ *
> > > DESC_AEAD_SHARED_TEXT_LEN) shy of what is needed to
> > > store the shared descriptor, resulting in memory
> > > corruption.  Fix this.
> > > 
> > > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> > 
> > Applied to cryptodev.  Thanks Kim!
> 
> Herbert, this patch fixes a memory corruption bug introduced in
> commit 4427b1b - "crypto: caam - add support for sha512 variants of
> existing AEAD algorithms", which is currently the last commit for
> caam in Linus' tree. Can you please push this commit (c5bf900 in
> cryptodev) to Linus before he releases 3.0?

Thanks for the note.  I'll push this patch to crypto-2.6 and rebase
cryptodev.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
