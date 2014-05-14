From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH resend 13/15] arm64/crypto: add voluntary preemption to
 Crypto Extensions SHA1
Date: Wed, 14 May 2014 09:36:39 +0800
Message-ID: <20140514013639.GA29126@gondor.apana.org.au>
References: <1398959486-8222-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	catalin.marinas@arm.com, will.deacon@arm.com,
	steve.capper@linaro.org, ard.biesheuvel@linaro.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:36121 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaENBgr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2014 21:36:47 -0400
Content-Disposition: inline
In-Reply-To: <1398959486-8222-4-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> +               /*
> +                * Pass current's thread info pointer to sha1_ce_transform()
> +                * below if we want it to play nice under preemption.
> +                */
> +               if ((IS_ENABLED(CONFIG_PREEMPT_VOLUNTARY) ||
> +                    IS_ENABLED(CONFIG_PREEMPT)) && !in_interrupt())
> +                       ti = current_thread_info();

Instead of in_interrupt you should test CRYPTO_TFM_REQ_MAY_SLEEP.
It's not a matter of correctness but it may avoid unnecessary
breaks in the loop.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
