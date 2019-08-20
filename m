Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7BEC3A59E
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 15:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3457022CE3
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 15:45:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XkmL6WnP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbfHTPpi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 11:45:38 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:42004 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728344AbfHTPpi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 11:45:38 -0400
Received: by mail-wr1-f54.google.com with SMTP id b16so12903424wrq.9
        for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2019 08:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=86CfnVRSUR5lU0gtFdEJI3KaYVGV/NC7wFzqBZ7PYz8=;
        b=XkmL6WnPm9Bt5A+MrIuXZtobgZwoeKtjVtXWTKwvHGqMqXpyn/FD6DH0vnZQLbELE6
         lL7H6OT3C/mNfTs+35OkVc7DFLf07JVpaeGtJ7PxKGsVykpUPqQ0VFT4ugV3OuhbDmxG
         kcjrHGGEJ1uJA3ShQmcr/thDrxfzNfRCy5M3dulkw9+uCHZ9ZhuIyLZBLEt5yOw3VlVq
         kI8y+ZbCPWBatPepM2gf5++QY70DmvcOhUZ0qXv5cTOuUmFFURUtCxAvIJwV/RvSCj0U
         hpaRVXkg31kUdvWcu02cf6Kwk99gdsN4iTFyK/PLOl7WmwRNNUriXSAFNuGNT8o9wsLK
         QqWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=86CfnVRSUR5lU0gtFdEJI3KaYVGV/NC7wFzqBZ7PYz8=;
        b=n0V/2lkmXEC9fM//OIS7852sULrl2fd5tTW207zGQ+9C0IN3pDrZ2JVUNBIcUdoNyo
         rAmmSPDbilKinpJTPNtyUa5yv+fXX2mMpzXS7okA1fvo1ogBROi5emsOQI5mSPOvFGt0
         RmUeEuRwrwIJM3oVJdF5iyEg3HNuMD8L3+U/HyiUixcg+9Um71MN0RVEhMDejsc0pagt
         ZZE1zKRbaYAFjnq8j/u7/isEmRUyJ3cZJuHBfAeFoHYcKamM16zysLLAgW4kpwA9yHW3
         C0M+F8qZpN5SpO4pzif9IMh4WsnfuKoaQs/yEakyIW0oJCvOMTUjUxdSj06usS2gAjcp
         MDaA==
X-Gm-Message-State: APjAAAULRqooJRHKsKD7BUkzzT3KYuX9wJkV3S76/O6PaacZgGPthnvY
        y2L8GnPeOiGKWQXx654BN++PfioshPgV8wj1Kv5xx918wnXl5g==
X-Google-Smtp-Source: APXvYqyspbTxpdZzHYELBW+9G8ZtcBVJAc+irGUpgHw1LrmKU9Our+iDMpoGo0eVhiFD7DK3M+OH+iLE8nAmzV6bLZk=
X-Received: by 2002:adf:9e09:: with SMTP id u9mr2956379wre.169.1566315936373;
 Tue, 20 Aug 2019 08:45:36 -0700 (PDT)
MIME-Version: 1.0
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 20 Aug 2019 18:45:25 +0300
Message-ID: <CAKv+Gu8mjM7o+CuP9VrGX+cuix_zRupfozUoDbEWXHVGsW8syw@mail.gmail.com>
Subject: cbc mode broken in rk3288 driver
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Zhang Zhijie <zhangzj@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello all,

While playing around with the fuzz tests on kernelci.org (which has a
couple of rk3288 based boards for boot testing), I noticed that the
rk3288 cbc mode driver is still broken (both AES and DES fail).

For instance, one of the runs failed with

 alg: skcipher: cbc-aes-rk encryption test failed (wrong result) on
test vector \"random: len=6848 klen=32\", cfg=\"random: may_sleep
use_digest src_divs=[93.41%@+1655, 2.19%@+3968, 4.40%@+22]\"

(but see below for the details of a few runs)

However, more importantly, it looks like the driver violates the
scatterlist API, by assuming that sg entries are always mapped and
that sg_virt() and/or page_address(sg_page()) can always be called on
arbitrary scatterlist entries

The failures in question all occur with inputs whose size > PAGE_SIZE,
so it looks like the PAGE_SIZE limit is interacting poorly with the
way the next IV is obtained.

Broken CBC is a recipe for disaster, and so this should really be
fixed, or the driver disabled.

-- 
Ard.


https://storage.kernelci.org/ardb/for-kernelci/v5.3-rc1-195-gd84aa2e87b0e/arm/multi_v7_defconfig/gcc-8/lab-collabora/boot-rk3288-veyron-jaq.html
https://storage.kernelci.org/ardb/for-kernelci/v5.3-rc1-195-gd84aa2e87b0e/arm/multi_v7_defconfig+CONFIG_EFI=y+CONFIG_ARM_LPAE=y/gcc-8/lab-collabora/boot-rk3288-veyron-jaq.html
https://storage.kernelci.org/ardb/for-kernelci/v5.3-rc1-195-gd84aa2e87b0e/arm/multi_v7_defconfig+CONFIG_SMP=n/gcc-8/lab-collabora/boot-rk3288-veyron-jaq.html
