From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hw_random: omap3-rom-rng.c: Remove obsoleted functions
Date: Wed, 24 Aug 2016 21:17:41 +0800
Message-ID: <20160824131741.GA4039@gondor.apana.org.au>
References: <1471708866-1423-1-git-send-email-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, aaro.koskinen@iki.fi,
        mpm@selenic.com, linux-kernel@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37072 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754455AbcHXNSA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 09:18:00 -0400
Content-Disposition: inline
In-Reply-To: <1471708866-1423-1-git-send-email-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 20, 2016 at 09:31:06PM +0530, PrasannaKumar Muralidharan wrote:
> Remove omap3_rom_rng_data_present method as it was returning 1 always.
> Use .read callback instead of .data_read callback. This avoids use of
> obsolete callbacks.
> 
> This patch is not tested with hardware as I don't have access to it.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
