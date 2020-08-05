Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6125C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 20:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3D7D206D4
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 20:38:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=foundries-io.20150623.gappssmtp.com header.i=@foundries-io.20150623.gappssmtp.com header.b="2S6WDkUD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgHEUiV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Aug 2020 16:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgHEUiU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Aug 2020 16:38:20 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F764C061575
        for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2020 13:38:20 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id q76so7606778wme.4
        for <linux-crypto@vger.kernel.org>; Wed, 05 Aug 2020 13:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=foundries-io.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7ai80oEXD5TUH4kL0wAhAhV8D1VZPYzvujrrgszirKg=;
        b=2S6WDkUDn9DLBsJscSu+iStNGO1FDRZewnWBSEYEyycowl4T6AZu/b4HrktcsQc4Cd
         sn/6QMScX1TGSFndtQNWYeMvzqryfNfKBGMEEkKmkXJJaR3ARZRg3JahLPCjADVjsfmq
         6cqiobIlzy088aA9lwBm/HfEwl7xTdZm/m69/KI2QF6a8yu5f31hFKiBHbEYQEO/PS58
         0Q1U0njODqZjp7XFPMeu/O5h7yqU+2bfAlrmD01POhRxT4XdejI9Li2t4Bci86rEWSwT
         a1jz5c8ud4wU8rgiVWxU+wvFDOpDF68UrOTbRxuFKKyHQSIP/pLj4jgqbNcH9Ip7Fw5q
         GMAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7ai80oEXD5TUH4kL0wAhAhV8D1VZPYzvujrrgszirKg=;
        b=k0Ce/RiRTwfrm87c9rJM81ayQjinlQi2Na52mOu0x8Tpb/7yA3AERItVU0hXwVKvp5
         QdQjkspuXjRiMM01opnxNk0wc/kFE8YJ0hw5J2sH66+vfZm3M8i2bIxr8iQuLFZ+m7Lc
         VqnMEW9WN+dkrwRIfQ7ihBGoxmGIb/zbnxKiMIl10ErcUCHzQZP/E56TFCIL4qrygkV0
         zXcBsktLcZmpNUkbl51GTRtkWlaTa/lWeo4ybzps19GcL663zI5FwtEs2YgSVhUSah9K
         ufKib7Yhhf1g3dX6eSSd4Y4gFHYM2elFx4RgeN0V0RQQkTpi7dUQ42Cjwb6m14vCpJcC
         aAhQ==
X-Gm-Message-State: AOAM531C1r8gi3sUQBm3rgVYhGmYiw+KNoTPF7Ege+yN6B6OTL9aopp5
        7otBsKQ3sISKY/EKz5u0R3g35w==
X-Google-Smtp-Source: ABdhPJw5dIrRnu6tWJo2YEBOEoRkU62p1ln//AAHICc8qihQrMWHzV9WM/WGq2WUU5Jrct39nNNFxw==
X-Received: by 2002:a1c:a942:: with SMTP id s63mr4602660wme.19.1596659898978;
        Wed, 05 Aug 2020 13:38:18 -0700 (PDT)
Received: from trex (239.red-83-34-184.dynamicip.rima-tde.net. [83.34.184.239])
        by smtp.gmail.com with ESMTPSA id 126sm4119322wme.42.2020.08.05.13.38.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Aug 2020 13:38:18 -0700 (PDT)
From:   "Jorge Ramirez-Ortiz, Foundries" <jorge@foundries.io>
X-Google-Original-From: "Jorge Ramirez-Ortiz, Foundries" <JorgeRamirez-Ortiz>
Date:   Wed, 5 Aug 2020 22:38:17 +0200
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     "Jorge Ramirez-Ortiz, Foundries" <jorge@foundries.io>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, ricardo@foundries.io,
        Michael Scott <mike@foundries.io>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        op-tee@lists.trustedfirmware.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/2] hwrng: optee: fix wait use case
Message-ID: <20200805203817.GA12229@trex>
References: <20200723084622.31134-1-jorge@foundries.io>
 <20200723084622.31134-2-jorge@foundries.io>
 <CAFA6WYPQ3GGYostoHU=6qg4c_LqoqOZVbZ8gbQbGkNfyGydQjQ@mail.gmail.com>
 <20200724142305.GA24164@trex>
 <CAFA6WYOGu4DPzd93h-yFLJvLmRH=ZroN70+ZNY6xCOOM+TJOSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYOGu4DPzd93h-yFLJvLmRH=ZroN70+ZNY6xCOOM+TJOSA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 05/08/20, Sumit Garg wrote:
> Apologies for my delayed response as I was busy with some other tasks
> along with holidays.

no pb! was just making sure this wasnt falling through some cracks.

> 
> On Fri, 24 Jul 2020 at 19:53, Jorge Ramirez-Ortiz, Foundries
> <jorge@foundries.io> wrote:
> >
> > On 24/07/20, Sumit Garg wrote:
> > > On Thu, 23 Jul 2020 at 14:16, Jorge Ramirez-Ortiz <jorge@foundries.io> wrote:
> > > >
> > > > The current code waits for data to be available before attempting a
> > > > second read. However the second read would not be executed as the
> > > > while loop exits.
> > > >
> > > > This fix does not wait if all data has been read and reads a second
> > > > time if only partial data was retrieved on the first read.
> > > >
> > > > This fix also does not attempt to read if not data is requested.
> > >
> > > I am not sure how this is possible, can you elaborate?
> >
> > currently, if the user sets max 0, get_optee_rng_data will regardless
> > issuese a call to the secure world requesting 0 bytes from the RNG
> >
> 
> This case is already handled by core API: rng_dev_read().

ah ok good point, you are right
but yeah, there is no consequence to the actual patch.

> 
> > with this patch, this request is avoided.
> >
> > >
> > > >
> > > > Signed-off-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
> > > > ---
> > > >  v2: tidy up the while loop to avoid reading when no data is requested
> > > >
> > > >  drivers/char/hw_random/optee-rng.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> > > > index 5bc4700c4dae..a99d82949981 100644
> > > > --- a/drivers/char/hw_random/optee-rng.c
> > > > +++ b/drivers/char/hw_random/optee-rng.c
> > > > @@ -122,14 +122,14 @@ static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> > > >         if (max > MAX_ENTROPY_REQ_SZ)
> > > >                 max = MAX_ENTROPY_REQ_SZ;
> > > >
> > > > -       while (read == 0) {
> > > > +       while (read < max) {
> > > >                 rng_size = get_optee_rng_data(pvt_data, data, (max - read));
> > > >
> > > >                 data += rng_size;
> > > >                 read += rng_size;
> > > >
> > > >                 if (wait && pvt_data->data_rate) {
> > > > -                       if (timeout-- == 0)
> > > > +                       if ((timeout-- == 0) || (read == max))
> > >
> > > If read == max, would there be any sleep?
> >
> > no but I see no reason why there should be a wait since we already have
> > all the data that we need; the msleep is only required when we need to
> > wait for the RNG to generate entropy for the number of bytes we are
> > requesting. if we are requesting 0 bytes, the entropy is already
> > available. at leat this is what makes sense to me.
> >
> 
> Wouldn't it lead to a call as msleep(0); that means no wait as well?

I dont understand: there is no reason to wait if read == max and this
patch will not wait: if read == max it calls 'return read'

am I misunderstanding your point?

> 
> -Sumit
> 
> >
> > >
> > > -Sumit
> > >
> > > >                                 return read;
> > > >                         msleep((1000 * (max - read)) / pvt_data->data_rate);
> > > >                 } else {
> > > > --
> > > > 2.17.1
> > > >
