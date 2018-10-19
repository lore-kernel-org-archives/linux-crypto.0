Return-Path: <SRS0=GKHD=M7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:37211 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbeJSR7g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Oct 2018 13:59:36 -0400
Received: by mail-it1-f195.google.com with SMTP id e74-v6so3813139ita.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2018 02:54:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9XJ0k82ZNPRirs3Qhda3375CUA8uhJmsK85=1a9VmaNQ@mail.gmail.com>
References: <20181018043759.7669-1-ebiggers@kernel.org> <20181018043759.7669-3-ebiggers@kernel.org>
 <CAKv+Gu9XJ0k82ZNPRirs3Qhda3375CUA8uhJmsK85=1a9VmaNQ@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 19 Oct 2018 17:54:12 +0800
Message-ID: <CAKv+Gu-qJM4i7EGkUDQwz2ys1G3ZrWDZYnZSBu8OabPm-Q7fFg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] crypto: arm/aes - add some hardening against
 cache-timing attacks
To: Eric Biggers <ebiggers@kernel.org>
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 19 October 2018 at 13:41, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 18 October 2018 at 12:37, Eric Biggers <ebiggers@kernel.org> wrote:
>> From: Eric Biggers <ebiggers@google.com>
>>
>> Make the ARM scalar AES implementation closer to constant-time by
>> disabling interrupts and prefetching the tables into L1 cache.  This is
>> feasible because due to ARM's "free" rotations, the main tables are only
>> 1024 bytes instead of the usual 4096 used by most AES implementations.
>>
>> On ARM Cortex-A7, the speed loss is only about 5%.  The resulting code
>> is still over twice as fast as aes_ti.c.  Responsiveness is potentially
>> a concern, but interrupts are only disabled for a single AES block.
>>
>
> So that would be in the order of 700 cycles, based on the numbers you
> shared in v1 of the aes_ti.c patch. Does that sound about right? So
> that would be around 1 microsecond, which is really not a number to
> obsess about imo.
>
> I considered another option, which is to detect whether an interrupt
> has been taken (by writing some canary value below that stack pointer
> in the location where the exception handler will preserve the value of
> sp, and checking at the end whether it has been modified) and doing a
> usleep_range(x, y) if that is the case.
>
> But this is much simpler so let's only go there if we must.
>

I played around a bit and implemented it for discussion purposes, but
restarting the operation if it gets interrupted, as suggested in the
paper (whitespace corruption courtesy of Gmail)


diff --git a/arch/arm/crypto/aes-cipher-core.S
b/arch/arm/crypto/aes-cipher-core.S
index 184d6c2d15d5..2e8a84a47784 100644
--- a/arch/arm/crypto/aes-cipher-core.S
+++ b/arch/arm/crypto/aes-cipher-core.S
@@ -10,6 +10,7 @@
  */

 #include <linux/linkage.h>
+#include <asm/asm-offsets.h>
 #include <asm/cache.h>

  .text
@@ -139,6 +140,34 @@

  __adrl ttab, \ttab

+ /*
+ * Set a canary that will allow us to tell whether any
+ * interrupts were taken while this function was executing.
+ * The zero value will be overwritten with the process counter
+ * value at the point where the IRQ exception is taken.
+ */
+ mov t0, #0
+ str t0, [sp, #-(SVC_REGS_SIZE - S_PC)]
+
+ /*
+ * Prefetch the 1024-byte 'ft' or 'it' table into L1 cache,
+ * assuming cacheline size >= 32.  This is a hardening measure
+ * intended to make cache-timing attacks more difficult.
+ * They may not be fully prevented, however; see the paper
+ * https://cr.yp.to/antiforgery/cachetiming-20050414.pdf
+ * ("Cache-timing attacks on AES") for a discussion of the many
+ * difficulties involved in writing truly constant-time AES
+ * software.
+ */
+ .set i, 0
+ .rept 1024 / 128
+ ldr r8, [ttab, #i + 0]
+ ldr r9, [ttab, #i + 32]
+ ldr r10, [ttab, #i + 64]
+ ldr r11, [ttab, #i + 96]
+ .set i, i + 128
+ .endr
+
  tst rounds, #2
  bne 1f

@@ -154,6 +183,8 @@
 2: __adrl ttab, \ltab
  \round r4, r5, r6, r7, r8, r9, r10, r11, \bsz, b

+ ldr r0, [sp, #-(SVC_REGS_SIZE - S_PC)] // check canary
+
 #ifdef CONFIG_CPU_BIG_ENDIAN
  __rev r4, r4
  __rev r5, r5
diff --git a/arch/arm/crypto/aes-cipher-glue.c
b/arch/arm/crypto/aes-cipher-glue.c
index c222f6e072ad..de8f32121511 100644
--- a/arch/arm/crypto/aes-cipher-glue.c
+++ b/arch/arm/crypto/aes-cipher-glue.c
@@ -11,28 +11,39 @@

 #include <crypto/aes.h>
 #include <linux/crypto.h>
+#include <linux/delay.h>
 #include <linux/module.h>

-asmlinkage void __aes_arm_encrypt(u32 *rk, int rounds, const u8 *in, u8 *out);
+asmlinkage int __aes_arm_encrypt(u32 *rk, int rounds, const u8 *in, u8 *out);
 EXPORT_SYMBOL(__aes_arm_encrypt);

-asmlinkage void __aes_arm_decrypt(u32 *rk, int rounds, const u8 *in, u8 *out);
+asmlinkage int __aes_arm_decrypt(u32 *rk, int rounds, const u8 *in, u8 *out);
 EXPORT_SYMBOL(__aes_arm_decrypt);

 static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
  struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
  int rounds = 6 + ctx->key_length / 4;
+ u8 buf[AES_BLOCK_SIZE];

- __aes_arm_encrypt(ctx->key_enc, rounds, in, out);
+ if (out == in)
+   in = memcpy(buf, in, AES_BLOCK_SIZE);
+
+ while (unlikely(__aes_arm_encrypt(ctx->key_enc, rounds, in, out)))
+   cpu_relax();
 }

 static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
  struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
  int rounds = 6 + ctx->key_length / 4;
+ u8 buf[AES_BLOCK_SIZE];
+
+ if (out == in)
+   in = memcpy(buf, in, AES_BLOCK_SIZE);

- __aes_arm_decrypt(ctx->key_dec, rounds, in, out);
+ while (unlikely(__aes_arm_decrypt(ctx->key_dec, rounds, in, out)))
+   cpu_relax();
 }

 static struct crypto_alg aes_alg = {
