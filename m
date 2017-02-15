From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Qualcomm QCE driver: XTS setkey only allows 128 bit AES
Date: Wed, 15 Feb 2017 12:02:43 +0800
Message-ID: <20170215040243.GA13703@gondor.apana.org.au>
References: <1690729.u0Mf5VzSsv@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37425 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751503AbdBOECw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 23:02:52 -0500
Content-Disposition: inline
In-Reply-To: <1690729.u0Mf5VzSsv@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Müller <smueller@chronox.de> wrote:
> Hi,
> 
> The Qualcomm QCE driver implementation defines:
> 
>                .flags          = QCE_ALG_AES | QCE_MODE_XTS,
>                .name           = "xts(aes)",
>                .drv_name       = "xts-aes-qce",
>                .blocksize      = AES_BLOCK_SIZE,
>                .ivsize         = AES_BLOCK_SIZE,
>                .min_keysize    = AES_MIN_KEY_SIZE,
>                .max_keysize    = AES_MAX_KEY_SIZE,
> 
> and
> 
>        alg->cra_ablkcipher.min_keysize = def->min_keysize;
>        alg->cra_ablkcipher.max_keysize = def->max_keysize;
>        alg->cra_ablkcipher.setkey = qce_ablkcipher_setkey;
> 
> Thus, this driver has the limits of 128 to 256 bits for the key. Furthermore, 
> the common setkey function is used.
> 
> May I ask how the key for AES XTS is supposed to be handled here considering 
> that the kernel crypto API expects that the AES key and the tweak key is set 
> via one setkey call. I.e. the setkey should expect 256 through 512 bits.

If the hardware doesn't support it then it needs to be handled with
a fallback.  Shouldn't testmgr catch this though?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
