Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F12C433FE
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Nov 2022 14:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiKFOvC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Nov 2022 09:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiKFOvB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Nov 2022 09:51:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC85DA6
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 06:50:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1AFE60C7E
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 14:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9976C433D7;
        Sun,  6 Nov 2022 14:50:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FS3XlJAB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667746253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KP2ixZ7qVlGjFhu3gUTQLi1IG37QIeVjRzibxjCFqE8=;
        b=FS3XlJABp6EwroqUF7hir6aiUNKjoJTTSOyKXHoutR6f0nKgwQjGUl4dmMvJ6/hZLOLI3O
        ugi3W6IAL7T6NxNqwx1gB2lgvwedd2NNORPLr9iy52UtliQcKzIvYap3cywzKDcEA8n+wo
        ICx/1D76g0bHw2dUcVdVe6hgnPlB5FU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e969e412 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 6 Nov 2022 14:50:53 +0000 (UTC)
Date:   Sun, 6 Nov 2022 15:50:51 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] hw_random: use add_hwgenerator_randomness() for early
 entropy
Message-ID: <Y2fJy1akGIdQdH95@zx2c4.com>
References: <CAHmME9r=xGdYa1n16TTgdfvzLkc==hGr+1v3eZmyzpEX+437uw@mail.gmail.com>
 <20221106015042.98538-1-Jason@zx2c4.com>
 <Y2dcIKWOmczDCGLG@owl.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2dcIKWOmczDCGLG@owl.dominikbrodowski.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Dominik,

On Sun, Nov 06, 2022 at 08:02:56AM +0100, Dominik Brodowski wrote:
> Am Sun, Nov 06, 2022 at 02:50:42AM +0100 schrieb Jason A. Donenfeld:
> > Rather than calling add_device_randomness(), the add_early_randomness()
> > function should use add_hwgenerator_randomness(), so that the early
> > entropy can be potentially credited, which allows for the RNG to
> > initialize earlier without having to wait for the kthread to come up.
> 
> We're already at device_initcall() level here, so that shouldn't be much of
> an additional delay.

Either the delay is not relevant, in which case we should entirely
remove `add_early_randomness()`, or the delay is relevant, in which case
hw_random should use the right function, so that it gets credited as it
should. (Semantically this is the right thing to do, too, so that
random.c can actually know what the deal is with the data it's getting;
knowing, "oh this comes from hw_random" could be useful.)

> > Since we don't want to sleep from add_early_randomness(), we also
> > refactor the API a bit so that hw_random/core.c can do the sleep, this
> > time using the correct function, hwrng_msleep, rather than having
> > random.c awkwardly do it.
> 
> Isn't this something you were quite hesistant about just recently[*]?

It is, yes, thanks. The concern is that now it means random.c can't ask
for more hw_random data by canceling that sleep. I was thinking that it
would be nice to cancel the sleep during system resume, vm fork, and
other similar events, so that we can get some fresh bits during the
times it matters most. But there's a bit of a problem of doing it in a
basic way like that: we might get the bits, but that doesn't mean we'll
reseed right away at that advanced stage in uptime. So we'd actually
need something more complicated like, "unblock from sleep now and reseed
after mixing data". When writing this patch last night, I was thinking
this is a more complicated thing that could benefit from a more
complicated API. But actually, maybe there's a way I can make it work
for the existing thing. So you're right: let's hold off on this v2. And
I'll send a v3 that just adds a boolean parameter of whether or not to
sleep. And then I'll also try tackling the unblock&reseed thing too at
the same time.

Jason
