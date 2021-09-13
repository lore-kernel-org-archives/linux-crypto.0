Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F00C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 02:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0B4D6101B
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 02:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbhIMCxy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Sep 2021 22:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236935AbhIMCxy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Sep 2021 22:53:54 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60061C061574
        for <linux-crypto@vger.kernel.org>; Sun, 12 Sep 2021 19:52:39 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 140so2091535wma.0
        for <linux-crypto@vger.kernel.org>; Sun, 12 Sep 2021 19:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=My9hk/Tw0MYHxwfv8TYYV+AgFffkF3PEJiUOHs/2dVA=;
        b=J/gwmfDPpzdQEq05gDvszLODzE9BJrYltCOmqQwxw7Otz1+J2pM4RKIHc+n2iE55XP
         +DZyaGcw44/sqcnmfz4g5Ty3No2XcdWpTKFydjfc43dGux30LxUK3hu0XaDlnh1QZbq3
         rwnesn+wX6EqHCqVscwfOk5+Q1GY6UrnegJe1AyJxXFJYZECz4+fHOXUZS+jiooW/BKV
         QEnbNB9fsqm9jPOXxsg6SII0j8oQr20zeHKMVxF5zxHV17KkNkyAZe8+Qbgk39W41Yr5
         EPtr+h9QeYq+7yPWostw696bQomO4JE3/KzI459eqp7X3AmHVfE9PMTSq9SX+BMQwojR
         EnhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=My9hk/Tw0MYHxwfv8TYYV+AgFffkF3PEJiUOHs/2dVA=;
        b=qIv2Jj4a6wQ2six3dNBTUm6hZyqLCE2wvj4V0A0K6/AQbTzqH6CPUkpwrUMQZzg+sT
         V9cSucnIRKPeL9Ze8Yd4r0JhAa6+AI+I51+/lvA7m36J80jpA6uWWM8frCKZq61wQb6L
         W82pJ3PROg164KDv/ovJzlr+pt6GvbwYffrXSGof6Hn/ZmvnQ7KUhHYdbDjXNxyByfGn
         +P69dsLq2eh4f/158N39cVv8LUOwzJh11KRS3A72QQxXWXng++Isybr/8VZm6GHxjN+d
         2j2tUErPC8+wJo6DB2Q1j2UekiqrYPg2iMyRuSCuRypm6GAgX9yLWwlAszW4HF9PAUep
         oazQ==
X-Gm-Message-State: AOAM530mr7iT/z/8MSbEzKbQToHmozOhdwghQaHiWMGWRNATsCbhH6ja
        P/sVuHUM31MsOjG8i6OrOkRRxpltBcYyVnOfolo=
X-Google-Smtp-Source: ABdhPJynOPxDSgSv9WiPzutYUEmIqv5LJ5AWv0AdZp+ep2XMX2P22tlQcnHbvM4lxcKO/UmmycxeTXeser9359ats2k=
X-Received: by 2002:a1c:f314:: with SMTP id q20mr8641226wmq.154.1631501557994;
 Sun, 12 Sep 2021 19:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <CACXcFmm798P6mPErh9B4thz7uvBG1sUO-eJpa1MB+7ayDyTCvw@mail.gmail.com>
 <YTmCyOTFADDSTdQm@sol.localdomain> <CACXcFmmpf+bkjr3oiMcABCbXE+LnNQxWXXSiuVk-GMYV09u+Zw@mail.gmail.com>
 <CACXcFmnnOK43qvVPPmMhB8+wWre062z-voyahUqX96Zy7byrFQ@mail.gmail.com>
In-Reply-To: <CACXcFmnnOK43qvVPPmMhB8+wWre062z-voyahUqX96Zy7byrFQ@mail.gmail.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Mon, 13 Sep 2021 10:52:25 +0800
Message-ID: <CACXcFmmsOM-jcWNBh=H+TBg1U4A1SfYDfYxkqiyre5gYUZTecA@mail.gmail.com>
Subject: Re: [PATCH] random: In _extract_crng() mix in 64 bits if possible
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Declare a variable that should have been in commit
 af4047981c61831da73f41d755fbf1f9f20b666a

---
 drivers/char/random.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 2c6b56cf8b27..a2360fb83dbe 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -989,7 +989,8 @@ static void _extract_crng(struct crng_state *crng,
               __u8 out[CHACHA_BLOCK_SIZE])
 {
     unsigned long v, flags;
-        u32 *q ;
+        u32 *p, *q ;
+        p = &crng->state[0] ;
         q = (u32 *) &v ;

     if (crng_ready() &&
