Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1ABC4346D
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 11:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EB0922D06
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 11:13:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PtaSV2ov"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgHFJRw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 05:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729065AbgHFJQ0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 05:16:26 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19D4C061575
        for <linux-crypto@vger.kernel.org>; Thu,  6 Aug 2020 02:16:11 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z14so13340849ljm.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Aug 2020 02:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O6y/1nusRg/opQLxoCjDaYb+pDRSmXrkyxeECnISubo=;
        b=PtaSV2ove3y2GjUl3zgbytQS4V18ekpX8JerMyv1Z5IU2wpobpSaREpEI0uNGytpuw
         Ms9/blsTo/qxS/fbnxhBYbah/5/clC0JT7vqsqanT3zqdxebPUvy8MZwl5w5L1JnA6Di
         dFg1iv4GZu+akQwYkN0ML4T5Rz6RLOMKwR1oGRx8npHtNFtlXyBPYc5lD9/XAUIMKLK5
         qchSdYBKlZ3ij7VZHHTh6kwLItkr4sIEUSITeu/YzRjAiw32gLYrb4Evl7ftXywUkXWQ
         vpBCx6LPuz7wNUprAXH+NFNIoKSF8vcDzIgxHtyw8H/4OWCmiBqDCCNNztIvSx4Exugj
         YnXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O6y/1nusRg/opQLxoCjDaYb+pDRSmXrkyxeECnISubo=;
        b=XARWBw8N0aRWQh8ikK+LyaLXPj3fbuNwjK+mBRX2AcWdCi9J0uXB2aCLgbV4aMXfNv
         SlfYU2utfhFbq+MsvVncE/EqDYTMHwi/9bd1W1HNdSNo4rXgTjJi5bt+miDxpv0iDegd
         7HJZG2Blsq+YVUEg6DFheOchm0Z3FRt/cnwkASbCusGJgNkGB8rWSeWLAc5dYa/UyfYl
         psNMZgb39/WOafqve8EudRFJ4IQ2ZOSkxUWePfVo6K9m7yYNhsghFP6fr5CEH23K6i6o
         2vkguU5OgPPbOE1s1qIglIQz2/ZvYWP6tUXcKYq3F6rQBzLZ+z0pAQMEUAeWseQ8tw/6
         TwZQ==
X-Gm-Message-State: AOAM533bGaHNuBbTdkEl99M/MWcIjymBxECH2hW6kZDSoadH2Z48V+K5
        LdTj8bHV1x0Sg4Aa16xzPFmmmhULcLRzTBMmVhDG1w==
X-Google-Smtp-Source: ABdhPJzBTOaMiojdnzKyHqLEImTKlT/zfzMQhRBTIgNOjRet/iAK+RkazmypZr39sE0b3ZVCLj56/E3KimwycMfX/pQ=
X-Received: by 2002:a2e:3202:: with SMTP id y2mr3666465ljy.30.1596705361101;
 Thu, 06 Aug 2020 02:16:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200723084622.31134-1-jorge@foundries.io> <20200723084622.31134-2-jorge@foundries.io>
 <CAFA6WYPQ3GGYostoHU=6qg4c_LqoqOZVbZ8gbQbGkNfyGydQjQ@mail.gmail.com>
 <20200724142305.GA24164@trex> <CAFA6WYOGu4DPzd93h-yFLJvLmRH=ZroN70+ZNY6xCOOM+TJOSA@mail.gmail.com>
 <20200805203817.GA12229@trex> <CAFA6WYPKGTb6Qj7emETpB9-XXO8vcf6v2ONKD4pt+M9F-=HWbQ@mail.gmail.com>
 <20200806063040.GA27943@trex> <CAFA6WYMSXGKXx2vM2qcTLpRUugQUphM8Gn5YvPX9fTj3MHvXqQ@mail.gmail.com>
 <20200806081437.GA21405@trex>
In-Reply-To: <20200806081437.GA21405@trex>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 6 Aug 2020 14:45:49 +0530
Message-ID: <CAFA6WYOH4OjwACqU6n7dJ6PtWOLC6wN5wPa=C_SGRMZNrmLrMA@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 6 Aug 2020 at 13:44, Jorge Ramirez-Ortiz, Foundries
<jorge@foundries.io> wrote:
>
> On 06/08/20, Sumit Garg wrote:
> > On Thu, 6 Aug 2020 at 12:00, Jorge Ramirez-Ortiz, Foundries
> > <jorge@foundries.io> wrote:
> > >
> > > On 06/08/20, Sumit Garg wrote:
> > > > On Thu, 6 Aug 2020 at 02:08, Jorge Ramirez-Ortiz, Foundries
> > > > <jorge@foundries.io> wrote:
> > > > >
> > > > > On 05/08/20, Sumit Garg wrote:
> > > > > > Apologies for my delayed response as I was busy with some other=
 tasks
