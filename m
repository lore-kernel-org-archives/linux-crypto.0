From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: generic/aes - drop alignment requirement
Date: Sat, 11 Feb 2017 18:52:00 +0800
Message-ID: <20170211105200.GC855@gondor.apana.org.au>
References: <1486051137-20511-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ebiggers3@gmail.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36097 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750994AbdBKTAI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2017 14:00:08 -0500
Content-Disposition: inline
In-Reply-To: <1486051137-20511-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 02, 2017 at 03:58:57PM +0000, Ard Biesheuvel wrote:
> The generic AES code exposes a 32-bit align mask, which forces all
> users of the code to use temporary buffers or take other measures to
> ensure the alignment requirement is adhered to, even on architectures
> that don't care about alignment for software algorithms such as this
> one.
> 
> So drop the align mask, and fix the code to use get_unaligned_le32()
> where appropriate, which will resolve to whatever is optimal for the
> architecture.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
