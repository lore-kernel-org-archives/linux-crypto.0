Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2D6C433FE
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Nov 2022 07:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiKFHIm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Nov 2022 02:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKFHIl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Nov 2022 02:08:41 -0500
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4ACB1FE
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 00:08:40 -0700 (PDT)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id 4F2A02000AF;
        Sun,  6 Nov 2022 07:03:03 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id BE8B88082C; Sun,  6 Nov 2022 08:02:56 +0100 (CET)
Date:   Sun, 6 Nov 2022 08:02:56 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] hw_random: use add_hwgenerator_randomness() for early
 entropy
Message-ID: <Y2dcIKWOmczDCGLG@owl.dominikbrodowski.net>
References: <CAHmME9r=xGdYa1n16TTgdfvzLkc==hGr+1v3eZmyzpEX+437uw@mail.gmail.com>
 <20221106015042.98538-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221106015042.98538-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Sun, Nov 06, 2022 at 02:50:42AM +0100 schrieb Jason A. Donenfeld:
> Rather than calling add_device_randomness(), the add_early_randomness()
> function should use add_hwgenerator_randomness(), so that the early
> entropy can be potentially credited, which allows for the RNG to
> initialize earlier without having to wait for the kthread to come up.

We're already at device_initcall() level here, so that shouldn't be much of
an additional delay.

> Since we don't want to sleep from add_early_randomness(), we also
> refactor the API a bit so that hw_random/core.c can do the sleep, this
> time using the correct function, hwrng_msleep, rather than having
> random.c awkwardly do it.

Isn't this something you were quite hesistant about just recently[*]?

| I was thinking the other day that under certain circumstances, it
| would be nice if random.c could ask hwrng for more bytes NOW, rather
| than waiting. With the code as it is currently, this could be
| accomplished by having a completion event or something similar to
| that. With your proposed change, now it's left up to the hwrng
| interface to handle.
| 
| That's not the end of the world, but it does mean we'd have to come up
| with a patch down the line that exports a hwrng function saying, "stop
| the delays and schedule the worker NOW". Now impossible, just more
| complex, as now the state flow is split across two places. Wondering
| if you have any thoughts about this.

Thanks,
	Dominik

[*] https://lore.kernel.org/lkml/CAHmME9rhunb05DEnc=UfGr8k9_LBi1NW2Hi0OsRbGwcCN2NzjQ@mail.gmail.com/
