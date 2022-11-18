Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51892C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241718AbiKRJKK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240700AbiKRJKJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:10:09 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8776F35C
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:10:07 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ovxNq-00FYN7-RO; Fri, 18 Nov 2022 17:10:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Nov 2022 17:10:02 +0800
Date:   Fri, 18 Nov 2022 17:10:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2] hw_random: treat default_quality as a maximum and
 default to 1024
Message-ID: <Y3dL6huTdU/vqD7H@gondor.apana.org.au>
References: <CAHmME9pjWNGaF+4+ubFuu1AXhRkEbU7mxT-RtOhWVYkAgxXiDg@mail.gmail.com>
 <20221107122455.6169-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107122455.6169-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 07, 2022 at 01:24:55PM +0100, Jason A. Donenfeld wrote:
> Most hw_random devices return entropy which is assumed to be of full
> quality, but driver authors don't bother setting the quality knob. Some
> hw_random devices return less than full quality entropy, and then driver
> authors set the quality knob. Therefore, the entropy crediting should be
> opt-out rather than opt-in per-driver, to reflect the actual reality on
> the ground.
> 
> For example, the two Raspberry Pi RNG drivers produce full entropy
> randomness, and both EDK2 and U-Boot's drivers for these treat them as
> such. The result is that EFI then uses these numbers and passes the to
> Linux, and Linux credits them as boot, thereby initializing the RNG.
> Yet, in Linux, the quality knob was never set to anything, and so on the
> chance that Linux is booted without EFI, nothing is ever credited.
> That's annoying.
> 
> The same pattern appears to repeat itself throughout various drivers. In
> fact, very very few drivers have bothered setting quality=1024.
> 
> Looking at the git history of existing drivers and corresponding mailing
> list discussion, this conclusion tracks. There's been a decent amount of
> discussion about drivers that set quality < 1024 -- somebody read and
> interepreted a datasheet, or made some back of the envelope calculation
> somehow. But there's been very little, if any, discussion about most
> drivers where the quality is just set to 1024 or unset (or set to 1000
> when the authors misunderstood the API and assumed it was base-10 rather
> than base-2); in both cases the intent was fairly clear of, "this is a
> hardware random device; it's fine."
> 
> So let's invert this logic. A hw_random struct's quality knob now
> controls the maximum quality a driver can produce, or 0 to specify 1024.
> Then, the module-wide switch called "default_quality" is changed to
> represent the maximum quality of any driver. By default it's 1024, and
> the quality of any particular driver is then given by:
> 
>     min(default_quality, rng->quality ?: 1024);
> 
> This way, the user can still turn this off for weird reasons (and we can
> replace whatever driver-specific disabling hacks existed in the past),
> yet we get proper crediting for relevant RNGs.
> 
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Changes v1->v2:
> - Expand commit message a bit.
> - Account for erroneous quality=1000 and quirky devices too.
> 
>  arch/um/drivers/random.c                          | 1 -
>  drivers/char/hw_random/cavium-rng-vf.c            | 1 -
>  drivers/char/hw_random/cn10k-rng.c                | 1 -
>  drivers/char/hw_random/core.c                     | 9 +++------
>  drivers/char/hw_random/mpfs-rng.c                 | 1 -
>  drivers/char/hw_random/npcm-rng.c                 | 1 -
>  drivers/char/hw_random/s390-trng.c                | 1 -
>  drivers/char/hw_random/timeriomem-rng.c           | 2 --
>  drivers/char/hw_random/virtio-rng.c               | 1 -
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c | 1 -
>  drivers/crypto/atmel-sha204a.c                    | 1 -
>  drivers/crypto/caam/caamrng.c                     | 1 -
>  drivers/firmware/turris-mox-rwtm.c                | 1 -
>  drivers/s390/crypto/zcrypt_api.c                  | 6 ------
>  drivers/usb/misc/chaoskey.c                       | 1 -
>  include/linux/hw_random.h                         | 2 +-
>  16 files changed, 4 insertions(+), 27 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
