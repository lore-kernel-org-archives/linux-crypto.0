Return-Path: <SRS0=MR99=BD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABD0C433E4
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 14:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3E2920578
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 14:23:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=foundries-io.20150623.gappssmtp.com header.i=@foundries-io.20150623.gappssmtp.com header.b="te8ZOk+r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGXOXJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jul 2020 10:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbgGXOXI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jul 2020 10:23:08 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85097C0619D3
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2020 07:23:08 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id j18so8115008wmi.3
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2020 07:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=foundries-io.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DfDJT8aMj8+QexuTYXjin9MXJVQvAj2SdRwLGyVwnJY=;
        b=te8ZOk+rj17Vw6j6a4LQ+3Sm3/VFJ3xcY8mFqfSulGryTbUh9UbJJEY1Nnc0M3yMko
         kXZ/rnVfnUD2H9LEuoJswc8OyE3ItkcIRPMQCOoCuMmkjEde1QuIJw/0o6nNJE8+jypF
         fe9nj/nMM4n3fQ8WrMZbfN5anoIomvLoE/0JoNzYabOnIdKIanyEdzC0I68oZmah29lq
         dmsooZk+iqmlmgE0/SgXzxW61UTLJhZEkpyc/mL4TWchxFZJEEOXKI2lRp7fp5AFExTr
         y9+S66UxsVlJi5Pddt5O5y3tMj/kkL5KsrOCLPG0ynRSwc6M16rGIYjoFvzna/msZYkc
         BQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DfDJT8aMj8+QexuTYXjin9MXJVQvAj2SdRwLGyVwnJY=;
        b=IMwQCt7wK/gJ0t5z1dNXXS44Y5rlaM3uksiFUOhP0KwFF0yFDqOD72b5E1vpVYeAC6
         t4d1+RSzXzfmB5fABR590Xpsu7VDBXNgdRjqQ3E9tOaq0qE6ikWU8D77vir4BrlqnCv9
         RcXNa528KLXYEG0yG9mFua42vJdW2vGT1xFHSsw7QQGpzjQcVtttfHPDYce8MYI3uOso
         J3/GnuXuxWPAG+9XHv8QC/CYLdDi+TD06nVZfAmoRGsfND0LMib+r80aTIkxltVG2fBm
         2d7oXPGdI89ixtwtr+5q1yldY2ZOtLTaECgSd93eAHUW8oDBBEKJIf4Y/7hZSnrAvMV9
         Je8w==
X-Gm-Message-State: AOAM531OMNik7z8tM6N+4ZWXUXy20FTa7GEAGNZLkMDyPIKofazGeMh5
        mtHui5T3AUI2/7biZLaNRFGMPA==
X-Google-Smtp-Source: ABdhPJx8gwWAeG6Nv5miCrI5rzpwQEUt+1LIAdyE6uPfvsPe2Kk7hluobi63TvjUaNOPT9X2VL0+2w==
X-Received: by 2002:a1c:c345:: with SMTP id t66mr675410wmf.0.1595600587179;
        Fri, 24 Jul 2020 07:23:07 -0700 (PDT)
Received: from trex (239.red-83-34-184.dynamicip.rima-tde.net. [83.34.184.239])
        by smtp.gmail.com with ESMTPSA id g145sm11515101wmg.23.2020.07.24.07.23.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 Jul 2020 07:23:06 -0700 (PDT)
From:   "Jorge Ramirez-Ortiz, Foundries" <jorge@foundries.io>
X-Google-Original-From: "Jorge Ramirez-Ortiz, Foundries" <JorgeRamirez-Ortiz>
Date:   Fri, 24 Jul 2020 16:23:05 +0200
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Jorge Ramirez-Ortiz <jorge@foundries.io>,
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
Message-ID: <20200724142305.GA24164@trex>
References: <20200723084622.31134-1-jorge@foundries.io>
 <20200723084622.31134-2-jorge@foundries.io>
 <CAFA6WYPQ3GGYostoHU=6qg4c_LqoqOZVbZ8gbQbGkNfyGydQjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYPQ3GGYostoHU=6qg4c_LqoqOZVbZ8gbQbGkNfyGydQjQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 24/07/20, Sumit Garg wrote:
> On Thu, 23 Jul 2020 at 14:16, Jorge Ramirez-Ortiz <jorge@foundries.io> wrote:
> >
> > The current code waits for data to be available before attempting a
> > second read. However the second read would not be executed as the
> > while loop exits.
> >
> > This fix does not wait if all data has been read and reads a second
> > time if only partial data was retrieved on the first read.
> >
> > This fix also does not attempt to read if not data is requested.
> 
> I am not sure how this is possible, can you elaborate?

currently, if the user sets max 0, get_optee_rng_data will regardless
issuese a call to the secure world requesting 0 bytes from the RNG

with this patch, this request is avoided.

> 
> >
> > Signed-off-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
> > ---
> >  v2: tidy up the while loop to avoid reading when no data is requested
> >
> >  drivers/char/hw_random/optee-rng.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> > index 5bc4700c4dae..a99d82949981 100644
> > --- a/drivers/char/hw_random/optee-rng.c
> > +++ b/drivers/char/hw_random/optee-rng.c
> > @@ -122,14 +122,14 @@ static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> >         if (max > MAX_ENTROPY_REQ_SZ)
> >                 max = MAX_ENTROPY_REQ_SZ;
> >
> > -       while (read == 0) {
> > +       while (read < max) {
> >                 rng_size = get_optee_rng_data(pvt_data, data, (max - read));
> >
> >                 data += rng_size;
> >                 read += rng_size;
> >
> >                 if (wait && pvt_data->data_rate) {
> > -                       if (timeout-- == 0)
> > +                       if ((timeout-- == 0) || (read == max))
> 
> If read == max, would there be any sleep?

no but I see no reason why there should be a wait since we already have
all the data that we need; the msleep is only required when we need to
wait for the RNG to generate entropy for the number of bytes we are
requesting. if we are requesting 0 bytes, the entropy is already
available. at leat this is what makes sense to me.


> 
> -Sumit
> 
> >                                 return read;
> >                         msleep((1000 * (max - read)) / pvt_data->data_rate);
> >                 } else {
> > --
> > 2.17.1
> >
