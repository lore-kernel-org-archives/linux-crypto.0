Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5193732B99E
	for <linux-crypto@vger.kernel.org>; Sun,  7 Jun 2026 11:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780831540; cv=none; b=DirX0Cs4ByqA50dKZwT4+l2itAe5AbyRk0AV/6owbtgb0junTMX5jmOIxMcfba7kX6cp53Bkzal9kN2eHligFiXx+9orc5lbN3zfmmvCfZXi7ifmb1++qMwOMX5gD/Cg4LM2ERLSibcUU40fLpWsuK8QGbC0A+dcCTtJWD/z+ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780831540; c=relaxed/simple;
	bh=WK8dNOBYpsLHJqBG9EtuIZvlHcO5fFHa4uh22QQA2Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r1l8hFUsD+kbNQ8v5FtJj9R8tqMZ8maClE5ek9Pu81Zt06mtymgN9o4P2892V77w1573pt01rWESX4w/N21NojNjJL05U1GG4fHuMA2OVJM2Vg8SZ+vuigG8GBbgA8wXmSmXDc/Mfr9IpO91dujP5LlgVvYKjTRbEgmA0Mzt8K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BjQfyJQY; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BjQfyJQY"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490be03d47bso27411945e9.0
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2026 04:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780831537; x=1781436337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m9nxHZo/Ea/9cV2py7u1jKrjrNWsS0AoJHAz+pUd7Ps=;
        b=BjQfyJQYvfOF7r+OjqPJYt5laIp9ccLuAj9tRGbLwuwQtclKIpeUDxfRkM+vfRA5CD
         EhqGJaDs7JV40zw60Urtoj9+bJvkDpnXcmaDq/ZCpVJZiY7Vu//Muyuw371WyadY82uX
         Mmek6DIE0Nky4Jl1zmvWOmKdmAxzvHC85A2V7U7A+S0BQ6bYsF82LZZbTG+OVUY9FxgA
         zpnYMMn7bw410qqbWZthTfQGaRN5nrM+HD1wbvuAzP4WflXLPuAKNBFjIJUi99OD/wUq
         uW3G81EJB6XMMq/9UptG+o9QRhTdk/imirAWf7w7aSkplN/7+L8G5hScBty2I6BW6hMN
         tLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780831537; x=1781436337;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9nxHZo/Ea/9cV2py7u1jKrjrNWsS0AoJHAz+pUd7Ps=;
        b=meJl/X697AIE/Wmg1ceIUtv6qHOLb7L41bdlmorSQiWJ9CnCoTO9yDIizjk+B1AFL6
         9vKo8sqU8/EvYqu5Ud4CbxX8Q73/KVXFmqf9VO2b535krdToU57D02AW3MLwnjSWsZ/G
         dQ4gmyr+eJysu0mPV1qxeEWorx/cCaXomeSRk5kReQfjczvuXaFECWHUKlU5l7k0RwzP
         OR3kyx5kRn2+hWHEfS+DOOzxIt4c9y72IU65Dzm+KXjMuNpY0TlhBRlmOTdk7etX621n
         w0nGhTl1Hquk5AtE28XuvFPdAsMopqUlR9NwEPKJ6FncUbOK6f30AnNpnQYMywpeHvQl
         rnug==
X-Forwarded-Encrypted: i=1; AFNElJ+KChIiHOaqKfpY+2R+eI4w6dGjPY6yM5esINASA9ugXvHwFhSVWRgBZi0bdFYeDXrULm8Rc6fUrPGfC9w=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywpk9Q0omXzHIyt0k5XeaIzY+ZZo9zBRVp4gIRtnKYSqnFksR/f
	ah6UsWQJOw5oH8saLJOP4tSGFlsizO+79f+QiHGgbMZmFWGZIqs3QQyj
X-Gm-Gg: Acq92OFGXDJO9lmBCl8M9CtC0u0N0F/sOSdnMoELWq3riU5NbIfYWBgbv1ldgJbOPWF
	1Q8TtWVgKO86KD7RsDfaLBNBFdhUaCZ1Gsd4ZONe+UwdY3kqEO+nvSeexzu3ZCUvrCMml4t4mW/
	Pwcw9i+1uRt4eFGKqNNjVO8TXhdmhU7PuiVg2NwA4V9dwfwwECj9EixWUfzKKOss3BG7yVKkTjd
	PH6LksxruQwA5KOKgP/h7objl4oth4Sfbud5GXYOh50IDvkZEJ224aT2bzNO4aAm1t3eKopvK8A
	H3VaEMgqqZU4SbZWD/XRpo6Qt/R/FtlY14Ia/FVI3BKfoUMwgjTE03amFW7WwL28IocAK0NBMwr
	SP+QxRHOzgcwC0dnf7NrQJriR4LgGoCRKAFNLRXUN+/1ICTLk6BcTKZsDRYvChK5jerNlH0jDc9
	FkchreaJnNcnVesuy/6rMJKo4AHM0qptkni56W7C61+ZkyN4sJKwx/oMedb+suUDvHhwpIvw==
