From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [HIFN]: Fix invalid config ifdefs for RNG support
Date: Fri, 8 Feb 2008 02:00:19 +1100
Message-ID: <20080207150019.GA6768@gondor.apana.org.au>
References: <47A9BCE5.5080307@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48678 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755846AbYBGPAW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Feb 2008 10:00:22 -0500
Content-Disposition: inline
In-Reply-To: <47A9BCE5.5080307@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 06, 2008 at 02:57:57PM +0100, Patrick McHardy wrote:

> commit 3810a091ff8bc9b5038647a4b32a08267284f3f9
> Author: Patrick McHardy <kaber@gw.localnet>
> Date:   Wed Feb 6 14:56:09 2008 +0100
> 
>     [HIFN]: Fix invalid config ifdefs for RNG support
>     
>     The CRYPTO_DEV_HIFN_795X_RNG ifdefs are missing the CONFIG_ prefix.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Patch applied.  Thanks Patrick!

I'll push this for 2.6.25.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
