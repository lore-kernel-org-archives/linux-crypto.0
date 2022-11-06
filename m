Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC7BC433FE
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Nov 2022 07:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiKFHFe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Nov 2022 02:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKFHFd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Nov 2022 02:05:33 -0500
X-Greylist: delayed 147 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Nov 2022 00:05:32 PDT
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED64A45A
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 00:05:32 -0700 (PDT)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id 5F2272000B1;
        Sun,  6 Nov 2022 07:05:30 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id 8B69D8010D; Sun,  6 Nov 2022 08:05:25 +0100 (CET)
Date:   Sun, 6 Nov 2022 08:05:25 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] hw_random: treat default_quality as a maximum and
 default to 1024
Message-ID: <Y2dctc4A0ccl3Hwp@owl.dominikbrodowski.net>
References: <20221104154230.52836-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104154230.52836-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Fri, Nov 04, 2022 at 04:42:30PM +0100 schrieb Jason A. Donenfeld:
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
> So let's invert this logic. A hw_random struct's quality knob now
> controls the maximum quality a driver can produce, or 0 to specify 1024.
> Then, the module-wide switch called "default_quality" is changed to
> represent the maximum quality of any driver. By default it's 1024, and
> the quality of any particular driver is then given by:
> 
>     min(default_quality, rng->quality ?: 1024);
> 
> This way, the user can still turn this off for weird reasons, yet we get
> proper crediting for relevant RNGs.

Hm. Wouldn't we need to verify that 1024 is appropriate for all drivers
where the quality currently is not set?

Thanks,
	Dominik
