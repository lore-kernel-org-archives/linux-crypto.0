From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] Added CRYPTO_ALG_KERN_DRIVER_ONLY flag (3rd
	attempt)
Date: Fri, 6 Jan 2012 20:32:22 +1100
Message-ID: <20120106093222.GA9671@gondor.apana.org.au>
References: <20120106013701.GA6484@gondor.apana.org.au> <4F06AE75.9050806@gnutls.org> <20120106082824.GA9152@gondor.apana.org.au> <CAJU7zaJHVr-7XhbTz2yap6Am=-kRYbx+88fo2C3dvZFc8Vv3kg@mail.gmail.com> <20120106091206.GA9458@gondor.apana.org.au> <CAJU7zaL76J-856byTkLYh9HGqs7X3=XP3HyaiSAOcEJfVtSGuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40408 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab2AFJcZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jan 2012 04:32:25 -0500
Content-Disposition: inline
In-Reply-To: <CAJU7zaL76J-856byTkLYh9HGqs7X3=XP3HyaiSAOcEJfVtSGuA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 06, 2012 at 10:29:22AM +0100, Nikos Mavrogiannopoulos wrote:
> On Fri, Jan 6, 2012 at 10:12 AM, Herbert Xu
> <herbert@gondor.hengli.com.au> wrote:
> 
> >> How the flag is exported by cryptodev-linux:
> >> http://repo.or.cz/w/cryptodev-linux.git/blob/aead:/ioctl.c#l716
> > Actually I was looking for code that uses crypto_tfm_alg_flags
> > function.
> 
> The code above will use it once it is accepted. Now it accesses
> directly the flags.

Yes but I don't see how you're going to use this since you don't
even have a crypto_tfm structure in user-space.  So how will your
code look like?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
