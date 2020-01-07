Return-Path: <SRS0=chSI=24=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA684C282DD
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 20:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EAC42077B
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 20:26:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="potrUYcY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbgAGU0g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jan 2020 15:26:36 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:58977 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgAGU0f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jan 2020 15:26:35 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0543f1d2;
        Tue, 7 Jan 2020 19:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=SF2YH1/XcFCc2KICEQEdNyxtQ/4=; b=potrUY
        cYc0INRLt1UQpOT+tflIdYmfRQUpqV0aEyc2mdguvNrEmgbgouPIqP9Ir+GQYOyw
        1ynogF16EEP/vLiUaGmrlzw5hjhttdvkV7mZlXSeRcjyeAyeq+A72sZ5Yg3hWd4t
        EzUHh0mJv7Y3B6JfPOY+KT8MPTYCasgDBfXNIVMAxpnN/85zF8jepuMdW9ukUt9C
        LaJLvFrJ1eRESdFINIeuKFNKmAVNmZ+2C+S7RVHwaHVllJvuKJKGc1NgJxEbeyTU
        REScLAiV1zaRZZd9lekRJc2wjtF7ViDoAB3V2MVfPu2+lfdz2kjvLttszMXGUB4L
        0pw5+3Psr6W2kXfg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id aae760f0 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 7 Jan 2020 19:27:21 +0000 (UTC)
Received: by mail-oi1-x236.google.com with SMTP id i1so610038oie.8;
        Tue, 07 Jan 2020 12:26:31 -0800 (PST)
X-Gm-Message-State: APjAAAUzcuo1tiDOIHyiMB/gOtBB0QkGIJdgSmYGEyuRpMm6AAY+xyYG
        iXEYPiyq+GIC6Au8Gfiyjn9K/FVn/WZoQeoCuSQ=
X-Google-Smtp-Source: APXvYqyug9RB3w6WVZGIbyrZdMVtg+VyewWxlcNicyva/YUGU9Mjf8+VEkEsiVgp4/YgWGPf8IAdQRchEgtb2dz7gQQ=
X-Received: by 2002:aca:39d6:: with SMTP id g205mr186294oia.122.1578428490343;
 Tue, 07 Jan 2020 12:21:30 -0800 (PST)
MIME-Version: 1.0
References: <20200107201327.3863345-1-arnd@arndb.de>
In-Reply-To: <20200107201327.3863345-1-arnd@arndb.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 7 Jan 2020 15:21:19 -0500
X-Gmail-Original-Message-ID: <CAHmME9rnevSYwWvfyv8LRitVo-=KVpPCoGLwYxo62mwnW0vjiQ@mail.gmail.com>
Message-ID: <CAHmME9rnevSYwWvfyv8LRitVo-=KVpPCoGLwYxo62mwnW0vjiQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: curve25519 - Work around link failure
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andy Polyakov <appro@cryptogams.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Arnd,

Another solution to this was already posted:

https://lore.kernel.org/linux-crypto/CAHmME9pg4KWw1zNVybxn1WLGusyGCjqeAHLQXY=Dr4zznUM82g@mail.gmail.com/T/#t

That might be slightly cleaner, though yours is shorter. I'm alright
with either one.

Jason
