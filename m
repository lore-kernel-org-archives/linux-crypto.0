Return-Path: <SRS0=chSI=24=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6155C33C9E
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 06:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B4FD207FF
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 06:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578378572;
	bh=GhOSuQQThHxmyW2srU1iYmKJZPiYeVV/Z+EWg2Jn4L8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=lFsPjGeVhZUk97Xim/09Ql/WpGvRaMhRCuDUzGxl9+62Wo06P/hWRA0v+xSgE2Gv9
	 ITToJ8y1e3E3WD+NCTERHxP7jR6SWcZCEgvMTIFX6Avt1ITzpDGuPTjoPDdS7lWP2O
	 b52u+FLN9LxmuxzdET6nm+3EqGc6xx2wJ7c6SL7U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgAGG31 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jan 2020 01:29:27 -0500
Received: from conssluserg-04.nifty.com ([210.131.2.83]:51037 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgAGG31 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jan 2020 01:29:27 -0500
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 0076TA8c014378;
        Tue, 7 Jan 2020 15:29:10 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 0076TA8c014378
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1578378551;
        bh=V4OXT4Fpyi9+NOlQeIWNoTFry/VXFE9skkoLr0JmobU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PUtkQKRh/fLDhr7OyI2jsy3dRzrVKjGRsJD26kFb8Yi5DYb3ZzVIj9aI89P3bCxO2
         kcx+0mSsXbAq4C2G/aOvNTObJyA3sA7ZRSemwGljOlIhcw4yni6N1g0mkghKwLkTff
         PCvpPysq86Ay4TJqu/B05j3eWpmSKVpUV3flWj7fJbDYzYBRe9GDCcNj/9ZPgS6WVy
         mBpxYB8cwCaNXyhhFYC562rrdIJWQJ4ftIQllFGlOQDej1RK7yQoEXLAEkU4cuevXA
         FSB3dvO2xXez30a7IBaDz3GjYj6T2nLHidaWCSDoGt0mX8w317v0yQ6iasfpegGulk
         qbQdyYxrLIKew==
X-Nifty-SrcIP: [209.85.222.46]
Received: by mail-ua1-f46.google.com with SMTP id y23so18070021ual.2;
        Mon, 06 Jan 2020 22:29:10 -0800 (PST)
X-Gm-Message-State: APjAAAX4OV0JdmY3G5sTMv5AWHnVrwQNu0DHhBg8VT2p58i/tMByElVg
        ROQnZfbu9nt9w1UAX2VzjdAUszkWFQxJNHz/+bk=
X-Google-Smtp-Source: APXvYqypZNoHbzfj+w5gFDA3N15SQKWwFjdrHnOhN5aGCU+FKq8xDDltKeTcAoYEWk93oUB5yZ92m3AGy2jJt8IgSdk=
X-Received: by 2002:ab0:2ea6:: with SMTP id y6mr41352359uay.25.1578378549666;
 Mon, 06 Jan 2020 22:29:09 -0800 (PST)
MIME-Version: 1.0
References: <20200106045833.1725-1-masahiroy@kernel.org> <20200107051521.GF705@sol.localdomain>
In-Reply-To: <20200107051521.GF705@sol.localdomain>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 7 Jan 2020 15:28:33 +0900
X-Gmail-Original-Message-ID: <CAK7LNATbLESJ6CdPSN8bdpt7+4iOKW2L3c4OZaz2sLzqJH6BTw@mail.gmail.com>
Message-ID: <CAK7LNATbLESJ6CdPSN8bdpt7+4iOKW2L3c4OZaz2sLzqJH6BTw@mail.gmail.com>
Subject: Re: [PATCH] treewide: remove redundent IS_ERR() before error code check
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        DTML <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 7, 2020 at 2:15 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Jan 06, 2020 at 01:58:33PM +0900, Masahiro Yamada wrote:
> > 'PTR_ERR(p) == -E*' is a stronger condition than IS_ERR(p).
> > Hence, IS_ERR(p) is unneeded.
> >
> > The semantic patch that generates this commit is as follows:
> >
> > // <smpl>
> > @@
> > expression ptr;
> > constant error_code;
> > @@
> > -IS_ERR(ptr) && (PTR_ERR(ptr) == - error_code)
> > +PTR_ERR(ptr) == - error_code
> > // </smpl>
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>
> Any reason for not doing instead:
>
>         ptr == ERR_PTR(-error_code)
>
> ?

Because there is no reason to change

        PTR_ERR(ptr) == -error_code
to
        ptr == ERR_PTR(-error_code)



     if (PTR_ERR(ptr) == -error_code)
style seems to be used more often.

But, I think it is just a matter of preference after all.
Both work equally fine.



>  To me it seems weird to use PTR_ERR() on non-error pointers.  I even had to
> double check that it returns a 'long' and not an 'int'.  (If it returned an
> 'int', it wouldn't work...)
>
> - Eric



-- 
Best Regards
Masahiro Yamada
