Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49254C47433
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 11:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ED2522CAE
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 11:05:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=foundries-io.20150623.gappssmtp.com header.i=@foundries-io.20150623.gappssmtp.com header.b="Y02KnJPd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgHFIOs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 04:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728669AbgHFIOl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 04:14:41 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B121C061575
        for <linux-crypto@vger.kernel.org>; Thu,  6 Aug 2020 01:14:40 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g8so8038293wmk.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Aug 2020 01:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=foundries-io.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5PktqX1lhXj7JIJmMasUxCbKwHj1GRVaq6Q9Nfn/AB0=;
        b=Y02KnJPdyHNoxv5A62MbXo+ySPtxSc7Zo6WJLI3eoRZB5waqsU59OlqE92BgFcDE/4
         dTWfYDULmCIgQQ1nP8sS/vW7g6x9PnmV1lDiyUOHw1VQU/vSMF+8aBtc0xagQagpAtKX
         0vRoWdnr5KcIoi4ExzFLCB3i/FODp+Gb/9+9IgjVuCjbdNxgLhnXmWqEEIyM7aEfdES0
         QCPS5Y5P1JCXd3t/1W8d0NVECwmfvcxxUYZa4/kfDWrBMglf3/uvk9HdK638sa8rzvZQ
         nSv7FICaSMsbklecY+ehKAGVFb6c+/AXslwso6PoftJn7hjfjSLT761UaZg6lSTkdnfe
         pl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5PktqX1lhXj7JIJmMasUxCbKwHj1GRVaq6Q9Nfn/AB0=;
        b=LsfXDoBLX6mNFZZLzErgELZbcMlwVyRj84TYpETbla6ZzA9/KZBKSx/4KztpNUvzQf
         7j1LOvmp81bMCu4/K8Cv1xTXgSkLGs0yJuE0qoSp80vNEPU7qFhSChme41Sup/cPBugI
         4Eq44aDJxSr1l6ruHjmWH4HegtC98DeyTWtGVo1X9ip7dHORVOVLeNLhORapeN/X38OB
         6dM2MecywhBYfskTKbd7BDaD4zD7N5cH4t/+aQ49Um3XJXoqMI6nK/jLqqR8M7/gzKgy
         ofAnL5xSVGzFwm963sHtxQW84mcIh2Q6V50mpEzKQ4I6FgdhpSPZ1Fvs+7MKrbs11lOR
         ddgw==
X-Gm-Message-State: AOAM530rMjTESOVvH4StF2clLPAEflb2n+CuRGznFBvrKgJTWFYLk5J7
        xOUbNAcvroKV+zYRkbwKT3g4mg==
X-Google-Smtp-Source: ABdhPJxKVWFIn+tzSkG2xCzWTuprtYCwg5y0fKh1L37+YmaeQYDCm5+KsZhOgFUVcf4NDAu+eSgfXQ==
X-Received: by 2002:a1c:2985:: with SMTP id p127mr6571788wmp.166.1596701679009;
        Thu, 06 Aug 2020 01:14:39 -0700 (PDT)
Received: from trex (239.red-83-34-184.dynamicip.rima-tde.net. [83.34.184.239])
        by smtp.gmail.com with ESMTPSA id h14sm5422330wml.30.2020.08.06.01.14.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Aug 2020 01:14:38 -0700 (PDT)
From:   "Jorge Ramirez-Ortiz, Foundries" <jorge@foundries.io>
X-Google-Original-From: "Jorge Ramirez-Ortiz, Foundries" <JorgeRamirez-Ortiz>
Date:   Thu, 6 Aug 2020 10:14:37 +0200
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
Message-ID: <20200806081437.GA21405@trex>
References: <20200723084622.31134-1-jorge@foundries.io>
 <20200723084622.31134-2-jorge@foundries.io>
 <CAFA6WYPQ3GGYostoHU=6qg4c_LqoqOZVbZ8gbQbGkNfyGydQjQ@mail.gmail.com>
 <20200724142305.GA24164@trex>
 <CAFA6WYOGu4DPzd93h-yFLJvLmRH=ZroN70+ZNY6xCOOM+TJOSA@mail.gmail.com>
 <20200805203817.GA12229@trex>
 <CAFA6WYPKGTb6Qj7emETpB9-XXO8vcf6v2ONKD4pt+M9F-=HWbQ@mail.gmail.com>
 <20200806063040.GA27943@trex>
 <CAFA6WYMSXGKXx2vM2qcTLpRUugQUphM8Gn5YvPX9fTj3MHvXqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYMSXGKXx2vM2qcTLpRUugQUphM8Gn5YvPX9fTj3MHvXqQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 06/08/20, Sumit Garg wrote:
