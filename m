Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF336C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 03:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8E3D6108D
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 03:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhKQDL5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 22:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhKQDL5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 22:11:57 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2482C061570;
        Tue, 16 Nov 2021 19:08:58 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id s13so1686909wrb.3;
        Tue, 16 Nov 2021 19:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7UhcpsKrtyIsxTBA6QenhVurPqFsIK55Y63ymJwZ+Fo=;
        b=ZN3EHphS8kER4m9GoZKX4VnmOccZKxd/re2+Nz57yq/lVLPXTU+QZvlDe8LMQ+H5r4
         tZc3nW7KQ1hvlw0IzDjZLcyojYbiDYJYv9EudP8AwUXQxqbCLLO2A/1ejyqG1E/wlUH8
         aHtqioUWjjXnkTn21knutTwSEa/1bgJCyl01FspxsPqrMghXEwQL7OXF1Bh9gS/e69Sf
         awPFGVn52q4YlgfPHjbwmlpihG38fkbznvPIgn+XLRKw2AWrsnSrBnXJyda3ak7sLbCw
         TmiEsGzpduktEf5hP9WVlgKkV3pclXs8c7xlbvkSWLGxbK46zGQncz11fPn9cEp/CN0Z
         +aMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7UhcpsKrtyIsxTBA6QenhVurPqFsIK55Y63ymJwZ+Fo=;
        b=RSjRS4yk0nqR6zinURa7fXLFyYk5x/n3Bv9mOpicG23WlPf9Z8BHGFueYAllgOwZiT
         5QyvE6CM+csxYrVSkdYGY0vmqlXPVF9enWQ1aKzC7KkqgnrxyL4csra1Guc8UKiAgvMT
         2C2FcOjJ7+kiJRYy/h53x/u20LBvmu9y7SbGq/Bq5shjvbF40Veexu5csRtv8O41Ad94
         IWO0Pl20Pjz7P/4oa69SGHj4fCv3/HvdNMZcDy3nO+P9EtGJTF/Xde0y5HWBmLZbDA5h
         ka6WCBQlE6riBOEEJNuB0TMG+UiOm/0IKhPUQyfbt4ZZjHLkgt/DItpcQNAaux7A+Tuk
         fFDQ==
X-Gm-Message-State: AOAM531wfXbr2Q9VP7Qc5+8ln054lgrE90FuYXDASLVVE1pFKxGcqQbU
        FnmNhHWTgZrAuRbbi7w5W9irugpGSZbEvAjxKNeFGDqT9DA=
X-Google-Smtp-Source: ABdhPJxcXeWlmlPMVZTnLP71dZsGRLdLEtXRpeRD39863OkYlkfI2jQI8gE+je80TT7FAJUWbe/hPpu54cymOk+zG8k=
X-Received: by 2002:adf:9d82:: with SMTP id p2mr15637311wre.414.1637118537630;
 Tue, 16 Nov 2021 19:08:57 -0800 (PST)
MIME-Version: 1.0
References: <CACXcFm=kwziZ5Etdevu0uq_t5qy0NbGY753WfLvnwkMqtU9Tvg@mail.gmail.com>
 <YZObImtJITs1ZfUc@kroah.com>
In-Reply-To: <YZObImtJITs1ZfUc@kroah.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Wed, 17 Nov 2021 11:08:45 +0800
Message-ID: <CACXcFm=bPdoLqYHEUpeZEQEULVGW6ej4ESHX+vMdeGfvjc51tg@mail.gmail.com>
Subject: Re: [PATCH 1/8] Replace memset() with memzero_explicit()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 16, 2021 at 7:51 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> Have you looked at the output of the compiler to see if this really is
> needed or not?

No. To do that right you'd need to look at (at least) gcc & clang,
multiple architectures (cross-compiled & native) & various levels
of optimisation. I just looked at the C code.

> And what exactly are you zeroing out that could be read afterward
> somehow?

Whatever it is, the person who wrote the code thought it was
worth zeroing out with memset(). The only question is whether
it is safer to use memzero_explicit().

Granted in many cases this will not matter unless the kernel
is compiled at some optimisation level that does cross-function
analysis so it might be "smart" enough to optimise out the
memset(). Also granted it does not matter unless an attacker
can look inside the running kernel & if  he or she has that
level of privilege, then you have much else to worry about.

Still, it seemed safer to me to use memzero_explicit() in
these cases.
