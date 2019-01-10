Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59604 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbfAJODT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 09:03:19 -0500
Date: Thu, 10 Jan 2019 22:03:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Rob Rice <rob.rice@broadcom.com>,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Yael Chemla <yael.chemla@foss.arm.com>
Subject: Re: [PATCH 0/3] crypto: authenc - fix key parsing
Message-ID: <20190110140314.h4jnz6ie3ldqrioo@gondor.apana.org.au>
References: <20181217072324.16844-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181217072324.16844-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 16, 2018 at 11:23:21PM -0800, Eric Biggers wrote:
> Fix incorrect validation of the key passed to "authenc" AEADs that
> allowed crashing the kernel via AF_ALG.  The real fix is in patch 1, but
> two drivers had to be converted to use crypto_authenc_extractkeys() too.
> 
> Please note: for the bcm and ccree driver changes I haven't re-run the
> self-tests, as I don't have that hardware.  Please do so if you can.
> 
> Eric Biggers (3):
>   crypto: authenc - fix parsing key with misaligned rta_len
>   crypto: bcm - convert to use crypto_authenc_extractkeys()
>   crypto: ccree - convert to use crypto_authenc_extractkeys()
> 
>  crypto/authenc.c               | 14 ++++++++---
>  drivers/crypto/Kconfig         |  1 +
>  drivers/crypto/bcm/cipher.c    | 44 ++++++++++------------------------
>  drivers/crypto/ccree/cc_aead.c | 40 +++++++++++++++----------------
>  4 files changed, 44 insertions(+), 55 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
