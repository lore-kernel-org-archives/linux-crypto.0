Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95918C54EEB
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 06:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59D362074D
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 06:53:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="tuhwgUCA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgCWGxX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 02:53:23 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:57655 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgCWGxX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 02:53:23 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 4025283f;
        Mon, 23 Mar 2020 06:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=hhsjJ5nTbW/Bbc8zpStB0FYxsX4=; b=tuhwgU
        CA3CliFET6ommFcdWnTY9HTFkBS8OxDwc7nsw3GhO5sx9aE5GBe5Ydojnok9nCw1
        1vYdyFqJzC6IUQojzF0/FaGqmY5bFAP0IIv9SYipC3yMwn3j+di1WhG1goRr3VCW
        P5cmkIKnazgNMzsqvfnWe6TVUvCuEqWD3um+ZYGPc/BpggtsnSpsmyIAX7/MCK+7
        IuH9MvimzRnSwT0LjlX7USt92bcXJvxwX8NMrlSIfASPVrcc6GxFbzodBtZPbpNE
        O0nmc2kSVca49dbX8zFc+js7wcC2h3zxcuvooAmt5gY5EDdSktMe/KXh2dnda38f
        ZJnxrIA5yatRhvvg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 386d45d0 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 23 Mar 2020 06:46:24 +0000 (UTC)
Received: by mail-il1-f180.google.com with SMTP id a6so12115110ilc.4;
        Sun, 22 Mar 2020 23:53:21 -0700 (PDT)
X-Gm-Message-State: ANhLgQ0yBy7JeiyoYgx/saz1H31ggZeKBarL+VktwiAitKFsEKhxQbL/
        Q/59bFvUpjwpWqY1unhQXXdEgIaCuSEVSMI7a98=
X-Google-Smtp-Source: ADFU+vvErpWTeF+7DC+qPRKivjaXJFbfQ/Ox9xb4I/r/H5QniD3d2icAJTBOpd6e052DbBZKVfb+zvNoYRMiCNhl/jc=
X-Received: by 2002:a92:cece:: with SMTP id z14mr11415751ilq.38.1584946400678;
 Sun, 22 Mar 2020 23:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org> <CAHmME9p=ECJ15uyPH79bF0tuzEksdxoUsjGQSyz74FfdEJxTpQ@mail.gmail.com>
 <CAHmME9q4egN7_KeYB-ZHCFPfXs-virgTv4iz9jW2SVOM7dTnLw@mail.gmail.com> <CAK7LNAR07vZFzh1Bbpq4CoJ4zmsc+p5rxpkO1Zv8QVfqhfvr2w@mail.gmail.com>
In-Reply-To: <CAK7LNAR07vZFzh1Bbpq4CoJ4zmsc+p5rxpkO1Zv8QVfqhfvr2w@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 23 Mar 2020 00:53:09 -0600
X-Gmail-Original-Message-ID: <CAHmME9qCjo4kOQM3Dw6PDjEebmb6rvXajqhK-m-=vKcHWqNhAw@mail.gmail.com>
Message-ID: <CAHmME9qCjo4kOQM3Dw6PDjEebmb6rvXajqhK-m-=vKcHWqNhAw@mail.gmail.com>
Subject: Re: [PATCH 0/7] x86: remove always-defined CONFIG_AS_* options
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

On Mon, Mar 23, 2020 at 12:36 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Hi Jason,
>
> On Mon, Mar 23, 2020 at 1:28 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Hi again,
> >
> > I've consolidated your patches and rebased mine on top, and
> > incorporated your useful binutils comments. The result lives here:
> >
> > https://git.zx2c4.com/linux-dev/log/?h=jd/kconfig-assembler-support
> >
> > I can submit all of those to the list, if you want, or maybe you can
> > just pull them out of there, include them in your v2, and put them in
> > your tree for 5.7? However you want is fine with me.
>
>
> Your series does not work correctly.
>
> I will comment why later.

Bummer, okay. Looking forward to learning what's up. Also, if some
parts of it are useful (like the resorting and organizing of
arch/x86/crypto/Makefile), feel free to cannibalize it, keeping what's
useful and discarding what's not.

Jason
