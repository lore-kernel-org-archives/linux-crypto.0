Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FE1C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 19:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E4CF2087E
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 19:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NgTyVLtt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgH0Ter (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 15:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgH0Teq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 15:34:46 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF35C06121B
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2020 12:34:46 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d22so4286497pfn.5
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2020 12:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fpDAKTX7sUt+h1k2qZMpf7zaIKLO9/YUehufInwZmRc=;
        b=NgTyVLttnfUsxHG4wG440jYmf1lU2XBuIdobcCjhI8JY0lnuPm3/o8dxslZ1XFqYoM
         9LAmbIMDHhdoT9VySODCkv2JlHJ7ZqQyT1Ts5IZ46FIgVs1JODBecEDVuaNxOJCduPJL
         SaIErm+GsNKJlg//YHiaeCv7q8mgFSSs2fOEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fpDAKTX7sUt+h1k2qZMpf7zaIKLO9/YUehufInwZmRc=;
        b=YjJVtdEJMDqAEy7y7gF1ZW09ZvfuS789CE/CcLAahZ1VlnZGNL01gkt5PjQgVAaBlZ
         lguoobCPFNNeAKsF4dI8etcAz4C7OjuVuVVPPVZUpnYSVQQ2dVSW+tDbbCwnsVkX6ob8
         zG6EhMvJu7ETdJMdmdbNx80oi6eSqg1CmJU5eaD9WwsNgtdSqYr7+k8GBqOu90bQUx++
         KVQtGoguEZw4UAMAjup6HTDkCmeZ+dZ6e79lDtw/ReYR7mBITcKaz0uZLewdx6ZejPbF
         dgM4QykSvHncP0r0gsQrOH4Dh07RzGUUMrZcC42uWb2YTgOcz5IcA4rtxKmMnXHd4Amg
         kr5w==
X-Gm-Message-State: AOAM530OKdcaYXEaW99QaLrh96CEayleqSoDnxMQpLMTj/sOHlbzM3fz
        DCfcN7kpFqxQX5DI8KfNBxZ/hA==
X-Google-Smtp-Source: ABdhPJy+43nZBP6WiUlsUteIOTltC5MaEaevO7peHccXunQTT9MOgLKO6FUW46vGB0su1CTKKlJgjQ==
X-Received: by 2002:a63:e703:: with SMTP id b3mr15566018pgi.39.1598556885979;
        Thu, 27 Aug 2020 12:34:45 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s20sm1943903pfd.128.2020.08.27.12.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 12:34:45 -0700 (PDT)
Date:   Thu, 27 Aug 2020 12:34:44 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        kbuild-all@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes
 is larger than 1024 bytes
Message-ID: <202008271233.AB0F0CDAB@keescook>
References: <202008271145.xE8qIAjp%lkp@intel.com>
 <20200827080558.GA3024@gondor.apana.org.au>
 <CAMj1kXHJrLtnJWYBKBYRtNHVS6rv51+crMsjLEnSqkud0BBaWw@mail.gmail.com>
 <20200827082447.GA3185@gondor.apana.org.au>
 <CAHk-=wg2RCgmW_KM8Gf9-3VJW1K2-FTXQsGeGHirBFsG5zPbsg@mail.gmail.com>
 <CAHk-=wgXW=YLxGN0QVpp-1w5GDd2pf1W-FqY15poKzoVfik2qA@mail.gmail.com>
 <CAK8P3a10oUYQHrSu-2rsa_rVemz3K+NBQtsuazn=dBAntsx1cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a10oUYQHrSu-2rsa_rVemz3K+NBQtsuazn=dBAntsx1cw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 09:11:52PM +0200, Arnd Bergmann wrote:
> On Thu, Aug 27, 2020 at 7:55 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Thu, Aug 27, 2020 at 10:34 AM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > How are you guys testing? I have UBSAN and GCOV on, and don't see
> > > crazy frames on either i386 or x86-64.
> >
> > Oh, never mind. I also have COMPILE_TEST on, so it ends up disabling
> > GCOV_PROFILE_ALL and UBSAN_SANITIZE_ALL.
> 
> Ah right, that explains why I never saw the warning in my randconfig
> build tests, I run those with COMPILE_TEST force-enabled.

Ah, I got this backwards. It's not COMPILE_TEST breaking it, it's
actually FIXING it. :P Anyway, I'll go clean this up more.

-- 
Kees Cook
