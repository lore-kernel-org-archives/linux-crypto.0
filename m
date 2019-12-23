Return-Path: <SRS0=py82=2N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27370C2D0C0
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Dec 2019 09:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E432620715
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Dec 2019 09:46:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IN5ucdOB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfLWJqS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Dec 2019 04:46:18 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34936 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfLWJqS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Dec 2019 04:46:18 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so15601119wmb.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Dec 2019 01:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qHF9LlKxt3BnaA8wu8Ms+iGu1dYYnhu93cFgkjFC7J4=;
        b=IN5ucdOBkV23Iz0OUuaTWPxHHrwbmjSS9fvV9matG+xxjpcB84I5t2EvcCo9q1W+Cs
         qPcMaSJMvDqp8hNCk2VZvFJ+oz1uGHASn6B9kAkuLKaWnzkrBsnz8ktjy26YkQ/JbpBW
         a02vy9T7NxJ/eN2HpXA6A4AjSb/0FY0SpzU53SfQeEAxE/ROnIJLo7Z0oblP0Osz5c+B
         xEgN+holnPI+2vgJyWX2uYGCstRUQaioccCogxXnhD8UDapOJ8iqY7m5hNoxTNHa/sik
         O/mkLMWN30XjwOUQj4UBmfSap1ro5RzHirVe2Kvrg4bwdxAbnYIHpQY/QmT0COPuFdsn
         OHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qHF9LlKxt3BnaA8wu8Ms+iGu1dYYnhu93cFgkjFC7J4=;
        b=YqCfRTz1RkBSSjVJC9SVtk9MB8AFMIYuMHdCKP7AWRpIBMwpVDeDn59LWYq7USW8qk
         DkRAEKTUpdjAqh8KLKG6UyTyNEnNbVwJcUmw8ooR9yJuc9gVFj25EUetxWLpwwbmMiOt
         WRAi+Y6Q2MqF0d8Sj7ULgn/ySAmwjHEItmqapoWagiJTuxmUThUfrUJa3pMAKC2Ctwty
         HasYV+lxQj/zDEek3x0567FKmPA2Ewsgm0IfA2ixeHL2mPSWhxhKBYbriUy4HmLrSa93
         V0hP3OKB1xPdTvUmGL5XBCYTHFs88g5HHN+X0HhUsFg5C17gid4sN5GHUgjBt+Ykxeq7
         5h3A==
X-Gm-Message-State: APjAAAUa1Y5bvkllm0yuqHWlYmYHhbHgq7JGP1wn/geIh4WYmwniH8s7
        xq1JijQ1qWv0gZqnm3Fs8EOxy5p6EZOp0+f9jiL/aqZ/xVOA8g==
X-Google-Smtp-Source: APXvYqyx5r19ln6eJDaXGZRydpEq0t6rFvL1MRx90MqVpL6ICrpIIsRcoC9ecoLtcpdk723GYmBdX/nyAcdedeSRWaI=
X-Received: by 2002:a1c:7205:: with SMTP id n5mr31288683wmc.9.1577094375839;
 Mon, 23 Dec 2019 01:46:15 -0800 (PST)
MIME-Version: 1.0
References: <20191220190218.28884-1-cotequeiroz@gmail.com>
In-Reply-To: <20191220190218.28884-1-cotequeiroz@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 23 Dec 2019 10:46:13 +0100
Message-ID: <CAKv+Gu9ZXCK41xOavw+2KEhhsZq9BFH6mxXKPNomzB6q+DP_FQ@mail.gmail.com>
Subject: Re: Subject: [PATCH 0/6] crypto: QCE hw-crypto fixes
To:     Eneas U de Queiroz <cotequeiroz@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 20 Dec 2019 at 20:02, Eneas U de Queiroz <cotequeiroz@gmail.com> wrote:
>
> I've been trying to make the Qualcomm Crypto Engine work with GCM-mode
> AES.  I fixed some bugs, and added an option to build only hashes or
> skciphers, as the VPN performance increases if you leave some of that to
> the CPU.
>
> A discussion about this can be found here:
> https://github.com/openwrt/openwrt/pull/2518
>
> I'm using openwrt to test this, and there's no support for kernel 5.x
> yet.  So I have backported the recent skcipher updates, and tested this
> with 4.19. I don't have the hardware with me, but I have run-tested
> everything, working remotely.
>
> All of the skciphers directly implemented by the driver work.  They pass
> the tcrypt tests, and also some tests from userspace using AF_ALG:
> https://github.com/cotequeiroz/afalg_tests
>
> However, I can't get gcm(aes) to work.  When setting the gcm-mode key,
> it sets the ctr(aes) key, then encrypt a block of zeroes, and uses that
> as the ghash key.  The driver fails to perform that encryption.  I've
> dumped the input and output data, and they apparently are not touched by
> the QCE.  The IV, which written to a buffer appended to the results sg
> list gets updated, but the results themselves are not.  I'm not sure
> what goes wrong, if it is a DMA/cache problem, memory alignment, or
> whatever.
>

This does sound like a DMA problem. I assume the accelerator is not
cache coherent?

In any case, it is dubious whether the round trip to the accelerator
is worth it when encrypting the GHASH key. Just call aes_encrypt()
instead, and do it in software.

> If I take 'be128 hash' out of the 'data' struct, and kzalloc them
> separately in crypto_gcm_setkey (crypto/gcm.c), it encrypts the data
> just fine--perhaps the payload and the request struct can't be in the
> same page?
>

Non-cache coherent DMA involves cache invalidation on inbound data. So
if both the device and the CPU write to the same cacheline while the
buffer is mapped for DMA from device to memory, one of the updates
gets lost.


> However, it still fails during decryption of the very first tcrypt test
> vector (I'm testing with the AF_ALG program, using the same vectors as
> the kernel), in the final encryption to compute the authentication tag,
> in the same fashion as it did in 'crypto_gcm_setkey'.  What this case
> has in common with the ghash key above is the input data, a single block
> of zeroes, so this may be a hardware bug.  However, if I perform the
> same encryption using the AF_ALG test, it completes OK.
>
> I am not experienced enough with the Linux Kernel, or with the ARM
> architecture to wrap this up on my own, so I need some pointers to what
> to try next.
>
> To come up a working setup, I am passing any AES requests whose length
> is less than or equal to one AES block to the fallback skcipher.  This
> hack is not a part of this series, but I can send it if there's any
> interest in it.
>
> Anyway, the patches in this series are complete enough on their own.
> With the exception of the last patch, they're all bugfixes.
>
> Cheers,
>
> Eneas
>
> Eneas U de Queiroz (6):
>   crypto: qce - fix ctr-aes-qce block, chunk sizes
>   crypto: qce - fix xts-aes-qce key sizes
>   crypto: qce - save a sg table slot for result buf
>   crypto: qce - update the skcipher IV
>   crypto: qce - initialize fallback only for AES
>   crypto: qce - allow building only hashes/ciphers
>
>  drivers/crypto/Kconfig        |  63 ++++++++-
>  drivers/crypto/qce/Makefile   |   7 +-
>  drivers/crypto/qce/common.c   | 244 ++++++++++++++++++----------------
>  drivers/crypto/qce/core.c     |   4 +
>  drivers/crypto/qce/dma.c      |   6 +-
>  drivers/crypto/qce/dma.h      |   3 +-
>  drivers/crypto/qce/skcipher.c |  41 ++++--
>  7 files changed, 229 insertions(+), 139 deletions(-)
>
