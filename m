From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] CAAM RNG4 fixes
Date: Mon, 25 Aug 2014 20:41:32 +0800
Message-ID: <20140825124132.GE28815@gondor.apana.org.au>
References: <1407746417-9134-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Alex Porosanu <alexandru.porosanu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34044 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbaHYMlf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Aug 2014 08:41:35 -0400
Content-Disposition: inline
In-Reply-To: <1407746417-9134-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 11, 2014 at 11:40:14AM +0300, Alex Porosanu wrote:
> This series of patches target the RNG4 block of CAAM and fix an
> issue identified on new platforms using this IP. 
> Two of the patches, change the way the entropy is being taken
> from the internal oscillator and adjust the delay accordingly.
> 
> Alex Porosanu (3):
>   crypto: caam - disable RNG oscillator maximum frequency check
>   crypto: caam - change starting entropy delay value
>   crypto: caam - enable raw data instead of von Neumann data

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
