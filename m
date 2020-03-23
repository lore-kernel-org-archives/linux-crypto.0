Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9648C10DCE
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 20:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0BD220719
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 20:48:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="b58XeakZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgCWUst (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 16:48:49 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:56697 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgCWUst (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 16:48:49 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b3e60c82;
        Mon, 23 Mar 2020 20:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=H/E7+InwbixoEBWVVgGNiW0bFwI=; b=b58Xea
        kZqz7YY98vn/PPE0vX0KkVsz1SrIbgXsVOndAKXTPqv4k+Xf6c5px586bgCivdqo
        zxyBTgg3pT8dGVIiaHL0ETkW5nXjW9zgIYZp8kgjLFBh02Xa60XOAbr9O3AoK4bs
        T8zWytg38SrywWPYzfgrmo2L6wiUC9bVuGCMCrDUDCp34XiAKmj1I3ZTQa+UVtJo
        94Qf4NsDE7IpUWnRkV9Q/ToZ3DYKmfmRslttlMRD4KykIzi2S4dinE5USnyGwwUc
        +lVx9RIlH3SkYt/jVEZ0huqonFJQQ2/JzJUSqKe35QigA/1fUY6o4YsHnuwQeQ7f
        XY4uAhQFnYvXFHuA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2a94b5b6 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 23 Mar 2020 20:41:45 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id k9so5168609iov.7;
        Mon, 23 Mar 2020 13:48:47 -0700 (PDT)
X-Gm-Message-State: ANhLgQ2Wmytooqn6r50E8x2MqoECbt3DwsGmEHon0WVPwfvMnVWniHmG
        34wTQiT7VTwQL1rZrAbjBUjybnm+9k2AYkVlIec=
X-Google-Smtp-Source: ADFU+vuogE2FYRhytJcSX3heagpm4iOVGOOafzpqpPi8fhbcekFavLibp6Y7zDbD/tPZtMeAGruZcXchqz5/fqCu7m8=
X-Received: by 2002:a5e:a50f:: with SMTP id 15mr4024585iog.67.1584996526758;
 Mon, 23 Mar 2020 13:48:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org> <20200323020844.17064-6-masahiroy@kernel.org>
 <CAHmME9p3LAnrUMmcGPEUFqY5vOASe8MVk4=pzqFRj3E9C-bM+Q@mail.gmail.com> <CAK7LNATVAq_Wkv=K-ezwnG=o8a9OoKspZJYOyq+4OXX7EZHPnA@mail.gmail.com>
In-Reply-To: <CAK7LNATVAq_Wkv=K-ezwnG=o8a9OoKspZJYOyq+4OXX7EZHPnA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 23 Mar 2020 14:48:35 -0600
X-Gmail-Original-Message-ID: <CAHmME9pg0_EAG_YkGJQ2AE0n=9EvP2CVoj+bT8cCuiDAdHzUCQ@mail.gmail.com>
Message-ID: <CAHmME9pg0_EAG_YkGJQ2AE0n=9EvP2CVoj+bT8cCuiDAdHzUCQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] x86: remove always-defined CONFIG_AS_SSSE3
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     X86 ML <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Song Liu <songliubraving@fb.com>,
        Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 23, 2020 at 2:45 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Tue, Mar 24, 2020 at 3:06 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Sun, Mar 22, 2020 at 8:10 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > > diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> > > index bf1b4765c8f6..77457ea5a239 100644
> > > --- a/lib/raid6/algos.c
> > > +++ b/lib/raid6/algos.c
> > > @@ -103,9 +103,7 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
> > >  #ifdef CONFIG_AS_AVX2
> > >         &raid6_recov_avx2,
> > >  #endif
> > > -#ifdef CONFIG_AS_SSSE3
> > >         &raid6_recov_ssse3,
> > > -#endif
> > >  #ifdef CONFIG_S390
> > >         &raid6_recov_s390xc,
> > >  #endif
> >
> > algos.c is compiled on all platforms, so you'll need to ifdef that x86
> > section where SSSE3 is no longer guarding it. The pattern in the rest
> > of the file, if you want to follow it, is "#if defined(__x86_64__) &&
> > !defined(__arch_um__)". That seems ugly and like there are better
> > ways, but in the interest of uniformity and a lack of desire to
> > rewrite all the raid6 code, I went with that in this cleanup:
> >
> > https://git.zx2c4.com/linux-dev/commit/?h=jd/kconfig-assembler-support&id=512a00ddebbe5294a88487dcf1dc845cf56703d9
>
>
> Thanks for the pointer,
> but I think guarding with CONFIG_X86 makes more sense.
>
> raid6_recov_ssse3 is defined in lib/raid6/recov_ssse3.c,
> which is guarded by like this:
>
> raid6_pq-$(CONFIG_X86) += recov_ssse3.o recov_avx2.o mmx.o sse1.o
> sse2.o avx2.o avx512.o recov_avx512.o
>
>
> Indeed,
>
>  #if defined(__x86_64__) && !defined(__arch_um__)
>
> is ugly.
>
>
> I wonder why the code was written like that.
>
> I rather want to check a single CONFIG option.
> Please see the attached patch.

Seems better indeed. Looks like you've cleaned up multiple cases.

Now if you could only tell me what is wrong with my series... "Your
series does not work correctly. I will comment why later." I've been
at the edge of my seat, Fermat's last theorem style. :)

By the way, it looks like 5.7 will be raising the minimum binutils to
2.23: https://lore.kernel.org/lkml/20200316160259.GN26126@zn.tnic/ In
light of this, I'll place another patch on top of my branch handling
that transition.

Jason
