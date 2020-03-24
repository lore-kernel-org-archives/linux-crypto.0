Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 007B7C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8DAA20722
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585011178;
	bh=P2oNbCx5t1xyZdNzp1UD6mwTvprw3BqkCsk+lW4PZQw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=TfxPRoofb31vO13UNDlfG1sBUxn7B0t49kWYlwce/vCXpQgqrMQUg3A6LAcH9kyBn
	 GMEip7WheQkQRQkl/a13vnr8e2uZJKvqt6q6Iekf5HZhV3Ws3h7aiCPbaLCa8dC1NF
	 isowoZj1blhNP6ZJNjyAM2/XmPpGFZh+A22eI334=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgCXAw6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:52:58 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:56151 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgCXAw6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 20:52:58 -0400
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id 02O0qspu005826;
        Tue, 24 Mar 2020 09:52:54 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com 02O0qspu005826
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585011174;
        bh=P2oNbCx5t1xyZdNzp1UD6mwTvprw3BqkCsk+lW4PZQw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=c9jILnI8FrdGLPp0pGPJcRtLjQHvX7eFFN3+IDW6FPEQ3Oeaxt0rjoT0YwU4h7/TM
         fNJjXmEinnE3k1p7YdrbIABva1LtHFhIhRD2Bc+4GHE9KdaRbTMzVexV4dEBBHSk46
         KodvW7nOuVYPjFy96P70UMRa7G5RMvFOaVjrKcwOczThx3fq5TZfrc1jzWPC18EIO/
         Yiep+svzoYyRVxR3NlOL1Qch/Btnw46FZ0jiBJacGUGUQ2blI5IAgkd+5Gd9iP70qf
         g8mhthc1XFwNyff02rv9A8gopNQZish7Wb6qbTrE3HsWvPYpzeIUZA2CT2I39RXI0w
         PgedNKSbLGXEg==
X-Nifty-SrcIP: [209.85.217.54]
Received: by mail-vs1-f54.google.com with SMTP id u11so168618vsg.2;
        Mon, 23 Mar 2020 17:52:54 -0700 (PDT)
X-Gm-Message-State: ANhLgQ0ciHSIo0gehdjsz5Rg2d69VIAeQyj0l4ebfejqy+8Qcnyk0a4i
        PVOiHnjcSsBklyJTcmKd7vylFoNKDQqJU77/fkk=
X-Google-Smtp-Source: ADFU+vvCqvboIcw4CBVM2i5u1rShQTwzICVwT7haDdL6BKrZF/0unDcF9eXZ2vWPJuONpYCzDIZaElvtm+vGoY9t7KQ=
X-Received: by 2002:a67:2d55:: with SMTP id t82mr17504165vst.215.1585011173169;
 Mon, 23 Mar 2020 17:52:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200324001358.4520-1-masahiroy@kernel.org> <CAHmME9rdoo2Q3n4YA59GrVEh8uaCY_0-q+QVghjgG3WwcHkmug@mail.gmail.com>
In-Reply-To: <CAHmME9rdoo2Q3n4YA59GrVEh8uaCY_0-q+QVghjgG3WwcHkmug@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 24 Mar 2020 09:52:17 +0900
X-Gmail-Original-Message-ID: <CAK7LNATQG4ABWxkShbgTpW78M4FYY_9Fmg2GSxXDTE51yWF=MQ@mail.gmail.com>
Message-ID: <CAK7LNATQG4ABWxkShbgTpW78M4FYY_9Fmg2GSxXDTE51yWF=MQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] x86: remove always-defined CONFIG_AS_* options
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     X86 ML <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        NeilBrown <neilb@suse.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 24, 2020 at 9:29 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Mon, Mar 23, 2020 at 6:15 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> >
> > arch/x86/Makefile tests instruction code by $(call as-instr, ...)
> >
> > Some of them are very old.
> > For example, the check for CONFIG_AS_CFI dates back to 2006.
> >
> > We raise GCC versions from time to time, and we clean old code away.
> > The same policy applied to binutils.
> >
> > The current minimal supported version of binutils is 2.21
> >
> > This is new enough to recognize the instruction in most of
> > as-instr calls.
> >
> > If this series looks good, how to merge it?
> > Via x86 tree or maybe crypto ?
>
> This series looks fine, but why is it still incomplete? That is, it's
> missing your drm commit plus the 4 I layered on top for moving to a
> Kconfig-based approach and accounting for the bump to binutils 2.23.
> Everything is now rebased here:
> https://git.zx2c4.com/linux-dev/log/?h=jd/kconfig-assembler-support
>
> Would you be up for resubmitting those all together so we can handle
> this in one go?


The drm one was independent of the others,
so I just sent it to drm ML separately.

As for your 4, I just thought you would
send a fixed version.

But, folding everything in a series will clarify
the patch dependency.
OK, I will do it.
Who/which ML should I send it to?


--
Best Regards
Masahiro Yamada
