Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FD5C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 20:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAA24206D5
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 20:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390108AbgEYU3H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 16:29:07 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:54673 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389950AbgEYU3G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 16:29:06 -0400
Received: from mail-qv1-f49.google.com ([209.85.219.49]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MoOMq-1jFEJU0njE-00olip; Mon, 25 May 2020 22:29:04 +0200
Received: by mail-qv1-f49.google.com with SMTP id x13so8508923qvr.2;
        Mon, 25 May 2020 13:29:03 -0700 (PDT)
X-Gm-Message-State: AOAM53354/FjqDVE2E0MeaCUZ4WUC4x+OxDr2p8v0DimfsIElLoVp51M
        5DI4+GAnTP6pe1Kvh1/MwvHVbkuHL+L2hTpDNLA=
X-Google-Smtp-Source: ABdhPJw3ixSwVawsVi4CGH//MbxLoWCZi8tO5hD8Ikb+gJoYfkAWT1jokkk1m8UMTmioBGv2fet83IOg36WWRNYGJvk=
X-Received: by 2002:a05:6214:1392:: with SMTP id g18mr16173417qvz.210.1590438542881;
 Mon, 25 May 2020 13:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200525195606.2941649-1-olivier.sobrie@silexinsight.com> <20200525195606.2941649-4-olivier.sobrie@silexinsight.com>
In-Reply-To: <20200525195606.2941649-4-olivier.sobrie@silexinsight.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 25 May 2020 22:28:46 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3=HoQZuBoqyFgyde1X7BRfcH-GFQpu=8acOi_JhVU99g@mail.gmail.com>
Message-ID: <CAK8P3a3=HoQZuBoqyFgyde1X7BRfcH-GFQpu=8acOi_JhVU99g@mail.gmail.com>
Subject: Re: [PATCH 3/3] hwrng: ba431-rng: add support for BA431 hwrng
To:     Olivier Sobrie <olivier.sobrie@silexinsight.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, DTML <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Waleed Ziad <waleed94ziad@gmail.com>,
        sebastien.rabou@silexinsight.com
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:HjOeeDg52uqVQNhDzmwNgO7Ruuyf0K2G7zBd0h/UNxvX4tz7qce
 H/rCLmgJRVPcYmiin6JM4Iwk/yspeiiA7qaiuttYG4BkSMCGcOqMERssbS/zsDNbelKaBqP
 9BUqJdvc5MSifyRCGU8RE2AvF0M6/IeNE6oaxOQ7QoPteXynnMypMiVyZH0QCb0XCGd+LmU
 +1kOr4clcCWJfUTJydKMg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QI8ewv8YUBI=:uXGY/Kg9NBA6rbzRAKgcIY
 5tVwfdwS+MZIJJ2wOl7QTqq8NncelVzuWrF7IMqX8tBS/owDpOJlgEJBidkk49cnX7aNo13z4
 hXEGP+/se9iIxSokfCdHmK91YbdHOdI1m35p7NOYO/MTKx0dcicNYSwouLmbfiSJy7aof1q7y
 55JmwbFn7zYDQx+MtivTJQ1WKqSVCETym52k1QQ+WYZMwsNA4gQMR5m7mcrQZjw0gyyk8M/2L
 CdNRrJRZ9j96dUpG2YZUoIXX7+gBbK8RkI0gg+zA8cXReJ58qcqEfM31F0RGI0QCYlBzBaWv1
 bfq2fvL5d2WuUvG/pbL1/ueuMSmLH8IBgmjg1+SYL6HZf/1lCybACitkIGW0eNjcVFBrp2jZT
 1sbFck0z5WbDR4DgvBnKQbi3FD2m+Dw1r+CCGurTQxZ0DMoe3UdPmqAdmRMOTecTtpKkUr4L3
 HtmLXVJ2aQLNZkuOdOltOkAZyL5HXGJ8d7o7l26IHiplUfkkmYefD9GwtA9zuC33iOZxKG1Kr
 wj7tqRXEq1PRX2XP22YdrORpIxPwrdwocR2evhchxibHm9Ypv+0xO1dtaVkvXSSJj5YBHK6NZ
 cz37Qndcg4TRvL28FESAYZrjoffDJKEsE1ImT61APcoVBNMbbGBIiGh8nf4buNDqXressk9/Z
 TpivR99RSKQJyA95K5CmQR54UeLuyyfGlQrjsD27d+3yUD5Pbv9UH9MiQmtmBkeQRB4Xwz2Je
 Pyad2YJKnvGNUHkan4PXylHrfnSaskswVYidX+T2QPohPqffrGvUgwxE7caQDl6RxHSI339Xa
 UvgNfwpSIx871SCAPrp6wm32m7+OgCRw81vPIUqGV++NIvGPkA=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 25, 2020 at 10:07 PM Olivier Sobrie
<olivier.sobrie@silexinsight.com> wrote:
>
> Silex insight BA431 is an IP designed to generate random numbers that
> can be integrated in various FPGA.
> This driver adds support for it through the hwrng interface.
>
> This driver is used in Silex Insight Viper OEM boards.
>
> Signed-off-by: Olivier Sobrie <olivier.sobrie@silexinsight.com>
> Signed-off-by: Waleed Ziad <waleed94ziad@gmail.com>

The driver looks good to me.

Acked-by: Arnd Bergmann  <arnd@arndb.de>

>  drivers/char/hw_random/Kconfig     |  10 ++
>  drivers/char/hw_random/Makefile    |   1 +
>  drivers/char/hw_random/ba431-rng.c | 240 +++++++++++++++++++++++++++++

I wonder if we should move drivers/char/hw_random to its own top-level drivers
subsystem outside of drivers/char. It seems to be growing steadily and is larger
than a lot of other subsystems with currently 34 drivers in there.

Not your problem though.

> +       /* Wait until the state changed */
> +       for (i = 0; i < BA431_RESET_READ_STATUS_RETRIES; ++i) {
> +               state = ba431_trng_get_state(ba431);
> +               if (state >= BA431_STATE_STARTUP)
> +                       break;
> +
> +               udelay(BA431_RESET_READ_STATUS_INTERVAL);
> +       }

Looking for something to improve, I noticed that this loop can take over
a millisecond to time out, and it always runs in non-atomic context.
It may be better to use usleep_range() than udelay().

      Arnd
