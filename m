Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C46E3C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Feb 2022 07:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiBVHrS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Feb 2022 02:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiBVHrQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Feb 2022 02:47:16 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F73D123413
        for <linux-crypto@vger.kernel.org>; Mon, 21 Feb 2022 23:39:22 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id d21so16931342yba.11
        for <linux-crypto@vger.kernel.org>; Mon, 21 Feb 2022 23:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E8NTjG7D381YlFNs2VaH0rQLmmGqTfOD1kAJuZ7gDmc=;
        b=FwcGCud3nJo3hq/CkX+78UgoyxDnKXUY/tZva6JRBoODTnWCf4PjGpp9f1ZrEWXycN
         oGMW0fORPA4wOwXwjbtZ1Sobuc9qCFVSJg/czvDdi++7c9UvHxIHyevfz6qp89RgCxkA
         uhWnTsLBdcktcVU197U8Lc4YUIHISbDTO0JUCl/xs7oNwmdnTqPu/L7oFcOvPRYYZVDY
         P1ayXACNKLck5wKdVWjwwdOgEAso/iuSTr/y3ApcioysnpFdp99Gy0czvIGaJnW1RQ2E
         2rXd+OoE3c20swVgkUK4KUnTSTR8t7RYuOgsj80sfehGp1aQ+sPYFaiMUtQ50hwjxwyJ
         EkxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E8NTjG7D381YlFNs2VaH0rQLmmGqTfOD1kAJuZ7gDmc=;
        b=7tCX50ztOsLN1rE1Q7xoQiEPOA++Qn7gDLYhisGCUy+/nvTtm61vVBDn5x6WLoDpzv
         /c2C6zUesvSt/7YrgKuzz0S8gxg/QJtq4ur8aJiTAK42/KHRj7Rdb7XmwNXYnwOSXLOX
         DH8U8ftTdLTxT/+Hs5xrsGVoaQA4U40WUV3Teur7bsc9qS1nNJ6MfTMF3lZiIs6CY0LP
         TNCJ90bBccvExysYnGdrLVxmtOKbRXgk5BYPL0AuEzqF1qpDCQDm714hZHy5EiGe2F9W
         6cfiiWgIge8fQaYtyvSt8h6p0oQ8aQWANAmDaNEzy9kDvaHHeUAK0M05JJXlLsHd4rDi
         dWAQ==
X-Gm-Message-State: AOAM530xtmWbbU8zjKR/VBImiIUkAFJmSX11ox4TRiebmi5Zvs10/DSe
        uh3nnDfkZ+S8dKhtOz2mbkId8PA8RDuAxmMaEFhpUANOyQ8=
X-Google-Smtp-Source: ABdhPJy0CcqqxFtkEsmov5tJFXh3NziREhE26+8iSZnhGdk8iANsbBpUnBMOu2cAcVja+mbG+cb0aHJsznStAh49u4Q=
X-Received: by 2002:a25:9d81:0:b0:622:7df3:ff6c with SMTP id
 v1-20020a259d81000000b006227df3ff6cmr21923630ybp.617.1645515561761; Mon, 21
 Feb 2022 23:39:21 -0800 (PST)
MIME-Version: 1.0
References: <YgOQBNIdf0UnSH+M@Red> <CAOtvUMeoYcVm7OQdqXd1V5iPSXW_BkVxx6TA6nF7zTLVeHe0Ww@mail.gmail.com>
 <CAOtvUMfy1fF35B2sfbOMui8n9Q4iCke9rgn5TiYMUMjd8gqHsA@mail.gmail.com>
 <YhKV55t90HWm6bhv@Red> <CAOtvUMdRU4wnRCXsC+U5XBDp+b+u8w7W7JCUKW2+ohuJz3PVhQ@mail.gmail.com>
 <YhOcEQEjIKBrbMIZ@Red>
In-Reply-To: <YhOcEQEjIKBrbMIZ@Red>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Tue, 22 Feb 2022 09:39:20 +0200
Message-ID: <CAOtvUMfN8U4+eG-TEVW4bSE6kOzuOSsJE4dOYGXYuWQKNzv7wQ@mail.gmail.com>
Subject: Re: [BUG] crypto: ccree: driver does not handle case where cryptlen =
 authsize =0
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 21, 2022 at 4:05 PM Corentin Labbe
<clabbe.montjoie@gmail.com> wrote:
>
> Le Mon, Feb 21, 2022 at 12:08:12PM +0200, Gilad Ben-Yossef a =C3=A9crit :
> > Hi,
> >
> > On Sun, Feb 20, 2022 at 9:26 PM Corentin Labbe
> > <clabbe.montjoie@gmail.com> wrote:
> > >
> > ...
> > >
> > > Hello
> > >
> > > While testing your patch for this problem, I saw another warning (unr=
elated with your patch):
> >
> > Dear Corentin, you are a treasure trove of bug reports. I love it.
> > Thank you! :-)
> >
> > > [   34.061953] ------------[ cut here ]------------
...
> >
> > So, this is an interesting one.
> > What I *think* is happening is that the drbg implementation is
> > actually doing something naughty: it is passing the same exact memory
> > buffer, both as source and destination to an encryption operation to
> > the crypto skcipher API, BUT via two different scatter gather lists.
> >
> > I'm not sure but I believe this is not a legitimate use of the API,
> > but before we even go into this, let's see if this little fix helps at
> > all and this is indeed the root cause.
> >
> > Can you test this small change for me, please?
> >
> > diff --git a/crypto/drbg.c b/crypto/drbg.c
> > index 177983b6ae38..13824fd27627 100644
> > --- a/crypto/drbg.c
> > +++ b/crypto/drbg.c
> > @@ -1851,7 +1851,7 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *=
drbg,
> >                 /* Use scratchpad for in-place operation */
> >                 inlen =3D scratchpad_use;
> >                 memset(drbg->outscratchpad, 0, scratchpad_use);
> > -               sg_set_buf(sg_in, drbg->outscratchpad, scratchpad_use);
> > +               sg_in =3D sg_out;
> >         }
> >
> >         while (outlen) {
> >
>
> No more stacktrace !

Thank you. I will send a patch later today.

Cheers,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
