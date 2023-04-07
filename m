Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D49C76196
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Apr 2023 11:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240209AbjDGL5Z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Apr 2023 07:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239298AbjDGL5X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Apr 2023 07:57:23 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A437A83
        for <linux-crypto@vger.kernel.org>; Fri,  7 Apr 2023 04:57:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680868630; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=WqPhax6w7eVj8NqLLfiYcyYJvqrGoKYsywmc3/PQjT8MkEpYzuJzTOyRgAkUBTp9uH
    z5BOCCY1dqn00g4bZ6qGtWafh8eSKh7wL9bf9rxZjvnNpNGS37+Vkw/p10y6AosVg7og
    9rb+DVRKFaWmduZ/o9XqWOsIh3SHbbJWnB0TBu8kXuT74UqCnzB+5C+59zSsT2CF6dWS
    /viv24Jd0eTIGLLj2lq6zarnG1AtAoP5NKjkBJyG/9TgkG5Y+uHxx4gqHGAPeO7KXPMA
    SttLy8LDfypUlCgpc6txEfwH1JXotgG0YxLgaw7uZ4ndYS7Wd+R4cB+OW7ZKe5iuTliN
    1etg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1680868630;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=4w0VAh45M+ELJShMxUIF3tB7nE3eH9RKxIl0QwFYaEU=;
    b=MbhgjWjXeYWcz5smhfoDSTvAbUjufM/dkJk2wuuFH3MttKB0oJTbL9T2l6HbFcr+Sb
    DGLJIvtzrDWZTZja2soNugUX9+7/3r/Yoxaf7SAvJa+pb4NgZeggpXfvJJ5GA1AGM2nF
    aURKR6dtFALZriIZvTMk8XIS/Phl6NkU/kWgnhICYRyFELk43xIRU5G2ADZhtF4UHE+q
    dwXJwPwfzzridnG+JIqylVbhOksAnjz+wnKuHCVsQUIaCtCV21f19+ohM/cvuHaeFH1q
    2DkOHxO/MoUu0pfmO/i2+6PWQ9iAdfr0LbA5AFDJg97yj8isc2RAjyW25OYT3qkDrmwm
    tDag==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1680868630;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=4w0VAh45M+ELJShMxUIF3tB7nE3eH9RKxIl0QwFYaEU=;
    b=ENl7bnRyGP8KiknvcKoK8R3eLoYIyAY9kJZ2nUybdP/olZr3w8kIbdzK2ydiQJwnKO
    ZaiPRpwI7/wY9ri31QQZOeOsZr2nKHYNm+mXypWy6erKyCJCo/4abhJxX/RgFKW8AYLP
    Cn+hMwTt9+2bpHSd27sGWTPxC8KFkMMEU0yq1MoLQey4KyjOi83lq+jfId01jTy9K4Q9
    F7sU7bRkE8vBlt71Ti2zf9Rh6uWQfaZl6C/awLfQQnwJSptdTZJeXRIgvBMHQDUa9SgT
    gxMddBtpSSy76WqQBhYbHWzvnvjepmYYWcYGB/ZlTsWP1yhN+6r54RXsxFfznY2FAHSY
    UfHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1680868630;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=4w0VAh45M+ELJShMxUIF3tB7nE3eH9RKxIl0QwFYaEU=;
    b=7DcYbyiimWZn7pPeUloOdNN/u7RULHFCNpjjbEfYI9L3ktUUgv7rJpxSQW/DLRq4LE
    L8AbJkKB9mCWHPoAzbCQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDz0d0u0OAA="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.4.0 AUTH)
    with ESMTPSA id ta02b6z37BvAFUW
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 7 Apr 2023 13:57:10 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Vladis Dronov <vdronov@redhat.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH 1/2] crypto: jitter - replace LFSR with SHA3-256
Date:   Fri, 07 Apr 2023 13:53:16 +0200
Message-ID: <5671873.DvuYhMxLoT@positron.chronox.de>
In-Reply-To: <2684670.mvXUDI8C0e@positron.chronox.de>
References: <2684670.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Autocrypt: addr=smueller@chronox.de;
 keydata=
 mQENBFqo+vgBCACp9hezmvJ4eeZv4PkyoMxGpXHN4Ox2+aofXxMv/yQ6oyZ69xu0U0yFcEcSWbe
 4qhxB+nlOvSBRJ8ohEU3hlGLrAKJwltHVzeO6nCby/T57b6SITCbcnZGIgKwX4CrJYmfQ4svvMG
 NDOORPk6SFkK7hhe1cWJb+Gc5czw3wy7By5c1OtlnbmGB4k5+p7Mbi+rui/vLTKv7FKY5t2CpQo
 OxptxFc/yq9sMdBnsjvhcCHcl1kpnQPTMppztWMj4Nkkd+Trvpym0WZ1px6+3kxhMn6LNYytHTC
 mf/qyf1+1/PIpyEXvx66hxeN+fN/7R+0iYCisv3JTtfNkCV3QjGdKqT3ABEBAAG0HVN0ZXBoYW4
 gTXVlbGxlciA8c21AZXBlcm0uZGU+iQFOBBMBCAA4FiEEO8xD1NLIfReEtp7kQh7pNjJqwVsFAl
 qo/M8CGwMFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQQh7pNjJqwVsV8gf+OcAaiSqhn0mYk
 fC7Fe48n9InAkHiSQ/T7eN+wWYLYMWGG0N2z5gBnNfdc4oFVL+ngye4C3bm98Iu7WnSl0CTOe1p
 KGFJg3Y7YzSa5/FzS9nKsg6iXpNWL5nSYyz8T9Q0KGKNlAiyQEGkt8y05m8hNsvqkgDb923/RFf
 UYX4mTUXJ1vk/6SFCA/72JQN7PpwMgGir7FNybuuDUuDLDgQ+BZHhJlW91XE2nwxUo9IrJ2FeT8
 GgFKzX8A//peRZTSSeatJBr0HRKfTrKYw3lf897sddUjyQU1nDYv9EMLBvkzuE+gwUakt2rOcpR
 +4Fn5jkQbN4vpfGPnybMAMMxW6GIrQfU3RlcGhhbiBNdWVsbGVyIDxzbUBjaHJvbm94LmRlPokB
 TgQTAQgAOBYhBDvMQ9TSyH0XhLae5EIe6TYyasFbBQJaqPzEAhsDBQsJCAcCBhUKCQgLAgQWAgM
 BAh4BAheAAAoJEEIe6TYyasFbsqUH/2euuyRj8b1xuapmrNUuU4atn9FN6XE1cGzXYPHNEUGBiM
 kInPwZ/PFurrni7S22cMN+IuqmQzLo40izSjXhRJAa165GoJSrtf7S6iwry/k1S9nY2Vc/dxW6q
 nFq7mJLAs0JWHOfhRe1caMb7P95B+O5B35023zYr9ApdQ4+Lyk+xx1+i++EOxbTJVqLZEF1EGmO
 Wh3ERcGyT05+1LQ84yDSCUxZVZFrbA2Mtg8cdyvu68urvKiOCHzDH/xRRhFxUz0+dCOGBFSgSfK
 I9cgS009BdH3Zyg795QV6wfhNas4PaNPN5ArMAvgPH1BxtkgyMjUSyLQQDrmuqHnLzExEQfG0JV
 N0ZXBoYW4gTXVlbGxlciA8c211ZWxsZXJAY2hyb25veC5kZT6JAU4EEwEIADgWIQQ7zEPU0sh9F
 4S2nuRCHuk2MmrBWwUCWqj6+AIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRBCHuk2MmrB
 WxVrB/wKYSuURgwKs2pJ2kmLIp34StoreNqe6cdIF7f7e8o7NaT528hFAVuDSTUyjXO+idbC0P+
 zu9y2SZfQhc4xbD+Zf0QngX7/sqIWVeiXJa6uR/qrtJF7OBEvlGkxcAwkC0d/Ts68ps4QbZ7s5q
 WBJJY4LmnytqvXGb63/fOTwImYiY3tKCOSCM2YQRFt6BO71t8tu/4NLk0KSW9OHa9nfcDqI18aV
 ylGMu5zNjYqjJpT/be1UpyZo6I/7p0yAQfGJ5YBiN4S264mdFN7jOvxZE3NKXhL4QMt34hOSWPO
 pW8ZGEo1hKjEdHFvYowPpcoOFicP+zvxdpMtUTEkppREN2a+uQENBFqo+vgBCACiLHsDAX7C0l0
 sB8DhVvTDpC2CyaeuNW9GZ1Qqkenh3Y5KnYnh5Gg5b0jubSkauJ75YEOsOeClWuebL3i76kARC8
 Gfo727wSLvfIAcWhO1ws6j1Utc8s1HNO0+vcGC9EEkn7LzO5piEUPkentjrSF7clPsXziW4IJq/
 z3DYZQkVPk7PSw6r0jXWR/p6sj4aXxslIiDgFJZyopki7Sl2805JYcvKKC6OWTyPHJMlnu9dNxJ
 viAentAUwzHxNqmvYjlkqBr/sFnjC9kydElecVm4YQh3TC6yt5h49AslAVlFYfwQwcio1LNWySc
 lWHbDZhcVZJZZi4++gpFmmg1AjyfLABEBAAGJATYEGAEIACAWIQQ7zEPU0sh9F4S2nuRCHuk2Mm
 rBWwUCWqj6+AIbIAAKCRBCHuk2MmrBWxPCCACQGQu5eOcH9qsqSOO64n+xUX7PG96S8s2JolN3F
 t2YWKUzjVHLu5jxznmDwx+GJ3P7thrzW+V5XdDcXgSAXW793TaJ/XMM0jEG+jgvuhE65JfWCK+8
 sumrO24M1KnVQigxrMpG5FT7ndpBRGbs059QSqoMVN4x2dvaP81/+u0sQQ2EGrhPFB2aOA3s7bb
 Wy8xGVIPLcCqByPLbxbHzaU/dkiutSaYqmzdgrTdcuESSbK4qEv3g1i2Bw5kdqeY9mM96SUL8cG
 UokqFtVP7b2mSfm51iNqlO3nsfwpRnl/IlRPThWLhM7/qr49GdWYfQsK4hbw0fo09QFCXN53MPL
 hLwuQENBFqo+vgBCAClaPqyK/PUbf7wxTfu3ZBAgaszL98Uf1UHTekRNdYO7FP1dWWT4SebIgL8
 wwtWZEqI1pydyvk6DoNF6CfRFq1lCo9QA4Rms7Qx3cdXu1G47ZtQvOqxvO4SPvi7lg3PgnuiHDU
 STwo5a8+ojxbLzs5xExbx4RDGtykBoaOoLYeenn92AQ//gN6wCDjEjwP2u39xkWXlokZGrwn3yt
 FE20rUTNCSLxdmoCr1faHzKmvql95wmA7ahg5s2vM9/95W4G71lJhy2crkZIAH0fx3iOUbDmlZ3
 T3UvoLuyMToUyaQv5lo0lV2KJOBGhjnAfmykHsxQu0RygiNwvO3TGjpaeB5ABEBAAGJATYEGAEI
 ACAWIQQ7zEPU0sh9F4S2nuRCHuk2MmrBWwUCWqj6+AIbDAAKCRBCHuk2MmrBW5Y4B/oCLcRZyN0
 ETep2JK5CplZHHRN27DhL4KfnahZv872vq3c83hXDDIkCm/0/uDElso+cavceg5pIsoP2bvEeSJ
 jGMJ5PVdCYOx6r/Fv/tkr46muOvaLdgnphv/CIA+IRykwyzXe3bsucHC4a1fnSoTMnV1XhsIh8z
 WTINVVO8+qdNEv3ix2nP5yArexUGzmJV0HIkKm59wCLz4FpWR+QZru0i8kJNuFrdnDIP0wxDjiV
 BifPhiegBv+/z2DOj8D9EI48KagdQP7MY7q/u1n3+pGTwa+F1hoGo5IOU5MnwVv7UHiW1MSNQ2/
 kBFBHm+xdudNab2U0OpfqrWerOw3WcGd2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Using the kernel crypto API, the SHA3-256 algorithm is used as
