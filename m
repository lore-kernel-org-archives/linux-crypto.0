Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E48C7C10F26
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 06:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B14FD206F8
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 06:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584945388;
	bh=Csqr77kgWxM20+oOpjO3J6BIvWyQRvuVQjRvzhXhAME=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ASIcUZUk2E2GjU7K6PSLo7qa47YNh1Bfukp2J320STpWJqRCR/gcvtlj4oGY1lV/N
	 moKKn9DUeWNTz3S9vvFdCCYckZ61MCRRhC339UlnNOUBjZVl67UG4ttOqUTNSZvmf0
	 uXZBpQ//zD82O+q3/yqQFhq/03kSPQ9NfozrG7y0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgCWGg2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 02:36:28 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:18538 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgCWGg2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 02:36:28 -0400
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 02N6aLFm018207;
        Mon, 23 Mar 2020 15:36:22 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 02N6aLFm018207
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1584945382;
        bh=shlaUHJ6YdG7mbEpHkN6/tISt8RC9LOOVikM/qp/dxc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wKnDwDhJFc8Y/ng9LZpTEIfoJiMcccezrUcXOqoOU+qE11X2LDCeehocKauCJbv3x
         cH+mCv+WsKtEX17ZCxJzOF1lQAciNfXPq/G3TPHalSLxt2xFQJynciyBPuL0cH9Fz8
         /6jn+rYSeUQ3CdRfRg5d7RZtfbVrvfOoM1q8RIJZuY/xxnALydPlP8xX1u1tN5eZXq
         bJOIlDdkvpEChWDcpMZVxfWqbVzaDyC3vXUtC+8pthTk/Wrdng+VSUp8SGgylt6NSf
         Kh1mnA3tQr9PXHVeruWGQRV30/8dhaHg4I7aw6qQOncGG4lnMUmjzvTjF/qfaMPNzC
         ZdLNkHCKYVpJQ==
X-Nifty-SrcIP: [209.85.217.52]
Received: by mail-vs1-f52.google.com with SMTP id e138so8016291vsc.11;
        Sun, 22 Mar 2020 23:36:22 -0700 (PDT)
X-Gm-Message-State: ANhLgQ2EJDheWMKgQ0QryFwTWbYtmEgscJAhgVCI9NBxUXLVVxwVjfFg
        P8KSDY/1rrb5D8xRTXSjWFL8iyvJ+cvPeglk7mI=
X-Google-Smtp-Source: ADFU+vsHb3DgDpRsXUG7d3UafC+Qn78HHllA0iW1XqDKXH45rCZbX13k7qZAtpwQCFWBh+DyDZFZIOxf9erXQX2+/NU=
X-Received: by 2002:a67:2d55:: with SMTP id t82mr14012597vst.215.1584945381312;
 Sun, 22 Mar 2020 23:36:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org> <CAHmME9p=ECJ15uyPH79bF0tuzEksdxoUsjGQSyz74FfdEJxTpQ@mail.gmail.com>
 <CAHmME9q4egN7_KeYB-ZHCFPfXs-virgTv4iz9jW2SVOM7dTnLw@mail.gmail.com>
In-Reply-To: <CAHmME9q4egN7_KeYB-ZHCFPfXs-virgTv4iz9jW2SVOM7dTnLw@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 23 Mar 2020 15:35:45 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR07vZFzh1Bbpq4CoJ4zmsc+p5rxpkO1Zv8QVfqhfvr2w@mail.gmail.com>
Message-ID: <CAK7LNAR07vZFzh1Bbpq4CoJ4zmsc+p5rxpkO1Zv8QVfqhfvr2w@mail.gmail.com>
Subject: Re: [PATCH 0/7] x86: remove always-defined CONFIG_AS_* options
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
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

Hi Jason,

On Mon, Mar 23, 2020 at 1:28 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi again,
>
> I've consolidated your patches and rebased mine on top, and
> incorporated your useful binutils comments. The result lives here:
>
> https://git.zx2c4.com/linux-dev/log/?h=jd/kconfig-assembler-support
>
> I can submit all of those to the list, if you want, or maybe you can
> just pull them out of there, include them in your v2, and put them in
> your tree for 5.7? However you want is fine with me.


Your series does not work correctly.

I will comment why later.




-- 
Best Regards
Masahiro Yamada
