From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: simd ciphers
Date: Wed, 28 Dec 2016 16:59:38 +0800
Message-ID: <20161228085938.GA11904@gondor.apana.org.au>
References: <3279008.xAQAe6ukNz@positron.chronox.de>
 <10079298.uODr7IfrOJ@tauon.atsec.com>
 <1497014.RmdRyQUAOo@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51185 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751145AbcL1JaX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 04:30:23 -0500
Content-Disposition: inline
In-Reply-To: <1497014.RmdRyQUAOo@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 28, 2016 at 09:37:04AM +0100, Stephan Müller wrote:
> Am Donnerstag, 8. Dezember 2016, 19:40:38 CET schrieb Stephan Müller:
> 
> Hi Herbert,
> 
> > Am Donnerstag, 8. Dezember 2016, 19:32:03 CET schrieb Stephan Müller:
> > 
> > Hi Herbert,
> > 
> > > Hi Herbert,
> > > 
> > > with the addition of the simd cipher change I seem to be unable to use the
> > > AESNI ciphers. My .config contains CONFIG_CRYPTO_SIMD=y and
> > > CONFIG_CRYPTO_AES_NI_INTEL=y. Those options always worked to load the
> > > AES-NI
> > (with "always worked" I meant the CONFIG_CRYPTO_AES_NI_INTEL=y option of
> > course, that always ensured AES-NI to be present and usable)
> 
> With 4.10-rc1, I also do not get the AES-NI implementations to work. do you 
> have any ideas what may be the issue?

I'm having problems reproducing this.  Does it work for you if you
build them as modules?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
