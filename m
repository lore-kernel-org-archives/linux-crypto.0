Return-Path: <SRS0=pw/0=7L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67BBC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 17:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3E4620814
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 17:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590772355;
	bh=pWdiLQKXlqkVWGFk1vwAA7pmGBuWEqo3AyBqWZl5aR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=r4DY8qtUqhVnYiJw+e9Al3WIIz64w4V/cdurLHZEco2lmZILP7zx1p8kubr8gMg+q
	 qgnnBi2qN5Ux8OU88P8Tpa48NTAGF1QeAshiu1MpCpYksBTALv5tDLxb5/LirdtyA5
	 sPO6/liaVgzNRv914zMK3zk3A5Ys+91W2a+DBUBY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgE2RMe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 May 2020 13:12:34 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:34777 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2RMe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 May 2020 13:12:34 -0400
Received: by mail-il1-f195.google.com with SMTP id v11so3254165ilh.1;
        Fri, 29 May 2020 10:12:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bx0PYvSq6NXKj78JIhFRx0Ln0MPRytiQWRFm69j6/II=;
        b=FibTTiAXPZA8ncGPD15f56t67fVXt50ryXvQcrpouWAHMUzjDv1nMYHkF8ZGH+wVdn
         lP14S8UMxjKZFQGJwccUuGIXrooQgj6fpD9KP4UafcYLcp97mY6mYYWdI5D24Df24vcI
         i2Qwc4bsxEE65hccxWAMsxMwDZSx1WWFbTQM4JlwiTcYlr6mqvk3kQWUNPeXH5xE7uPn
         WbCSp3T2YAWb3ubnf55t0qnblXtog/VpwZjXVcH48RkZOgohLlbVNpYTDjDOPMmZ5nP6
         OKkrSNQzNDO+fE+dCyO/4Y4IA9sIj14sKf/TR4c2OiUQ/Lew6C2gmKMddtewRzhrWPIF
         sAkQ==
X-Gm-Message-State: AOAM530gtSvSuqwlMUSxONSPxXWq1p9YGfgjZlaoGaEnSquTtC2pFdG+
        mSudf7criqDAqRjS/3Gn6g==
X-Google-Smtp-Source: ABdhPJx3pelBzqI23xyZAGyODV+mdjrDEnHa6vJcIHqwehHVDJoZHGYIfuPjm8tPctXXxT9q75pF9A==
X-Received: by 2002:a92:5b15:: with SMTP id p21mr7028596ilb.22.1590772353030;
        Fri, 29 May 2020 10:12:33 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id v13sm5199788ili.15.2020.05.29.10.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 10:12:32 -0700 (PDT)
Received: (nullmailer pid 2586805 invoked by uid 1000);
        Fri, 29 May 2020 17:12:31 -0000
Date:   Fri, 29 May 2020 11:12:31 -0600
From:   Rob Herring <robh@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Olivier Sobrie <olivier.sobrie@silexinsight.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, DTML <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Waleed Ziad <waleed94ziad@gmail.com>,
        sebastien.rabou@silexinsight.com
Subject: Re: [PATCH 3/3] hwrng: ba431-rng: add support for BA431 hwrng
Message-ID: <20200529171231.GA2581035@bogus>
References: <20200525195606.2941649-1-olivier.sobrie@silexinsight.com>
 <20200525195606.2941649-4-olivier.sobrie@silexinsight.com>
 <CAK8P3a3=HoQZuBoqyFgyde1X7BRfcH-GFQpu=8acOi_JhVU99g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3=HoQZuBoqyFgyde1X7BRfcH-GFQpu=8acOi_JhVU99g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 25, 2020 at 10:28:46PM +0200, Arnd Bergmann wrote:
> On Mon, May 25, 2020 at 10:07 PM Olivier Sobrie
> <olivier.sobrie@silexinsight.com> wrote:
> >
> > Silex insight BA431 is an IP designed to generate random numbers that
> > can be integrated in various FPGA.
> > This driver adds support for it through the hwrng interface.
> >
> > This driver is used in Silex Insight Viper OEM boards.
> >
> > Signed-off-by: Olivier Sobrie <olivier.sobrie@silexinsight.com>
> > Signed-off-by: Waleed Ziad <waleed94ziad@gmail.com>
> 
> The driver looks good to me.
> 
> Acked-by: Arnd Bergmann  <arnd@arndb.de>
> 
> >  drivers/char/hw_random/Kconfig     |  10 ++
> >  drivers/char/hw_random/Makefile    |   1 +
> >  drivers/char/hw_random/ba431-rng.c | 240 +++++++++++++++++++++++++++++
> 
> I wonder if we should move drivers/char/hw_random to its own top-level drivers
> subsystem outside of drivers/char. It seems to be growing steadily and is larger
> than a lot of other subsystems with currently 34 drivers in there.
> 
> Not your problem though.
> 
> > +       /* Wait until the state changed */
> > +       for (i = 0; i < BA431_RESET_READ_STATUS_RETRIES; ++i) {
> > +               state = ba431_trng_get_state(ba431);
> > +               if (state >= BA431_STATE_STARTUP)
> > +                       break;
> > +
> > +               udelay(BA431_RESET_READ_STATUS_INTERVAL);
> > +       }
> 
> Looking for something to improve, I noticed that this loop can take over
> a millisecond to time out, and it always runs in non-atomic context.
> It may be better to use usleep_range() than udelay().

Or better yet, use the register polling helpers.

Rob
