From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] x86/crypto: ghash: use C implementation for setkey()
Date: Thu, 27 Mar 2014 19:36:10 +0800
Message-ID: <20140327113610.GA8402@gondor.apana.org.au>
References: <1395919740-20774-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
	hpa@zytor.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:38025 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbaC0LgS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Mar 2014 07:36:18 -0400
Content-Disposition: inline
In-Reply-To: <1395919740-20774-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 27, 2014 at 12:29:00PM +0100, Ard Biesheuvel wrote:
> The GHASH setkey() function uses SSE registers but fails to call
> kernel_fpu_begin()/kernel_fpu_end(). Instead of adding these calls, and
> then having to deal with the restriction that they cannot be called from
> interrupt context, move the setkey() implementation to the C domain.

Note that setkey cannot be called from interrupt context since
allocation/setkey is supposed to be slow-path material.

But your approach is fine by me.

> Note that setkey() does not use any particular SSE features and is not
> expected to become a performance bottleneck.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> 
> I suppose this should be marked for stable as well?

Sure I'll add the cc.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
