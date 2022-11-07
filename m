Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD48C43219
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Nov 2022 07:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiKGHjd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Nov 2022 02:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiKGHjc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Nov 2022 02:39:32 -0500
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94E6D9A
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 23:39:30 -0800 (PST)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id D06EC201472;
        Mon,  7 Nov 2022 07:39:28 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id AB650806D5; Mon,  7 Nov 2022 08:37:52 +0100 (CET)
Date:   Mon, 7 Nov 2022 08:37:52 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] hw_random: use add_hwgenerator_randomness() for early
 entropy
Message-ID: <Y2i10CV5OJ69ZK8q@owl.dominikbrodowski.net>
References: <CAHmME9r=xGdYa1n16TTgdfvzLkc==hGr+1v3eZmyzpEX+437uw@mail.gmail.com>
 <20221106015042.98538-1-Jason@zx2c4.com>
 <Y2dcIKWOmczDCGLG@owl.dominikbrodowski.net>
 <Y2fJy1akGIdQdH95@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2fJy1akGIdQdH95@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

Am Sun, Nov 06, 2022 at 03:50:51PM +0100 schrieb Jason A. Donenfeld:
> On Sun, Nov 06, 2022 at 08:02:56AM +0100, Dominik Brodowski wrote:
> > Am Sun, Nov 06, 2022 at 02:50:42AM +0100 schrieb Jason A. Donenfeld:
> > > Rather than calling add_device_randomness(), the add_early_randomness()
> > > function should use add_hwgenerator_randomness(), so that the early
> > > entropy can be potentially credited, which allows for the RNG to
> > > initialize earlier without having to wait for the kthread to come up.
> > 
> > We're already at device_initcall() level here, so that shouldn't be much of
> > an additional delay.
> 
> Either the delay is not relevant, in which case we should entirely
> remove `add_early_randomness()`,

There's another subtlety going on here: add_device_randomness() is called
for *all* hw_random devices upon their registration, while the hwrng thread
currently only works with the hw_random device with the best quality
available.

Thanks,
	Dominik