> > > > > > along with holidays.
> > > > >
> > > > > no pb! was just making sure this wasnt falling through some crack=
s.
> > > > >
> > > > > >
> > > > > > On Fri, 24 Jul 2020 at 19:53, Jorge Ramirez-Ortiz, Foundries
> > > > > > <jorge@foundries.io> wrote:
> > > > > > >
> > > > > > > On 24/07/20, Sumit Garg wrote:
> > > > > > > > On Thu, 23 Jul 2020 at 14:16, Jorge Ramirez-Ortiz <jorge@fo=
undries.io> wrote:
> > > > > > > > >
> > > > > > > > > The current code waits for data to be available before at=
tempting a
> > > > > > > > > second read. However the second read would not be execute=
d as the
> > > > > > > > > while loop exits.
> > > > > > > > >
> > > > > > > > > This fix does not wait if all data has been read and read=
s a second
> > > > > > > > > time if only partial data was retrieved on the first read=
.
> > > > > > > > >
> > > > > > > > > This fix also does not attempt to read if not data is req=
uested.
> > > > > > > >
> > > > > > > > I am not sure how this is possible, can you elaborate?
> > > > > > >
> > > > > > > currently, if the user sets max 0, get_optee_rng_data will re=
gardless
> > > > > > > issuese a call to the secure world requesting 0 bytes from th=
e RNG
> > > > > > >
> > > > > >
> > > > > > This case is already handled by core API: rng_dev_read().
> > > > >
> > > > > ah ok good point, you are right
> > > > > but yeah, there is no consequence to the actual patch.
> > > > >
> > > >
> > > > So, at least you could get rid of the corresponding text from commi=
t message.
> > > >
> > > > > >
> > > > > > > with this patch, this request is avoided.
> > > > > > >
> > > > > > > >
> > > > > > > > >
> > > > > > > > > Signed-off-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
> > > > > > > > > ---
> > > > > > > > >  v2: tidy up the while loop to avoid reading when no data=
 is requested
> > > > > > > > >
> > > > > > > > >  drivers/char/hw_random/optee-rng.c | 4 ++--
> > > > > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/drivers/char/hw_random/optee-rng.c b/drivers=
/char/hw_random/optee-rng.c
> > > > > > > > > index 5bc4700c4dae..a99d82949981 100644
> > > > > > > > > --- a/drivers/char/hw_random/optee-rng.c
> > > > > > > > > +++ b/drivers/char/hw_random/optee-rng.c
> > > > > > > > > @@ -122,14 +122,14 @@ static int optee_rng_read(struct hw=
rng *rng, void *buf, size_t max, bool wait)
> > > > > > > > >         if (max > MAX_ENTROPY_REQ_SZ)
> > > > > > > > >                 max =3D MAX_ENTROPY_REQ_SZ;
> > > > > > > > >
> > > > > > > > > -       while (read =3D=3D 0) {
> > > > > > > > > +       while (read < max) {
> > > > > > > > >                 rng_size =3D get_optee_rng_data(pvt_data,=
 data, (max - read));
> > > > > > > > >
> > > > > > > > >                 data +=3D rng_size;
> > > > > > > > >                 read +=3D rng_size;
> > > > > > > > >
> > > > > > > > >                 if (wait && pvt_data->data_rate) {
> > > > > > > > > -                       if (timeout-- =3D=3D 0)
> > > > > > > > > +                       if ((timeout-- =3D=3D 0) || (read=
 =3D=3D max))
> > > > > > > >
> > > > > > > > If read =3D=3D max, would there be any sleep?
> > > > > > >
> > > > > > > no but I see no reason why there should be a wait since we al=
ready have
> > > > > > > all the data that we need; the msleep is only required when w=
e need to
> > > > > > > wait for the RNG to generate entropy for the number of bytes =
we are
> > > > > > > requesting. if we are requesting 0 bytes, the entropy is alre=
ady
> > > > > > > available. at leat this is what makes sense to me.
> > > > > > >
> > > > > >
> > > > > > Wouldn't it lead to a call as msleep(0); that means no wait as =
well?
> > > > >
> > > > > I dont understand: there is no reason to wait if read =3D=3D max =
and this
> > > > > patch will not wait: if read =3D=3D max it calls 'return read'
> > > > >
> > > > > am I misunderstanding your point?
> > > >
> > > > What I mean is that we shouldn't require this extra check here as
> > > > there wasn't any wait if read =3D=3D max with existing implementati=
on too.
> > >
> > > um, I am getting confused Sumit
> > >
> > > with the exisiting implementation (the one we aim to replace), if get=
_optee_rng_data reads all the values requested on the first call (ie, read =
=3D 0) with wait set to true, the call will wait with msleep(0). Which is u=
nnecessary and waits for a jiffy (ie, the call to msleep 0 will schedule a =
one jiffy timeout interrruptible)
> > >
> > > with this alternative implementation, msleep(0) does not get called.
> > >
> > > are we in synch?
> >
> > Ah, I see msleep(0) also by default schedules timeout for 1 jiffy. So
> > we are in sync now. Probably you can clarify this in commit message as
> > well to avoid confusion.
>
> ok will do.
> shall I add your reviewed-by line or just resend?
>

Yes it's fine with me to add mine reviewed-by.

> >
> > -Sumit
> >
> > >
> > > >
> > > > -Sumit
> > > >
> > > > >
> > > > > >
> > > > > > -Sumit
> > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > > -Sumit
> > > > > > > >
> > > > > > > > >                                 return read;
> > > > > > > > >                         msleep((1000 * (max - read)) / pv=
t_data->data_rate);
> > > > > > > > >                 } else {
> > > > > > > > > --
> > > > > > > > > 2.17.1
> > > > > > > > >
