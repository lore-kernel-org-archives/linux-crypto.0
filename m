From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm/ghash: change internal cra_name to "__ghash"
Date: Wed, 7 Sep 2016 21:22:26 +0800
Message-ID: <20160907132226.GM17176@gondor.apana.org.au>
References: <1473076724-2725-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47247 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756625AbcIGOD7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 10:03:59 -0400
Content-Disposition: inline
In-Reply-To: <1473076724-2725-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 05, 2016 at 12:58:44PM +0100, Ard Biesheuvel wrote:
> The fact that the internal synchrous hash implementation is called
> "ghash" like the publicly visible one is causing the testmgr code
> to misidentify it as an algorithm that requires testing at boottime.
> So rename it to "__ghash" to prevent this.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
