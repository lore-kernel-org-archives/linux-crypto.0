Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F18C433EC
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 10:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93FDA20829
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 10:06:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=foundries-io.20150623.gappssmtp.com header.i=@foundries-io.20150623.gappssmtp.com header.b="Rgc3hv+0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgG1KF7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 06:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728355AbgG1KF7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 06:05:59 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188E4C061794
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 03:05:59 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x5so16187807wmi.2
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 03:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=foundries-io.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=acftKy5haTTez29DldMveP4DByaH/OvKD4GTibGUU4c=;
        b=Rgc3hv+0TiPIPSmJyeuNzphIlAXlhB57Ndn3MyQQjhGIRo7fBOZm0ddElDeMWTuygZ
         dRjmlW9ouLZrHpVmLNTsw5F8YzqPnchsPuj2Cp2NtvtEiUwEwfBSoH4odVJmHnJnGvNj
         ZU7+Jlag9E0ffsFq77QUbAE/vznnG4tQCQ1ivZhMFZdROTfoFMcmOO+b7ZaZB5HMpSv3
         L5dahpKCwrcOQcp5Rq8BJFAWUEBFhMdwLUSSPyF8G+AbkXhzSUhy0ZUZBukxzZr9VFhi
         a9ZertakXO+gT9GioNeRWN6ytFTIETHAcEJBIvBse019ratABWkASFXNxtE3aSY/GN1/
         EZ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=acftKy5haTTez29DldMveP4DByaH/OvKD4GTibGUU4c=;
        b=VfvbLo1qNbQcdt+CyF7ud8ch8Yv1v8fOw8mLSGB8GMvaYfndMtl0n+r6isTx+Zkzfm
         dUvM1h4GOCUvZzAIvTMQPDJ8oVMfi09yJ+FOTd8xtVzdMmNUBcB3Tf/X1AddF3X56wpS
         w5OAtSv9mZvmC1wp5NWFR/7krxfWm7oaeBaf1Xa11v8Bu/SFbvQJ4HIwtQPPSP0jGY+G
         eR/nHtwBqNQD3kQVlnDF92dVxZZAzwr9jOKbivWaXuFNEVr4yXD7VMUMZr+lKI1G9oy3
         4lDzCC9roiBLgXWW5WLbTMviWmfITKacxZNcOm3CtQT91cvqtQwdLpFMPWukdUhF6n68
         s1aw==
X-Gm-Message-State: AOAM531mdXa7K/BW06/6a1epRtBkVeYOrFiyVpBs5JHx5/FUuq8EF82g
        4wIm63W6RVo7dzQ5WFsNpxt/NA==
X-Google-Smtp-Source: ABdhPJwMEO6MXfxPWKVzQyfOwgd+Lnn1mfBFwcsn5n3Aff24Y/ORpbQAQBqKE1qjHnpg35DJaCfWOQ==
X-Received: by 2002:a1c:1b93:: with SMTP id b141mr3393238wmb.150.1595930757237;
        Tue, 28 Jul 2020 03:05:57 -0700 (PDT)
Received: from trex (239.red-83-34-184.dynamicip.rima-tde.net. [83.34.184.239])
        by smtp.gmail.com with ESMTPSA id x4sm17668932wru.81.2020.07.28.03.05.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jul 2020 03:05:56 -0700 (PDT)
From:   "Jorge Ramirez-Ortiz, Foundries" <jorge@foundries.io>
X-Google-Original-From: "Jorge Ramirez-Ortiz, Foundries" <JorgeRamirez-Ortiz>
Date:   Tue, 28 Jul 2020 12:05:55 +0200
To:     "Jorge Ramirez-Ortiz, Foundries" <jorge@foundries.io>
Cc:     Sumit Garg <sumit.garg@linaro.org>, Matt Mackall <mpm@selenic.com>,
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
Message-ID: <20200728100555.GA2074@trex>
References: <20200723084622.31134-1-jorge@foundries.io>
 <20200723084622.31134-2-jorge@foundries.io>
 <CAFA6WYPQ3GGYostoHU=6qg4c_LqoqOZVbZ8gbQbGkNfyGydQjQ@mail.gmail.com>
 <20200724142305.GA24164@trex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724142305.GA24164@trex>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 24/07/20, Jorge Ramirez-Ortiz, Foundries wrote:
> On 24/07/20, Sumit Garg wrote:
> > On Thu, 23 Jul 2020 at 14:16, Jorge Ramirez-Ortiz <jorge@foundries.io> wrote:
> > >
> > > The current code waits for data to be available before attempting a
> > > second read. However the second read would not be executed as the
> > > while loop exits.
> > >
> > > This fix does not wait if all data has been read and reads a second
> > > time if only partial data was retrieved on the first read.
> > >
> > > This fix also does not attempt to read if not data is requested.
> > 
> > I am not sure how this is possible, can you elaborate?
> 
> currently, if the user sets max 0, get_optee_rng_data will regardless
> issuese a call to the secure world requesting 0 bytes from the RNG
> 
> with this patch, this request is avoided.
> 
> > 
> > >
> > > Signed-off-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
> > > ---
> > >  v2: tidy up the while loop to avoid reading when no data is requested
> > >
> > >  drivers/char/hw_random/optee-rng.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> > > index 5bc4700c4dae..a99d82949981 100644
> > > --- a/drivers/char/hw_random/optee-rng.c
> > > +++ b/drivers/char/hw_random/optee-rng.c
> > > @@ -122,14 +122,14 @@ static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> > >         if (max > MAX_ENTROPY_REQ_SZ)
> > >                 max = MAX_ENTROPY_REQ_SZ;
> > >
> > > -       while (read == 0) {
> > > +       while (read < max) {
> > >                 rng_size = get_optee_rng_data(pvt_data, data, (max - read));
> > >
> > >                 data += rng_size;
> > >                 read += rng_size;
> > >
> > >                 if (wait && pvt_data->data_rate) {
> > > -                       if (timeout-- == 0)
> > > +                       if ((timeout-- == 0) || (read == max))
> > 
> > If read == max, would there be any sleep?
> 
> no but I see no reason why there should be a wait since we already have
> all the data that we need; the msleep is only required when we need to
> wait for the RNG to generate entropy for the number of bytes we are
> requesting. if we are requesting 0 bytes, the entropy is already
> available. at leat this is what makes sense to me.
> 
>

any further comments?

> > 
> > -Sumit
> > 
> > >                                 return read;
> > >                         msleep((1000 * (max - read)) / pvt_data->data_rate);
> > >                 } else {
> > > --
> > > 2.17.1
> > >
