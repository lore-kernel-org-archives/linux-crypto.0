Return-Path: <SRS0=5TcX=2G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1887FC43603
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Dec 2019 09:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6129206B7
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Dec 2019 09:49:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Y/R7G24x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfLPJtz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Dec 2019 04:49:55 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:59731 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbfLPJtz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Dec 2019 04:49:55 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ac404c7a
        for <linux-crypto@vger.kernel.org>;
        Mon, 16 Dec 2019 08:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Fe4LA0XNDI4aDHTNME44XXqOQKA=; b=Y/R7G2
        4xs1XI+FqJgrWFgTTc6qAinYyfOsJtx2E6REPXENCPbu2CNJAEe8vCuKUHu+FTSU
        iY5rqjVvaM1QPSdmgCkd/e7Es4RWbyIXPJgmp69Lfl72eYAqvJxXpRw+9gwwRW5Q
        2A7QVtEDj4fz23DKvHZY5Tp3eWOBs8vHlHGikntIn/0feYgf/Jsn+mUAziqPni6W
        3lC8AVXIwlAkmN+uVvjQ9tH3b7Lv6HEMz/lzi2Ft87udn3DEqcbJtp561/2gGElR
        KnRzAxv85hIZZMvcIofeDYUGVoNhXKdMTogGYyKeX+Qfn93wpP1bpRHxPKLVOYIq
        l9Ci77HEOWY8UXPA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8c6d3e75 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 16 Dec 2019 08:53:35 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id i15so8463560oto.7
        for <linux-crypto@vger.kernel.org>; Mon, 16 Dec 2019 01:49:53 -0800 (PST)
X-Gm-Message-State: APjAAAUUVXIkhSsYwxlsVAApkJdjACi9JMdJ8wWNjeuNRKny3KPmckti
        3c1PqMoCeYDz7XMOhcQ9HJ30QffjYPjkKO0+2DM=
X-Google-Smtp-Source: APXvYqxgiArG5oKkvYS5n4Kwln06HTaLlqSMn+puHJXJELxbjOgpjNsE44NrtajU50Yr/5Apbe+TqrNRk6LatXfPJZE=
X-Received: by 2002:a05:6830:1141:: with SMTP id x1mr31528414otq.120.1576489792485;
 Mon, 16 Dec 2019 01:49:52 -0800 (PST)
MIME-Version: 1.0
References: <20191215204631.142024-1-Jason@zx2c4.com> <20191215204631.142024-3-Jason@zx2c4.com>
 <20191216060026.GC908@sol.localdomain>
In-Reply-To: <20191216060026.GC908@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 16 Dec 2019 10:49:41 +0100
X-Gmail-Original-Message-ID: <CAHmME9rqYVw0O9KiES5Pzx1abjy+v1HHgxpOG3VOydJ5kKZdvg@mail.gmail.com>
Message-ID: <CAHmME9rqYVw0O9KiES5Pzx1abjy+v1HHgxpOG3VOydJ5kKZdvg@mail.gmail.com>
Subject: Re: [PATCH crypto-next v5 2/3] crypto: x86_64/poly1305 - add faster implementations
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Polyakov <appro@openssl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 16, 2019 at 7:00 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sun, Dec 15, 2019 at 09:46:30PM +0100, Jason A. Donenfeld wrote:
> > diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> > index 958440eae27e..6982a2f8863f 100644
> > --- a/arch/x86/crypto/Makefile
> > +++ b/arch/x86/crypto/Makefile
> > @@ -73,6 +73,10 @@ aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
> >
> >  nhpoly1305-sse2-y := nh-sse2-x86_64.o nhpoly1305-sse2-glue.o
> >  blake2s-x86_64-y := blake2s-core.o blake2s-glue.o
> > +poly1305-x86_64-y := poly1305-x86_64.o poly1305_glue.o
> > +ifneq ($(CONFIG_CRYPTO_POLY1305_X86_64),)
> > +targets += poly1305-x86_64.S
> > +endif
>
> poly1305-x86_64.S is a generated file, so it needs to be listed in a gitignore
> file arch/x86/crypto/.gitignore.

Ack. I made the change and put it in for-cryptodev-2.6:

https://git.zx2c4.com/linux-dev/log/?h=for-cryptodev-2.6
