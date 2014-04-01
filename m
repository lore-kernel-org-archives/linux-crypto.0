From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] x86/crypto: ghash: use C implementation for setkey()
Date: Tue, 1 Apr 2014 17:23:28 +0800
Message-ID: <20140401092327.GA12328@gondor.apana.org.au>
References: <1395940480-3827-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, x86@kernel.org, hpa@zytor.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:34559 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaDAJXe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Apr 2014 05:23:34 -0400
Content-Disposition: inline
In-Reply-To: <1395940480-3827-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 27, 2014 at 06:14:40PM +0100, Ard Biesheuvel wrote:
> The GHASH setkey() function uses SSE registers but fails to call
> kernel_fpu_begin()/kernel_fpu_end(). Instead of adding these calls, and
> then having to deal with the restriction that they cannot be called from
> interrupt context, move the setkey() implementation to the C domain.
> 
> Note that setkey() does not use any particular SSE features and is not
> expected to become a performance bottleneck.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Acked-by: H. Peter Anvin <hpa@linux.intel.com>
> Fixes: 0e1227d356e9b (crypto: ghash - Add PCLMULQDQ accelerated implementation)

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
