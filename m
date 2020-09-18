Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E459CC43465
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 19:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC01621741
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 19:39:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MMijeS5i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgIRTjo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 15:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgIRTji (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 15:39:38 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B50C0613CE
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 12:39:38 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id m15so3508698pls.8
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 12:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ugDHAjreJcjr2sWmhzBxhqb0r9L38OJhgw/SK5/hXcA=;
        b=MMijeS5iSCBD6TdcsROq3wTBNGom0mymBli3Y7GoxookncCyXLPhiCD1hGXMM0OPi5
         FseDWPW8AhtFzulUwDfOV2C3xvDwwnImE4cEeDboLKnfr5d0EoqWPWaiBKAtg9etgxJ1
         QsnrQSM3hWlZXg8UiHNO4ulb7iMZt/9OiWq3v38GuXw68fRaJ2bKNZWfI61k64ntRwZf
         uzPs70jvLCyw0j05qFjWEogD5N0tr2ki5DrGgtt/3hABsWDoXC1CkjoQAc0IsqUrG0bC
         LACfKgVvIhbxEGYIP5RFTiKMGlbl71EUpNLtn63mpCgEKqp3RqIyxU20U5v4ocLq8a11
         8OFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ugDHAjreJcjr2sWmhzBxhqb0r9L38OJhgw/SK5/hXcA=;
        b=mMj7KQ3c7iX0clcu5NM+XBfXsDUleO/xPX5smNvxEH4lCTpiSwfpZF48RqztqoVnAn
         iabQN6riSAK3c8E15Vwn86Nf9gBYT2/1Avlh6M/52iP+l83xw2FGzt4JkoLYC3FKL0dD
         sSPSF7G90ws1XtI3zPI0izudbTJIawt43koKJrtsS7m8nypsipCvHxFRjmo+e44zPe/7
         dtEt6zWGewg/Yckoui8hZLYmMa1aCvr1joJlUF/q5gmwQVQ7X/mief/gehT8kB+Anq/+
         ISAx7kO+apbevdwhIyY1HAaVNKjn2bT+6kOtPYiy8EsLKA1GhnkGyttS+T21tTZaWdf5
         FuoA==
X-Gm-Message-State: AOAM531TgRBcaJA9LuSwkeZriS3QCbMwgv06lLG8axJ2MrAW2We2h3iw
        CPoZVGc+NH6H8mrxG7vaRURERsfK0zN2HEEwLMvgSA==
X-Google-Smtp-Source: ABdhPJyuTQ6eWHseHu6pz8Fdfd7MU+vsvAbZLf6HZw27l+sY0R/11CACwcB2ADGtOmcQ/AT2rgvgSVZPcMhDmT/R5Yo=
X-Received: by 2002:a17:90b:f18:: with SMTP id br24mr1807074pjb.32.1600457977854;
 Fri, 18 Sep 2020 12:39:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200916071950.1493-3-gilad@benyossef.com> <202009162154.fxQ0Z6wT%lkp@intel.com>
 <CAOtvUMdv9QNVdaU7N6wJVq27Asyrckuu9bf15fO=+oZUh5iKOg@mail.gmail.com>
In-Reply-To: <CAOtvUMdv9QNVdaU7N6wJVq27Asyrckuu9bf15fO=+oZUh5iKOg@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 18 Sep 2020 12:39:26 -0700
Message-ID: <CAKwvOdmW+n_g4C_pXnF+8wh2q0gZZyXAfaYR9cVNm3p1QeJ-xA@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: ccree - add custom cache params from DT file
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     kernel test robot <lkp@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Network Development <netdev@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alex Elder <elder@linaro.org>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 17, 2020 at 12:20 AM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
> hmm...
>
> On Wed, Sep 16, 2020 at 4:48 PM kernel test robot <lkp@intel.com> wrote:
> >
> > url:    https://github.com/0day-ci/linux/commits/Gilad-Ben-Yossef/add-optional-cache-params-from-DT/20200916-152151
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> > config: arm64-randconfig-r015-20200916 (attached as .config)
> > compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 9e3842d60351f986d77dfe0a94f76e4fd895f188)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # install arm64 cross compiling tool for clang build
> >         # apt-get install binutils-aarch64-linux-gnu
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm64
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> drivers/crypto/ccree/cc_driver.c:120:18: warning: result of comparison of constant 18446744073709551615 with expression of type 'u32' (aka 'unsigned int') is always false [-Wtautological-constant-out-of-range-compare]
> >            cache_params |= FIELD_PREP(mask, val);
> >                            ^~~~~~~~~~~~~~~~~~~~~
> >    include/linux/bitfield.h:94:3: note: expanded from macro 'FIELD_PREP'
> >                    __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");    \
> >                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    include/linux/bitfield.h:52:28: note: expanded from macro '__BF_FIELD_CHECK'
> >                    BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,         \
> >                    ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    include/linux/build_bug.h:39:58: note: expanded from macro 'BUILD_BUG_ON_MSG'
> >    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
> >                                        ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
> >    include/linux/compiler_types.h:319:22: note: expanded from macro 'compiletime_assert'
> >            _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >            ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    include/linux/compiler_types.h:307:23: note: expanded from macro '_compiletime_assert'
> >            __compiletime_assert(condition, msg, prefix, suffix)
> >            ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    include/linux/compiler_types.h:299:9: note: expanded from macro '__compiletime_assert'
> >                    if (!(condition))                                       \
> >                          ^~~~~~~~~
>
> I am unable to understand this warning. It looks like it is
> complaining about a FIELD_GET sanity check that is always false, which
> makes sense since we're using a constant.
>
> Anyone can enlighten me if I've missed something?

Looked at some of this code recently.  I think it may have an issue
for masks where sizeof(mask) < sizeof(unsigned long long).

In your code, via 0day bot:

   107          u32 cache_params, ace_const, val, mask;
...
> 120          cache_params |= FIELD_PREP(mask, val);

then in include/linux/bitfield.h, we have:

 92 #define FIELD_PREP(_mask, _val)           \
 93   ({                \
 94     __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");  \

 44 #define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)     \
...
 52     BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,   \
 53          _pfx "type of reg too small for mask"); \

so the 0ULL in FIELD_PREP is important.  In __BF_FIELD_CHECK, the
typeof(_reg) is unsigned long long (because 0ULL was passed).  So we
have a comparison between a u32 and a u64; indeed any u32 can never be
greater than a u64 that we know has the value of ULLONG_MAX.

I did send a series splitting these up, I wonder if they'd help here:
https://lore.kernel.org/lkml/20200708230402.1644819-3-ndesaulniers@google.com/
-- 
Thanks,
~Nick Desaulniers