X-Received: by 2002:a05:600c:81c9:b0:490:b724:507d with SMTP id 5b1f17b1804b1-490c259f6e2mr153245535e9.11.1780831536484;
        Sun, 07 Jun 2026 04:25:36 -0700 (PDT)
Received: from localhost.localdomain ([2a02:1210:8e0c:3300:bec7:46ff:fea1:47ad])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490c2d37edbsm211286635e9.2.2026.06.07.04.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 04:25:35 -0700 (PDT)
From: Fabian Blatter <fabianblatter09@gmail.com>
To: lukas@wunner.de,
	ignat@linux.win,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: stefanb@linux.ibm.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fabian Blatter <fabianblatter09@gmail.com>
Subject: [PATCH] crypto: ecc - Optimize vli additive operations using compiler builtins
Date: Sun,  7 Jun 2026 13:24:35 +0200
Message-ID: <20260607112435.42804-1-fabianblatter09@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the software carry flag emulation with compiler builtins.

Even the newest compilers struggle with taking advantage of the
hardware carry flag. Compiler builtins allow the compiler to
much more easily achieve this while still remaining constant-time.

This yields an approximately 6-7% performance improvement
on the ecc_gen_privkey, ecc_make_pub_key and crypto_ecdh_shared_secret
functions on x86_64 on all curve sizes.

Additionally, the code becomes much more readable.

Signed-off-by: Fabian Blatter <fabianblatter09@gmail.com>
---

Hi,

I'd like to expand on the benchmarks, compare the generated assembly,
and clarify some things.


Use of compiler builtins:

This patch uses __builtin_addcll, __builtin_subcll when available and
otherwise __builtin_uaddll_overflow, __builtin_usubll_overflow. the
latter have existed since ancient gcc versions, so no third fallback
is needed.

I have put the add_carry and sub_borrow inline functions with the
preprocessor logic for builtin selection directly in crypto/ecc.c.
Please let me know if you would like them to be somewhere else.

They do not emit data-dependent branches, and so remain constant-time.


Benchmarks:

All benchmarks were run single-threaded on my AMD 7700X CPU limited to
5.6Ghz. I have measured both nanoseconds and clock cycles, since their
combination can hint at downclocking issues and allows calculation of
the clock speed during the benchmark.

I have omitted the raw output from the benchmarking code, as they much
exceed the 72 character limit.

I have calculated the percent differences, included clock speed
calculations and relevant summaries.


Macro benchmarks:

These were run in a virtualized environment using virtme-ng on the
compiled linux kernel image compiled with default flags.

(the first value is the original time per operation, the second the
patched one. cc is short for clock cycles)

Curve keypair generation (ecc_gen_privkey + ecc_make_pub_key):

P256:
 - 646963ns/op -> 600632ns/op = -7.71%
 - 2911300cc/op -> 2702854cc/op = -7.71%
 - 4.4999Ghz -> 4.5000Ghz = no difference

P384:
 - 1239160ns/op -> 1153940ns/op = -7.38%
 - 5576250cc/op -> 5192749cc/op = -7.38%
 - 4.5000Ghz -> 4.5000Ghz = no difference

Shared secret generation (crypto_ecdh_shared_secret):

P256:
 - 320114ns/op -> 297548ns/op = -7.58%
 - 1440521cc/op -> 1338972cc/op = -7.58%
 - 4.5000Ghz -> 4.5000Ghz = no difference

P384:
 - 620768ns/op -> 582560ns/op = -6.55%
 - 2793467cc/op -> 2621529cc/op = -6.55%
 - 4.5000Ghz -> 4.5000Ghz = no difference

The benchmarks clearly indicate a roughly 6-7% performance increase on
the public API functions. It also appears that virtme-ng limited the
clock speed to 4.5Ghz


Micro benchmarks:

Since the vli additive functions only rely on u64 being defined, these
were run without virtualization and with varying compilers and
compiler flags.

The microbenchmarks show much more mixed results, depending
heavily on the compiler and optimization level used.

For instance, on gcc and O2, the vli_add present in the
patch is actually 25.3% slower than the original one. I have tracked
this down to gcc using a weird way to restore the carry flag after
each iteration, causing way more dependent instructions, preventing
ILP from executing multiple at once.

