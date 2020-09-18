Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04E8C43464
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 20:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A651206D4
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 20:08:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bSGw16RK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIRUI2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 16:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIRUI2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 16:08:28 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FA8C0613CE
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 13:08:28 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u3so3573096pjr.3
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 13:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y3gCF6cVXQ/uNljeBB8xutvFX6D3KBD6dmi/Mv4Oc4E=;
        b=bSGw16RK4CFd9T9smTFOmmMuaQBniYxgjLaks3N0dr0ZD6WSkNnecZkr6OIdqmw17z
         PysfKXheo2kAvYwBZCS1pxEF2VhZqlPt6CvTaB3Wwf4Z4qyCnLmCmbSdtPOIBVHSMKoh
         Ss5aoQWQC5/Sa7y+59TKbtXVTp0GVvpx5R8n6iTzLlQ8Hb7c8cZJeUicOJvrsUlt5END
         Fzk5VX2OCrFONdDXznj5QO3fzSGBbvju1862X6+UENGxLXxeEfU94jzNlqhjGUqhnO0g
         M6lefDd+0viUEvPxYFDAx7ZTwb+wdaeAwqM8dLkYm3RRFMEemD2eS8mEcZGA6WARYZS5
         onAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y3gCF6cVXQ/uNljeBB8xutvFX6D3KBD6dmi/Mv4Oc4E=;
        b=VNA3KXe04nwOunYxIvfzyBtBNL5aw0YzC0+F5tFS5QX7rXKDEHCUylqxSz3AppoF7g
         CRGq2FDIHmOietV+pyeKsNjvXnRLZxYWvYGRLZepqSeK8Bj/6xF9fw85M5cbORjNJEZp
         Igl3Alj4wDDumAgUNgs0SgcmKcFyl2Acb7Y/5WhbmvQBeSQYMxF5913/Ta626hglSHd2
         RVlfIxYWo+O4QUoRyO9ntM0Ql4vUXQtB80KPhed5x8dI1gQnEXUEfPSQPO6RWnwfz1JM
         vzPMxKqDkY7bCaii0a7RLdzp/ZH8JaGm44MraIpvwp//GqPyOb9pfCLAeuR/0yQD7lHS
         XGbg==
X-Gm-Message-State: AOAM531S1YNe2tvaNsh40pu5sieM6iwRpzCxRxQ4LFSBeCbiQkN8D9J0
        TZnHABLSrdG8anC0Jsm4HK+pQs1o9lX1jYorbb72ow==
X-Google-Smtp-Source: ABdhPJwe2+REn+FgVcbl/5xaqa7hC0bqyulNMJq81dqH9hHkz77b7rr4OlV+8SQY6LuvkBsFZYrH08uJ3sNY7otFTwI=
X-Received: by 2002:a17:902:7295:b029:d1:e3bd:48cc with SMTP id
 d21-20020a1709027295b02900d1e3bd48ccmr18375149pll.10.1600459707638; Fri, 18
 Sep 2020 13:08:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200916061418.9197-1-ardb@kernel.org> <CAKwvOdmqFoVxQz9Z_9sM_m3qykVbavnUnkCvy_G2S2aPEofTog@mail.gmail.com>
 <CAMj1kXE-WJoT0GhCzGGqF4uzVNCqdd1O0SZ9xbHP25eQMCUsqw@mail.gmail.com>
In-Reply-To: <CAMj1kXE-WJoT0GhCzGGqF4uzVNCqdd1O0SZ9xbHP25eQMCUsqw@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 18 Sep 2020 13:08:16 -0700
Message-ID: <CAKwvOd=G3CCwDdMsrbZvvUpNtxFL=FReovS4ProcRhZBQ73RiQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] crypto: arm/sha-neon - avoid ADRL instructions
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stefan Agner <stefan@agner.ch>,
        Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 16, 2020 at 11:08 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 17 Sep 2020 at 03:53, Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > One thing I noticed was that if I grep for `adrl` with all of the
> > above applied within arch/arm, I do still see two more instances:
> >
> > crypto/sha256-armv4.pl
> > 609:    adrl    $Ktbl,K256
> >
> > crypto/sha256-core.S_shipped
> > 2679:   adrl    r3,K256
> >
> > Maybe those can be fixed up in patch 01/02 of this series for a v2?  I
> > guess in this cover letter, you did specify *some occurrences of
> > ADRL*.  It looks like those are guarded by
> > 605 # ifdef __thumb2__
> > ...
> > 608 # else
> > 609   adrl  $Ktbl,K256
> >
> > So are these always built as thumb2?
> >
>
> No need. The code in question is never assembled when built as part of
> the kernel, only when building OpenSSL for user space. It appears
> upstream has removed this already, but they have also been playing
> weird games with the license blocks, so I'd prefer fixing the code
> here rather than pulling the latest version.

Oh, like mixing and matching licenses throughout the source itself?
Or changing the source license?

(I've always wondered if software licenses apply to an entire
repository, or were per source file?  Could you mix and match licenses
throughout your project?  Not sure why you'd do that; maybe to make
some parts reusable for some other project.  But if you could, could
you do different sections of a file under different licenses? Again,
probably a worthless hypothetical; you could just split up your source
files better).
-- 
Thanks,
~Nick Desaulniers