> On Thu, 6 Aug 2020 at 12:00, Jorge Ramirez-Ortiz, Foundries
> <jorge@foundries.io> wrote:
> >
> > On 06/08/20, Sumit Garg wrote:
> > > On Thu, 6 Aug 2020 at 02:08, Jorge Ramirez-Ortiz, Foundries
> > > <jorge@foundries.io> wrote:
> > > >
> > > > On 05/08/20, Sumit Garg wrote:
> > > > > Apologies for my delayed response as I was busy with some other tasks
> > > > > along with holidays.
> > > >
> > > > no pb! was just making sure this wasnt falling through some cracks.
> > > >
> > > > >
> > > > > On Fri, 24 Jul 2020 at 19:53, Jorge Ramirez-Ortiz, Foundries
> > > > > <jorge@foundries.io> wrote:
> > > > > >
> > > > > > On 24/07/20, Sumit Garg wrote:
> > > > > > > On Thu, 23 Jul 2020 at 14:16, Jorge Ramirez-Ortiz <jorge@foundries.io> wrote:
> > > > > > > >
> > > > > > > > The current code waits for data to be available before attempting a
> > > > > > > > second read. However the second read would not be executed as the
> > > > > > > > while loop exits.
> > > > > > > >
> > > > > > > > This fix does not wait if all data has been read and reads a second
> > > > > > > > time if only partial data was retrieved on the first read.
> > > > > > > >
> > > > > > > > This fix also does not attempt to read if not data is requested.
> > > > > > >
> > > > > > > I am not sure how this is possible, can you elaborate?
> > > > > >
> > > > > > currently, if the user sets max 0, get_optee_rng_data will regardless
> > > > > > issuese a call to the secure world requesting 0 bytes from the RNG
> > > > > >
> > > > >
> > > > > This case is already handled by core API: rng_dev_read().
> > > >
> > > > ah ok good point, you are right
> > > > but yeah, there is no consequence to the actual patch.
> > > >
> > >
> > > So, at least you could get rid of the corresponding text from commit message.
> > >
> > > > >
> > > > > > with this patch, this request is avoided.
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > Signed-off-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
> > > > > > > > ---
> > > > > > > >  v2: tidy up the while loop to avoid reading when no data is requested
> > > > > > > >
> > > > > > > >  drivers/char/hw_random/optee-rng.c | 4 ++--
> > > > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> > > > > > > > index 5bc4700c4dae..a99d82949981 100644
> > > > > > > > --- a/drivers/char/hw_random/optee-rng.c
> > > > > > > > +++ b/drivers/char/hw_random/optee-rng.c
> > > > > > > > @@ -122,14 +122,14 @@ static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> > > > > > > >         if (max > MAX_ENTROPY_REQ_SZ)
> > > > > > > >                 max = MAX_ENTROPY_REQ_SZ;
> > > > > > > >
> > > > > > > > -       while (read == 0) {
> > > > > > > > +       while (read < max) {
> > > > > > > >                 rng_size = get_optee_rng_data(pvt_data, data, (max - read));
> > > > > > > >
> > > > > > > >                 data += rng_size;
> > > > > > > >                 read += rng_size;
> > > > > > > >
> > > > > > > >                 if (wait && pvt_data->data_rate) {
> > > > > > > > -                       if (timeout-- == 0)
> > > > > > > > +                       if ((timeout-- == 0) || (read == max))
> > > > > > >
> > > > > > > If read == max, would there be any sleep?
> > > > > >
> > > > > > no but I see no reason why there should be a wait since we already have
> > > > > > all the data that we need; the msleep is only required when we need to
> > > > > > wait for the RNG to generate entropy for the number of bytes we are
> > > > > > requesting. if we are requesting 0 bytes, the entropy is already
> > > > > > available. at leat this is what makes sense to me.
> > > > > >
> > > > >
> > > > > Wouldn't it lead to a call as msleep(0); that means no wait as well?
> > > >
> > > > I dont understand: there is no reason to wait if read == max and this
> > > > patch will not wait: if read == max it calls 'return read'
> > > >
> > > > am I misunderstanding your point?
> > >
> > > What I mean is that we shouldn't require this extra check here as
> > > there wasn't any wait if read == max with existing implementation too.
> >
> > um, I am getting confused Sumit
> >
> > with the exisiting implementation (the one we aim to replace), if get_optee_rng_data reads all the values requested on the first call (ie, read = 0) with wait set to true, the call will wait with msleep(0). Which is unnecessary and waits for a jiffy (ie, the call to msleep 0 will schedule a one jiffy timeout interrruptible)
> >
> > with this alternative implementation, msleep(0) does not get called.
> >
> > are we in synch?
> 
> Ah, I see msleep(0) also by default schedules timeout for 1 jiffy. So
> we are in sync now. Probably you can clarify this in commit message as
> well to avoid confusion.

ok will do.
shall I add your reviewed-by line or just resend?

> 
> -Sumit
> 
> >
> > >
> > > -Sumit
> > >
> > > >
> > > > >
> > > > > -Sumit
> > > > >
> > > > > >
> > > > > > >
> > > > > > > -Sumit
> > > > > > >
> > > > > > > >                                 return read;
> > > > > > > >                         msleep((1000 * (max - read)) / pvt_data->data_rate);
> > > > > > > >                 } else {
> > > > > > > > --
> > > > > > > > 2.17.1
> > > > > > > >