conditioning element to replace the LFSR in the Jitter RNG. All other
parts of the Jitter RNG are unchanged.

The application and use of the SHA-3 conditioning operation is identical
to the user space Jitter RNG 3.4.0 by applying the following concept:

- the Jitter RNG initializes a SHA-3 state which acts as the "entropy
  pool" when the Jitter RNG is allocated.

- When a new time delta is obtained, it is inserted into the "entropy
  pool" with a SHA-3 update operation. Note, this operation in most of
  the cases is a simple memcpy() onto the SHA-3 stack.

- To cause a true SHA-3 operation for each time delta operation, a
  second SHA-3 operation is performed hashing Jitter RNG status
  information. The final message digest is also inserted into the
  "entropy pool" with a SHA-3 update operation. Yet, this data is not
  considered to provide any entropy, but it shall stir the entropy pool.

- To generate a random number, a SHA-3 final operation is performed to
  calculate a message digest followed by an immediate SHA-3 init to
  re-initialize the "entropy pool". The obtained message digest is one
  block of the Jitter RNG that is returned to the caller.

Mathematically speaking, the random number generated by the Jitter RNG
is:

aux_t = SHA-3(Jitter RNG state data)

Jitter RNG block = SHA-3(time_i || aux_i || time_(i-1) || aux_(i-1) ||
                         ... || time_(i-255) || aux_(i-255))

