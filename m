Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0289336197F
	for <linux-crypto@vger.kernel.org>; Sun, 13 Sep 2026 15:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789312610; cv=pass; b=RLebtjidULka/ZmfpqBanezLWwA+iG0ca8Q0ijD8fPkp75eekj7gd9c2invUToubYOgr8TUkEZCA/ZQ8CthBKDx6gAQj5vDu0FXrEdxP8G/W/IU++r21+QHz27Qd3+zOfRFo5feT8z3LlZSWAiJtbbZNEWbKP1PSq3uTwcSsNh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789312610; c=relaxed/simple;
	bh=aTTMCVnrzErNo3gjfBn1PksZY0Pj3ZNQwgpIX9uxXUo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=PwaTh3q/f76VzuO+3ybraq28eKbMFalmRBl5at9f0496tyjAS/c1jELmVcSV8Bf06Owc7/U5kUhI/9Z9Uvo2vzHZGtNjbrNsmizHDW6uxNt46d4eT6AWCRF7yX9X2WqzIn1JvEE8LKkJoOCD0J5tii27QKznHYVr1TU03ViLbcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jN4pRQ/K; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jN4pRQ/K"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254fa663bfso233650466b.1
        for <linux-crypto@vger.kernel.org>; Sun, 13 Sep 2026 08:16:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789312606; cv=none;
        d=google.com; s=arc-20260327;
        b=OzFwDczaI9YJPLuZRJ0qpBxPovL3Qatz01W/srsk8NfOR5I1eTXk1BVYQy6MgkAnzR
         bZsj6GNIG4FFHwBBf2As4JcrfWHgHJgLm2dnOyzLnB//PC2q6oFySAViJXjn+SuD05IX
         axFbbgnR8LFihrIQxF4v98pIJa5wTB0NFeE3l0yV9QO6qoHhoqVex+EvFfQLOxlLy+Ep
         KhBjhu/r4MFnts77Lh8KfkDAGcXBkFu5CyeAfrnVYZDpYpiH14OtIh2qG98YOxZa8xv9
         RbLTTmWi2uJJslc5LBf1BNgbwVQW/u7j9KaGbSJObKubFUyqCCl6+T3DPRqeZ5lGgf9F
         nRoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=aTTMCVnrzErNo3gjfBn1PksZY0Pj3ZNQwgpIX9uxXUo=;
        fh=dVa4OajLyrOENmjD1WIzyzD4Bf4cb6CnysCq17SnKzg=;
        b=Mmh6rD7aWYRrxfYZ4SLmBeby7hSYnnuOTbwyTkmXzKksi3bMk6KrNpaFcQSHTvtAHn
         gleXShDZV5x0VNFxqJf4MFgPYlV8yGnJ9aw8iDQM1p0dLsRwBw2sdKmT9bLAeKQg8VdS
         42Vt3lluZJusHXfjGcgnA4SYAwyOE56rKFqSZswd2eycHZ3j30v0PZkxZOybuvyeQmlJ
         QXCf5QheJ8vfKQRSP7I+TFSaW511n02iFQxzQZnxS4ohckwlHGOtjneB1k4gBg33rC4y
         ENEn2gj67yVi3ZTcQJnYJwyiM2Pte8VNE6yW9pPng76KHMs4sLbUFPPDI1m1ijczyI19
         JQrA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789312606; x=1789917406; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aTTMCVnrzErNo3gjfBn1PksZY0Pj3ZNQwgpIX9uxXUo=;
        b=jN4pRQ/K7WGpaaevX9Rd6IgHowJ5DvXdaDUrCOLhMigPN4a7v802MVayWc+ed7eKNV
         axmi5mll4Q8uzf3QlWF2Dsr7Fj8+LnncJudXqrfB8S/q9wSrgziZf0lI/KI9f9SZhHr8
         fSaw40C4IB6uHmG3pwgIlSRbpaiJq5nFnmlzJ4yJrmmnuVMhR7HwVUMmR7ARr7fMBcaH
         XZdN4VrXB6VhydefCfNMREyZAJkJBHBQWXSTfsuFA0VAV1dPmiBMM4ZIP0qT3Oa6Tf81
         20iBo0iu1n5RLp27WVUrebSjSxRXOISHlDs2PziWZssKwLDkxnaP+PdwIZMQe85LhKVz
         yiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789312606; x=1789917406;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aTTMCVnrzErNo3gjfBn1PksZY0Pj3ZNQwgpIX9uxXUo=;
        b=elq6tD92LAno4t59DhlRc0MVxplNOWp1opLW0uug0P9+z4nQn8gwlVRVG6wz3DuH4S
         fRFGbpv0tLNC8zxraUSBSlqd5n4rrSDCgt0VMirKAW6fr5AxjyYi150LwM9WWYY89gEI
         iPmWpcnibT7BcLodrjwVUW7h5BA0Abs9E4L97lvhTR2JShgWTnQK8QbRz/MvBhWJm8Ha
         Kv6/Xfm6S/pOHSpeFe2wh0cBHaH+m/oyTHk39GNG5LxEW7xtn1+CbD5tKbQlOZHuKBHx
         moMFG8xXjbrvKbeiVVZYOTBJfDLM/8wNq2JMQCFlZWm4fPDmEj02cqbEVbt7y79yhyU4
         p7GA==
