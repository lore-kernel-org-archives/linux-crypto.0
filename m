Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B77C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Feb 2022 10:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiBIKkS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Feb 2022 05:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiBIKkR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Feb 2022 05:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B032E051177;
        Wed,  9 Feb 2022 02:26:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4A746116A;
        Wed,  9 Feb 2022 10:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24C2C340E9;
        Wed,  9 Feb 2022 10:26:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kbhn+IvZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1644402414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2svKcuu1J+kLIMEZbYbrBfR3/HhtSLEOQ2lCTBpyRBU=;
        b=kbhn+IvZgCgy8RN2OoNq2kBiQpFy1IlqZvD5L1s2x5enXqxCqjMc26aBVyKMqx9aM3b9SD
        7Duqqwylncc+gEadD1gDxRwtjzMiuk+3LQ0CVpJtFniIcbA6dtKk2BLLsG1UnhoevK7Kti
        glAxUJfPTYTAw4/gTxHChGtaL/8kznM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4df73488 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 9 Feb 2022 10:26:54 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id o19so4412411ybc.12;
        Wed, 09 Feb 2022 02:26:54 -0800 (PST)
X-Gm-Message-State: AOAM53327nBQTI5mtePEo/67UBwlXhs0MEoaf+wx44fj437NU1e2rsRG
        Zc2yiII6vmetaxRUimgoa2kysNkkj21Q7JWbVbA=
X-Google-Smtp-Source: ABdhPJyfcN4r5lUGnIocQvQ6XpDe8g0x/a66jIhAhNJnVd4qpv30dbMx7AO4/UHptDK4tEaYXVT60/iooT5pQlsrWNk=
X-Received: by 2002:a81:3283:: with SMTP id y125mr1409333ywy.100.1644402412944;
 Wed, 09 Feb 2022 02:26:52 -0800 (PST)
MIME-Version: 1.0
References: <20220209011919.493762-1-Jason@zx2c4.com> <20220209011919.493762-3-Jason@zx2c4.com>
 <YgN5wp58XHYd7/WA@owl.dominikbrodowski.net>
In-Reply-To: <YgN5wp58XHYd7/WA@owl.dominikbrodowski.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 9 Feb 2022 11:26:41 +0100
X-Gmail-Original-Message-ID: <CAHmME9rjNQuBzoenhQ8rh_zep5bW9jRKj2zncTUFSu5dy1smFQ@mail.gmail.com>
Message-ID: <CAHmME9rjNQuBzoenhQ8rh_zep5bW9jRKj2zncTUFSu5dy1smFQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] random: get rid of secondary crngs
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Dominik,

On Wed, Feb 9, 2022 at 9:31 AM Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
>
> Just one question (which was already present in the past, but...):
>
> > -     WRITE_ONCE(crng->init_time, jiffies);
> > -     spin_unlock_irqrestore(&crng->lock, flags);
> > -     if (crng == &primary_crng && crng_init < 2)
> > -             crng_finalize_init();
> > +     WRITE_ONCE(primary_crng.init_time, jiffies);
> > +     spin_unlock_irqrestore(&primary_crng.lock, flags);
> > +     if (crng_init < 2) {
> > +             invalidate_batched_entropy();
> > +             crng_init = 2;
>
> Might this branch be taken twice if crng_reseed() is called concurrently
> twice? If so, we'd need to increment crng_init while holding the lock,
> such as I suggested in my patch "random: fix locking for crng_init in
> crng_reseed()". But that can be deferred to an additional patch.

Yes absolutely it can and absolutely we should. As a matter of fact,
your patch that you reference was kind of the straw that broke the
camel's back that motivated me to do this patchset now rather than
deferring it. Now we can fix the race you speak of without having to
split the functions and complicate the call graph even more. Do you
think you could rebase your patch on this branch and re-send? I'll
happily apply.

Jason
