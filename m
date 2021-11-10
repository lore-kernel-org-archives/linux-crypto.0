Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063CBC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 09:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCFE361205
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 09:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhKJJ2H (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 04:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhKJJ2H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 04:28:07 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC8EC061764;
        Wed, 10 Nov 2021 01:25:20 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id g17so4719199ybe.13;
        Wed, 10 Nov 2021 01:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=BZ0thEzEEgN8Vv8lNiduAKq1NabNeUpqnuyPRupYYmE=;
        b=bAT+hBIH/pqHIqQbAo5kA+2T8xqHzlSAXrFdaVUp7Z5VS5H1fOzFTB+CIe85zNEVJd
         FCvaKldm9u/8AMZkdNCbYvAtswCIzrYXb8cucp2oPyYb3EFTiWvGJgybqtq5XHK+wNdu
         D5z1XA6lcQo0sgN8MnUvmluFeu0kXi2XTUkClRlOfre+FZxyTqhZXHNRXHw/dGAs8ChB
         aIODKBeGuGA/w/B+qv8HcYhvOV52YQPaVkMzbMkbqAFYhw18EDUZheJjxLH2i87RDUHh
         J8oRFMBTwkuw9h9SQ1Y4dRZMCtEoeASI2myLB2wauYQDtLT3gVQGzjHigJSlKaUHk1Ca
         WEGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BZ0thEzEEgN8Vv8lNiduAKq1NabNeUpqnuyPRupYYmE=;
        b=QEX8lyRSlRv++VgobU2OMdZ+nkG7oJqwYFVSLlt0gTK2lZMT9TKqWJCchJk/1HFcgJ
         6pHwQ5RKZ8571QT+Y8EK9uX/EvjxRdEo4W/9rj3XCZjBdkHv0GuSvHetGZ9N9GOdoID7
         VFj6PNqLJxQ+VMOVWj781yxNMXiUamZ1+vYy6mJhhiV1XzKkkzmGk7bfJ1jTwwo1TYMa
         9x4vxF2XPuCNltglvrsZnlkaEDZpTKXteHkPDzLfFQjGiGtdK2cJdjqumNPL0DVXKP9o
         EB71nRHGEol4PuCAm2Mma1BLfybT1z+6i7RsqWkP2dOj3IizC9NKcBAnAhdO1vsjkFAH
         8hTA==
X-Gm-Message-State: AOAM5300dGBER48P8td1uomk2PcqcX2fV+VBMB925rsAkQIjhgRpvoXO
        W0YPuSVKbbJLBZERXbjEc06abvgNEyQGAxlinfNMmUvx2rc=
X-Google-Smtp-Source: ABdhPJxrhXUy2hs02whrKt98Y/SM6DMR7UOlPhkfhkVK+Q/kMm4WvN2c1uOS+FWJyqGBEx/uqGZomO+BQsjcnS3eZw0=
X-Received: by 2002:a25:ae07:: with SMTP id a7mr15958073ybj.364.1636536319416;
 Wed, 10 Nov 2021 01:25:19 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Wed, 10 Nov 2021 17:25:07 +0800
Message-ID: <CACXcFmnKhYyjHNzu_MxZ2qup1jxp4CWT09HzBu=h5D2Ur9LjWQ@mail.gmail.com>
Subject: [PATCH] random: Use 64 bits from get_random_long() in extract_crng()
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

---
drivers/char/random.c | 10 ++++++++--
1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 605969ed0f96..bf644b594fb7 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -989,14 +989,20 @@ static void _extract_crng(struct crng_state *crng,
                         __u8 out[CHACHA_BLOCK_SIZE])
{
       unsigned long v, flags;
+        u32 *p, *q ;
+        p = crng->state ;
+        q = (u32 *) &v ;

       if (crng_ready() &&
           (time_after(crng_global_init_time, crng->init_time) ||
            time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL)))
               crng_reseed(crng, crng == &primary_crng ? &input_pool : NULL);
       spin_lock_irqsave(&crng->lock, flags);
-       if (arch_get_random_long(&v))
-               crng->state[14] ^= v;
+       if (arch_get_random_long(&v))  {
+               p[14] ^= q[0];
+                if (sizeof(v) == 8)
+                        p[15] ^= q[1];
+        }
       chacha20_block(&crng->state[0], out);
       if (crng->state[12] == 0)
               crng->state[13]++;
--
