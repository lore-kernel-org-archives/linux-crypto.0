Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01B8C433FE
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Jan 2022 09:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354558AbiA3J4T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 Jan 2022 04:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354547AbiA3J4T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jan 2022 04:56:19 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F70AC061714
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jan 2022 01:56:19 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id s13so33231982ejy.3
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jan 2022 01:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=62vWaH+BpXQhqUFk98i4vcDbSM6tFCe6SZcQwYD/3Y0=;
        b=prLW52JlDOpz6yNUcs65dzdRgVn3cXmAG8Bpmvs+FsVvPtLX8MLpoK3WnpdHve8PgE
         UDEoAwFPHdlXf1+bC1QAPbbu8LUT4VlUfGCazDzyY9erTfQ+Rqrh+H8XETqe5NOHjyp9
         iGu52kjEGfp/H31FXAO5VPynXBRFrHrJBPyYdY7gW066wFE6Q/Ig9u0tKlQPYJ4YZ3Ts
         BbpUTolg0r0sSTrJ0broz0HThqcQEEKgiMyhbrlJKUOzqX9/QONXC50lUnoBeqmfy+AM
         jwJNdM+mkVh5hg+jsC+JCCTBwzc9WBPt648SoJP31hQMVPNG3FWKr8OAIIR8kjCSLsyn
         Mhtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=62vWaH+BpXQhqUFk98i4vcDbSM6tFCe6SZcQwYD/3Y0=;
        b=E6UMI6AMfYNr6itz7xm6dEq2oF3kgPjeMKQbMDMSTDZgWs9yH5Cx38HwpduoGF/3HK
         dX8zBvH/aL+1Md3fWoh1IcaKtr5+xKCDKn2KLgLZHzEy2Z4WIlk/r4AmEhKhrtO5TAvE
         5lu7jlSdEjdnmf96/rj4+sItgWx4y00JEAa77sSENtHl8BReeCHfZ7W4YYAxmZYGif3X
         Drk356yNdtQfOH9noecrMX+sA8EM56x5qqKvgZLudWjsifOJhEvXtpMMk/A9Nlws3Zgq
         nNn3eKkfXthhy5EuHhsosF441JpEH1tG2gE1RVN8oSkdCCeRvTb5tUyKMc0ubxUk4Won
         dN1w==
X-Gm-Message-State: AOAM531qcuSIVLs5dzHipVK+hOrxBBNDBRTYryX1aJ98PDgDuL85ctGY
        7qEErlivFD37rD6+hkSC4fR/2mAIKbjY2MBBEHM6U3Mtn1E=
X-Google-Smtp-Source: ABdhPJx2gff3oqe82aQi+2Q5VhubmXMU+C7cyTOBuRxlQjUYexMBDr0nZzfgnuZ1wJ7UoRbnE8/mAIu0qsat79dZnKg=
X-Received: by 2002:a17:907:1c19:: with SMTP id nc25mr13737832ejc.354.1643536576104;
 Sun, 30 Jan 2022 01:56:16 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Sun, 30 Jan 2022 17:56:04 +0800
Message-ID: <CACXcFmnPumpkfLLzzjqkBmxwtpMa0izNj3LOtf2ycTugAKAUwQ@mail.gmail.com>
Subject: [PATCH] random.c Remove locking in extract_buf()
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        m@ib.tc, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This function does not need to lock the input pool
during the hash since that only reads the pool &
we do not care if a write makes the hash result
indeterminate. "That's not a bug; it's a feature."

Removing the unnecessary lock prevents it from
delaying other threads or interrupts which write
to the input pool. Such delays are a bug.

We do need to lock the input pool when writing
to it. Changing __mix_pool_bytes() to plain
mix_pool_bytes() accomplishes that.

We do not need a lock for *out, the only other
place where this function writes. That points to
an array declared local in the calling function.
---
 drivers/char/random.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 68613f0b6887..9dbf7c8c68dd 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1355,7 +1355,6 @@ static void extract_buf(u8 *out)
     }

     /* Generate a hash across the pool */
-    spin_lock_irqsave(&input_pool.lock, flags);
     blake2s_update(&state, (const u8 *)input_pool_data, POOL_BYTES);
     blake2s_final(&state, hash); /* final zeros out state */

@@ -1368,8 +1367,7 @@ static void extract_buf(u8 *out)
      * brute-forcing the feedback as hard as brute-forcing the
      * hash.
      */
-    __mix_pool_bytes(hash, sizeof(hash));
-    spin_unlock_irqrestore(&input_pool.lock, flags);
+    mix_pool_bytes(hash, sizeof(hash));

     /* Note that EXTRACT_SIZE is half of hash size here, because above
      * we've dumped the full length back into mixer. By reducing the
-- 
Signed-off-by: Sandy Harris <sandyinchina@gmail.com>
