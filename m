Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550C8C54FCF
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 19:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1846D20714
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 19:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FY2Jx9nE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgCWTuP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 15:50:15 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:54011 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgCWTuP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 15:50:15 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d07cdbd7;
        Mon, 23 Mar 2020 19:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=ARsmCOiccHNPI2GJ9BGtp7i3LYY=; b=FY2Jx9
        nEsfEJLPF+tI/yEJKvvVu8yS5lCI8K8rZ8gWD4b+8uL8yaAIQhJ/EYyDsBTgkQPZ
        BpTyrg+V/0v0GRdQit67Itpr+s+hyMM+Sd8UEvSOapxyDL/ClZV/D8+q8V7c2zO0
        xw8JwrQr2W6tLdvuFZ9NXa9cxs96xzgb4sF4TyqjXpgWPF2syrfm8uDia7yzuXDO
        Yd+rx5hta/MUozntQCB4VsxSWw99vDoeZa0/RCe+tRhQ9EBr1d8puPZ6ib6dX4bZ
        OJ/rVivrJf20pJR46rpusX9J5jJk6Zkw7bl+M76d70aQ9xxuTmVKcZ9kUGk6GJ5r
        06zbLGKzsHVjedMQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 783bb53a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 23 Mar 2020 19:43:10 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id c19so15661347ioo.6;
        Mon, 23 Mar 2020 12:50:12 -0700 (PDT)
X-Gm-Message-State: ANhLgQ0mmizbXUaf9SheXk3cKAvUB3LYWlTQfVg/qiFbkri3BjSDEYAF
        +49g/k8LwpQkpFd0/RSGTt2fWshfdO5NvsK4Ymo=
X-Google-Smtp-Source: ADFU+vtbqSgGXmN8lOz/6XAXbL8GhAwjjTG6v2fKkZp23QgkzRne+YI9zK1t8WN3CztQO2PAapdtgwE0xNatsIUGuYw=
X-Received: by 2002:a5e:a50f:: with SMTP id 15mr3802700iog.67.1584993011135;
 Mon, 23 Mar 2020 12:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org> <CAHmME9p=ECJ15uyPH79bF0tuzEksdxoUsjGQSyz74FfdEJxTpQ@mail.gmail.com>
 <CAHmME9q4egN7_KeYB-ZHCFPfXs-virgTv4iz9jW2SVOM7dTnLw@mail.gmail.com>
 <CAK7LNAR07vZFzh1Bbpq4CoJ4zmsc+p5rxpkO1Zv8QVfqhfvr2w@mail.gmail.com>
 <CAHmME9qCjo4kOQM3Dw6PDjEebmb6rvXajqhK-m-=vKcHWqNhAw@mail.gmail.com> <CA+icZUUjP7e2zgrVCFenO_YJfpcOQWV++kuU5UWGKN_5udZXSw@mail.gmail.com>
In-Reply-To: <CA+icZUUjP7e2zgrVCFenO_YJfpcOQWV++kuU5UWGKN_5udZXSw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 23 Mar 2020 13:50:00 -0600
X-Gmail-Original-Message-ID: <CAHmME9quSMLwLacntdhvLKVDVtg6QVGhOQxADzz_4kVZYOJxNA@mail.gmail.com>
Message-ID: <CAHmME9quSMLwLacntdhvLKVDVtg6QVGhOQxADzz_4kVZYOJxNA@mail.gmail.com>
Subject: Re: [PATCH 0/7] x86: remove always-defined CONFIG_AS_* options
To:     sedat.dilek@gmail.com
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

On Mon, Mar 23, 2020 at 3:53 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> Hi Jason,
> I have not checked your Kconfig changes are really working, especially
> I looked at [2] and comment on this.
>
> I would have expected your arch/x86/Kconfig.assembler file as
> arch/x86/crypto/Kconfig (source include needs to be adapted in
> arch/x86/Kconfig).

CONFIG_AS_* is required for more than just the crypto.

> What about a commit subject like "x86: crypto: Probe assembler options
> via Kconfig instead of makefile"?

Thanks. Will fix silly verbiage and update branch.

Jason