when assuming that the OSR = 1, i.e. the default value.

This operation implies that the Jitter RNG has an output-blocksize of
256 bits instead of the 64 bits of the LFSR-based Jitter RNG that is
replaced with this patch.

The patch also replaces the varying number of invocations of the
conditioning function with one fixed number of invocations. The use
of the conditioning function consistent with the userspace Jitter RNG
library version 3.4.0.

The code is tested with a system that exhibited the least amount of
entropy generated by the Jitter RNG: the SiFive Unmatched RISC-V
system. The measured entropy rate is well above the heuristically
implied entropy value of 1 bit of entropy per time delta. On all other
tested systems, the measured entropy rate is even higher by orders
of magnitude. The measurement was performed using updated tooling
provided with the user space Jitter RNG library test framework.

The performance of the Jitter RNG with this patch is about en par
with the performance of the Jitter RNG without the patch.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig               |   1 +
 crypto/jitterentropy-kcapi.c | 179 +++++++++++++++++++++++++++++++----
 crypto/jitterentropy.c       | 145 ++++++++++------------------
 crypto/jitterentropy.h       |  10 +-
 4 files changed, 215 insertions(+), 120 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9c86f7045157..113dee4b167b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1277,6 +1277,7 @@ endif	# if CRYPTO_DRBG_MENU
 config CRYPTO_JITTERENTROPY
 	tristate "CPU Jitter Non-Deterministic RNG (Random Number Generator)"
 	select CRYPTO_RNG
