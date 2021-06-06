Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D067C4743E
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Jun 2021 06:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E42FA61377
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Jun 2021 06:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhFFGws (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Jun 2021 02:52:48 -0400
Received: from mail-yb1-f178.google.com ([209.85.219.178]:43995 "EHLO
        mail-yb1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhFFGwr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jun 2021 02:52:47 -0400
Received: by mail-yb1-f178.google.com with SMTP id b9so20101456ybg.10
        for <linux-crypto@vger.kernel.org>; Sat, 05 Jun 2021 23:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ewox+9cGN83ZVHlmKbfQQi54MPTvUwrOVLfwbTgvjqk=;
        b=Pqfyv/ujPqAaidZbz3RuYIYc7TIhKzRnN++eP+Ibsb9rksvtk0qyjhDrnWqPNpUH+o
         adDJVJ143ON5FFjBaee9Ra55PmbUGv3k3ZbPAHPPJEG3Ip7EorCS5pJW+1GIzZLv1pfn
         Uo8JtP9yrSybRmvg1rnn8hdOeYO0EC/xtkreNWjAZE82ciXtBYyLtUqIfiIXflv15gAQ
         N96oYwqGAx2w/lgmmIPEZNm/cw7u5KdEFyYBQDTjL3bxwWLaB33sO4hXyX6b5EdYX60Q
         sVdS78VoorF1VNCr0/QIhE4rma9XoFunctQs6Y7adGjQoLRdXtMYBYAVKXRaWszhIgOD
         QFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ewox+9cGN83ZVHlmKbfQQi54MPTvUwrOVLfwbTgvjqk=;
        b=j7VSEzgSDX9PyPrEISb+URukgCQDFkhlX2qjgzf2VNF4WgYhB3OaFmJr55lzwNhBvh
         1reVPs6mvhcJia/Fc2N3P8u77wCNAwF6ZZneQIyHal8AGqjmVp3+tHXOHvtGrdnfcest
         MxmZ1Z6tecj4NSAhBhfaizZkOqxcA74DuUP8gDiWPgv/lGwqb7FeHgfWtyze2CSWhJyM
         tIJy8w+dYOIIgfEtirJ/jgAMNQWwhvukvB1lUSKMh4ulq/LDzq5LfExN7aFxerMC+Si4
         F8RYqs/mcFuO5jE1CxMWbpcB7cjTSX/6X0DZPDGldmdWDV7qaf1QXnvY+eaOlDP5ZHyc
         SV+w==
X-Gm-Message-State: AOAM5311ThSn1efDIFWvN44zQ0z5rOa5AD6WDK6PqoNig8dBXO6HQSGj
        6v3RVcUfk7z3Hg3EGyTUi+4MI4OkUpm3QxoxKVb6OMSCA/o=
X-Google-Smtp-Source: ABdhPJxx4k2RISuzARCkLJuovjKjSwJ/g2jqRyJYuxv/LsWCfaBMUqMohfz+z7xO8HbCXAHsBJiiVcIG7yUviupOtec=
X-Received: by 2002:a25:1689:: with SMTP id 131mr16164997ybw.375.1622962197575;
 Sat, 05 Jun 2021 23:49:57 -0700 (PDT)
MIME-Version: 1.0
References: <bc3c139f-4c0c-a9b7-ae00-59c2f8292ef8@linaro.org> <CAMj1kXGRb=_tozRAMA+ZFbAHU4P7ocLbWq+B3s0ngoRoo82V6g@mail.gmail.com>
In-Reply-To: <CAMj1kXGRb=_tozRAMA+ZFbAHU4P7ocLbWq+B3s0ngoRoo82V6g@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 6 Jun 2021 09:49:47 +0300
Message-ID: <CAOtvUMf3r0oT6w=mgQyykX_RHDDmebm_q-TqV61jSmo5x0bweQ@mail.gmail.com>
Subject: Re: Qualcomm Crypto Engine performance numbers on mainline kernel
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Thara Gopinath <thara.gopinath@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Sat, Jun 5, 2021 at 6:33 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Hello Thara,
>
> On Fri, 4 Jun 2021 at 18:49, Thara Gopinath <thara.gopinath@linaro.org> w=
rote:
> >
> >
> > Hi All,
> >
> > Below are the performance numbers from running "crypsetup benchmark" on
> > CE algorithms in the mainline kernel. All numbers are in MiB/s. The
> > platform used is RB3 for sdm845 and MTPs for rest of them.
> >
> >
> >                         SDM845    SM8150     SM8250     SM8350
> > AES-CBC (128)
> > Encrypt / Decrypt       114/106  36/48       120/188    133/197
> >
> > AES-XTS (256)
> > Encrypt / Decrypt       100/102  49/48       186/187    n/a
> >
>
> The CPU instruction based ones are apparently an order of magnitude
> faster, and are synchronous so their latency should be lower.
>
> So, as Eric already pointed out IIRC, there doesn't seem to be much
> value in enabling this IP in Linux - it should not be the default
> choice/highest priority, and it is not obvious to me whether/when you
> would prefer this implementation over the CPU based one. Do you have
> any idea how many queues it has, or how much data it can process in
> parallel? Are there other features that stand out?

One of the things to consider with separate hardware block
implementation vis a vis CPU instruction based ones in general is that
often the consideration is more about getting a good enough
performance while freeing the CPU to perform other tasks which results
in better overall system performance rather than getting the best
possible performance in the specific task at hand. This is sometimes
further extended with power considerations where you can get better
power consumption when the lower performance  engine is used.
Less often, a lower jitter is more important than the peak
performance. I've seen this with encrypted video decoding for example.

Sadly, whether any of these considerations is applicable is very much
system and work load specific.

So my 2c contribution would be to include support for this, even if
not make this the default.

Gilad




--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