This is quite interesting, since, as far as I know, the kernel compiles
with gcc and O2 by default, yet the macro-level benchmarks still show a
performance increase. The effect seems to be reversed when crypto/ecc.c
gets compiled. Or maybe the linux kernel uses some additional
optimization flags, I am unsure.

However, most of the time, the patched version outperforms the original
one by a wide margin:
 - On clang -O2 or -O3, vli_add and vli_uadd show a 4.074x and 5.384x
   speedup.
 - On gcc, vli_uadd shows a 74% performance increase at O2, 
   and a 2.07x speedup at O3.

The performance profile of vli_sub and vli_usub is almost identical to
that of vli_add and vli_uadd.


Assembly comparison:

I have put together a piece of code on Compiler explorer, to make sure
it compiles on old gcc versions, view instructions and play around with
compiler settings.

If you would like, you can play around yourself here:
https://godbolt.org/z/1jT5zesz8

When using clang 22.1 at -O3 -march=lunarlake, the difference between
the patched and original version is particularly clear. The patched
version produces this assembly in the unrolled vli_add loop:

mov     rax, qword ptr [rsi + 8*rcx + 16]
adc     rax, qword ptr [rdx + 8*rcx + 16]
mov     qword ptr [rdi + 8*rcx + 16], rax
mov     rax, qword ptr [rsi + 8*rcx + 24]
adc     rax, qword ptr [rdx + 8*rcx + 24]
mov     qword ptr [rdi + 8*rcx + 24], rax
mov     rax, qword ptr [rsi + 8*rcx + 32]
adc     rax, qword ptr [rdx + 8*rcx + 32]
mov     qword ptr [rdi + 8*rcx + 32], rax
mov     rax, qword ptr [rsi + 8*rcx + 40]
adc     rax, qword ptr [rdx + 8*rcx + 40]
mov     qword ptr [rdi + 8*rcx + 40], rax
mov     rax, qword ptr [rsi + 8*rcx + 48]
adc     rax, qword ptr [rdx + 8*rcx + 48]

This is basically optimal for an inner loop. It's pure adc and mov
instructions. The loop counting part is still nowhere near perfect,
and still uses setc instructions. But it is still better than what
the original version produces with the same compiler and flags:

mov     r10, qword ptr [rsi + 8*rcx]
lea     r11, [r10 + rax]
add     r11, qword ptr [rdx + 8*rcx]
xor     ebx, ebx
cmp     r11, r10
setb    bl
cmove   rbx, rax
mov     qword ptr [rdi + 8*rcx], r11
mov     rax, qword ptr [rsi + 8*rcx + 8]
lea     r10, [rax + rbx]
add     r10, qword ptr [rdx + 8*rcx + 8]
xor     r11d, r11d
cmp     r10, rax
setb    r11b
cmove   r11, rbx
mov     qword ptr [rdi + 8*rcx + 8], r10
mov     rax, qword ptr [rsi + 8*rcx + 16]
lea     r10, [rax + r11]
add     r10, qword ptr [rdx + 8*rcx + 16]
xor     ebx, ebx
cmp     r10, rax
setb    bl
cmove   rbx, r11
mov     qword ptr [rdi + 8*rcx + 16], r10
mov     rax, qword ptr [rsi + 8*rcx + 24]
lea     r10, [rax + rbx]
add     r10, qword ptr [rdx + 8*rcx + 24]
xor     r11d, r11d
cmp     r10, rax
setb    r11b
cmove   r11, rbx

This is downright horrendous. that entire block of processes only 4
limbs, thats 8 instructions per limb! The add instructions
are also not adc instructions, showing that the carry flag is
being fully emulated. This demonstrates how even on the newest
compilers and at the highest optimization level, still cannot
generate hardware carry chains without explicit use of builtins.

I should note that not just clang 22.1.0 with -O3 -march=lunarlake
does this. Gcc and clang show this behaviour on every version i have
tested, regardless of target architecture.

I am not very familiar with ARM or RISC-V assembly, but looking at
compiler explorer, the effect clearly persists, and in the case of
RISC-V actually gets much worse.

This affects all architectures across all compilers and compiler
flags.


If you have gotten this far, thank you for reading this and I am looking
forward to any feedback! If you would like any changes to this patch,
I am very happy to send a v2.

 crypto/ecc.c | 98 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 60 insertions(+), 38 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 43b0def3a225..4f7bb6f424d8 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -279,6 +279,48 @@ static void vli_rshift1(u64 *vli, unsigned int ndigits)
 	}
 }
 
