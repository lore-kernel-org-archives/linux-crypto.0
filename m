From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm/aes - avoid reserved 'tt' mnemonic in asm
 code
Date: Fri, 13 Jan 2017 22:37:34 +0800
Message-ID: <20170113143734.GC26101@gondor.apana.org.au>
References: <1484296406-13224-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47059 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751745AbdAMOhp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 09:37:45 -0500
Content-Disposition: inline
In-Reply-To: <1484296406-13224-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 08:33:26AM +0000, Ard Biesheuvel wrote:
> The ARMv8-M architecture introduces 'tt' and 'ttt' instructions,
> which means we can no longer use 'tt' as a register alias on recent
> versions of binutils for ARM. So replace the alias with 'ttab'.
> 
> Fixes: 81edb4262975 ("crypto: arm/aes - replace scalar AES cipher")
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
