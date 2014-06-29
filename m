From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/4] DRBG: cleanup of preprocessor macros
Date: Sun, 29 Jun 2014 13:37:05 +0200
Message-ID: <1616464.nTZ4WdyPoM@myon.chronox.de>
References: <4927386.WYHrRe3NJm@myon.chronox.de> <3104100.drOBnqUFp8@myon.chronox.de> <53AFC322.2060109@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-crypto@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34511 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbaF2LiW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Jun 2014 07:38:22 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S224> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 29 Jun 2014 13:37:12 +0200
In-Reply-To: <53AFC322.2060109@infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 29. Juni 2014, 00:41:22 schrieb Randy Dunlap:

Hi Randy,

> On 06/28/14 22:07, Stephan Mueller wrote:
> > Am Sonntag, 29. Juni 2014, 12:20:15 schrieb Stephen Rothwell:
> > 
> > Hi Stephen,
> > 
> >> Hi Stephan,
> >> 
> >> On Sat, 28 Jun 2014 22:00:07 +0200 Stephan Mueller <smueller@chronox.de>
> > 
> > wrote:
> >>> diff --git a/crypto/drbg.c b/crypto/drbg.c
> >>> index 6679a26..03a230e 100644
> >>> --- a/crypto/drbg.c
> >>> +++ b/crypto/drbg.c
> >>> @@ -102,8 +102,13 @@
> >>> 
> >>>  #if !defined(CONFIG_CRYPTO_DRBG_HASH) && \
> >>>  
> >>>  	!defined(CONFIG_CRYPTO_DRBG_HMAC) && \
> >>>  	!defined(CONFIG_CRYPTO_DRBG_CTR)
> >>> 
> >>> -#warning "The DRBG code is useless without compiling at least one DRBG
> >>> type" -#endif
> >>> +#define CRYPTO_DRBG_NONE_STRING "none "
> >>> +static int __init drbg_init(void)
> >>> +{
> >>> +	pr_warn("DRBG: no DRBG core was compiled!\n");
> >>> +	return -EFAULT;
> >>> +}
> >>> +#else
> >> 
> >> Wouldn't this be better handled by Kconfig so that we don't even try to
> >> build this unless one of the required core modules is chosen?
> > 
> > I tried that, but it seems that my Kconfig Foo is not too well: adding the
> > DRBG cores to the depends line of CRYPTO_DRBG as indicated in the
> > following, I have a circular dependency. With that circular dependency,
> > the DRBG entries do not show up in make menuconfig.
> > 
> > menuconfig CRYTPO_DRBG
> > 
> >         tristate "NIST SP800-90A DRBG"
> >         depends on CRYPTO && (CRYPTO_DRBG_HMAC || CRYPTO_DRBG_CTR ||
> > 
> > CRYPTO_DRBG_HASH)
> > ...
> > 
> > if CRYTPO_DRBG
> > 
> > config CRYPTO_DRBG_HMAC
> > 
> >         bool "Enable HMAC DRBG"
> >         default y
> >         depends on CRYTPO_DRBG
> > 
> > Do you have a working solution in mind? The goal is that once CRYPTO_DRBG
> > is selected, at least one of the DRBG cores must be selected.
> 
> That sounds like a 'choice' Kconfig could be used.
> Have you looked at that possibility?
> 
> See Documentation/kbuild/kconfig-language.txt and search for 'choice'.

When looking into the documentation and trying it I found:

- bool choices allow me to only select one option, and only one

- tristate choices allow me to only select one option, if the initial tristate 
is set to yes. If the initial tristate is set to module, it allows zero to all 
options to be set.

That said, neither covers my requirement here: require that at least one 
option is set, but allow more options.

Thanks
Stephan
-- 
| Cui bono? |