+#ifdef __has_builtin
+#if __has_builtin(__builtin_addcll)
+#define USE_BUILTIN_ADDC
+#endif
+#endif
+
+/* Computes result = left + right + carry_in and updates carry_out */
+static inline void add_carry(u64 left, u64 right, u64 *result, u64 carry_in,
+			     u64 *carry_out)
+{
+#ifdef USE_BUILTIN_ADDC
+	*result = __builtin_addcll(left, right, carry_in, carry_out);
+#else
+	u64 sum1, sum2;
+	u64 c1 = __builtin_uaddll_overflow(left, right, &sum1);
+	u64 c2 = __builtin_uaddll_overflow(sum1, carry_in, &sum2);
+	*result = sum2;
+	*carry_out = c1 | c2;
+#endif
+}
+
+#ifdef __has_builtin
+#if __has_builtin(__builtin_subcll)
+#define USE_BUILTIN_SUBC
+#endif
+#endif
+
+/* Computes result = left - right - borrow_in and updates borrow_out */
+static inline void sub_borrow(u64 left, u64 right, u64 *result, u64 borrow_in,
+			      u64 *borrow_out)
+{
+#ifdef USE_BUILTIN_SUBC
+	*result = __builtin_subcll(left, right, borrow_in, borrow_out);
+#else
+	u64 diff1, diff2;
+	u64 b1 = __builtin_usubll_overflow(left, right, &diff1);
+	u64 b2 = __builtin_usubll_overflow(diff1, borrow_in, &diff2);
+	*result = diff2;
+	*borrow_out = b1 | b2;
+#endif
+}
+
 /* Computes result = left + right, returning carry. Can modify in place. */
 static u64 vli_add(u64 *result, const u64 *left, const u64 *right,
 		   unsigned int ndigits)
@@ -286,15 +328,8 @@ static u64 vli_add(u64 *result, const u64 *left, const u64 *right,
 	u64 carry = 0;
 	int i;
 
-	for (i = 0; i < ndigits; i++) {
-		u64 sum;
-
-		sum = left[i] + right[i] + carry;
-		if (sum != left[i])
-			carry = (sum < left[i]);
-
-		result[i] = sum;
-	}
+	for (i = 0; i < ndigits; i++)
+		add_carry(left[i], right[i], &result[i], carry, &carry);
 
 	return carry;
 }
@@ -303,40 +338,29 @@ static u64 vli_add(u64 *result, const u64 *left, const u64 *right,
 static u64 vli_uadd(u64 *result, const u64 *left, u64 right,
 		    unsigned int ndigits)
 {
-	u64 carry = right;
+	u64 carry;
 	int i;
 
-	for (i = 0; i < ndigits; i++) {
-		u64 sum;
+	if (ndigits == 0)
+		return right;
 
-		sum = left[i] + carry;
-		if (sum != left[i])
-			carry = (sum < left[i]);
-		else
-			carry = !!carry;
+	carry = __builtin_uaddll_overflow(left[0], right, &result[0]);
 
-		result[i] = sum;
-	}
+	for (i = 1; i < ndigits; i++)
+		carry = __builtin_uaddll_overflow(left[i], carry, &result[i]);
 
 	return carry;
 }
 
 /* Computes result = left - right, returning borrow. Can modify in place. */
 u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
-		   unsigned int ndigits)
+	    unsigned int ndigits)
 {
 	u64 borrow = 0;
 	int i;
 
-	for (i = 0; i < ndigits; i++) {
-		u64 diff;
-
-		diff = left[i] - right[i] - borrow;
-		if (diff != left[i])
-			borrow = (diff > left[i]);
-
-		result[i] = diff;
-	}
+	for (i = 0; i < ndigits; i++)
+		sub_borrow(left[i], right[i], &result[i], borrow, &borrow);
 
 	return borrow;
 }
@@ -344,20 +368,18 @@ EXPORT_SYMBOL(vli_sub);
 
 /* Computes result = left - right, returning borrow. Can modify in place. */
 static u64 vli_usub(u64 *result, const u64 *left, u64 right,
-	     unsigned int ndigits)
+		    unsigned int ndigits)
 {
-	u64 borrow = right;
+	u64 borrow;
 	int i;
 
-	for (i = 0; i < ndigits; i++) {
-		u64 diff;
+	if (ndigits == 0)
+		return right;
 
-		diff = left[i] - borrow;
-		if (diff != left[i])
-			borrow = (diff > left[i]);
+	borrow = __builtin_usubll_overflow(left[0], right, &result[0]);
 
-		result[i] = diff;
-	}
+	for (i = 1; i < ndigits; i++)
+		borrow = __builtin_usubll_overflow(left[i], borrow, &result[i]);
 
 	return borrow;
 }
-- 
2.54.0

