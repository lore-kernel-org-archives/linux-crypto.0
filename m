Return-Path: <SRS0=E9jf=D4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AA7C56202
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Oct 2020 19:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97D1224178
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Oct 2020 19:23:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t8zYGjnd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444244AbgJUTXR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Oct 2020 15:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441845AbgJUTXR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Oct 2020 15:23:17 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073EDC0613CE;
        Wed, 21 Oct 2020 12:23:17 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id c129so2734858yba.8;
        Wed, 21 Oct 2020 12:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ngb6VdnFO3Cj0Aq7+OesUyk7zjfF0LMjcERe0s6GBrk=;
        b=t8zYGjndpXem8DQZgcJuBlFjaO5IBm2Rsc1xHDtuNliFDnzjVT0i5Buhk12ftG+GvR
         APTGDWJZrfOm4Fgyv1oC0frFaF4koQEjFiY1IXfv8vc7VVvx0/RqOufYTNt/EXfwx6b3
         OHvZCx29eRVDULPQIgwEEt+IKY40doVUxY/vX25PIeWXis4ZiVce1eT8uqZyPkrwHr2f
         V4nQApPN5RIy/OdNZcucmP+lCsb2zKy+UZnNZm8nWL6xeeF7fugXQV7Ax73x+8xXKKfg
         m2THQ+BdsKwRQiD2aIPsryJ/Q8XPCljvh2K2AsWHlhGOCZXAOYkD+IrWbWNyHfJw7JCZ
         YMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ngb6VdnFO3Cj0Aq7+OesUyk7zjfF0LMjcERe0s6GBrk=;
        b=JkbTc3yx0HHiyIKPo0F44aL84A1yJlaj+F4xLLHKduFpJF1D9+BvtX5hmP0U2fYfxa
         yqwgUrbihT8JBluut0YtXRXvvcQFSW5HTR0HnyTMjD5F+WH+S5fIn+nOiVHJY/GWqjJY
         LV8as7ujiCNm/3c9JTcH9Uusp3pW4HH9oQdGingwaq2s84cQmPlSvFS+kdR3TC01gA8O
         2B0ivASEQCgZUfNC+jlaWuPQoULxJiflBiNFtRJZ2dkm+x/dFSBnOxqIl6JnQj01hHwT
         ytSb8X4BAFQAMzJ4DBEGWm8B0EDdPvj9eeznGb9A9PP1+gsIYzY3915r4iLUG/PQegvf
         TE1Q==
X-Gm-Message-State: AOAM532sXDYpDffxcvPwm/QKqy+6Jv/BU3LOwFUITjsgkz59cMDGdDnz
        pIp5XbTjQeftW7qxNdqBivMdmVT2gXcahUAv4PY=
X-Google-Smtp-Source: ABdhPJxdsOYT82PK7x6Fj8Pd5fHM4hcKBF/eXtyc2y+iIT2S5Ob9BhvjkkyLWKF3HF6eu0aMB1v8BZMQ1KVcBeFT1Ao=
X-Received: by 2002:a25:384c:: with SMTP id f73mr6935747yba.135.1603308196270;
 Wed, 21 Oct 2020 12:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <e9b1ba517f06b81bd24e54c84f5e44d81c27c566.camel@perches.com>
 <CAMj1kXHe0hEDiGNMM_fg3_RYjM6B6mbKJ+1R7tsnA66ZzsiBgw@mail.gmail.com> <1cecfbfc853b2e71a96ab58661037c28a2f9280e.camel@perches.com>
In-Reply-To: <1cecfbfc853b2e71a96ab58661037c28a2f9280e.camel@perches.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Wed, 21 Oct 2020 21:23:05 +0200
Message-ID: <CANiq72=FFasodzT76EqaSj_NEY2chV6hzoDtkhMMQfa422oJrQ@mail.gmail.com>
Subject: Re: [PATCH -next] treewide: Remove stringification from __alias macro definition
To:     Joe Perches <joe@perches.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 21, 2020 at 9:07 PM Joe Perches <joe@perches.com> wrote:
>
> Using quotes in __section caused/causes differences
> between clang and gcc.

Yeah, it is a good cleanup get.

Thanks!

> https://lkml.org/lkml/2020/9/29/2187

Can you please put this in a Link: like Ard suggested? (and ideally
find the message in lore.kernel.org instead).

Cheers,
Miguel
