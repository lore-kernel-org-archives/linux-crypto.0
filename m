Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7171C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 20:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88ED820848
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 20:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598558914;
	bh=+ahsqD4+P45OnWV98BsP5VqbkrtURaPEVN6JZN1X5fw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=pH7LlZR0M6Ac83h0Y/s7odofxmuEEGYFE0Q8ILKtSSkSDhNjz8WoX7tNRhc3uhy7W
	 V2jV3R/x1mU5pgW+NYVCPR3NZxSXcYxBtCoXO8qqpH+7nx0C+zbIIxDKx52VjvObvK
	 WIkKbMVpzkw1lBOKJ/STUBBRfLRR1m2v758nGQVc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgH0UId (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 16:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgH0UIc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 16:08:32 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88DCC061264
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2020 13:08:31 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id f26so7827865ljc.8
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2020 13:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a8jHDpzVrAaYyxUKChUy4AApnjCve/xW4jBJvWug5sU=;
        b=h+38sNK30OnEgbzyecaCCmurI820RdHYas7ObLmWqmW9XreH/DQ/k5vML5Xv7IxcSj
         bCZnw9R7iRQOY1obXuyh+CHqwRInpSvQSp/WT/eofKgugtuPzMoT0F2AKldNvzP59mcI
         A7KrUezrrJ4XNpsttDHknomB4O0Z34vXazI68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a8jHDpzVrAaYyxUKChUy4AApnjCve/xW4jBJvWug5sU=;
        b=ipZQF0a6wZ9mL1gVsS5DjG/tBI83pu0aNOU4AGD21f2zCzevE/3tVWfberMbkcqu2S
         FL16YG4YJKOjGfH6WWsaEu6YMxQcvud8UlmlHysnZYZGYsMzDTW1l/Yyaajh+cafJh6P
         tN6XlvbDJDHS12KL608OcUsWrbM18NbGBUE8lzLzC3I4jbrLea/wNXUT3Rheo+I6wuHF
         LscmF7mh2R8nS852GmP1mzZvNf4kdZwncUFXa36IDyzPgFtNa/Fhp+rlOA6u1htCfLkN
         N/ZmfiD1ee+7HWHxaIq9XTbVIvG/ef3BICWP6tzK6bdmK1++XRm+8JqVwm0ttghtSKx6
         qOvg==
X-Gm-Message-State: AOAM533MW8T2SZVMo0town7UgMw79o/124bHyhikXG5bi+CrMG/q4UWG
        7BQ8KjjG+ZnCqFG1zNJ2tAUp2JHqnt5Uwg==
X-Google-Smtp-Source: ABdhPJyfB8juaqUKbWUzZyXna1+zvlH/sS8Jnxt+e92Zl/Ngs5Y5pJ6zUpbAmXLdRiy665SCsREAqg==
X-Received: by 2002:a2e:97da:: with SMTP id m26mr11303180ljj.9.1598558910049;
        Thu, 27 Aug 2020 13:08:30 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id h6sm677843ljg.86.2020.08.27.13.08.27
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 13:08:28 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id v12so7826241ljc.10
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2020 13:08:27 -0700 (PDT)
X-Received: by 2002:a2e:b008:: with SMTP id y8mr9294411ljk.421.1598558907362;
 Thu, 27 Aug 2020 13:08:27 -0700 (PDT)
MIME-Version: 1.0
References: <202008271145.xE8qIAjp%lkp@intel.com> <20200827080558.GA3024@gondor.apana.org.au>
 <CAMj1kXHJrLtnJWYBKBYRtNHVS6rv51+crMsjLEnSqkud0BBaWw@mail.gmail.com>
 <20200827082447.GA3185@gondor.apana.org.au> <CAHk-=wg2RCgmW_KM8Gf9-3VJW1K2-FTXQsGeGHirBFsG5zPbsg@mail.gmail.com>
 <CAHk-=wgXW=YLxGN0QVpp-1w5GDd2pf1W-FqY15poKzoVfik2qA@mail.gmail.com> <CAK8P3a10oUYQHrSu-2rsa_rVemz3K+NBQtsuazn=dBAntsx1cw@mail.gmail.com>
In-Reply-To: <CAK8P3a10oUYQHrSu-2rsa_rVemz3K+NBQtsuazn=dBAntsx1cw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 27 Aug 2020 13:08:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgE2BdfCwakExsKzDXeQq6PBRyt20xw2tf9RWK-RuO0sw@mail.gmail.com>
Message-ID: <CAHk-=wgE2BdfCwakExsKzDXeQq6PBRyt20xw2tf9RWK-RuO0sw@mail.gmail.com>
Subject: Re: lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes
 is larger than 1024 bytes
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        kbuild-all@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 12:12 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Ah right, that explains why I never saw the warning in my randconfig
> build tests, I run those with COMPILE_TEST force-enabled.

.. but your clang test did enable this?

.. never mind, I have clang locally anyway, and while I usually don't
do the allmodconfig test there, I did it now with COMPILE_TEST
disabled.

clang does seem fine. It generates 136 bytes of stack-frame (plus
register saves), which is certainly not optimal, but it's not horribly
excessive.

Of course, I don't know if clang actually does the same as gcc with
-fsanitize=object-size and -fprofile-arcs, but whatever they do, they
were on for that clang build.

So yes, this does seem to be a gcc-only problem.

               Linus
