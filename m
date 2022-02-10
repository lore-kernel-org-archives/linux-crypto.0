Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BABC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 14:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243099AbiBJOo5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:44:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbiBJOo5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 09:44:57 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5FCC4C
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:44:57 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id a8so15886494ejc.8
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=n3tP7J+GjUP9n0pTkqOGo4TBLlmw+yXnfxJFvhpA38Q=;
        b=kOOHqjU2sPsPoe93/TCS8P/mwS383UN0KBzObpB8GX/Spw+WN2tXzVIzoeYIK0u9So
         6hBKf/1WzBR6yEIxovD80ezzbsWWe1C8j1zrTmNU07RIw686Z20mK9VIatTx6FzSS/Yl
         g0Jsu/ME5dmxsl6tYhVaxPN5xqFadEYG13O3cE9kqp2+Pt7SVPrNmD6HeYz4pkiWWfsJ
         iXQiaC1xa0w9f2V2p3cwyimfQLW216EX2PrUdm5EQ19vdGGdIJoEUYLc8VSAC3PU9sYD
         NySVV/Cp0wE3gYM10DKsTXGImDDufHVJzU+fZXyNAr/Xmg8rKD/W/NpkBV5B7mTHRVaH
         mvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=n3tP7J+GjUP9n0pTkqOGo4TBLlmw+yXnfxJFvhpA38Q=;
        b=w5PibhL+Tt0HXP/xRqlfpqLKow6+xjqBtRS3e2b0havo5T9zMXgVMFrrp8o1zzSwoX
         s6hnw2JVpifm9nQ5kgkAkVRib6qSjd4AYyknBiox79bOx0OHwct2myk4zHuBdcKK/8SG
         +2jqMcR8GKPhwnUcKbEuu8lxxfxMSQbAILaBMU++rTVdC3r/opi1uUhnE3hWASTObs1L
         r0gberROaQEkjQLBlY0sNyDnJjG3sQMKBfbuhRlO+KuyD9xhbQBBnSXSadoI8mLsOKBt
         IbZLdw485qLaVFapq45ecjbGl/VU0XBqZWADSMBouR4395u/ovBruAmcu7JnkWKsUv//
         G1fA==
X-Gm-Message-State: AOAM531McyKMcOiR4vSIHVSkXf6512B69QpvUKesPKgggcDMdT1AnAVs
        x14vjeGpOGj9ZS6u0/3CV9nFWTs+1uYZsq+PNn8ytHCYy6w=
X-Google-Smtp-Source: ABdhPJzkM7dOorRhiPZMGqk8gPYVMigqFnvZ/XLeY4jyg4cPDz2SLmfOpGlZLUC56QOL8kQtIu/eBOXkJeFn1L8sHr4=
X-Received: by 2002:a17:907:a428:: with SMTP id sg40mr2351305ejc.128.1644504296367;
 Thu, 10 Feb 2022 06:44:56 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 10 Feb 2022 22:44:44 +0800
Message-ID: <CACXcFmm7Bxnctksf2e96+f7UZk_HjHSJwiCakPuBfdGX5d=T9A@mail.gmail.com>
Subject: [PATCH 4/4] random: Apply get_source_long() in several places
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace arch_get_random_long()/random_get_entropy() sequences
with get_source_long().

Signed-off-by: Sandy Harris <sandyinchina@gmail.com>
---
 drivers/char/random.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6c77fd056f66..20af61a56ec0 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1140,11 +1140,7 @@ static bool crng_init_try_arch(struct crng_state *crng)
     unsigned long rv;

     for (i = 4; i < 16; i++) {
-        if (!arch_get_random_seed_long(&rv) &&
-            !arch_get_random_long(&rv)) {
-            rv = random_get_entropy();
-            arch_init = false;
-        }
+        get_source_long(&rv) ;
         crng->state[i] ^= rv;
     }

@@ -1158,11 +1154,7 @@ static bool __init crng_init_try_arch_early(void)
     unsigned long rv;

     for (i = 4; i < 16; i++) {
-        if (!arch_get_random_seed_long_early(&rv) &&
-            !arch_get_random_long_early(&rv)) {
-            rv = random_get_entropy();
-            arch_init = false;
-        }
+        get_source_long(&rv) ;
         primary_crng.state[i] ^= rv;
     }

@@ -1341,7 +1333,7 @@ static int crng_slow_load(const u8 *cp, size_t len)

 static void crng_reseed(struct crng_state *crng, bool use_input_pool)
 {
-    unsigned long flags;
+    unsigned long flags, rv;
     int i, num;
     union {
         u8 block[CHACHA_BLOCK_SIZE];
@@ -1359,10 +1351,7 @@ static void crng_reseed(struct crng_state
*crng, bool use_input_pool)
     }
     spin_lock_irqsave(&crng->lock, flags);
     for (i = 0; i < 8; i++) {
-        unsigned long rv;
-        if (!arch_get_random_seed_long(&rv) &&
-            !arch_get_random_long(&rv))
-            rv = random_get_entropy();
+        get_source_long(&rv) ;
         crng->state[i + 4] ^= buf.key[i] ^ rv;
     }
     memzero_explicit(&buf, sizeof(buf));
@@ -1728,6 +1717,7 @@ static void extract_buf(u8 *out)
     u8 hash[BLAKE2S_HASH_SIZE];
     unsigned long *salt;
     unsigned long flags;
+    unsigned long v ;

     blake2s_init(&state, sizeof(hash));

@@ -1737,10 +1727,8 @@ static void extract_buf(u8 *out)
      */
     for (salt = (unsigned long *)&state.h[4];
          salt < (unsigned long *)&state.h[8]; ++salt) {
-        unsigned long v;
-        if (!arch_get_random_long(&v))
-            break;
-        *salt ^= v;
+        get_source_long(&v) ;
+        *salt ^= v ;
     }

     /* Generate a hash across the pool */
@@ -2037,9 +2025,7 @@ int __must_check get_random_bytes_arch(void
*buf, int nbytes)
         unsigned long v;
         int chunk = min_t(int, left, sizeof(unsigned long));

-        if (!arch_get_random_long(&v))
-            break;
-
+        get_source_long(&v) ;
         memcpy(p, &v, chunk);
         p += chunk;
         left -= chunk;
@@ -2064,9 +2050,7 @@ static void __init init_std_data(void)

     mix_pool_bytes(&now, sizeof(now));
     for (i = POOL_BYTES; i > 0; i -= sizeof(rv)) {
-        if (!arch_get_random_seed_long(&rv) &&
-            !arch_get_random_long(&rv))
-            rv = random_get_entropy();
+        get_source_long(&rv) ;
         mix_pool_bytes(&rv, sizeof(rv));
     }
     mix_pool_bytes(utsname(), sizeof(*(utsname())));
-- 
2.25.1
