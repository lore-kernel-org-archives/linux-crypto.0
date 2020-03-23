Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB07C4332B
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 22:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 273AB20753
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 22:11:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Bn4ZMdB1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgCWWLE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 18:11:04 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:48721 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgCWWLE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 18:11:04 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9c3939ec;
        Mon, 23 Mar 2020 22:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=du1Xi2cJwvyAEA0LnnfUIYXiBFE=; b=Bn4ZMd
        B1myZuRZfOPybIza1CaPghEjwXkG/Vq+8+3muxbgDuMvoQbKwb0QMxkCnmLO2aKG
        6QmvTgmlJ9vt1WI4odD9mueaXwe5aGGKPwmgNF7pA5CMQq1Yrrdxuv77KutE4nu4
        2D6C5i5ntwp2kJCfWyx8sRcB49zDs8dMEBecVtSh/AyMiUTNz79GgbJ9RugIUJoM
        dcgkHuH5oZ74lXY5ZmvtJQYL7Ry0KkMkOKnambR7tKUQ4wx3WyWV2Ui+wDhv3nLe
        LGw6CYXp2grS9dQdVfMeJwWi8TI8ZHA1vPJd/z7UPBw2AhYlQAtjnAGyyB4GCqjd
        KTyR7Ec14x4WSkLg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 97ca2ba1 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 23 Mar 2020 22:03:59 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id f16so5509154ilj.9;
        Mon, 23 Mar 2020 15:11:01 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3VAf8AngCaPI44pBgJZTf+G6+QfuH3yiqx8bjnZtwck8PmIs6t
        iZr1xCUnJrTETnv6Y1enL1UgmSX+70arG+QcFPE=
X-Google-Smtp-Source: ADFU+vtKxW8+wIo2evA9dEZmdKot1mmMyNY7t0WeeWDY74vjHLbsz9Exe56Jz1LOd3H5thx7nTAdiENmTb5nMZ15f38=
X-Received: by 2002:a92:cd4e:: with SMTP id v14mr24213070ilq.231.1585001460661;
 Mon, 23 Mar 2020 15:11:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org> <CAHmME9p=ECJ15uyPH79bF0tuzEksdxoUsjGQSyz74FfdEJxTpQ@mail.gmail.com>
 <CAHmME9q4egN7_KeYB-ZHCFPfXs-virgTv4iz9jW2SVOM7dTnLw@mail.gmail.com>
 <CAK7LNAR07vZFzh1Bbpq4CoJ4zmsc+p5rxpkO1Zv8QVfqhfvr2w@mail.gmail.com>
 <CAHmME9qCjo4kOQM3Dw6PDjEebmb6rvXajqhK-m-=vKcHWqNhAw@mail.gmail.com> <CAK7LNAQgKgKgOpQ2bgHrB5h=LTffs2khbYRrBhrxFM44gS88KQ@mail.gmail.com>
In-Reply-To: <CAK7LNAQgKgKgOpQ2bgHrB5h=LTffs2khbYRrBhrxFM44gS88KQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 23 Mar 2020 16:10:49 -0600
X-Gmail-Original-Message-ID: <CAHmME9rgNB5L_x9rRcW4RDHJnPuAZMUtJ+7HNK3302nwb9Y0OQ@mail.gmail.com>
Message-ID: <CAHmME9rgNB5L_x9rRcW4RDHJnPuAZMUtJ+7HNK3302nwb9Y0OQ@mail.gmail.com>
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

On Mon, Mar 23, 2020 at 4:04 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Hi Jason,
>
> On Mon, Mar 23, 2020 at 3:53 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Mon, Mar 23, 2020 at 12:36 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > >
> > > Hi Jason,
> > >
> > > On Mon, Mar 23, 2020 at 1:28 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > >
> > > > Hi again,
> > > >
> > > > I've consolidated your patches and rebased mine on top, and
> > > > incorporated your useful binutils comments. The result lives here:
> > > >
> > > > https://git.zx2c4.com/linux-dev/log/?h=jd/kconfig-assembler-support
> > > >
> > > > I can submit all of those to the list, if you want, or maybe you can
> > > > just pull them out of there, include them in your v2, and put them in
> > > > your tree for 5.7? However you want is fine with me.
> > >
> > >
> > > Your series does not work correctly.
> > >
> > > I will comment why later.
> >
> > Bummer, okay. Looking forward to learning what's up. Also, if some
> > parts of it are useful (like the resorting and organizing of
> > arch/x86/crypto/Makefile), feel free to cannibalize it, keeping what's
> > useful and discarding what's not.
> >
>
>
> The answer is mostly in my previous reply to Linus:
> https://lkml.org/lkml/2020/3/13/27
>
>
> I think this problem would happen
> for CONFIG_AS_CFI and CONFIG_AS_ADX
> since the register in instruction code
> is machine-bit dependent.
>
> The former is OK wince we are planning to
> remove it.
>
> We need to handle -m64 for the latter.
> Otherwise, a problem like commit
> 3a7c733165a4799fa1 would happen.
>
>
> So, I think we should merge this
> https://lore.kernel.org/patchwork/patch/1214332/
> then, fix-up CONFIG_AS_ADX on top of it.
>
> (Or, if we do not need to rush,
> we can delete CONFIG_AS_ADX entirely after
> we bump the binutils version to 2.23)

Oh, gotcha. The easiest thing to do for that case would actually be
passing 32-bit registers to adox, which are valid. I'll fix that up in
my tree.

And then indeed it looks like the binutils bump is coming anyway for 5.7.

Your flags patch looks fine and potentially useful for other things
down the line though. I suppose you had in mind something like:

def_bool $(as-instr,...,-m64) if 64BIT
def_bool $(as-instr,...,-m32) if !64BIT

Anyway, I'll fix up the ADX code to be biarch like the AVX test code.

Jason
