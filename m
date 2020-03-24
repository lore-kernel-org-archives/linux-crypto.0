Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91023C4332B
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 08:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BAC420786
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 08:46:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iB9wbzaX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgCXIqm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Mar 2020 04:46:42 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51766 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgCXIqm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Mar 2020 04:46:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id c187so2251533wme.1;
        Tue, 24 Mar 2020 01:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=vqE7J9avKRSB75CS08tA1XMoBisXuxlVqJUICDm2RMc=;
        b=iB9wbzaXPETI8Jb4Po7UfmfNXF6g7zdHRjpkGrdg+WTzOJRbBAx2+GP7gcOQS/Vzs5
         +C+Pi9XP8VtWYdqYg/gHoDei+hXFTHyCSbL6eII5G6A0LIpmETLm/pG87ekJ+EINYE/E
         zrA73dd/jf7HTdinDv4q3tlxozFIwRNicWm0FXioCDqu3YW3mMjfJWvdJex1KIZR6qMI
         kI3MToyfz87GWNGZh4U8kB2iw5xIcV/A+UJBA2c0mCbvQvW0krQqvMwjkdSDvNaoQZF7
         UtBwA1IiMoQOjNUx3EA1ajUgOr6Pnnzk0A0Fic8eL2OYmtc7y0mFCxEkRbvvr78mYnyq
         m8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=vqE7J9avKRSB75CS08tA1XMoBisXuxlVqJUICDm2RMc=;
        b=PO4Rp3vDhsPNw2QoujVgXZc63iRF/2LPh4ENh9nERtiqAahtuK1O1LHAg+K3lpIQud
         tBNJDMabDCTooRq6wEzFzu6BSUX3RMrIO6keXpYr4QxDRnIp59jYf+ggAbWDkc5Y+TBp
         7jZl5sMx12RuIo72PlwXNxYvOK7Idoj0XrN6ppHrslA/PaSHBzO8kNuyB2204Bf0886x
         f/B3BIYA1wvmKf5cZ13y77p8VYs3vLpe2/oLe6q+Jk7e64O9dxvmWOtNJV+2DCIQd0Xc
         xQL9TRWpYCF4KrS7oqN5T8PrATj48I36wFDe8dPMv0cBR45LIrHHg6qxO1te+kO6tbJt
         +w/g==
X-Gm-Message-State: ANhLgQ02cnskAVs7lWCMOslMEf7r1sJH3fkeSC/aMLfZHTKg6IFRgv6K
        MUt0Ifry0fkZf9Uf1pzSUgt64wsMqidBhP5fuWKo8CVWgHI=
X-Google-Smtp-Source: ADFU+vu3SGbdVgIeiQ031Be5sYxOpTkuy1gw7+8uJLrstgU/URuYpZnDw+A4NvU7i0GqhuMsIPrA0BEnrww0jHe9CBY=
X-Received: by 2002:a1c:41d6:: with SMTP id o205mr4183235wma.122.1585039600829;
 Tue, 24 Mar 2020 01:46:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org> <CAHmME9p=ECJ15uyPH79bF0tuzEksdxoUsjGQSyz74FfdEJxTpQ@mail.gmail.com>
 <CAHmME9q4egN7_KeYB-ZHCFPfXs-virgTv4iz9jW2SVOM7dTnLw@mail.gmail.com>
 <CAK7LNAR07vZFzh1Bbpq4CoJ4zmsc+p5rxpkO1Zv8QVfqhfvr2w@mail.gmail.com>
 <CAHmME9qCjo4kOQM3Dw6PDjEebmb6rvXajqhK-m-=vKcHWqNhAw@mail.gmail.com>
 <CA+icZUUjP7e2zgrVCFenO_YJfpcOQWV++kuU5UWGKN_5udZXSw@mail.gmail.com> <CAHmME9quSMLwLacntdhvLKVDVtg6QVGhOQxADzz_4kVZYOJxNA@mail.gmail.com>
In-Reply-To: <CAHmME9quSMLwLacntdhvLKVDVtg6QVGhOQxADzz_4kVZYOJxNA@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 24 Mar 2020 09:46:29 +0100
Message-ID: <CA+icZUVCftYBYzxe+YJkN1WRGX+nQkHVaFxvW-S64k6WtdB64g@mail.gmail.com>
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

On Mon, Mar 23, 2020 at 8:50 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> > I would have expected your arch/x86/Kconfig.assembler file as
> > arch/x86/crypto/Kconfig (source include needs to be adapted in
> > arch/x86/Kconfig).
>
> CONFIG_AS_* is required for more than just the crypto.
>

OK. I was not aware of this.

> > What about a commit subject like "x86: crypto: Probe assembler options
> > via Kconfig instead of makefile"?
>
> Thanks. Will fix silly verbiage and update branch.
>

Just looked to what I see new in [0].

Would you mind to add the patch

   "Documentation/changes: Raise minimum supported binutils version to 2.23"

from [1] to your series, please?

For the meantime and clarification - you can drop it later (with
adding Link-tag to [1]) when it landed in tip Git [2] where I am not
seeing it.

Thanks for taking care to you an Masah*e*ro :-).

- Sedat -

[0] https://git.zx2c4.com/linux-dev/log/?h=jd/kconfig-assembler-support
[1] https://lore.kernel.org/lkml/20200316160259.GN26126@zn.tnic/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/
