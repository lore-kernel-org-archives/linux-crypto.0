Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B006FC28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 10:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82E2B25729
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 10:25:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nd0DMgUY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfE3KZb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 06:25:31 -0400
Received: from mail-it1-f171.google.com ([209.85.166.171]:35607 "EHLO
        mail-it1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727671AbfE3KZb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 06:25:31 -0400
Received: by mail-it1-f171.google.com with SMTP id u186so8553054ith.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2019 03:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z7J0Xn39SgXExIYRuvTnrthM0vFkOvqZa1CicHZsTm4=;
        b=nd0DMgUYn/C3HA5qIBdAT7FzHoYVy/Jr4OHQZOK2I+GDNxbj5/qe7ffEJVugezW/xN
         +P1wo4wzNYa/fNjdb6rmM3guw4j5eFqxSjUigS5EzBA6XNI7wTjwnnmp+6F1zKFQsPdL
         o+JgJg1pHFWLWf38kEI/KX67U2P6lEQHWNE4AsctVpHlU1C9tA8yLXD9Y3AFIOtdPv1O
         YruqSrOYppj06jNE+QWvr0KdfSI72GTvpc1tu+RXwhYXO8rNbEezrswdNIv3DeW1geFX
         OVbrmAFJFAlL6lMNeCcyi1UwR8FLyXSCWrGfvO1mB9Cxot5rKQfRs5NRKAJL5smlpnLM
         2M0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z7J0Xn39SgXExIYRuvTnrthM0vFkOvqZa1CicHZsTm4=;
        b=FLGxuuphRXRx1YhhSseXNz0IGYfuI2xkw7wXOWPndtj8bQFAdH6/yi3Q1z66ngwLyV
         t7gMzduMNVu5/XQ0hbbHh35Wcv5Rd1hwhxFhQjwZjNutOHq/8DmFY7+3p6FbslEf4zqK
         WRyDQn8EHH1a+O1+A/abxggcIm4ah/oWFNtAN0ZikomatplRb1OVpw93yfrTYQNbqJmB
         dZwAPwKcUCcEBtuRx0oD9UHXi1PV1oXXPMZf7psiHODfPwWYIEg/KgGXmgQMlnIBK9/B
         S871OymiO2t64PRPvSdeURrJz7U0j9v1tc0g4zZbsDQIAOdSZW7sQAI7LxZyiUIhaVN4
         CVBQ==
X-Gm-Message-State: APjAAAX4olWLFmLnBrFsV2UgXPBq01JOsnBgzYYBrq/8nlOauNe/aqjL
        2zfL4epvFYBH6gycS45glVB2cLTq4DrjusuDjblmMA==
X-Google-Smtp-Source: APXvYqx0honRJSH4fLNZ8T+gtFm2VtkvPDW4R4Hx4+/eIL/JBEN6KFK3oy/jST3MO1DcUraYmTt5ADzecb6LJUqh3o8=
X-Received: by 2002:a02:b01c:: with SMTP id p28mr1799230jah.130.1559211930579;
 Thu, 30 May 2019 03:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB3523ADF4617CB97D59904616D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu8bReGWAUm4GrCg7kefVR7U0Z8XBt_GVV4WEvgOpCtjpA@mail.gmail.com>
 <AM6PR09MB3523B77DE66DD5353F08A687D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190529180731.Horde.NGHeOXuCgw23pVdGqjc0fw9@messagerie.si.c-s.fr> <AM6PR09MB35232561AF362BF5A9FE72FFD2180@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB35232561AF362BF5A9FE72FFD2180@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 30 May 2019 12:25:06 +0200
Message-ID: <CAKv+Gu_DRDwQLuajk9TZ14vTce_1NhyU86dhtvY=-kQuvrP0AA@mail.gmail.com>
Subject: Re: Conding style question regarding configuration
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 30 May 2019 at 12:16, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > >> Yes. Code and data with static linkage will just be optimized away by
> > >> the compiler if the CONFIG_xx option is not enabled, so all you need
> > >> to guard are the actual statements, function calls etc.
> > >>
> > > Ok, makes sense. Then I'll just config out the relevant function bodies
> > > and assume the compiler will do the rest ...
> > >
> >
> > No need to config out function bodies when they are static.
> >
> Well, I got a complaint from someone that my driver updates for adding PCIE
> support wouldn't  compile properly on a platform without a PCI(E) subsystem.
> So I figure I do have to config out the references to PCI specific function
> calls to fix that.
>
> Or are you just referring to bodies of static subfunctions that are no
> longer being called? Would the compiler skip those entirely?
>

The idea is that, by doing something like

static int bar;

static void foo(void)
{
    bar = 1;
}

if (IS_ENABLED(CONFIG_FOO))
    foo();

the function foo() or the variable bar don't have to be decorated with
#ifdefs or anything. The compiler will not complain that they are
unused if CONFIG_FOO is not enabled, and the contents of foo() are
always visible to the compiler, and so any programming errors will be
caught regardless of whether CONFIG_FOO is set.
