Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412B9C43463
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 20:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD77C23119
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 20:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600461039;
	bh=pF2EaBfAA91yl1GxbvEf1Iab4mN8wnQ4UVt8kbNrQng=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=NDtt6/LjykJrDP0GzfcBCpmzSFDekPhpnoBKVMvYdut4Jz7GmDL1LJDhn2Ua/sTD5
	 LJzS/imAGOtqiVT1pstH2ThW04Z6pqWlk8l6EeD/dAzPhZKHWmB+elYukq4jsCf42j
	 yiwkp4fTL7Zq3kxxQbwsAjBPfia8guoXrHSjoLbU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIRUaj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 16:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgIRUaj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 16:30:39 -0400
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB23208C3
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 20:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600461038;
        bh=pF2EaBfAA91yl1GxbvEf1Iab4mN8wnQ4UVt8kbNrQng=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1IP8r9cTTDMmZmiOnaGa5N/3pw+gEY/UIjHvcCoypxfVHZOel3edMo0ZfF82s1c7+
         XUfmggxEuHzRKe3Lai+pnlNILQswEPLlPqlpvIRNhU0BOXsA5hZrHaTP942Om0iRgh
         LsG0+9HZB5bgrM8HcQSe1hOSD1zPSUk94OvYs9FU=
Received: by mail-oo1-f49.google.com with SMTP id r4so1748326ooq.7
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 13:30:37 -0700 (PDT)
X-Gm-Message-State: AOAM5305rQQise/+plq8wa4txCHe5EzPN95xpbAA+q5LoRwbeEC8yhdg
        MU7PwH3izkWBKZyFxlHNwxmxNSjA52NJLsTPnHQ=
X-Google-Smtp-Source: ABdhPJz+HLSHsP2Bs5ZUlCTquWT0HglW+ELvKLXHubshv0bmVurHx87mM90zpAycNx67xaxd+o0Rzdwj0a40JKHEnWU=
X-Received: by 2002:a4a:b443:: with SMTP id h3mr25381514ooo.45.1600461037066;
 Fri, 18 Sep 2020 13:30:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200916061418.9197-1-ardb@kernel.org> <CAKwvOdmqFoVxQz9Z_9sM_m3qykVbavnUnkCvy_G2S2aPEofTog@mail.gmail.com>
 <CAMj1kXE-WJoT0GhCzGGqF4uzVNCqdd1O0SZ9xbHP25eQMCUsqw@mail.gmail.com> <CAKwvOd=G3CCwDdMsrbZvvUpNtxFL=FReovS4ProcRhZBQ73RiQ@mail.gmail.com>
In-Reply-To: <CAKwvOd=G3CCwDdMsrbZvvUpNtxFL=FReovS4ProcRhZBQ73RiQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 18 Sep 2020 22:30:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFVn=8-1KPOTm5FxG9FoVWPMcnfzR6xVB96Fk58GjrQDA@mail.gmail.com>
Message-ID: <CAMj1kXFVn=8-1KPOTm5FxG9FoVWPMcnfzR6xVB96Fk58GjrQDA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] crypto: arm/sha-neon - avoid ADRL instructions
To:     Nick Desaulniers <ndesaulniers@google.com>
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

On Fri, 18 Sep 2020 at 22:08, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Wed, Sep 16, 2020 at 11:08 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Thu, 17 Sep 2020 at 03:53, Nick Desaulniers <ndesaulniers@google.com> wrote:
> > >
> > > One thing I noticed was that if I grep for `adrl` with all of the
> > > above applied within arch/arm, I do still see two more instances:
> > >
> > > crypto/sha256-armv4.pl
> > > 609:    adrl    $Ktbl,K256
> > >
> > > crypto/sha256-core.S_shipped
> > > 2679:   adrl    r3,K256
> > >
> > > Maybe those can be fixed up in patch 01/02 of this series for a v2?  I
> > > guess in this cover letter, you did specify *some occurrences of
> > > ADRL*.  It looks like those are guarded by
> > > 605 # ifdef __thumb2__
> > > ...
> > > 608 # else
> > > 609   adrl  $Ktbl,K256
> > >
> > > So are these always built as thumb2?
> > >
> >
> > No need. The code in question is never assembled when built as part of
> > the kernel, only when building OpenSSL for user space. It appears
> > upstream has removed this already, but they have also been playing
> > weird games with the license blocks, so I'd prefer fixing the code
> > here rather than pulling the latest version.
>
> Oh, like mixing and matching licenses throughout the source itself?
> Or changing the source license?
>
> (I've always wondered if software licenses apply to an entire
> repository, or were per source file?  Could you mix and match licenses
> throughout your project?  Not sure why you'd do that; maybe to make
> some parts reusable for some other project.  But if you could, could
> you do different sections of a file under different licenses? Again,
> probably a worthless hypothetical; you could just split up your source
> files better).
>

https://github.com/openssl/openssl/blob/master/crypto/sha/asm/sha256-armv4.pl
