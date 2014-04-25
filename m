From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 00/11] crypto: caam: Error reporting fixes
Date: Fri, 25 Apr 2014 11:20:52 -0700
Message-ID: <20140425182052.GE5422@outflux.net>
References: <1398362722-16430-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.outflux.net ([198.145.64.163]:44489 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbaDYSU6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Apr 2014 14:20:58 -0400
Content-Disposition: inline
In-Reply-To: <1398362722-16430-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Apr 24, Marek wrote:
> First stab at reworking the error.c thing in Freescale CAAM.
> This patchset cleans it up so it's not doing any too insane
> string messing anymore.
>
> NOTE: Can someone please test this on real hardware? I have
>       none at hand, so THIS IS COMPILE-TESTED ONLY!
>
> Marek Vasut (11):
>   crypto: caam: Contain caam_jr_strstatus() ugliness
>   crypto: caam: Pull all the error codes out
>   crypto: caam: Implement fast-path for error codes with no handler
>   crypto: caam: Pass error type into the functions
>   crypto: caam: Kill the easy targets
>   crypto: caam: Dissolve report_jump_idx()
>   crypto: caam: Clean up report_ccb_status()
>   crypto: caam: Clean up report_deco_status()
>   crypto: caam: Kill SPRINTFCAT() with fire
>   crypto: caam: Sweep the remnants
>   crypto: caam: Fix the 'quoted string split across lines'
>
>  drivers/crypto/caam/caamalg.c  |  28 +--
>  drivers/crypto/caam/caamhash.c |  28 +--
>  drivers/crypto/caam/caamrng.c  |   7 +-
>  drivers/crypto/caam/error.c    | 389
> +++++++++++++++++++----------------------
>  drivers/crypto/caam/error.h    |   2 +-
>  drivers/crypto/caam/key_gen.c  |   7 +-
>  6 files changed, 200 insertions(+), 261 deletions(-)
>
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Horia Geanta <horia.geanta@freescale.com>

Thanks for doing this! The final result looks good to me, though I too
can't test with real hardware. Please consider the whole series:

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