+	select CRYPTO_SHA3
 	help
 	  CPU Jitter RNG (Random Number Generator) from the Jitterentropy library
 
diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index b9edfaa51b27..228b10cab55f 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -2,7 +2,7 @@
  * Non-physical true random number generator based on timing jitter --
  * Linux Kernel Crypto API specific code
  *
- * Copyright Stephan Mueller <smueller@chronox.de>, 2015
+ * Copyright Stephan Mueller <smueller@chronox.de>, 2015 - 2023
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -37,6 +37,8 @@
  * DAMAGE.
  */
 
+#include <crypto/hash.h>
+#include <crypto/sha3.h>
 #include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -46,6 +48,8 @@
 
 #include "jitterentropy.h"
 
+#define JENT_CONDITIONING_HASH	"sha3-256-generic"
+
 /***************************************************************************
  * Helper function
  ***************************************************************************/
@@ -60,11 +64,6 @@ void jent_zfree(void *ptr)
 	kfree_sensitive(ptr);
 }
 
-void jent_memcpy(void *dest, const void *src, unsigned int n)
-{
-	memcpy(dest, src, n);
-}
-
 /*
  * Obtain a high-resolution time stamp value. The time stamp is used to measure
  * the execution time of a given code path and its variations. Hence, the time
@@ -91,6 +90,91 @@ void jent_get_nstime(__u64 *out)
 	*out = tmp;
 }
 
+int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
+		   unsigned int addtl_len, __u64 hash_loop_cnt,
+		   unsigned int stuck)
+{
+	struct shash_desc *hash_state_desc = (struct shash_desc *)hash_state;
+	SHASH_DESC_ON_STACK(desc, hash_state_desc->tfm);
+	u8 intermediary[SHA3_256_DIGEST_SIZE];
+	__u64 j = 0;
+	int ret;
+
+	desc->tfm = hash_state_desc->tfm;
+
+	if (sizeof(intermediary) != crypto_shash_digestsize(desc->tfm)) {
+		pr_warn_ratelimited("Unexpected digest size\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * This loop fills a buffer which is injected into the entropy pool.
+	 * The main reason for this loop is to execute something over which we
+	 * can perform a timing measurement. The injection of the resulting
+	 * data into the pool is performed to ensure the result is used and
+	 * the compiler cannot optimize the loop away in case the result is not
+	 * used at all. Yet that data is considered "additional information"
+	 * considering the terminology from SP800-90A without any entropy.
+	 *
+	 * Note, it does not matter which or how much data you inject, we are
+	 * interested in one Keccack1600 compression operation performed with
+	 * the crypto_shash_final.
+	 */
+	for (j = 0; j < hash_loop_cnt; j++) {
+		ret = crypto_shash_init(desc) ?:
+		      crypto_shash_update(desc, intermediary,
+					  sizeof(intermediary)) ?:
+		      crypto_shash_finup(desc, addtl, addtl_len, intermediary);
+		if (ret)
+			goto err;
+	}
+
+	/*
+	 * Inject the data from the previous loop into the pool. This data is
+	 * not considered to contain any entropy, but it stirs the pool a bit.
+	 */
+	ret = crypto_shash_update(desc, intermediary, sizeof(intermediary));
+	if (ret)
+		goto err;
+
+	/*
+	 * Insert the time stamp into the hash context representing the pool.
+	 *
+	 * If the time stamp is stuck, do not finally insert the value into the
+	 * entropy pool. Although this operation should not do any harm even
+	 * when the time stamp has no entropy, SP800-90B requires that any
+	 * conditioning operation to have an identical amount of input data
+	 * according to section 3.1.5.
+	 */
+	if (!stuck) {
+		ret = crypto_shash_update(hash_state_desc, (u8 *)&time,
+					  sizeof(__u64));
+	}
+
+err:
+	shash_desc_zero(desc);
+	memzero_explicit(intermediary, sizeof(intermediary));
+
+	return ret;
+}
+
+int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_len)
+{
+	struct shash_desc *hash_state_desc = (struct shash_desc *)hash_state;
+	u8 jent_block[SHA3_256_DIGEST_SIZE];
+	/* Obtain data from entropy pool and re-initialize it */
+	int ret = crypto_shash_final(hash_state_desc, jent_block) ?:
+		  crypto_shash_init(hash_state_desc) ?:
+		  crypto_shash_update(hash_state_desc, jent_block,
+				      sizeof(jent_block));
+
+	if (!ret && dst_len)
+		memcpy(dst, jent_block, dst_len);
+
+	memzero_explicit(jent_block, sizeof(jent_block));
+	return ret;
+}
+
 /***************************************************************************
  * Kernel crypto API interface
  ***************************************************************************/
