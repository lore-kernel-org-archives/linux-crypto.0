Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780E5C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jun 2022 19:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240730AbiF0TuU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jun 2022 15:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238673AbiF0TuT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jun 2022 15:50:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CECF1BE8F
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jun 2022 12:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656359418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aY3BGsAPWXJIRlV7BW/+M56z3wTEg8cyWf2FbY9hbGQ=;
        b=Gsw3Yx4aZRmv6mgFZxLmAvVQgieSVVsxeCrqqG5Q1LiE/GwnCNedZDnmgDkS2EaCLZjrPt
        5UKxMHs08lpxrzZ5qwvw3k9K9MkgVIIx3HXkScGY14ZBsXFbIAzIj7cA/zOiqQwu5Na4HO
        wt7QJe97iUxl8ICJYfS2Np1GU5gE6To=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-nnQUaRLRPW2SBwwNzbk8rA-1; Mon, 27 Jun 2022 15:50:16 -0400
X-MC-Unique: nnQUaRLRPW2SBwwNzbk8rA-1
Received: by mail-ed1-f71.google.com with SMTP id z17-20020a05640235d100b0043762b1e1e3so6434455edc.21
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jun 2022 12:50:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aY3BGsAPWXJIRlV7BW/+M56z3wTEg8cyWf2FbY9hbGQ=;
        b=LPmVdoaM19/JAj3m8PZ2fkaCRMWDLvxeNcQr6tC8JX3xNSawauE0ygq7OEfQ9ORU53
         qaT95TOO0yJW9sYnPIWFWnWCQNkuPuiXXa7HwbqfIEfTTkKjvug4KlbPmmyTtfo8th2Z
         xQE81nrlGFS1kp5btNt5s6vCcqoaa8+k90Z7HZtHB11LH7O9XXmNGqBhEAKwxWFvS2gh
         xPWnIQHbbAQdD3x6W8oKQMRH49MB+qaBoUL6VJifDB7uqb8iCIpdRk39t588O+fqG8LV
         AaR2OIuOZSyNt3SNpgrI2K5SDf49BXUq7Y0X13BGrzWxIo6OZNyEwwj0Rm8r/sqQf2CX
         gUuw==
X-Gm-Message-State: AJIora/0w6Tuj3l9sIpyvio35H2QzTz2dzF1VtUoFD0E7iaG/tdV9rBM
        ScwwF4xWLGR2TMNFvl6Stzfuxxn0H783TWnigGnIE8OAgWuEFRzUi0zWSaKOGAA8O48l0OlKwgu
        gvrrGOV5MABsTVw5/pKXlj3divHCOR5F4NWYr38Xs
X-Received: by 2002:aa7:c7cc:0:b0:435:81f5:2021 with SMTP id o12-20020aa7c7cc000000b0043581f52021mr18734034eds.62.1656359415711;
        Mon, 27 Jun 2022 12:50:15 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tEuFxoP8I8/hLDGv9l/Zdwg7W+hqUq1QVeylsUNVGisYwFrgcDJGy6PJPqeWWvuRE1Uig29ILMJgLnusfRYfg=
X-Received: by 2002:aa7:c7cc:0:b0:435:81f5:2021 with SMTP id
 o12-20020aa7c7cc000000b0043581f52021mr18734023eds.62.1656359415585; Mon, 27
 Jun 2022 12:50:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220620131618.952133-1-vdronov@redhat.com> <20220621150832.1710738-1-vdronov@redhat.com>
 <YrkFiM+Y2G7a50z5@gondor.apana.org.au>
In-Reply-To: <YrkFiM+Y2G7a50z5@gondor.apana.org.au>
From:   Vlad Dronov <vdronov@redhat.com>
Date:   Mon, 27 Jun 2022 21:50:04 +0200
Message-ID: <CAMusb+SOk3TW5q6q6-QNjimupaX+V-DMS==RdQinZ+jLRrADOQ@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: fips - make proc files report fips module name
 and version
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Simo Sorce <simo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Herbert,

On Mon, Jun 27, 2022 at 3:19 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Jun 21, 2022 at 05:08:32PM +0200, Vladis Dronov wrote:
> >
> >  #ifdef CONFIG_CRYPTO_FIPS
> >  extern int fips_enabled;
> >  extern struct atomic_notifier_head fips_fail_notif_chain;
> >
> > +#define FIPS_MODULE_NAME CONFIG_CRYPTO_FIPS_NAME
> > +#ifdef CONFIG_CRYPTO_FIPS_CUSTOM_VERSION
> > +#define FIPS_MODULE_VERSION CONFIG_CRYPTO_FIPS_VERSION
> > +#else
> > +#define FIPS_MODULE_VERSION UTS_RELEASE
> > +#endif
>
> Why does this need to be in fips.h? If it's only used by one file
> then it should be moved to the place where it's used.

Indeed, you are right, these defines are used only once, thank you. I'll move
them to fips.c. Let me post v3 to this same thread below.

Just a heads-up, a kernel with this patch builds, boots and a FIPS output is
correct.

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

