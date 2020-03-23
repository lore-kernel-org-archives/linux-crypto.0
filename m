Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92EF7C10F26
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 04:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 600F220719
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 04:28:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="O5cmhuB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgCWE2W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 00:28:22 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:35081 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgCWE2V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 00:28:21 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 8be5a25f;
        Mon, 23 Mar 2020 04:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=rPcJKtmVmgC2yVAkJsVpmVlhlVE=; b=O5cmhu
        B3qaC6X36Tz3r3UfL8jvz0kuXAsrueNt1JVuQOxY1KPmNLiCxwoTf6jvBpjI+ARb
        sSckkRtvMFhUh9O0TkNesQGppxzi5XQpj0OXzwIczPSkg9QCupLVpLfiFG9qocVT
        XSo2VoTUGVQY8SwqUTQKmdWSIqE250JUfDIzMOjhVwhtRr/Z8HbSMCV1UPd3Fw53
        ZJlkKrJmpuBt8FBZoeTKOg7zrNRZgXiaMXVw+1t+yq7x6R15cpn1Wtzf75awLjZL
        8G+lsgfXwc8CszycBdPTYExheIdvBr0C2kVP8pXCNvQK60D2X202NbUlR1q7edJh
        ijkkaLXp6sFp8Xkg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9464c482 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 23 Mar 2020 04:21:21 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id c19so12772691ioo.6;
        Sun, 22 Mar 2020 21:28:18 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3B7nb/u9z8S7suA73Tg1QjORtEGwgTYWT3xjyqf+ViD5Rw1swO
        irt5m0Puch09KKdMYgUg8i+YgA/kVQhxb49CiXE=
X-Google-Smtp-Source: ADFU+vvpUXvu/rKVGq2dH+x983lMWOfilzM5Msb6ti3npc9A1Ta3Erhx9TQ3udPp8SFJeKboX0RRMXBJ1HzMKdvrooQ=
X-Received: by 2002:a02:cbd0:: with SMTP id u16mr17792844jaq.36.1584937696838;
 Sun, 22 Mar 2020 21:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org> <CAHmME9p=ECJ15uyPH79bF0tuzEksdxoUsjGQSyz74FfdEJxTpQ@mail.gmail.com>
In-Reply-To: <CAHmME9p=ECJ15uyPH79bF0tuzEksdxoUsjGQSyz74FfdEJxTpQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 22 Mar 2020 22:28:06 -0600
X-Gmail-Original-Message-ID: <CAHmME9q4egN7_KeYB-ZHCFPfXs-virgTv4iz9jW2SVOM7dTnLw@mail.gmail.com>
Message-ID: <CAHmME9q4egN7_KeYB-ZHCFPfXs-virgTv4iz9jW2SVOM7dTnLw@mail.gmail.com>
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
        clang-built-linux@googlegroups.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi again,

I've consolidated your patches and rebased mine on top, and
incorporated your useful binutils comments. The result lives here:

https://git.zx2c4.com/linux-dev/log/?h=jd/kconfig-assembler-support

I can submit all of those to the list, if you want, or maybe you can
just pull them out of there, include them in your v2, and put them in
your tree for 5.7? However you want is fine with me.

Jason
