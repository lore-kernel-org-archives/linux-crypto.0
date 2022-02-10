Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBEEC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 14:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237546AbiBJOil (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:38:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiBJOil (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 09:38:41 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C3DBCD
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:38:41 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id bx2so11254107edb.11
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=subFRo9C4IgkyQoK4fTnhoIriPdJdF3hOgikBCMqSl0=;
        b=P/3X32JQjhKgHNhzl6nUD2p7SWH127MJjo7EpX/dy56/8czi7R1L953Qzq3/32Ie3p
         6u7TgrKiTML7UDMN9ExRD1l/90UBs5OKnds9ZIUOynVmHHcxy4a4VznWUWQiLSWIrvDp
         Qz08JjK1GmBluYYl9h1xNgQFeyj6KCap8iSqNbjGVQQ6sihbUSycoLxc8DwyaDNxhfYh
         Tkirp/8Qyb4o8Tc87Ddcw/d82Irbv6ibvMkRGCxu53ZmorGn9gmxwC8rNSquG0AXUDUW
         i98dIw5TQqgkRL2fuz1iJKIyVLe1MqP6F4O9EB8E2ciLibkRaxy+ElkqUsF/hEs0inX9
         omzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=subFRo9C4IgkyQoK4fTnhoIriPdJdF3hOgikBCMqSl0=;
        b=Y2lH58K/zcmJjM200fiBvNGurkD3MwWhMBQunKMaNrDX8HKc6DvxZbU7bI+BKKC3TU
         5E8lxXPzgpCeUWzAN+yjQbNbWkJC7oXq4L4z51zbb0MpWaJzbdp3/aXSA5w9xmCgEsAo
         brZjB8bzsDfYWz3ZfZkm+mh1K7CvFJ84o2z10xBLXWn10Zs++1o6qXLDHgHmdBUq6n/K
         2Z0150BqRELvknUGyYji+jWiShn8pICj9F/Np1zVcF936Y34jbwhxOWwGYq/ULlbkXQd
         6jyx8dcgk5exY6M/8QRPrV7zdGdPM/AZQN8Se14Gku4dZSI7gXE1NNGSIxAvoUqxcKZ1
         ApLA==
X-Gm-Message-State: AOAM532tFEm1KZ4BlkehJC/w+VACB+5NXLRlXvy/YeXyyv8cspzRwl0C
        tnYhb00bIw27yrQxr1U/B0vmAWB/UI/6PH+NE0CWUIHTvY8=
X-Google-Smtp-Source: ABdhPJxHE5Z2m34Ymgp6RMNSN2NfPwS1f/SlPixJXpNGOINx98tCGhpsr3L5MjOt5tXa07sU4LEjHxPHvzYXY+eW5Hg=
X-Received: by 2002:a05:6402:5243:: with SMTP id t3mr8663351edd.260.1644503919879;
 Thu, 10 Feb 2022 06:38:39 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 10 Feb 2022 22:38:28 +0800
Message-ID: <CACXcFmnkeFJ2e7A4HOfTJ90ps956xZnoQ=RiZd=7=cZTzxGwMw@mail.gmail.com>
Subject: [PATCH 2/4] random: Add a pseudorandom generator based on the xtea cipher
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a pseudorandom generator based on the xtea cipher

This will be used only within the kernel, mainly within the driver
to rekey chacha or dump extra random data into the input pool.

It needs a 64-bit output to match arch_get_random_long(), and
the obvious way to get that is a 64-bit block cipher.

xtea was chosen partly for speed but mainly because, unlike
most other block ciphers, it does not use a lot of storage
for round keys or S-boxes. This driver already has 4k bits
in the input pool and 512 bits each for chacha and hash
contexts; that is reasonable, but if anything we should
be looking at ways to reduce storage use rather than
increasing it.

---
 drivers/char/random.c | 294 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 294 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index c8618020b49f..9edf65ad4259 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -737,6 +737,300 @@ static int credit_entropy_bits_safe(int nbits)
     return 0;
 }

+/*************************************************************************
+ * Use xtea to create a pseudorandom 64-bit output
+ * This should not be used for output to user space,
+ * only for things within the kernel
+ *
+ * xtea is fast & uses little storage
+ * See https://en.wikipedia.org/wiki/XTEA and papers it links
+ *
+ * tea is the original block cipher, Tiny Encryption Algorithm
+ * xtea is an improved version preventing some published attacks
+ * both are in linux/crypto/tea.c
+ *************************************************************************/
+
+static spinlock_t xtea_lock;
+
+/*
+ * These initialisations are not strictly needed,
+ * but they are more-or-less free and can do no harm.
+ * Constants are from SHA-512
+ */
+static unsigned long tea_mask = 0x7137449123ef65cd ;
+static unsigned long tea_counter = 0xb5c0fbcfec4d3b2f ;
+/*
+ * 128-bit key
+ * cipher itself uses 32-bit operations
+ * but rekeying uses 64-bit
+ */
+#ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
+static unsigned long tea_key64[2] __latent_entropy ;
+#else
+static unsigned long tea_key64[2] = {0x0fc19dc68b8cd5b5, 0xe9b5dba58189dbbc} ;
+#endif
+static u32 *tea_key = (u32 *) &tea_key64[0] ;
+
+static void xtea_rekey(void) ;
+
+/*
+ * simplified version of code fron crypto/tea.c
+ * xtea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+ *
+ * does not use struct
+ * does no endianess conversions
+ * no *src or *dst, encrypt a 64-bit block in place
+ */
+#define XTEA_ROUNDS        32
+#define XTEA_DELTA        0x9e3779b9
+
+static void xtea_block(unsigned long *x)
+{
+    u32 i, y, z, sum, *p ;
+    p = (u32 *) x ;
+
+    y = p[0] ;
+    z = p[1] ;
+    for (i = 0, sum = 0 ; i < XTEA_ROUNDS ; i++) {
+        y += ((z << 4 ^ z >> 5) + z) ^ (sum + tea_key[sum&3]);
+        sum += XTEA_DELTA;
+        z += ((y << 4 ^ y >> 5) + y) ^ (sum + tea_key[sum>>11 &3]);
+    }
+    p[0] = y ;
+    p[1] = z ;
+}
+
+/*
+ * For counter mode see RFC 4086 section 6.2.1
+ * Add a constant instead of just incrementing
+ * to change more bits
+ *
+ * Even and Mansour proved proved a lower bound
+ * for an XOR-permutation-XOR sequence.
+ * S. Even, Y. Mansour, Asiacrypt 1991
+ * A Construction of a Cipher From a Single Pseudorandom Permutation
+ *
+ * For an n-bit block and D known or chosen plaintexts,
+ * time T to break it is bounded by DT >= 2^n.
+ *
+ * This applies even if the enemy knows the permutation,
+ * for a block cipher even if he or she knows the key.
+ * All the proof requires is that the permutation be
+ * nonlinear, which any block cipher is.
+ *
+ * Neither this function nor xtea_block() takes any locks.
+ * Callers should take xtea_lock.
+ */
+#define COUNTER_DELTA 0x240ca1cc77ac9c65
+static int xtea_iterations = 0 ;
+
+static unsigned long xtea_counter(void)
+{
+    unsigned long x ;
+    x = tea_counter ^ tea_mask ;
+    xtea_block(&x) ;
+    x ^= tea_mask ;
+    tea_counter += COUNTER_DELTA ;
+    xtea_iterations++ ;
+    return x ;
+}
+
+/*
+ * This does a full rekey (update key, mask and counter)
+ * when xtea_iterations >= 1021, the largest prime < 1024.
+ *
+ * Using the Even-Mansour bound DT >= 2^n we have n = 64
+ * and D < 2^10 so time T to break it is T > 2^54.
+ *
+ * That lets the attacker learn the mask value for one
+ * sequence of 1021 outputs between rekeyings. He or she
+ * must repeat the costly attack to get the next mask
+ * when the cipher is rekeyed.
+ *
+ * Also, the attack needs D known plaintext/ciphertext
+ * pairs which should be hard to get. The plaintext is
+ * only a counter but it is randomly initialised, and
+ * the ciphertext is not sent outside the kernel. Even
+ * within the kernel it is never just saved, but always
+ * mixed with other data.
+ *
+ * Assuming proper keying and that the enemy cannot
+ * peek into the running kernel, this can be considered
+ * effectively unbreakable, and would be so even if
+ * xtea itself were flawed.
+ */
+#define TEA_REKEY       1021
+
+static void get_xtea_long(unsigned long *out)
+{
+    unsigned long flags ;
+
+    if (xtea_iterations >= TEA_REKEY)
+        xtea_iterations = 0 ;
+    if (xtea_iterations == 0)
+        xtea_rekey() ;
+
+    spin_lock_irqsave(&xtea_lock, flags) ;
+    *out = xtea_counter() ;
+    spin_unlock_irqrestore(&xtea_lock, flags) ;
+}
+
+/*
+ * Inject a bit of external entropy
+ * Use a cheap source, not particularly strong
+ *
+ * xtea has reasonable round avalanche and
+ * 32 rounds, so any change in the key will
+ * affect many output bits
+ *
+ * After two calls to this, every 32-bit word
+ * of the key has been changed. After four,
+ * each word has had two updates, one with
+ * ^= and one with +=
+ */
+static u32 perturb_count = 0 ;
+
+static void xtea_perturb(void)
+{
+    u32 x ;
+    unsigned long flags ;
+    x = random_get_entropy() ;
+
+    spin_lock_irqsave(&xtea_lock, flags) ;
+    tea_key[perturb_count] ^= x ;
+    tea_key[3 - perturb_count] += x ;
+    perturb_count++ ;
+    perturb_count ^= 3 ;
+    spin_unlock_irqrestore(&xtea_lock, flags) ;
+}
+
+/*
+ * Despite the name, this is not used for standalone
+ * rekeying, only as a mixer when some part of the
+ * xtea data has been changed and we want to spread
+ * the effect to all parts.
+ *
+ * Uses xtea_counter() rather than get_xtea_long()
+ * to avoid complications with recursion and locking
+ */
+static void xtea_self_rekey(void)
+{
+    unsigned long flags ;
+    spin_lock_irqsave(&xtea_lock, flags) ;
+    tea_key64[0] ^= xtea_counter() ;
+    tea_key64[1] ^= xtea_counter() ;
+    tea_counter  ^= xtea_counter() ;
+    tea_mask += xtea_counter() ;
+    spin_unlock_irqrestore(&xtea_lock, flags) ;
+}
+
+static int xtea_initialised = 0 ;
+
+static void xtea_rekey(void)
+{
+    unsigned long u, v, x, y ;
+    int a, b, c, d, i ;
+    int flag = 0 ;
+    unsigned long flags ;
+
+    if ((system_state == SYSTEM_BOOTING) && IS_ENABLED(CONFIG_ARCH_RANDOM)) {
+        a = (arch_get_random_long_early(&u) ||
arch_get_random_seed_long_early(&u));
+        b = (arch_get_random_long_early(&v) ||
arch_get_random_seed_long_early(&v));
+        c = (arch_get_random_long_early(&x) ||
arch_get_random_seed_long_early(&x));
+        d = (arch_get_random_long_early(&y) ||
arch_get_random_seed_long_early(&y));
+        if (a && b && c && d)
+            flag = 1 ;
+        else
+            pr_warn("arch_get_random_long_early() failed in xtea_rekey()") ;
+    }
+    if (!flag && IS_ENABLED(CONFIG_ARCH_RANDOM)) {
+        a = arch_get_random_long(&u) || arch_get_random_seed_long(&u);
+        b = arch_get_random_long(&v) || arch_get_random_seed_long(&v) ;
+        c = arch_get_random_long(&x) || arch_get_random_seed_long(&x) ;
+        d = arch_get_random_long(&y) || arch_get_random_seed_long(&y) ;
+        if (a && b && c && d)
+            flag = 1 ;
+        else
+            pr_warn("arch_get_random_long() failed in xtea_rekey()") ;
+    }
+    if (!flag && IS_ENABLED(CONFIG_HW_RANDOM))      {
+        a = get_hw_long(&u) ;
+        b = get_hw_long(&v) ;
+        c = get_hw_long(&x) ;
+        d = get_hw_long(&y) ;
+        if (a && b && c && d)
+            flag = 1 ;
+        else
+            pr_warn("hardware rng failed in xtea_rekey()") ;
+    }
+    if (flag)       {
+        spin_lock_irqsave(&xtea_lock, flags) ;
+        tea_mask += u ;
+        tea_counter ^= v ;
+        tea_key64[0] ^= x ;
+        tea_key64[1] ^= y ;
+        spin_unlock_irqrestore(&xtea_lock, flags) ;
+        memzero_explicit(&u, 8) ;
+        memzero_explicit(&v, 8) ;
+        memzero_explicit(&x, 8) ;
+        memzero_explicit(&y, 8) ;
+        /*
+         * any of the above should be good enough
+         * but mix in a little extra entropy to avoid
+         * trusting them completely
+         */
+        if (!xtea_initialised)    {
+            xtea_initialised = 1 ;
+        }
+        xtea_perturb() ;
+    }
+    if (!flag && IS_ENABLED(CONFIG_GCC_PLUGIN_LATENT_ENTROPY))    {
+        if (xtea_initialised)
+            xtea_perturb() ;
+
+        spin_lock_irqsave(&xtea_lock, flags) ;
+        // tea_counter ^= latent_entropy ;
+        if (!xtea_initialised)    {
+            /*
+             * the plugin randomly initialises both tea-key[]
+             * and the input pool at boot
+             */
+            xor128(tea_key, &input_pool_data[0]) ;
+            add128(tea_key, &input_pool_data[4]) ;
+            xtea_initialised = 1 ;
+        }
+        spin_unlock_irqrestore(&xtea_lock, flags) ;
+        xtea_self_rekey() ;
+        flag = 1 ;
+    }
+    /*
+     * None of the above succeeded so the driver cannot be
+     * fully secure until enough entropy is accumulated
+     * in the input pool and chacha is reseeded.
+     *
+     * Do some extra mixing here, likely enough to stop
+     * some attackers.
+     *
+     * This does not add enough entropy to stop a determined
+     * attacker with major resources. If you need protection
+     * against such opponents, then you must ensure that
+     * some branch above succeeds.
+     */
+    if (!flag)    {
+        if (xtea_initialised)
+            a = 1 ;
+        else    {
+            a = 4 ;
+            xtea_initialised = 1 ;
+        }
+        for( i = 0 ; i < a ; i++ )    {
+            xtea_perturb() ;
+            xtea_self_rekey() ;
+        }
+    }
+    xtea_iterations = 0 ;
+}
+
 /*********************************************************************
  *
  * CRNG using CHACHA20
-- 
2.25.1
