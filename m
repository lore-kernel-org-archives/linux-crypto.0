From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm64/sha - avoid non-standard inline asm tricks
Date: Thu, 18 May 2017 13:26:54 +0800
Message-ID: <20170518052654.GE32485@gondor.apana.org.au>
References: <20170426161132.11311-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, mka@chromium.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:41902 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752823AbdERF1I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 May 2017 01:27:08 -0400
Content-Disposition: inline
In-Reply-To: <20170426161132.11311-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 26, 2017 at 05:11:32PM +0100, Ard Biesheuvel wrote:
> Replace the inline asm which exports struct offsets as ELF symbols
> with proper const variables exposing the same values. This works
> around an issue with Clang which does not interpret the "i" (or "I")
> constraints in the same way as GCC.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
