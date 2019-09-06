Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3033FC43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AD5C208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404655AbfIFSkN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 14:40:13 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44602 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404675AbfIFSkM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 14:40:12 -0400
Received: by mail-qk1-f196.google.com with SMTP id i78so6573257qke.11;
        Fri, 06 Sep 2019 11:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oUUjU8KYMc7BzEQi/4l2yuN6uGqhnfetnQPhKIRDru4=;
        b=JNS7ZuZi3k4MgV/deUR2inOJ1+vw91VWR7JrgePISkV902f0qgAiO7tFA/Us9vk+zD
         Hp0WOVFDpw7N7OaW6/YP6D/zYOtFlHyL0TWjTPMxP07NE9X8GrAQBNDsKGlSpmnwcvV8
         fWoStIuqQVGbsaLFA9BrC7Pxono3L6fWFRm7bciDcIsKRrWmJk6mAdyYffLwvvb492UB
         HYie2hxzDiEiCDHffIyaqQrL3FgkpSxh8zCIAasMZNgAOii0aBC9L8pDl6ds4MOq84oZ
         +OWKU+l+mJk74nGu6xap+WlhFyd94ssfiHaOyWKcS8kq4pS/jBiL24PE0C3KfocspLjv
         mvFQ==
X-Gm-Message-State: APjAAAXfvmxpwf9ndBq2mUjKRk6+ORg5CJUlV+666WvJgWWvsJOVZniI
        r4I3XLw+TmiW3IKrHYyls4mIzYU9FOZzsFkntFs=
X-Google-Smtp-Source: APXvYqyCqw7rYGaMP81YoI/ZO38/GgHsA863ax6/DiS+UT5bKfL8klB0skhPEiZep7cc9b5ZeTCiSGXA1nTvXmI71zw=
X-Received: by 2002:a37:4fcf:: with SMTP id d198mr10389759qkb.394.1567795211679;
 Fri, 06 Sep 2019 11:40:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190906152250.1450649-1-arnd@arndb.de> <MN2PR20MB297378A683764AF4F2171B7CCABA0@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB297378A683764AF4F2171B7CCABA0@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 6 Sep 2019 20:39:55 +0200
Message-ID: <CAK8P3a13Ebqd51SWx9svUyvFxV4MKDJKOwKEozzKyga9azBqJA@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: inside-secure - fix uninitialized-variable warning
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 6, 2019 at 6:08 PM Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:

> >
> >  config CRYPTO_DEV_SAFEXCEL
> >       tristate "Inside Secure's SafeXcel cryptographic engine driver"
> > -     depends on OF || PCI || COMPILE_TEST
> > +     depends on OF || PCI
> >
>
> This seems like it just ignores the problem by not allowing compile testing
> anymore? Somehow that does not feel right ...

No, it just ignores the uninteresting case. You can compile-test this on
any architecture by turning on OF.

> >       select CRYPTO_LIB_AES
> >       select CRYPTO_AUTHENC
> >       select CRYPTO_BLKCIPHER
> > diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-
> > secure/safexcel.c
> > index e12a2a3a5422..9c0bce77de14 100644
> > --- a/drivers/crypto/inside-secure/safexcel.c
> > +++ b/drivers/crypto/inside-secure/safexcel.c
> > @@ -938,6 +938,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
> >       struct device *dev;
> >
> >       if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
> > +#ifdef CONFIG_PCI
> >
>
> The whole point was NOT to use regular #ifdefs such that the code can
> be compile tested without needing to switch configurations.
> There is already a different solution in the works involving some empty
> inline stubs for those pci routines, please see an earlier mail by Herbert
> titled "PCI: Add stub pci_irq_vector and others".

Ah, good. That should take care of most of the problems. I think
we still need the Kconfig change, unless the safexcel_init()
function is also changed to use if(IS_ENABLED()) checks
instead of #if.

     Arnd
