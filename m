Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8620AC4332F
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Nov 2022 12:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiKGMoj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Nov 2022 07:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiKGMoi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Nov 2022 07:44:38 -0500
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B0C1B7AE
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 04:44:37 -0800 (PST)
Received: by isilmar-4.linta.de (Postfix, from userid 1000)
        id 84E0320142B; Mon,  7 Nov 2022 12:44:34 +0000 (UTC)
Date:   Mon, 7 Nov 2022 13:44:34 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2] hw_random: treat default_quality as a maximum and
 default to 1024
Message-ID: <20221107124434.GA9166@isilmar-4.linta.de>
References: <CAHmME9pjWNGaF+4+ubFuu1AXhRkEbU7mxT-RtOhWVYkAgxXiDg@mail.gmail.com>
 <20221107122455.6169-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107122455.6169-1-Jason@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

Thanks for the additional explanation!

	Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>

Thanks,
	Dominik
