Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:45575 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbeJRLpr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 07:45:47 -0400
Received: by mail-io1-f67.google.com with SMTP id e12-v6so20136095iok.12
        for <linux-crypto@vger.kernel.org>; Wed, 17 Oct 2018 20:46:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20181017061813.32751-3-ebiggers@kernel.org>
References: <20181017061813.32751-1-ebiggers@kernel.org> <20181017061813.32751-3-ebiggers@kernel.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 18 Oct 2018 11:46:53 +0800
Message-ID: <CAKv+Gu8u+eGb6gSC7JXQMVPAJA3_i1JSaSSmt5VmSEsedYcDzg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: arm/aes - add some hardening against
 cache-timing attacks
To: Eric Biggers <ebiggers@kernel.org>
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Eric,

Thanks for looking into this.

On 17 October 2018 at 14:18, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Make the ARM scalar AES implementation closer to constant-time by
> disabling interrupts and prefetching the tables into L1 cache.  This is
> feasible because due to ARM's "free" rotations, the main tables are only
> 1024 bytes instead of the usual 4096 used by most AES implementations.
>
> On ARM Cortex-A7, the speed loss is only about 5%.  The resulting
> implementation is still over twice as fast as aes_ti.c.
>
> Note that even after these changes, the implementation still isn't
> necessarily guaranteed to be constant-time; see
> https://cr.yp.to/antiforgery/cachetiming-20050414.pdf for a discussion
> of the many difficulties involved in writing truly constant-time AES
> software.  But it's valuable to make such attacks more difficult.
>
> Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/arm/crypto/aes-cipher-core.S | 26 ++++++++++++++++++++++++++
>  arch/arm/crypto/aes-cipher-glue.c | 13 +++++++++++++
>  crypto/aes_generic.c              |  9 +++++----
>  3 files changed, 44 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/crypto/aes-cipher-core.S b/arch/arm/crypto/aes-cipher-core.S
> index 184d6c2d15d5..ba9d4aefe585 100644
> --- a/arch/arm/crypto/aes-cipher-core.S
> +++ b/arch/arm/crypto/aes-cipher-core.S
> @@ -138,6 +138,23 @@
>         eor             r7, r7, r11
>
>         __adrl          ttab, \ttab
> +       /*
> +        * Prefetch the 1024-byte 'ft' or 'it' table into L1 cache, assuming
> +        * cacheline size >= 32.  This, along with the caller disabling
> +        * interrupts, is a hardening measure intended to make cache-timing
> +        * attacks more difficult.  They may not be fully prevented, however;
> +        * see the paper https://cr.yp.to/antiforgery/cachetiming-20050414.pdf
> +        * ("Cache-timing attacks on AES") for a discussion of the many
> +        * difficulties involved in writing truly constant-time AES software.
> +        */
> +       .set i, 0
> +.rept 1024 / 128
> +       ldr             r8, [ttab, #i + 0]
> +       ldr             r9, [ttab, #i + 32]
> +       ldr             r10, [ttab, #i + 64]
> +       ldr             r11, [ttab, #i + 96]
> +       .set i, i + 128
> +.endr
>

Mind sticking a bit more to the coding style of the file? I.e., indent
the gas directives with the code, and putting two tabs after them

>         tst             rounds, #2
>         bne             1f
> @@ -152,6 +169,15 @@
>         b               0b
>
>  2:     __adrl          ttab, \ltab
> +.if \bsz == 0
> +       /* Prefetch the 256-byte inverse S-box; see explanation above */
> +       .set i, 0
> +.rept 256 / 64
> +       ldr             t0, [ttab, #i + 0]
> +       ldr             t1, [ttab, #i + 32]
> +       .set i, i + 64
> +.endr
> +.endif
>         \round          r4, r5, r6, r7, r8, r9, r10, r11, \bsz, b
>
>  #ifdef CONFIG_CPU_BIG_ENDIAN
> diff --git a/arch/arm/crypto/aes-cipher-glue.c b/arch/arm/crypto/aes-cipher-glue.c
> index c222f6e072ad..f40e35eb22e4 100644
> --- a/arch/arm/crypto/aes-cipher-glue.c
> +++ b/arch/arm/crypto/aes-cipher-glue.c
> @@ -23,16 +23,29 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>         int rounds = 6 + ctx->key_length / 4;
> +       unsigned long flags;
>
> +       /*
> +        * This AES implementation prefetches the lookup table into L1 cache to
> +        * try to make timing attacks on the table lookups more difficult.
> +        * Temporarily disable interrupts to avoid races where cachelines are
> +        * evicted when the CPU is interrupted to do something else.
> +        */
> +       local_irq_save(flags);
>         __aes_arm_encrypt(ctx->key_enc, rounds, in, out);
> +       local_irq_restore(flags);
>  }
>

Disabling interrupts like that is going to raise some eyebrows, so I'd
prefer it if we can reduce the scope of the IRQ blackout as much as we
can. This means we should move the IRQ en/disable into the .S file,
and only let it cover the parts of the code where we are actually
doing table lookups that are indexed by the input.

>  static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>         int rounds = 6 + ctx->key_length / 4;
> +       unsigned long flags;
>
> +       /* Disable interrupts to help mitigate timing attacks, see above */
> +       local_irq_save(flags);
>         __aes_arm_decrypt(ctx->key_dec, rounds, in, out);
> +       local_irq_restore(flags);
>  }
>
>  static struct crypto_alg aes_alg = {
> diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
> index ca554d57d01e..13df33aca463 100644
> --- a/crypto/aes_generic.c
> +++ b/crypto/aes_generic.c
> @@ -63,7 +63,8 @@ static inline u8 byte(const u32 x, const unsigned n)
>
>  static const u32 rco_tab[10] = { 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 };
>
> -__visible const u32 crypto_ft_tab[4][256] = {
> +/* cacheline-aligned to facilitate prefetching into cache */
> +__visible const u32 crypto_ft_tab[4][256] __cacheline_aligned = {
>         {
>                 0xa56363c6, 0x847c7cf8, 0x997777ee, 0x8d7b7bf6,
>                 0x0df2f2ff, 0xbd6b6bd6, 0xb16f6fde, 0x54c5c591,
> @@ -327,7 +328,7 @@ __visible const u32 crypto_ft_tab[4][256] = {
>         }
>  };
>
> -__visible const u32 crypto_fl_tab[4][256] = {
> +__visible const u32 crypto_fl_tab[4][256] __cacheline_aligned = {
>         {
>                 0x00000063, 0x0000007c, 0x00000077, 0x0000007b,
>                 0x000000f2, 0x0000006b, 0x0000006f, 0x000000c5,
> @@ -591,7 +592,7 @@ __visible const u32 crypto_fl_tab[4][256] = {
>         }
>  };
>
> -__visible const u32 crypto_it_tab[4][256] = {
> +__visible const u32 crypto_it_tab[4][256] __cacheline_aligned = {
>         {
>                 0x50a7f451, 0x5365417e, 0xc3a4171a, 0x965e273a,
>                 0xcb6bab3b, 0xf1459d1f, 0xab58faac, 0x9303e34b,
> @@ -855,7 +856,7 @@ __visible const u32 crypto_it_tab[4][256] = {
>         }
>  };
>
> -__visible const u32 crypto_il_tab[4][256] = {
> +__visible const u32 crypto_il_tab[4][256] __cacheline_aligned = {
>         {
>                 0x00000052, 0x00000009, 0x0000006a, 0x000000d5,
>                 0x00000030, 0x00000036, 0x000000a5, 0x00000038,
> --
> 2.19.1
>
