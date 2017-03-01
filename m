From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: arm/crc32 - fix build error with outdated
 binutils
Date: Wed, 1 Mar 2017 19:52:02 +0800
Message-ID: <20170301115202.GA11489@gondor.apana.org.au>
References: <1488292617-27317-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        arnd@arndb.de, jonathanh@nvidia.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58753 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752159AbdCALwW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Mar 2017 06:52:22 -0500
Content-Disposition: inline
In-Reply-To: <1488292617-27317-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 28, 2017 at 02:36:56PM +0000, Ard Biesheuvel wrote:
> Annotate a vmov instruction with an explicit element size of 32 bits.
> This is inferred by recent toolchains, but apparently, older versions
> need some help figuring this out.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
