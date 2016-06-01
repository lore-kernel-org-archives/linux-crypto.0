From: Stephan Mueller <smueller@chronox.de>
Subject: Re: (none)
Date: Wed, 01 Jun 2016 09:05:42 +0200
Message-ID: <1581206.RWN3o2UYVn@tauon.atsec.com>
References: <20160601045943.GA31881@gondor.apana.org.au> <20160601061947.GA32424@gondor.apana.org.au> <CAH8yC8==HPONkYSoPaa9E0b4+SKnbPEPeQatBUqc_HzJbD8DAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35630 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbcFAHFp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 03:05:45 -0400
In-Reply-To: <CAH8yC8==HPONkYSoPaa9E0b4+SKnbPEPeQatBUqc_HzJbD8DAA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 1. Juni 2016, 02:59:21 schrieb Jeffrey Walton:

Hi Jeffrey,

> On Wed, Jun 1, 2016 at 2:19 AM, Herbert Xu <herbert@gondor.apana.org.au> 
wrote:
> > On Wed, Jun 01, 2016 at 07:53:38AM +0200, Stephan Mueller wrote:
> >> I thought via-rng.c covers the VIA Padlock RNG?
> > 
> > Indeed, you're quite right.  In that case Jeffrey was the via-rng
> > driver loaded?

[...]

Ok, it is loaded. Did you use /dev/hw_random for getting data?

Ciao
Stephan