@@ -98,32 +182,78 @@ void jent_get_nstime(__u64 *out)
 struct jitterentropy {
 	spinlock_t jent_lock;
 	struct rand_data *entropy_collector;
+	struct crypto_shash *tfm;
+	struct shash_desc *sdesc;
 };
 
-static int jent_kcapi_init(struct crypto_tfm *tfm)
+static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 {
 	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
-	int ret = 0;
 
-	rng->entropy_collector = jent_entropy_collector_alloc(1, 0);
-	if (!rng->entropy_collector)
-		ret = -ENOMEM;
+	spin_lock(&rng->jent_lock);
 
-	spin_lock_init(&rng->jent_lock);
-	return ret;
-}
+	if (rng->sdesc) {
+		shash_desc_zero(rng->sdesc);
+		kfree(rng->sdesc);
+	}
+	rng->sdesc = NULL;
 
-static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
-{
-	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
+	if (rng->tfm)
+		crypto_free_shash(rng->tfm);
+	rng->tfm = NULL;
 
-	spin_lock(&rng->jent_lock);
 	if (rng->entropy_collector)
 		jent_entropy_collector_free(rng->entropy_collector);
 	rng->entropy_collector = NULL;
 	spin_unlock(&rng->jent_lock);
 }
 
+static int jent_kcapi_init(struct crypto_tfm *tfm)
+{
+	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
+	struct crypto_shash *hash;
+	struct shash_desc *sdesc;
+	int size, ret = 0;
+
+	/*
+	 * Use SHA3-256 as conditioner. We allocate only the generic
+	 * implementation as we are not interested in high-performance. The
+	 * execution time of the SHA3 operation is measured and adds to the
+	 * Jitter RNG's unpredictable behavior. If we have a slower hash
+	 * implementation, the execution timing variations are larger. When
+	 * using a fast implementation, we would need to call it more often
+	 * as its variations are lower.
+	 */
+	hash = crypto_alloc_shash(JENT_CONDITIONING_HASH, 0, 0);
+	if (IS_ERR(hash)) {
+		pr_err("Cannot allocate conditioning digest\n");
+		return PTR_ERR(hash);
+	}
+	rng->tfm = hash;
+
+	size = sizeof(struct shash_desc) + crypto_shash_descsize(hash);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	sdesc->tfm = hash;
+	crypto_shash_init(sdesc);
+	rng->sdesc = sdesc;
+
+	rng->entropy_collector = jent_entropy_collector_alloc(1, 0, sdesc);
+	if (!rng->entropy_collector)
+		ret = -ENOMEM;
+
+	spin_lock_init(&rng->jent_lock);
+	return 0;
+
+err:
+	jent_kcapi_cleanup(tfm);
+	return ret;
+}
+
 static int jent_kcapi_random(struct crypto_rng *tfm,
 			     const u8 *src, unsigned int slen,
 			     u8 *rdata, unsigned int dlen)
