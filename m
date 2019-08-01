Return-Path: <SRS0=q4N3=V5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42845C19759
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 06:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13F23206A2
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 06:04:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U3srDwm+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfHAGEZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Aug 2019 02:04:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36959 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfHAGEY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Aug 2019 02:04:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so61957838wme.2
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jul 2019 23:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZX8DEZG5Ea4sWFl/9jg9pO3wxEnjlg0LPax30I/HuEI=;
        b=U3srDwm+9wseLkx5qtt3lUz/lvVsvqnqihuUwsbeXKkBgKpmgXujCZ4DbQH7AOaolj
         b/xl/C0xgW1JTEIyvb3KdYWOGmXBTT9QoIou15Q6uOIkDObjSIEHmxuFIim03SEHLMk4
         h984h9UQiyaxRtRWZ+J7g9vIBQLhFLDIdcescwEa4ySEzMXXC7ut/L2eFvD4t9UOlpPJ
         DDPTTzxt+pxQcNp3V6t1xROnwsnYiB/YJO9SpXNnL6olRO9ZJPsYYOzIOeVg1IbXlxix
         GOLbXj/l4mX0xpkrR7u2li4dyEz+eHUr/K5ByllfSMZZKMDEYLQSU4D4dCHlnz/RZsTi
         N9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZX8DEZG5Ea4sWFl/9jg9pO3wxEnjlg0LPax30I/HuEI=;
        b=EfpDUuixWRcfnLtTQHMF9KJKP6bE1v3sGh/7zy4g8QW9txgNCjjdS7hTbkl6n88hbV
         Mrl4cmsxVQQuCwvgMpKy1HXRPcIzbc2uv5wVUrroUtcpFcwqTXgXt7jRLGvsmIwDsCKU
         d+jC70s7SqSb68JF2jj8dk3ym1wzm3lVJUzazrljRJXcO1IPeNE7Z8D3Q+j4PUGg2STy
         v3Rrg7kJkGsR6gZ/W3bK/LZw0RejjEv7cjxkNteJjDqiAnXMlog5njp7vFjSxrNs2TyH
         l+kVlg3CTyJUTTUlxdhLp0eST2vq1EqqF/esEAzf7j7l4plc4gmybyhnlyZcglbOMhrF
         864w==
X-Gm-Message-State: APjAAAXXIsVtNKOxNc4YUkZCBEdy4LA0dGS8lZM/9I0jLqcKahN6EUPP
        H0m+8FEbY/6UkDMyUZ8UxJ/GMgC7ZWU+kJK0yhFZwg==
X-Google-Smtp-Source: APXvYqz7Hx5Vl5ToMrMxE/l4VfUQcmbVYx2Oqw/jQf6dLJG1mYM9y8hd9gXbwqDQtby/tqAgS7dZqRzp/ZuqN9aCduY=
X-Received: by 2002:a05:600c:20c1:: with SMTP id y1mr117636636wmm.10.1564639462519;
 Wed, 31 Jul 2019 23:04:22 -0700 (PDT)
MIME-Version: 1.0
References: <13353.1564635114@turing-police> <CAKv+Gu8EF3R05hLWHh7mgbgkUyzBwELctdVvSFMq+6Crw6Tf4A@mail.gmail.com>
 <32521.1564638419@turing-police>
In-Reply-To: <32521.1564638419@turing-police>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 1 Aug 2019 09:04:11 +0300
Message-ID: <CAKv+Gu_zEO75s6o8bv4TXPxibSH-dCe-V46AYjL-dOEAvpQaqw@mail.gmail.com>
Subject: Re: [PATCH] linux-next 20190731 - aegis128-core.c fails to build
To:     =?UTF-8?Q?Valdis_Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 1 Aug 2019 at 08:47, Valdis Kl=C4=93tnieks <valdis.kletnieks@vt.edu=
> wrote:
>
> On Thu, 01 Aug 2019 08:01:54 +0300, Ard Biesheuvel said:
>
> > > ERROR: "crypto_aegis128_decrypt_chunk_simd" [crypto/aegis128.ko] unde=
fined!
> > > ERROR: "crypto_aegis128_update_simd" [crypto/aegis128.ko] undefined!
> > > ERROR: "crypto_aegis128_encrypt_chunk_simd" [crypto/aegis128.ko] unde=
fined!
> > > make[1]: *** [scripts/Makefile.modpost:105: modules-modpost] Error 1
> > > make: *** [Makefile:1299: modules] Error 2
>
> > Which compiler version are you using? All references to the
> > crypt_aegis128_xx_simd() routines should disappear if
> > CONFIG_CRYPTO_AEGIS128_SIMD is not set (in which case have_simd will
> > always be false and so the compiler should optimize away those calls).
>
> gcc 9.1.1 obviously doesn't think it can be optimized away. Apparently, i=
t's
> not smart enough to realize that nothing sets have_simd in any of the fun=
ctions
> and therefor it's guaranteed to be zero, and  it can do dead code optimiz=
ation
> based on that.
>
> Now, if we had something like:
>
> #ifdef CONFIG_CRYPTO_AEGIS_128_SIMD
> static bool have_simd;
> #else
> #define have_simd (0)
> #endif
>
> then that should be enough to tell the compiler it can optimize it away, =
except
> that then runs into problems here:
>
>         if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD))
>                 have_simd =3D crypto_aegis128_have_simd();
>
> because it will whine about the lack of an lvalue before it optimizes the=
 assignment away...

The fact that crypto_aegis128_have_simd() does get optimized away, but
crypto_aegis128_update_simd() doesn't (which is only called directly
and not via a function pointer like the other two routines) makes me
suspicious that this is some pathology in the compiler. Is this a
distro build of gcc? Also, which architecture are you compiling for?
