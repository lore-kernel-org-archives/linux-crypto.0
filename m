Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37352 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeKITbC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:31:02 -0500
Date: Fri, 9 Nov 2018 17:51:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yael Chemla <yael.chemla@foss.arm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: ccree: add SM3 support
Message-ID: <20181109095108.4txbedqhdxn7bz4r@gondor.apana.org.au>
References: <1539867599-20504-1-git-send-email-yael.chemla@foss.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539867599-20504-1-git-send-email-yael.chemla@foss.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 18, 2018 at 01:59:56PM +0100, Yael Chemla wrote:
> Add support for SM3 in CryptoCell 713.
> 
> Yael Chemla (3):
>   crypto: ccree: adjust hash length to suit certain context specifics
>   crypto: ccree:  modify set_cipher_mode usage from cc_hash
>   crypto: ccree: add SM3 support
> 
>  drivers/crypto/Kconfig                  |   1 +
>  drivers/crypto/ccree/cc_aead.c          |  19 +++-
>  drivers/crypto/ccree/cc_crypto_ctx.h    |   4 +-
>  drivers/crypto/ccree/cc_driver.c        |  10 +-
>  drivers/crypto/ccree/cc_driver.h        |   2 +-
>  drivers/crypto/ccree/cc_hash.c          | 175 +++++++++++++++++++++++---------
>  drivers/crypto/ccree/cc_hw_queue_defs.h |  27 +++++
>  7 files changed, 182 insertions(+), 56 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
