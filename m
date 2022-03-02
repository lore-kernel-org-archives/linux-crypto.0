Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9905C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 00:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiCBA1O (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Mar 2022 19:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiCBA1M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Mar 2022 19:27:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9C98D6B5;
        Tue,  1 Mar 2022 16:26:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95CD261515;
        Wed,  2 Mar 2022 00:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3B8C340F3;
        Wed,  2 Mar 2022 00:26:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nGIjknW0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646180787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k9xw86NHArWj2uO6PAsN4hcNs/13iwpRHPZMgOQNy+I=;
        b=nGIjknW0g714PyasoKdpdjgD77VIEp7CkZ0a3hLgB/xn6UMOnjAjOeWVTO0Qe5Q3vNnK14
        hqfn50wQOEPhphnENsvs+S1G+pvD6aI2otB4h+cHgFcK2k4PLH6ztZNDIJAcNs/m46TvlL
        EKqOlhaaillaaevVV/E7ZKSK8CIq6x8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9eae437d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 2 Mar 2022 00:26:27 +0000 (UTC)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-2dbd8777564so462327b3.0;
        Tue, 01 Mar 2022 16:26:26 -0800 (PST)
X-Gm-Message-State: AOAM531CYxU0OdejtfDDcaA0W8J2/jzkuMk4iMCaYvE4H56/xZImxgWg
        8QV3l4V8+rxOwInss9Bqrx37bUe0/Me4Uueypwg=
X-Google-Smtp-Source: ABdhPJxmOvwhXZVVX4xkXIGcz9J6tJgHh4UZppc2qWTHU6TIzRTQvU7f04SMelyGVDtker1h/Mp/6FWKG3f8bf3ViaE=
X-Received: by 2002:a0d:e005:0:b0:2d7:fb79:8f36 with SMTP id
 j5-20020a0de005000000b002d7fb798f36mr29334342ywe.404.1646180784379; Tue, 01
 Mar 2022 16:26:24 -0800 (PST)
MIME-Version: 1.0
References: <20210610134459.28541-1-tianjia.zhang@linux.alibaba.com>
 <20210610134459.28541-2-tianjia.zhang@linux.alibaba.com> <Yh32tEhUgGeSXf/A@zx2c4.com>
 <Yh65NU6TwcvW/VZV@gondor.apana.org.au>
In-Reply-To: <Yh65NU6TwcvW/VZV@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 2 Mar 2022 01:26:13 +0100
X-Gmail-Original-Message-ID: <CAHmME9qL4gHwJZcYGRmJ8sxcjkpGFjWDH2gxu15FXzgCUDLifw@mail.gmail.com>
Message-ID: <CAHmME9qL4gHwJZcYGRmJ8sxcjkpGFjWDH2gxu15FXzgCUDLifw@mail.gmail.com>
Subject: Re: [PATCH 1/3] crypto: sm4 - create SM4 library based on sm4 generic code
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        X86 ML <x86@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 2, 2022 at 1:24 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Mar 01, 2022 at 11:34:28AM +0100, Jason A. Donenfeld wrote:
> > >  lib/crypto/Kconfig   |   3 +
> > >  lib/crypto/Makefile  |   3 +
> > >  lib/crypto/sm4.c     | 184 +++++++++++++++++++++++++++++++++++++++++++
> >
> > If this is only used by the crypto API, it does not belong in
> > lib/crypto.
>
> Nope there is no such rule.  lib/crypto is fine if you're adding
> code that is shared between crypto and arch/*/crypto.

The sprawling madness continues then... Noted.