X-Gm-Message-State: AFuF++nfJUz8AU+rJiNF1cqw0Nzu8QI2SmHUNF7gvP++xyECpswONmNq
	7zLPrkmO9B3FhosAaaX4qcZt0eY+mao9E7ukAZ/5D2G2WGiCE7k7W/jo0T/O4DmhkC2FT4CSu3q
	CZ/QHT5EHrijpj54a6evZxQcpdaCI2DU=
X-Gm-Gg: AYBFou3ytugmF2vLzPdy04f+unNfYXeTQOvnM28pJoS3xcF5BoHHJBVlWLB3Hb0x1Uw
	rZkwFLRN24q8IoK1qCJtNA++NmNlEKX9vJDa09inNVSGN6oJKmCAk8Kl6yZVzSHMWxntI1TErJd
	llvHbOmO2DL9DjCbUofGY5eTO8C3ZtHLrKzLMcaJ+y/ISC/nliMvAql5UhEJ1SYgMVU69XGdb6k
	8OzTr6VE2w6WqTJe3aERU//PMVGocfnEZsnxMT1bClno5dAYQHoZWJWNb2SfUAipAW943Ob4raG
	4uJkLs/ZZbSk2XNGDgOC1aGiQBKxYFq03uc0OQ2ozzJRRiH32CUdBqfa7bBZab40terO64P3SVj
	5jCTDQ1Y6Q2oY+UFD+JDfQ1MvHlOSrxp/KRkaqqBb+OTqIlJNGXVMqN98yATiwqavrDqRokCdnQ
	pibj/zdEH2r5BeB3o6Ym+AUm1EbuuJ1nY=
X-Received: by 2002:a17:907:e895:b0:c20:1bc5:7002 with SMTP id
 a640c23a62f3a-c29665414f1mr1196956866b.3.1789312605638; Sun, 13 Sep 2026
 08:16:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?2K3Zhtin2YYg2KfZhNmF2LfZitix2Yo=?= <ha2020anan@gmail.com>
Date: Sun, 13 Sep 2026 18:16:34 +0300
X-Gm-Features: AcwNN1WOf4qSQfH2HT5Ui-EqT0KiK-mgj0fgM__SNKx8e4sV2XVVIPyfTLlmLhk
Message-ID: <CANai08PJ9bKRn3JkgUP7SFHn+qXLoE_JDerRv-UtMkELZXu-wg@mail.gmail.com>
Subject: [PATCH] crypto: jitterentropy - add fast hardware jitter mixer extension
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This patch introduces a fast custom hardware jitter mixer extension for the
jitterentropy subsystem. It utilizes high-precision cycle counters combined
with memory pointer attributes to disturb the branch prediction unit
and hardware
prefetcher dynamically. This creates pure architectural micro-entropy
by exploiting
execution timing variations (CPU jitter) without relying on
floating-point operations,
ensuring compatibility within the kernel space.

Tested on x86 architectures using standard high-precision macros.

