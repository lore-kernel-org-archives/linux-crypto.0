Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE90C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 19:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C0CD21D95
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 19:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C0cYsA4z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgHETtv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Aug 2020 15:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbgHEQyO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Aug 2020 12:54:14 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B930AC0A888C
        for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2020 06:49:36 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id t23so24247684ljc.3
        for <linux-crypto@vger.kernel.org>; Wed, 05 Aug 2020 06:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQapRFN5NnXQ3j6nhvaneguoE0rre3sj3XHy1JRT4ss=;
        b=C0cYsA4zOCivuhLcnAa/hXcHaA4cqHJIyCzMnE8R9D9xV4aiUjFIAWtdnzO5rAOatH
         Xj0RZyBRPODrykxHzD4aj5bHgYh6uAC2hM1Nx0vbhQWHSpWU7Ps0zG9/Konnur6taL8x
         sjItooKO85Lse8Rxw6ZHjSL7NTQGLK4f25eWv1xliQJAjS2Y5XUm8GqVgy1z1y6PZz6W
         eLIbMwWEBhQQP42dFnXX3KSaJV2AtGOgNCTavqtZyivcpmm3e8AD61Oa16Ul0pfDs9gF
         Ak/oHDAE5mgc1d1LQJIzioUc0mRtThJwviRDDRlD2b+PQ2+Lnu/FML91ulodGISzqOi4
         QJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQapRFN5NnXQ3j6nhvaneguoE0rre3sj3XHy1JRT4ss=;
        b=NoOJ3Cr4qaQXPSZ/TS/Onqc76FuOXt0YLrMpbfZCxb+MKSDqk3bAvIfd9ucyxmzJ8Q
         dLuVshRiu7or5I+Y0sbPZ3mmEQeE1BFk8YNUfc1jKWEjfkHJYM0CEN8xnwFjuZAfxBHb
         7AK5lVxU33P+Ad0b6l5XPmFpH7iOD+3JhsdtYsIlBOr8xA16MmiPBUyT/9NfZONY9GzH
         vNhiP/I/LV1uOKHUFQns4j2lPHCafawHKB97Ibl50Sqx9pewdwUXPztuucyIaB6tuLCS
         az9TrC/Lit7LGwsXjRu5TCJPJS/Ex5CqDg4xH5C2wiJRrwNvW1yN3HsS/GAXf5rZutgx
         oWdA==
X-Gm-Message-State: AOAM531os2Hy4uyqAvarDSmMSdgVKQkbx+NEq8+CIk2wX8Qy67Z91+NF
        MrFc/Hy3WaTsuAG80G3cAQ2UKlIrGuky2q+BVkhtdw==
X-Google-Smtp-Source: ABdhPJx3AX+qVfOBTzo7irvlIIsyKx5rNGh29b8e478CtBquVMfDMxeyTo6zPw8l7obuWxKViTt4wTxZFzPwjb+NTZ0=
X-Received: by 2002:a05:651c:294:: with SMTP id b20mr1417834ljo.4.1596635375036;
 Wed, 05 Aug 2020 06:49:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200723084622.31134-1-jorge@foundries.io> <20200723084622.31134-2-jorge@foundries.io>
 <CAFA6WYPQ3GGYostoHU=6qg4c_LqoqOZVbZ8gbQbGkNfyGydQjQ@mail.gmail.com> <20200724142305.GA24164@trex>
In-Reply-To: <20200724142305.GA24164@trex>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Wed, 5 Aug 2020 19:19:23 +0530
Message-ID: <CAFA6WYOGu4DPzd93h-yFLJvLmRH=ZroN70+ZNY6xCOOM+TJOSA@mail.gmail.com>
Subject: Re: [PATCHv2 2/2] hwrng: optee: fix wait use case
To:     "Jorge Ramirez-Ortiz, Foundries" <jorge@foundries.io>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, ricardo@foundries.io,
        Michael Scott <mike@foundries.io>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        op-tee@lists.trustedfirmware.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Apologies for my delayed response as I was busy with some other tasks
along with holidays.

On Fri, 24 Jul 2020 at 19:53, Jorge Ramirez-Ortiz, Foundries
<jorge@foundries.io> wrote:
>
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

This case is already handled by core API: rng_dev_read().

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

Wouldn't it lead to a call as msleep(0); that means no wait as well?

-Sumit

>
> >
> > -Sumit
> >
> > >                                 return read;
> > >                         msleep((1000 * (max - read)) / pvt_data->data_rate);
> > >                 } else {
> > > --
> > > 2.17.1
> > >
