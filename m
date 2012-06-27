From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/20] crypto: caam - driver updates
Date: Wed, 27 Jun 2012 14:51:44 +0800
Message-ID: <20120627065144.GD22920@gondor.apana.org.au>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:33330 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751960Ab2F0Gvr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jun 2012 02:51:47 -0400
Content-Disposition: inline
In-Reply-To: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 22, 2012 at 07:42:34PM -0500, Kim Phillips wrote:
> The following updates bring the upstream CAAM driver mostly up to date wrt
> Freescale's SDK 1.2 release:
> 
> patch 1 is a cosmetic fix
> 
> patch 2 is a mapping size fix
> 
> patches 3-5 are protocol descriptor generation updates (not currently used
> in the kernel driver, but these header files are shared with other projects in
> the SDK; hope that's ok).
> 
> patches 6-9 refactor code in preparation for ahash and hwrng support; and
> patch 7 removes the job ring registration interface in favour of user-managed
> selection and sharing of rings (see caam_rng_init, which simply chooses
> job ring 0 for all its operations).
> 
> patches 10-12 add ahash support (keyed and unkeyed)
> 
> patch 13 adds hwrng support
> 
> patches 14-15 add support for the SEC v5.x series, which most notably gets a
> new RNG (tested on P5040 h/w)
> 
> patches 16-20 contain various performance improvements

All applied.  Thanks Kim!

> There are two patches remaining in the SDK that I'm holding off for now,
> as I believe they need more testing: use NAPI instead of tasklet, and
> set descriptor sharing type to SERIAL.

While using the NAPI concept definitely makes sense, I'm still
unsure about using napi_struct directly in crypto code.  Dave,
did you have a chance to look at their patch to use NAPI in their
crypto driver?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
