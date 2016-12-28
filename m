From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - initialize cra_flags before register into
 kpp
Date: Wed, 28 Dec 2016 18:12:12 +0800
Message-ID: <20161228101212.GA12607@gondor.apana.org.au>
References: <20161222150051.6284-1-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com,
        Sushil Kumar <sushilx.kumar@intel.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59363 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751268AbcL1Kad (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 05:30:33 -0500
Content-Disposition: inline
In-Reply-To: <20161222150051.6284-1-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 22, 2016 at 03:00:51PM +0000, Giovanni Cabiddu wrote:
> Initialize dh.base.cra_flags before registering the dh algorithm.
> Without this fix, the registration of the dh algorithm might fail
> if the qat driver is restarted.
> 
> Signed-off-by: Sushil Kumar <sushilx.kumar@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Please patch the crypto API instead.  I think unsetting the bit
CRYPTO_ALG_DEAD at the top of crypto_register_alg should do the
trick.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