@@ -180,15 +310,24 @@ static struct rng_alg jent_alg = {
 		.cra_module             = THIS_MODULE,
 		.cra_init               = jent_kcapi_init,
 		.cra_exit               = jent_kcapi_cleanup,
-
 	}
 };
 
 static int __init jent_mod_init(void)
 {
+	SHASH_DESC_ON_STACK(desc, tfm);
+	struct crypto_shash *tfm;
 	int ret = 0;
 
-	ret = jent_entropy_init();
+	tfm = crypto_alloc_shash(JENT_CONDITIONING_HASH, 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	desc->tfm = tfm;
+	crypto_shash_init(desc);
+	ret = jent_entropy_init(desc);
+	crypto_free_shash(tfm);
+	shash_desc_zero(desc);
 	if (ret) {
 		/* Handle permanent health test error */
 		if (fips_enabled)
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 22f48bf4c6f5..dc423210c9f9 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -2,7 +2,7 @@
  * Non-physical true random number generator based on timing jitter --
  * Jitter RNG standalone code.
  *
- * Copyright Stephan Mueller <smueller@chronox.de>, 2015 - 2020
+ * Copyright Stephan Mueller <smueller@chronox.de>, 2015 - 2023
  *
  * Design
  * ======
@@ -47,7 +47,7 @@
 
 /*
  * This Jitterentropy RNG is based on the jitterentropy library
- * version 2.2.0 provided at https://www.chronox.de/jent.html
+ * version 3.4.0 provided at https://www.chronox.de/jent.html
  */
 
 #ifdef __OPTIMIZE__
@@ -57,21 +57,22 @@
 typedef	unsigned long long	__u64;
 typedef	long long		__s64;
 typedef	unsigned int		__u32;
+typedef unsigned char		u8;
 #define NULL    ((void *) 0)
 
 /* The entropy pool */
 struct rand_data {
+	/* SHA3-256 is used as conditioner */
+#define DATA_SIZE_BITS 256
 	/* all data values that are vital to maintain the security
 	 * of the RNG are marked as SENSITIVE. A user must not
 	 * access that information while the RNG executes its loops to
 	 * calculate the next random value. */
-	__u64 data;		/* SENSITIVE Actual random number */
-	__u64 old_data;		/* SENSITIVE Previous random number */
-	__u64 prev_time;	/* SENSITIVE Previous time stamp */
-#define DATA_SIZE_BITS ((sizeof(__u64)) * 8)
-	__u64 last_delta;	/* SENSITIVE stuck test */
-	__s64 last_delta2;	/* SENSITIVE stuck test */
-	unsigned int osr;	/* Oversample rate */
+	void *hash_state;		/* SENSITIVE hash state entropy pool */
+	__u64 prev_time;		/* SENSITIVE Previous time stamp */
+	__u64 last_delta;		/* SENSITIVE stuck test */
+	__s64 last_delta2;		/* SENSITIVE stuck test */
+	unsigned int osr;		/* Oversample rate */
 #define JENT_MEMORY_BLOCKS 64
 #define JENT_MEMORY_BLOCKSIZE 32
 #define JENT_MEMORY_ACCESSLOOPS 128
@@ -302,15 +303,13 @@ static int jent_permanent_health_failure(struct rand_data *ec)
  * an entropy collection.
  *
  * Input:
- * @ec entropy collector struct -- may be NULL
  * @bits is the number of low bits of the timer to consider
  * @min is the number of bits we shift the timer value to the right at
  *	the end to make sure we have a guaranteed minimum value
  *
  * @return Newly calculated loop counter
  */
-static __u64 jent_loop_shuffle(struct rand_data *ec,
-			       unsigned int bits, unsigned int min)
+static __u64 jent_loop_shuffle(unsigned int bits, unsigned int min)
 {
 	__u64 time = 0;
 	__u64 shuffle = 0;
@@ -318,12 +317,7 @@ static __u64 jent_loop_shuffle(struct rand_data *ec,
 	unsigned int mask = (1<<bits) - 1;
 
 	jent_get_nstime(&time);
-	/*
-	 * Mix the current state of the random number into the shuffle
-	 * calculation to balance that shuffle a bit more.
-	 */
-	if (ec)
-		time ^= ec->data;
+
 	/*
 	 * We fold the time value as much as possible to ensure that as many
 	 * bits of the time stamp are included as possible.
@@ -345,81 +339,32 @@ static __u64 jent_loop_shuffle(struct rand_data *ec,
  *			      execution time jitter
  *
  * This function injects the individual bits of the time value into the
- * entropy pool using an LFSR.
+ * entropy pool using a hash.
  *
- * The code is deliberately inefficient with respect to the bit shifting
- * and shall stay that way. This function is the root cause why the code
- * shall be compiled without optimization. This function not only acts as
- * folding operation, but this function's execution is used to measure
- * the CPU execution time jitter. Any change to the loop in this function
- * implies that careful retesting must be done.
- *
- * @ec [in] entropy collector struct
- * @time [in] time stamp to be injected
- * @loop_cnt [in] if a value not equal to 0 is set, use the given value as
- *		  number of loops to perform the folding
- * @stuck [in] Is the time stamp identified as stuck?
+ * ec [in] entropy collector
+ * time [in] time stamp to be injected
+ * stuck [in] Is the time stamp identified as stuck?
  *
  * Output:
- * updated ec->data
- *
- * @return Number of loops the folding operation is performed
+ * updated hash context in the entropy collector or error code
  */
-static void jent_lfsr_time(struct rand_data *ec, __u64 time, __u64 loop_cnt,
-			   int stuck)
+static int jent_condition_data(struct rand_data *ec, __u64 time, int stuck)
 {
-	unsigned int i;
-	__u64 j = 0;
-	__u64 new = 0;
-#define MAX_FOLD_LOOP_BIT 4
-#define MIN_FOLD_LOOP_BIT 0
-	__u64 fold_loop_cnt =
-		jent_loop_shuffle(ec, MAX_FOLD_LOOP_BIT, MIN_FOLD_LOOP_BIT);
-
-	/*
-	 * testing purposes -- allow test app to set the counter, not
-	 * needed during runtime
-	 */
-	if (loop_cnt)
-		fold_loop_cnt = loop_cnt;
-	for (j = 0; j < fold_loop_cnt; j++) {
-		new = ec->data;
-		for (i = 1; (DATA_SIZE_BITS) >= i; i++) {
-			__u64 tmp = time << (DATA_SIZE_BITS - i);
-
-			tmp = tmp >> (DATA_SIZE_BITS - 1);
-
-			/*
-			* Fibonacci LSFR with polynomial of
-			*  x^64 + x^61 + x^56 + x^31 + x^28 + x^23 + 1 which is
-			*  primitive according to
-			*   http://poincare.matf.bg.ac.rs/~ezivkovm/publications/primpol1.pdf
-			* (the shift values are the polynomial values minus one
-			* due to counting bits from 0 to 63). As the current
-			* position is always the LSB, the polynomial only needs
-			* to shift data in from the left without wrap.
-			*/
-			tmp ^= ((new >> 63) & 1);
-			tmp ^= ((new >> 60) & 1);
-			tmp ^= ((new >> 55) & 1);
-			tmp ^= ((new >> 30) & 1);
-			tmp ^= ((new >> 27) & 1);
-			tmp ^= ((new >> 22) & 1);
-			new <<= 1;
-			new ^= tmp;
-		}
-	}
-
-	/*
-	 * If the time stamp is stuck, do not finally insert the value into
-	 * the entropy pool. Although this operation should not do any harm
-	 * even when the time stamp has no entropy, SP800-90B requires that
-	 * any conditioning operation (SP800-90B considers the LFSR to be a
-	 * conditioning operation) to have an identical amount of input
-	 * data according to section 3.1.5.
-	 */
-	if (!stuck)
-		ec->data = new;
+#define SHA3_HASH_LOOP (1<<3)
+	struct {
+		int rct_count;
+		unsigned int apt_observations;
+		unsigned int apt_count;
+		unsigned int apt_base;
+	} addtl = {
+		ec->rct_count,
+		ec->apt_observations,
+		ec->apt_count,
+		ec->apt_base
+	};
+
+	return jent_hash_time(ec->hash_state, time, (u8 *)&addtl, sizeof(addtl),
+			      SHA3_HASH_LOOP, stuck);
 }
 
 /*
@@ -453,7 +398,7 @@ static void jent_memaccess(struct rand_data *ec, __u64 loop_cnt)
 #define MAX_ACC_LOOP_BIT 7
 #define MIN_ACC_LOOP_BIT 0
 	__u64 acc_loop_cnt =
-		jent_loop_shuffle(ec, MAX_ACC_LOOP_BIT, MIN_ACC_LOOP_BIT);
+		jent_loop_shuffle(MAX_ACC_LOOP_BIT, MIN_ACC_LOOP_BIT);
 
 	if (NULL == ec || NULL == ec->mem)
 		return;
@@ -521,14 +466,15 @@ static int jent_measure_jitter(struct rand_data *ec)
 	stuck = jent_stuck(ec, current_delta);
 
 	/* Now call the next noise sources which also injects the data */
-	jent_lfsr_time(ec, current_delta, 0, stuck);
+	if (jent_condition_data(ec, current_delta, stuck))
+		stuck = 1;
 
 	return stuck;
 }
 
 /*
  * Generator of one 64 bit random number
- * Function fills rand_data->data
+ * Function fills rand_data->hash_state
  *
  * @ec [in] Reference to entropy collector
  */
@@ -575,7 +521,7 @@ static void jent_gen_entropy(struct rand_data *ec)
  * @return 0 when request is fulfilled or an error
  *
  * The following error codes can occur:
- *	-1	entropy_collector is NULL
+ *	-1	entropy_collector is NULL or the generation failed
  *	-2	Intermittent health failure
  *	-3	Permanent health failure
  */
@@ -605,7 +551,7 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 			 * Perform startup health tests and return permanent
 			 * error if it fails.
 			 */
-			if (jent_entropy_init())
+			if (jent_entropy_init(ec->hash_state))
 				return -3;
 
 			return -2;
@@ -615,7 +561,8 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 			tocopy = (DATA_SIZE_BITS / 8);
 		else
 			tocopy = len;
-		jent_memcpy(p, &ec->data, tocopy);
+		if (jent_read_random_block(ec->hash_state, p, tocopy))
+			return -1;
 
 		len -= tocopy;
 		p += tocopy;
@@ -629,7 +576,8 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
  ***************************************************************************/
 
 struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
-					       unsigned int flags)
+					       unsigned int flags,
+					       void *hash_state)
 {
 	struct rand_data *entropy_collector;
 
@@ -656,6 +604,8 @@ struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
 		osr = 1; /* minimum sampling rate is 1 */
 	entropy_collector->osr = osr;
 
+	entropy_collector->hash_state = hash_state;
+
 	/* fill the data pad with non-zero values */
 	jent_gen_entropy(entropy_collector);
 
@@ -669,7 +619,7 @@ void jent_entropy_collector_free(struct rand_data *entropy_collector)
 	jent_zfree(entropy_collector);
 }
 
-int jent_entropy_init(void)
+int jent_entropy_init(void *hash_state)
 {
 	int i;
 	__u64 delta_sum = 0;
@@ -682,6 +632,7 @@ int jent_entropy_init(void)
 
 	/* Required for RCT */
 	ec.osr = 1;
+	ec.hash_state = hash_state;
 
 	/* We could perform statistical tests here, but the problem is
 	 * that we only have a few loop counts to do testing. These
@@ -719,7 +670,7 @@ int jent_entropy_init(void)
 		/* Invoke core entropy collection logic */
 		jent_get_nstime(&time);
 		ec.prev_time = time;
-		jent_lfsr_time(&ec, time, 0, 0);
+		jent_condition_data(&ec, time, 0);
 		jent_get_nstime(&time2);
 
 		/* test whether timer works */
diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
index 5cc583f6bc6b..b3890ff26a02 100644
--- a/crypto/jitterentropy.h
+++ b/crypto/jitterentropy.h
@@ -2,14 +2,18 @@
 
 extern void *jent_zalloc(unsigned int len);
 extern void jent_zfree(void *ptr);
-extern void jent_memcpy(void *dest, const void *src, unsigned int n);
 extern void jent_get_nstime(__u64 *out);
+extern int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
+			  unsigned int addtl_len, __u64 hash_loop_cnt,
+			  unsigned int stuck);
+int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_len);
 
 struct rand_data;
-extern int jent_entropy_init(void);
+extern int jent_entropy_init(void *hash_state);
 extern int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 			     unsigned int len);
 
 extern struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
-						      unsigned int flags);
+						      unsigned int flags,
+						      void *hash_state);
 extern void jent_entropy_collector_free(struct rand_data *entropy_collector);
-- 
2.40.0




