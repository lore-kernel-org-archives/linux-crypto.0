Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 352A3C4332B
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 09:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A33F2072D
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 09:53:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EI2zKktS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgCWJxE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 05:53:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54624 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727752AbgCWJxE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 05:53:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id c81so3434307wmd.4;
        Mon, 23 Mar 2020 02:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Z+6XVznaFEON0f8iN5LEjyjFaUvEkyzSk7nWE3yhXyU=;
        b=EI2zKktST7siFx8D5JHNrQES9a9jniXP+LT73GIPnwoUwynj2pC0K7zDBxeclTGJPd
         Ph8+H9FavfKjZP6pI8Hi0CmWQEL/MPftc/U2L3C+p18DIQ1+iyhHT4+j6HbifIiMHX4F
         n9xX9O3Ezwi5B8b2ghTMjvwkvsjFrGnSpiA6gm5/aPNE4kX8Si6TOWD2ZmMXiVdcl1FB
         caSBR5D07nYH/Z1u6Z/lXFZqJ4w0hUeKJFKJhJV+eaKcz636ZIIYt9GvA8QRfjySGO19
         hvbudMx9EzHxSiUAMkWYdOU9Yknh6DWpviuJJf1O5rQKGe16OB2+9ImoD5heJMyqASA6
         PwKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Z+6XVznaFEON0f8iN5LEjyjFaUvEkyzSk7nWE3yhXyU=;
        b=lAnBvXtB2dLALA0XbKxiW/Y4L/KIoHmx8ajbyvwnZMyO9Zb8JexmoXUsnVqLgLmzoc
         Y8iHRNPY/fGZQkagnz6hQpWgCt1WO2AElbMWgZdVfZY7mAxJ+jehXlXuqzG5C3KNAT2d
         as3LrYu/zE4x+I/n6D+RVTTDjhWD0zNGtdZJEjuQb1Yspsi6SeA7bpVqKFgfKM84k4Gr
         G1Ni9r4W55cpOOv6tuVN/6LlXkJq9FsKk5Mm9ayI/Q0xTC4ct++KJzLkUJz/5BBBlIRp
         cEJSEhRwPBJitRTRv69gSeWJdETL4pwCQATOWSmMzNZLf1Gcj9eB2X1xv5+Hhxr4tdJf
         Exqg==
X-Gm-Message-State: ANhLgQ2PWHTvMkORYZeE6iXvW/yfur4Rw74xXZEe9VzA30KcyROmAlm6
        /iWb3wlcrXuDKOACUDTZoRRHsbructhBnJ+O67c=
X-Google-Smtp-Source: ADFU+vuntAywRjz8eiWGZawNNazTzcPLdLf5SbEvx4DOHezzFPANFDCW/hQE4Lrr5sX/Nd4jh6OidJJxI8X1Nyv+Bq0=
X-Received: by 2002:a1c:4e0f:: with SMTP id g15mr12959874wmh.163.1584957182077;
 Mon, 23 Mar 2020 02:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org> <CAHmME9p=ECJ15uyPH79bF0tuzEksdxoUsjGQSyz74FfdEJxTpQ@mail.gmail.com>
 <CAHmME9q4egN7_KeYB-ZHCFPfXs-virgTv4iz9jW2SVOM7dTnLw@mail.gmail.com>
 <CAK7LNAR07vZFzh1Bbpq4CoJ4zmsc+p5rxpkO1Zv8QVfqhfvr2w@mail.gmail.com> <CAHmME9qCjo4kOQM3Dw6PDjEebmb6rvXajqhK-m-=vKcHWqNhAw@mail.gmail.com>
In-Reply-To: <CAHmME9qCjo4kOQM3Dw6PDjEebmb6rvXajqhK-m-=vKcHWqNhAw@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 23 Mar 2020 10:52:50 +0100
Message-ID: <CA+icZUUjP7e2zgrVCFenO_YJfpcOQWV++kuU5UWGKN_5udZXSw@mail.gmail.com>
Subject: Re: [PATCH 0/7] x86: remove always-defined CONFIG_AS_* options
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
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

On Mon, Mar 23, 2020 at 7:53 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Mon, Mar 23, 2020 at 12:36 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> > Hi Jason,
> >
> > On Mon, Mar 23, 2020 at 1:28 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > Hi again,
> > >
> > > I've consolidated your patches and rebased mine on top, and
> > > incorporated your useful binutils comments. The result lives here:
> > >
> > > https://git.zx2c4.com/linux-dev/log/?h=jd/kconfig-assembler-support
> > >
> > > I can submit all of those to the list, if you want, or maybe you can
> > > just pull them out of there, include them in your v2, and put them in
> > > your tree for 5.7? However you want is fine with me.
> >
> >
> > Your series does not work correctly.
> >
> > I will comment why later.
>
> Bummer, okay. Looking forward to learning what's up. Also, if some
> parts of it are useful (like the resorting and organizing of
> arch/x86/crypto/Makefile), feel free to cannibalize it, keeping what's
> useful and discarding what's not.
>

Hi Jason,

I have your patches on my radar.

I have not checked your Kconfig changes are really working, especially
I looked at [2] and comment on this.

I would have expected your arch/x86/Kconfig.assembler file as
arch/x86/crypto/Kconfig (source include needs to be adapted in
arch/x86/Kconfig).
What about a commit subject like "x86: crypto: Probe assembler options
via Kconfig instead of makefile"?
Not sure if the commit message needs some massage?

Maybe this is all irrelevant when Masahiro has commented.

Thanks.

Regards,
- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/log/?h=jd/kconfig-assembler-support
[2] https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/commit/?h=jd/kconfig-assembler-support&id=ac483ff6fb4c785cd0b10d9756b71696829cd117
