Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B3DC433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Sep 2021 07:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B52261213
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Sep 2021 07:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbhIKHUc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Sep 2021 03:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbhIKHUb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Sep 2021 03:20:31 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FC5C061574
        for <linux-crypto@vger.kernel.org>; Sat, 11 Sep 2021 00:19:18 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u16so5915239wrn.5
        for <linux-crypto@vger.kernel.org>; Sat, 11 Sep 2021 00:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+DYR8PAkwXpeDmgSUOy4CsnQMTsFD5jEc+0fbJ6ulNY=;
        b=dB12GGO90xBt0riBV0IgkNEgvmSg11GdySkuFtWlir4fP2wIodJXY66J7R8s00Xk2Q
         7ucpM7g/VYQeB34r2dvzjtZWiXDfL5n7L1Pl7qkfDakh58UciF/9OiGnD0XDP0p6xYFi
         yCrOzZf6ngskyLiFVke/XzuN/UzPQPXi2SP8L9Wu9yFWJlScUlye38Ep6iuKTMaI60L0
         44v1IIxGp0H9ZQaKF00obcv5xQK0Oo512W+anVyig9fhAgtq76JZdQkfKSt6M0wZClYN
         G8hjITs8xpa5MxEJt2kF+HXoIwyOl6rl1GvVCrbpm+/T5gUsh2zxt5FSq5ZSE2vU3x06
         mnRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+DYR8PAkwXpeDmgSUOy4CsnQMTsFD5jEc+0fbJ6ulNY=;
        b=i44/nr4YW27YNuqf2X6YTf3sxabl2IoGj+MGuX2bFzwh1vroTFwJ1yAFZ6JSYL1VdE
         6zMdkAySLqiI+pVaKIC2XPSzJpnlMgCNQkG34NOB7DV5xAYjH5GdQp4nBsQEYiEmm7d8
         PFjsfHeg4VGKh/vzB/o4kuDIik0gSo5hzFHhU7e84nTEp8OX9Rw/9HzQxL1F1X6uI2dF
         +Ev66x15pwk3onanUcOVOu74isJKhkaAvYjgCd4sfCeTkFcLgi5wkXbcRObYNZgi3fTv
         7qllH7NCRP2cYJF1IAKP5boz7QaO7hsjEDh7WYYEkY8gLwZ0d2YfPEUFyd1kNrHUepKc
         IUKw==
X-Gm-Message-State: AOAM530EjWFDKwg6h3rtjCttuiUdpXHNA/iHs4Ho4gVg39RYK7c1w2DD
        P7c+aC9a7BXb2E+9/A0HmnjPxW0mfAheHy+l24hFruC+
X-Google-Smtp-Source: ABdhPJy4Z0NB+H/zDcNeNT/xPPNeU3mpsDLqBjvokX9yueTCh+G1RstznYKzWSCc0bkAd2pRPOMuHsvWLt+aKbvqw98=
X-Received: by 2002:a5d:538e:: with SMTP id d14mr1705516wrv.192.1631344757436;
 Sat, 11 Sep 2021 00:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <CACXcFmm798P6mPErh9B4thz7uvBG1sUO-eJpa1MB+7ayDyTCvw@mail.gmail.com>
 <YTmCyOTFADDSTdQm@sol.localdomain> <CACXcFmmpf+bkjr3oiMcABCbXE+LnNQxWXXSiuVk-GMYV09u+Zw@mail.gmail.com>
In-Reply-To: <CACXcFmmpf+bkjr3oiMcABCbXE+LnNQxWXXSiuVk-GMYV09u+Zw@mail.gmail.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Sat, 11 Sep 2021 15:19:05 +0800
Message-ID: <CACXcFmnnOK43qvVPPmMhB8+wWre062z-voyahUqX96Zy7byrFQ@mail.gmail.com>
Subject: Re: [PATCH] random: In _extract_crng() mix in 64 bits if possible
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On many machines arch_get_random_long() gives 64 bits
but current code uses only 32 of them since it XORs
the result into p[14] which is u32.
---
My previous patch made an unwarranted assumption that
an array declared u32 would be 64-bit aligned. Thanks to
Eric for catching that.

This version avoids that problem and also handles the case
where on some machines a long is only 32 bits.

 drivers/char/random.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 605969ed0f96..2c6b56cf8b27 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -989,14 +989,19 @@ static void _extract_crng(struct crng_state *crng,
               __u8 out[CHACHA_BLOCK_SIZE])
 {
     unsigned long v, flags;
+        u32 *q ;
+        q = (u32 *) &v ;

     if (crng_ready() &&
         (time_after(crng_global_init_time, crng->init_time) ||
          time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL)))
         crng_reseed(crng, crng == &primary_crng ? &input_pool : NULL);
     spin_lock_irqsave(&crng->lock, flags);
-    if (arch_get_random_long(&v))
-        crng->state[14] ^= v;
+    if (arch_get_random_long(&v))  {
+                p[14] ^= q[0] ;
+                if (sizeof(v) == 8)
+                        p[15] ^= q[1] ;
+        }
     chacha20_block(&crng->state[0], out);
     if (crng->state[12] == 0)
         crng->state[13]++;
