Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A542C4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 02:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56CFC20835
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 02:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569549992;
	bh=ZMzFHyK/Vb5fDfPG7wxoQ164d/ZDSvIGKnlZs3qq3xQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=PSYxGJ4FqnI8USzgH5YZwskgG4VnKuiG+I19CPkjnznlwr1cB1+Bs5cAPaVCcSQOo
	 5Veze9JKmPqXfYJGdsuxMLcZ97lyOy9y6JpYni3OxKwTZ44ZLHN5bzh53N4K/6QFLo
	 JDFaL+a+BbqiQixqsnynAqib0rlKeIKwBO/SxgCg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfI0CGb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 22:06:31 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42629 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfI0CGb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 22:06:31 -0400
Received: by mail-lf1-f65.google.com with SMTP id c195so652271lfg.9
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 19:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OJh6hczbbMF+hVrPwQo82LrMWLXXhdgwuK2FQy+UbcU=;
        b=dG5VU4yCxZ8kISwmVBqfUikv8VNBMtH2elKShBQTmWjuKMM73DSlWccxnyNeoSUOF/
         lFxW4MbHMqpQ/DSN8ak25pchuhkYPCnX3aOQK6JA8/4ZONpKbxQ5es1cZkl+MFK61p4f
         NrJM8OX4525vvN+QzOSqhkmHv67y/TWGtra18=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OJh6hczbbMF+hVrPwQo82LrMWLXXhdgwuK2FQy+UbcU=;
        b=NCLJdTYOQ0drr+v8B0kj/7Q64icrdHb2jOCepBIxuIgWGF6yhyWgQgDrGa9WVnx7TD
         rQtueCCfTiMey5w6kTsG+T3j0y16tifx4pCpyK1L1reO0nXZHT0MVVX5Ijaohha2zhZm
         lz5MyuMpKmPCovG24DojTs5tX5XGK6jPQmCpClEwVUcJMa8TJayKOzXD+dT4/Hw3fjlZ
         eVnKYilIEj2GCKjkg9Etp6gt/7fcdd1dmiEuU6wOYpG6HUUPEPOTdeD37IO05URJUGum
         u/aNuTazveHIrW7iHXwqFxuLUJo0uyZIliPFCP5K66j+R3uFXj+sa3CmOgPj0dVAWIvO
         92cQ==
X-Gm-Message-State: APjAAAXySxml5+VNQ9ZlSuKr3A0/9WXovjny4cw3ssKpCjvrqku/QlVy
        lLgyWqn/nwmPHpcHXLEQxMjGitafaxs=
X-Google-Smtp-Source: APXvYqxWd3xFTtRhdswzr3mmbSUquklljFdv4ltBIt07Yr8vMzb+UxJzqzLOOAZsNb/g0ilVzdKWbw==
X-Received: by 2002:a19:ef17:: with SMTP id n23mr876371lfh.109.1569549985906;
        Thu, 26 Sep 2019 19:06:25 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id l3sm186339lfc.31.2019.09.26.19.06.24
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 19:06:24 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id f5so867306ljg.8
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 19:06:24 -0700 (PDT)
X-Received: by 2002:a2e:9854:: with SMTP id e20mr1057382ljj.72.1569549984094;
 Thu, 26 Sep 2019 19:06:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org> <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com> <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 26 Sep 2019 19:06:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgu5-Wj=UY+iU+x=RcKN_ceUsKdfhsv2-E5TNocELU8Ag@mail.gmail.com>
Message-ID: <CAHk-=wgu5-Wj=UY+iU+x=RcKN_ceUsKdfhsv2-E5TNocELU8Ag@mail.gmail.com>
Subject: Re: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 26, 2019 at 5:15 PM Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> But even the CPU only thing may have several implementations, of which
> you want to select the fastest one supported by the _detected_ CPU
> features (i.e. SSE, AES-NI, AVX, AVX512, NEON, etc. etc.)
> Do you think this would still be efficient if that would be some
> large if-else tree? Also, such a fixed implementation wouldn't scale.

Just a note on this part.

Yes, with retpoline a large if-else tree is actually *way* better for
performance these days than even just one single indirect call. I
think the cross-over point is somewhere around 20 if-statements.

But those kinds of things also are things that we already handle well
with instruction rewriting, so they can actually have even less of an
overhead than a conditional branch. Using code like

  if (static_cpu_has(X86_FEATURE_AVX2))

actually ends up patching the code at run-time, so you end up having
just an unconditional branch. Exactly because CPU feature choices
often end up being in critical code-paths where you have
one-or-the-other kind of setup.

And yes, one of the big users of this is very much the crypto library code.

The code to do the above is disgusting, and when you look at the
generated code you see odd unreachable jumps and what looks like a
slow "bts" instruction that does the testing dynamically.

And then the kernel instruction stream gets rewritten fairly early
during the boot depending on the actual CPU capabilities, and the
dynamic tests get overwritten by a direct jump.

Admittedly I don't think the arm64 people go to quite those lengths,
but it certainly wouldn't be impossible there either.  It just takes a
bit of architecture knowledge and a strong stomach ;)

                 Linus
