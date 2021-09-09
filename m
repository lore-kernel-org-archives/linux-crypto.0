Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE939C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Sep 2021 02:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3361611B0
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Sep 2021 02:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbhIICul (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Sep 2021 22:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhIICul (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Sep 2021 22:50:41 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA03C061575
        for <linux-crypto@vger.kernel.org>; Wed,  8 Sep 2021 19:49:32 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id bf15so371170vsb.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Sep 2021 19:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=CZqyvCLSFUDXa9i9bd/f880aOzgowCzE7gZuzT+ZrF4=;
        b=QF4TOAjj0q7O7eCbYf2KIvpZC9byTdgQRLjZE6fz1rCGzSVehKt8akh4ELBmnWIuHM
         niUtS4tF4ly/XfJTA0s8KGDSL6syIzcujK23hwd99q5LRLsE5nOq4nWwN0cJAhW47xkH
         Wz1k08hFM2YbwNMGnFGGW0WpxkNlHf7t8PG30AD8fZwlBHIB85SL49mXj8wSh/PRRxy+
         SGYXdSbMwVxRdk85ALsyDdWJgQCq670tyI8xv/hO50c9P1ohH5EmRWPFwrMF9IM+I16c
         lSmoSDB6gCoARUDjVUu4u2ASck0LoFtHcbttGA6ls6WXHgXtgehLOYlDn++yFu3u1yP1
         /brg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=CZqyvCLSFUDXa9i9bd/f880aOzgowCzE7gZuzT+ZrF4=;
        b=p/Drz3Fv4+ploGZaxbyWgAVc6Dywwwe7/TJKQBcs10cQflcA29GF7Juh7w5FBJsdSF
         q9L+ZuqTAXfl43z7ORez4lM2vP0poPyQiAs5tW1rLVnm/K4yETDz7w8YL9y0BNgxFJDy
         TOHhtJrrBlS+5WxEgPuIhyOED1fJdOBFQ1OgbEdppXteURChgMBmiH0BcJLp5n4y26qk
         6sxwrhOdJk2xliGwDgMHBaZz7L+ba3kEsumZeoChlWahoNBWzTdE83/BlgqWh3N/3Y+d
         WnogsOCd67Bb58mEKZkFBxGGCzjhHTPOWqHFZMFm5b+4rYP2aT7EgNwKP8AKTunzFCsc
         NMMg==
X-Gm-Message-State: AOAM531x+fUtmld9lZipCrx7txHOhKgtO66KIOczJp8OTscbOcA4uRki
        AMfIpvudoHBpVCn+8XpVueAxF8z8jlX4DCa4EbnnCp0CVDQ=
X-Google-Smtp-Source: ABdhPJymVKgd9zgFekE0FHvzHn7cjkFIqXLUcP0FVoCm3wHCi6DwEVVSwqYNLnUd4CT2Ckr5r1YcqC3h3sGKn1X7yEs=
X-Received: by 2002:a05:6102:9d5:: with SMTP id g21mr191213vsi.11.1631155771654;
 Wed, 08 Sep 2021 19:49:31 -0700 (PDT)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 9 Sep 2021 10:49:20 +0800
Message-ID: <CACXcFmm798P6mPErh9B4thz7uvBG1sUO-eJpa1MB+7ayDyTCvw@mail.gmail.com>
Subject: [PATCH] In _extract-crng mix in 64 bits if possible
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On some machines arch_get_random_long() gives 64 bits.
XORing it into a 32-bit state word uses only half of it.
This change makes it use it all instead.

Signed-off-by: Sandy Harris <sandyinchina@gmail.com>

---
 drivers/char/random.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 57fe011fb5e4..fe7f3366b934 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -988,7 +988,8 @@ static void crng_reseed(struct crng_state *crng,
struct entropy_store *r)
 static void _extract_crng(struct crng_state *crng,
               __u8 out[CHACHA_BLOCK_SIZE])
 {
-    unsigned long v, flags;
+    unsigned long v, flags, *last;
+    last = (unsigned long *) &crng->state[14] ;

     if (crng_ready() &&
         (time_after(crng_global_init_time, crng->init_time) ||
@@ -996,7 +997,7 @@ static void _extract_crng(struct crng_state *crng,
         crng_reseed(crng, crng == &primary_crng ? &input_pool : NULL);
     spin_lock_irqsave(&crng->lock, flags);
     if (arch_get_random_long(&v))
-        crng->state[14] ^= v;
+        *last ^= v;
     chacha20_block(&crng->state[0], out);
     if (crng->state[12] == 0)
         crng->state[13]++;
--