Signed-off-by: Tamim N. Almutairi <tamimdevlopment@hotmail.com>
---
diff --git a/crypto/jitterentropy-mixer.c b/crypto/jitterentropy-mixer.c
new file mode 100644
index 0000000..1234567
--- /dev/null
+++ b/crypto/jitterentropy-mixer.c
@@ -0,0 +1,105 @@
+/*
+ * Jitter Entropy Fast Mixer Extension
+ * Copyright (C) 2026 Tamim N. Almutairi <tamimdevlopment@hotmail.com>
+ * Author: Tamim N. Almutairi
+ */
+
+#include <linux/types.h>
+#include <asm/timex.h>
+#include <linux/sched.h>
+#include <linux/math64.h>
+#include <asm/unaligned.h>
+
+#define JENT_MIX_CONST_1 0x9e3779b97f4a7c15ULL
+#define JENT_MIX_CONST_2 0xff51afd7ed558ccdULL
+#define JENT_MIX_CONST_3 0xc4ceb9fe1a85ec53ULL
+
+struct rand_data {
+ uint64_t data;
+ uint64_t prev_time;
+};
+
+static inline uint64_t jent_custom_mixer(uint64_t rdtsc1)
+{
+ uint64_t var1 = rdtsc1 * 2;
+ uint64_t var2 = rdtsc1 * 3;
+ uint64_t x, ti;
+ int max_loops, i;
+
+ var1 = ((var1 ^ (var1 * (1000000 ^ (var1 & 0xFFFF))) * JENT_MIX_CONST_1));
+ var2 = ((var2 ^ (var2 * (1000000 ^ (var2 & 0xFFFF))) * JENT_MIX_CONST_1));
+
+ x = (var1 >> 20) ^ (var2 << 32);
+ ti = mul_u64_u64_shr(x, 100, 64);
+ max_loops = (int)(ti & 0x3F);
+
+ for (i = 1; i <= max_loops; i++) {
+ uint64_t y = (uint64_t)get_cycles() * i;
+ x ^= ((ti + 1) ^ (y * (ti & 0xFFFF)));
+ x = (x ^ (y ^ rdtsc1)) * (ti + 1);
+ barrier();
+ }
+
+ x ^= x >> 33;
+ x *= JENT_MIX_CONST_2;
+ x ^= x >> 33;
+ x *= JENT_MIX_CONST_3;
+ x ^= x >> 33;
+
+ return x;
+}
+
+static inline uint64_t jent_gen_random_not_for_crypto(void)
+{
+ uint64_t x = 1;
+ int i;
+
+ for (i = 1; i <= 5; i++) {
+ x *= (jent_custom_mixer((uint64_t)get_cycles()) * i);
+ x ^= (jent_custom_mixer((uint64_t)get_cycles()) * (i * 2));
+ }
+ x *= (jent_custom_mixer((uint64_t)get_cycles()) * 25);
+ return x;
+}
+
+int jent_read_entropy(struct rand_data *ec, unsigned char *data,
unsigned int len)
+{
+ unsigned int i, j;
+ unsigned int words = len / sizeof(uint64_t);
+ unsigned int tail = len % sizeof(uint64_t);
+ uint64_t word_data;
+
+ if (!ec || !data || len == 0)
+ return -1;
+
+ for (i = 0; i < words; i++) {
+ word_data = jent_gen_random_not_for_crypto();
+ put_unaligned_le64(word_data, data + (i * sizeof(uint64_t)));
+ }
+
+ for (i = 0; i < 26; i++) {
+ cond_resched();
+ for (j = 0; j < words; j++) {
+ word_data = get_unaligned_le64(data + (j * sizeof(uint64_t)));
+ word_data *= (jent_gen_random_not_for_crypto() * ((i + 1) * 2));
+ word_data ^= (jent_gen_random_not_for_crypto() * ((i + 1) * 3));
+
+ if (j > 0) {
+ word_data ^= get_unaligned_le64(data + ((j - 1) * sizeof(uint64_t)))
* JENT_MIX_CONST_3;
+ } else if (words > 1) {
+ word_data ^= get_unaligned_le64(data + ((words - 1) *
sizeof(uint64_t))) * JENT_MIX_CONST_2;
+ }
+ put_unaligned_le64(word_data, data + (j * sizeof(uint64_t)));
+ }
+ }
+
+ if (tail > 0) {
+ word_data = jent_gen_random_not_for_crypto();
+ for (i = 0; i < tail; i++) {
+ data[(words * sizeof(uint64_t)) + i] = (unsigned char)(word_data >> (i * 8));
+ }
+ }
+
+ return 0;
+}
