Return-Path: <SRS0=xEWH=4H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3298C34053
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Feb 2020 15:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 979D124672
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Feb 2020 15:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="YArzoa4V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgBSPld (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Feb 2020 10:41:33 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:39553 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgBSPlc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Feb 2020 10:41:32 -0500
Received: by mail-vk1-f195.google.com with SMTP id t129so249288vkg.6
        for <linux-crypto@vger.kernel.org>; Wed, 19 Feb 2020 07:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tixAwjd/iBwOVvMUkoHkR35VFV1hk5+5PSWICrltUF8=;
        b=YArzoa4V4eRVzc1Z1MN2Kw7tDP/CvjLP8MNH126A4u5zj1zngZ7yJpnYNCMdHJitj8
         8JoDlysPvl4X7Y3ynFY28N0BAv5L4w13DJ5B4+o1DX/BG2tNiZe9AZ3pnrCLqFFNZ9qn
         VMs9ls11IVerkQxds7l9lQt+kJdaT/uA7TFUJRWl22Fh8s0SV8HQJxRTHSSn9blKdywO
         b22WHA1gpxS5Dpx9/vzNM4c+FcuDlhwtokYD8VnWsnLMhVIaR6cjQd4aq9HEAnv2Sgtx
         dfXFpEumeKfRauXzd0Jos/Lt4leJBnvEd+W9Afy5cYSy5BF0Gtcw4IrVWz/MnVWOwAQ9
         8nAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tixAwjd/iBwOVvMUkoHkR35VFV1hk5+5PSWICrltUF8=;
        b=AJfr5sTh6/i26Q09MeqbI5cfaQIwwZ4ay4wEPI5GTPeU+EPArXdlVIEm0GYCszzNbv
         E0S/0yAZjTkaJq1K//fBxZALmiKpSAnJiIdDPnTOmmxblCULzfbbaGZwjEWeqhu79B0t
         lKWw6so+sjKLUF6AhR3/LuL2SPBe3eFqMM1JG+vQup15KXQKxGPAkREDVVIJM3aMG9KO
         QqpwkUb2WYPiWJ88VWMG0agvzVhe4SzUEn7d2d0Fs1t/Y1mUt5Ecf5/LB0FzEWgDi4eE
         y/fXBuQbj86p9LLhv8HODeP/iOYMfNZCeDYKjiZgdQEAiNTEe0wR1Rz7gZU89umHzVoi
         wwrg==
X-Gm-Message-State: APjAAAUSRfhJFghuEJ/0iUfcKWuPBPJXnQiVTzR6zt/3Z3il5Wu9kDcF
        xrYJwxl+Yp4CfazcZUjxjWn9+9+ckZEXkznD8gZsyPZOCY8=
X-Google-Smtp-Source: APXvYqzKlFoh9X6IKBRf1LTr85mehnhWd4RLw3FnVWN7juIyAtZ7owUC5Oz4/2JkLI6KsDJRPzt/fcHpBd6p0wZQ8CM=
X-Received: by 2002:ac5:c15a:: with SMTP id e26mr11344039vkk.62.1582126890725;
 Wed, 19 Feb 2020 07:41:30 -0800 (PST)
MIME-Version: 1.0
References: <20200211181928.15178-1-geert+renesas@glider.be>
 <CAOtvUMfs84VXAecVNShoEg-CU6APjyiVTUBkogpFq_c3fbaX+Q@mail.gmail.com> <CAMuHMdXfB9R-1Lwm6Jva6+NPrBJnV7bgHdygbxoqyzikqgqqgQ@mail.gmail.com>
In-Reply-To: <CAMuHMdXfB9R-1Lwm6Jva6+NPrBJnV7bgHdygbxoqyzikqgqqgQ@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 19 Feb 2020 17:41:19 +0200
Message-ID: <CAOtvUMcbtFpLAy8hincY8x+aQGk8Dw0o2PmOYN1mR-Hd9uWvhw@mail.gmail.com>
Subject: Re: [PATCH v2 00/34] crypto: ccree - miscellaneous fixes and improvements
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 13, 2020 at 9:47 AM Geert Uytterhoeven <geert@linux-m68k.org> w=
rote:
>
> Hi Gilad,
>
> On Thu, Feb 13, 2020 at 7:46 AM Gilad Ben-Yossef <gilad@benyossef.com> wr=
ote:
> > On Tuesday, February 11, 2020, Geert Uytterhoeven <geert+renesas@glider=
.be> wrote:
> >> This series contains several fixes, cleanups, and other improvements f=
or
> >> the ARM TrustZone CryptoCell driver.
> >
> >  Thank you so much for doing this Geert.
> >
> > The whole series looks wonderful. It does not only makes the driver bet=
ter, it has made me a better programmer - I'm not ashamed to say I've learn=
ed some new things about the kernel API  from this series...
> >
> > I am currently out of the office until mid next week and away from my t=
esting lab.
> >
> > I'd like to delay formal ACK until I return and run a regression test s=
uite using some of the newer revisions of the hardware which the driver als=
o support, just in case, although I don't forsee any issues. I hope that is=
 ok.
>
> Should be OK, we're only at rc1.
> I'm looking forward to the test results on newer hardware revision/


The smoke test on the most recent HW looks OK, I've submitted the
changes to a longer  regression test suite on multiple HW and it is
running.
I hope to have a final result and an ACK by tomorrow.

Thanks,
Gilad



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
