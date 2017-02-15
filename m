From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Qualcomm QCE driver: XTS setkey only allows 128 bit AES
Date: Wed, 15 Feb 2017 08:28:25 +0100
Message-ID: <1735310.xhZtslYW8T@positron.chronox.de>
References: <20170215040243.GA13703@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59634 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdBOH22 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 02:28:28 -0500
In-Reply-To: <20170215040243.GA13703@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 15. Februar 2017, 12:02:43 CET schrieb Herbert Xu:

Hi Herbert,

> Stephan Müller <smueller@chronox.de> wrote:
> > Hi,
> > 
> > The Qualcomm QCE driver implementation defines:
> >                .flags          = QCE_ALG_AES | QCE_MODE_XTS,
> >                .name           = "xts(aes)",
> >                .drv_name       = "xts-aes-qce",
> >                .blocksize      = AES_BLOCK_SIZE,
> >                .ivsize         = AES_BLOCK_SIZE,
> >                .min_keysize    = AES_MIN_KEY_SIZE,
> >                .max_keysize    = AES_MAX_KEY_SIZE,
> > 
> > and
> > 
> >        alg->cra_ablkcipher.min_keysize = def->min_keysize;
> >        alg->cra_ablkcipher.max_keysize = def->max_keysize;
> >        alg->cra_ablkcipher.setkey = qce_ablkcipher_setkey;
> > 
> > Thus, this driver has the limits of 128 to 256 bits for the key.
> > Furthermore, the common setkey function is used.
> > 
> > May I ask how the key for AES XTS is supposed to be handled here
> > considering that the kernel crypto API expects that the AES key and the
> > tweak key is set via one setkey call. I.e. the setkey should expect 256
> > through 512 bits.
> If the hardware doesn't support it then it needs to be handled with
> a fallback.  Shouldn't testmgr catch this though?

It should be caught there because there are test vectors with a klen of 64 
bytes. Thus, the setkey should fail.

Ciao
Stephan
