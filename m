Return-Path: <SRS0=Kj53=OL=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:36950 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbeLBT53 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Dec 2018 14:57:29 -0500
Received: by mail-io1-f66.google.com with SMTP id f14so3219248iol.4
        for <linux-crypto@vger.kernel.org>; Sun, 02 Dec 2018 11:57:25 -0800 (PST)
MIME-Version: 1.0
References: <20181130203811.30269-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20181130203811.30269-1-ard.biesheuvel@linaro.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sun, 2 Dec 2018 20:57:13 +0100
Message-ID: <CAKv+Gu8zFDS_hJSB916h7eni2t8Occ0-2U_eSayZDAz-=ApwQg@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] crypto: arm64/chacha - optimize for arbitrary
 length inputs
To: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Martin Willi <martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 30 Nov 2018 at 21:38, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> Update the 4-way NEON ChaCha routine so it can handle input of any
> length >64 bytes in its entirety, rather than having to call into
> the 1-way routine and/or do memcpy()s via temp buffers to handle the
> tail of a ChaCha invocation that is not a multiple of 256 bytes.
>
> On inputs that are a multiple of 256 bytes (and thus in tcrypt
> benchmarks), performance drops by around 1% on Cortex-A57, while
> performance for inputs drawn randomly from the range [64, 1024+64)
> increases by around 30% (using ChaCha20). On Cortex-A72, performance
> gains are similar. On Cortex-A53, performance improves but only by 5%.
>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Martin Willi <martin@strongswan.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> Test program after the patch.
>

Perhaps a better benchmark below: I added 1472 byte blocks to the
tcrypt template (which should reflect the VPN case IIUC), and that
gives me (before/after)

tcrypt: test 0 (256 bit key, 16 byte blocks): 2848103 operations in 1
seconds (45569648 bytes)
tcrypt: test 1 (256 bit key, 64 byte blocks): 2840030 operations in 1
seconds (181761920 bytes)
tcrypt: test 2 (256 bit key, 256 byte blocks): 1408404 operations in 1
seconds (360551424 bytes)
tcrypt: test 3 (256 bit key, 1024 byte blocks): 390180 operations in 1
seconds (399544320 bytes)
tcrypt: test 4 (256 bit key, 1472 byte blocks): 217175 operations in 1
seconds (319681600 bytes)
tcrypt: test 5 (256 bit key, 8192 byte blocks): 49271 operations in 1
seconds (403628032 bytes)

tcrypt: test 0 (256 bit key, 16 byte blocks): 2960809 operations in 1
seconds (47372944 bytes)
tcrypt: test 1 (256 bit key, 64 byte blocks): 2970977 operations in 1
seconds (190142528 bytes)
tcrypt: test 2 (256 bit key, 256 byte blocks): 1404117 operations in 1
seconds (359453952 bytes)
tcrypt: test 3 (256 bit key, 1024 byte blocks): 390356 operations in 1
seconds (399724544 bytes)
tcrypt: test 4 (256 bit key, 1472 byte blocks): 261865 operations in 1
seconds (385465280 bytes)
tcrypt: test 5 (256 bit key, 8192 byte blocks): 49311 operations in 1
seconds (403955712 bytes)


>  arch/arm64/crypto/chacha-neon-core.S | 185 ++++++++++++++++++--
>  arch/arm64/crypto/chacha-neon-glue.c |  36 ++--
>  2 files changed, 188 insertions(+), 33 deletions(-)
>
> diff --git a/arch/arm64/crypto/chacha-neon-core.S b/arch/arm64/crypto/chacha-neon-core.S
> index 75b4e06cee79..45ffc51cb437 100644
> --- a/arch/arm64/crypto/chacha-neon-core.S
> +++ b/arch/arm64/crypto/chacha-neon-core.S
> @@ -19,6 +19,7 @@
>   */
>
>  #include <linux/linkage.h>
> +#include <asm/cache.h>
>
>         .text
>         .align          6
> @@ -164,6 +165,7 @@ ENTRY(chacha_4block_xor_neon)
>         // x1: 4 data blocks output, o
>         // x2: 4 data blocks input, i
>         // w3: nrounds
> +       // x4: byte count
>
>         //
>         // This function encrypts four consecutive ChaCha blocks by loading
> @@ -177,11 +179,11 @@ ENTRY(chacha_4block_xor_neon)
>         ld1             {v30.4s-v31.4s}, [x9]
>
>         // x0..15[0-3] = s0..3[0..3]
> -       mov             x4, x0
> -       ld4r            { v0.4s- v3.4s}, [x4], #16
> -       ld4r            { v4.4s- v7.4s}, [x4], #16
> -       ld4r            { v8.4s-v11.4s}, [x4], #16
> -       ld4r            {v12.4s-v15.4s}, [x4]
> +       mov             x8, x0
> +       ld4r            { v0.4s- v3.4s}, [x8], #16
> +       ld4r            { v4.4s- v7.4s}, [x8], #16
> +       ld4r            { v8.4s-v11.4s}, [x8], #16
> +       ld4r            {v12.4s-v15.4s}, [x8]
>
>         // x12 += counter values 0-3
>         add             v12.4s, v12.4s, v30.4s
> @@ -425,24 +427,47 @@ ENTRY(chacha_4block_xor_neon)
>         zip1            v30.4s, v14.4s, v15.4s
>         zip2            v31.4s, v14.4s, v15.4s
>
> +       mov             x3, #64
> +       subs            x5, x4, #64
> +       add             x6, x5, x2
> +       csel            x3, x3, xzr, ge
> +       csel            x2, x2, x6, ge
> +
>         // interleave 64-bit words in state n, n+2
>         zip1            v0.2d, v16.2d, v18.2d
>         zip2            v4.2d, v16.2d, v18.2d
>         zip1            v8.2d, v17.2d, v19.2d
>         zip2            v12.2d, v17.2d, v19.2d
> -       ld1             {v16.16b-v19.16b}, [x2], #64
> +       ld1             {v16.16b-v19.16b}, [x2], x3
> +
> +       subs            x6, x4, #128
> +       ccmp            x3, xzr, #4, lt
> +       add             x7, x6, x2
> +       csel            x3, x3, xzr, eq
> +       csel            x2, x2, x7, eq
>
>         zip1            v1.2d, v20.2d, v22.2d
>         zip2            v5.2d, v20.2d, v22.2d
>         zip1            v9.2d, v21.2d, v23.2d
>         zip2            v13.2d, v21.2d, v23.2d
> -       ld1             {v20.16b-v23.16b}, [x2], #64
> +       ld1             {v20.16b-v23.16b}, [x2], x3
> +
> +       subs            x7, x4, #192
> +       ccmp            x3, xzr, #4, lt
> +       add             x8, x7, x2
> +       csel            x3, x3, xzr, eq
> +       csel            x2, x2, x8, eq
>
>         zip1            v2.2d, v24.2d, v26.2d
>         zip2            v6.2d, v24.2d, v26.2d
>         zip1            v10.2d, v25.2d, v27.2d
>         zip2            v14.2d, v25.2d, v27.2d
> -       ld1             {v24.16b-v27.16b}, [x2], #64
> +       ld1             {v24.16b-v27.16b}, [x2], x3
> +
> +       subs            x8, x4, #256
> +       ccmp            x3, xzr, #4, lt
> +       add             x9, x8, x2
> +       csel            x2, x2, x9, eq
>
>         zip1            v3.2d, v28.2d, v30.2d
>         zip2            v7.2d, v28.2d, v30.2d
> @@ -451,29 +476,167 @@ ENTRY(chacha_4block_xor_neon)
>         ld1             {v28.16b-v31.16b}, [x2]
>
>         // xor with corresponding input, write to output
> +       tbnz            x5, #63, 0f
>         eor             v16.16b, v16.16b, v0.16b
>         eor             v17.16b, v17.16b, v1.16b
>         eor             v18.16b, v18.16b, v2.16b
>         eor             v19.16b, v19.16b, v3.16b
> +       st1             {v16.16b-v19.16b}, [x1], #64
> +
> +       tbnz            x6, #63, 1f
>         eor             v20.16b, v20.16b, v4.16b
>         eor             v21.16b, v21.16b, v5.16b
> -       st1             {v16.16b-v19.16b}, [x1], #64
>         eor             v22.16b, v22.16b, v6.16b
>         eor             v23.16b, v23.16b, v7.16b
> +       st1             {v20.16b-v23.16b}, [x1], #64
> +
> +       tbnz            x7, #63, 2f
>         eor             v24.16b, v24.16b, v8.16b
>         eor             v25.16b, v25.16b, v9.16b
> -       st1             {v20.16b-v23.16b}, [x1], #64
>         eor             v26.16b, v26.16b, v10.16b
>         eor             v27.16b, v27.16b, v11.16b
> -       eor             v28.16b, v28.16b, v12.16b
>         st1             {v24.16b-v27.16b}, [x1], #64
> +
> +       tbnz            x8, #63, 3f
> +       eor             v28.16b, v28.16b, v12.16b
>         eor             v29.16b, v29.16b, v13.16b
>         eor             v30.16b, v30.16b, v14.16b
>         eor             v31.16b, v31.16b, v15.16b
>         st1             {v28.16b-v31.16b}, [x1]
>
>         ret
> +
> +       // fewer than 64 bytes of in/output
> +0:     adr             x12, .Lpermute
> +       add             x12, x12, x5
> +       sub             x2, x1, #64
> +       add             x1, x1, x5
> +       add             x13, x12, #64
> +       ld1             {v8.16b}, [x12]
> +       ld1             {v9.16b}, [x13]
> +       movi            v10.16b, #16
> +
> +       ld1             {v16.16b-v19.16b}, [x2]
> +       tbl             v4.16b, {v0.16b-v3.16b}, v8.16b
> +       tbx             v20.16b, {v16.16b-v19.16b}, v9.16b
> +       add             v8.16b, v8.16b, v10.16b
> +       add             v9.16b, v9.16b, v10.16b
> +       tbl             v5.16b, {v0.16b-v3.16b}, v8.16b
> +       tbx             v21.16b, {v16.16b-v19.16b}, v9.16b
> +       add             v8.16b, v8.16b, v10.16b
> +       add             v9.16b, v9.16b, v10.16b
> +       tbl             v6.16b, {v0.16b-v3.16b}, v8.16b
> +       tbx             v22.16b, {v16.16b-v19.16b}, v9.16b
> +       add             v8.16b, v8.16b, v10.16b
> +       add             v9.16b, v9.16b, v10.16b
> +       tbl             v7.16b, {v0.16b-v3.16b}, v8.16b
> +       tbx             v23.16b, {v16.16b-v19.16b}, v9.16b
> +
> +       eor             v20.16b, v20.16b, v4.16b
> +       eor             v21.16b, v21.16b, v5.16b
> +       eor             v22.16b, v22.16b, v6.16b
> +       eor             v23.16b, v23.16b, v7.16b
> +       st1             {v20.16b-v23.16b}, [x1]
> +       ret
> +
> +       // fewer than 128 bytes of in/output
> +1:     adr             x12, .Lpermute
> +       add             x12, x12, x6
> +       add             x1, x1, x6
> +       add             x13, x12, #64
> +       ld1             {v8.16b}, [x12]
> +       ld1             {v9.16b}, [x13]
> +       movi            v10.16b, #16
> +       tbl             v0.16b, {v4.16b-v7.16b}, v8.16b
> +       tbx             v20.16b, {v16.16b-v19.16b}, v9.16b
> +       add             v8.16b, v8.16b, v10.16b
> +       add             v9.16b, v9.16b, v10.16b
> +       tbl             v1.16b, {v4.16b-v7.16b}, v8.16b
> +       tbx             v21.16b, {v16.16b-v19.16b}, v9.16b
> +       add             v8.16b, v8.16b, v10.16b
> +       add             v9.16b, v9.16b, v10.16b
> +       tbl             v2.16b, {v4.16b-v7.16b}, v8.16b
> +       tbx             v22.16b, {v16.16b-v19.16b}, v9.16b
> +       add             v8.16b, v8.16b, v10.16b
> +       add             v9.16b, v9.16b, v10.16b
> +       tbl             v3.16b, {v4.16b-v7.16b}, v8.16b
> +       tbx             v23.16b, {v16.16b-v19.16b}, v9.16b
> +
> +       eor             v20.16b, v20.16b, v0.16b
> +       eor             v21.16b, v21.16b, v1.16b
> +       eor             v22.16b, v22.16b, v2.16b
> +       eor             v23.16b, v23.16b, v3.16b
> +       st1             {v20.16b-v23.16b}, [x1]
> +       ret
> +
> +       // fewer than 192 bytes of in/output
> +2:     adr             x12, .Lpermute
> +       add             x12, x12, x7
> +       add             x1, x1, x7
> +       add             x13, x12, #64
> +       ld1             {v4.16b}, [x12]
> +       ld1             {v5.16b}, [x13]
> +       movi            v6.16b, #16
> +       tbl             v0.16b, {v8.16b-v11.16b}, v4.16b
> +       tbx             v24.16b, {v20.16b-v23.16b}, v5.16b
> +       add             v4.16b, v4.16b, v6.16b
> +       add             v5.16b, v5.16b, v6.16b
> +       tbl             v1.16b, {v8.16b-v11.16b}, v4.16b
> +       tbx             v25.16b, {v20.16b-v23.16b}, v5.16b
> +       add             v4.16b, v4.16b, v6.16b
> +       add             v5.16b, v5.16b, v6.16b
> +       tbl             v2.16b, {v8.16b-v11.16b}, v4.16b
> +       tbx             v26.16b, {v20.16b-v23.16b}, v5.16b
> +       add             v4.16b, v4.16b, v6.16b
> +       add             v5.16b, v5.16b, v6.16b
> +       tbl             v3.16b, {v8.16b-v11.16b}, v4.16b
> +       tbx             v27.16b, {v20.16b-v23.16b}, v5.16b
> +
> +       eor             v24.16b, v24.16b, v0.16b
> +       eor             v25.16b, v25.16b, v1.16b
> +       eor             v26.16b, v26.16b, v2.16b
> +       eor             v27.16b, v27.16b, v3.16b
> +       st1             {v24.16b-v27.16b}, [x1]
> +       ret
> +
> +       // fewer than 256 bytes of in/output
> +3:     adr             x12, .Lpermute
> +       add             x12, x12, x8
> +       add             x1, x1, x8
> +       add             x13, x12, #64
> +       ld1             {v4.16b}, [x12]
> +       ld1             {v5.16b}, [x13]
> +       movi            v6.16b, #16
> +       tbl             v0.16b, {v12.16b-v15.16b}, v4.16b
> +       tbx             v28.16b, {v24.16b-v27.16b}, v5.16b
> +       add             v4.16b, v4.16b, v6.16b
> +       add             v5.16b, v5.16b, v6.16b
> +       tbl             v1.16b, {v12.16b-v15.16b}, v4.16b
> +       tbx             v29.16b, {v24.16b-v27.16b}, v5.16b
> +       add             v4.16b, v4.16b, v6.16b
> +       add             v5.16b, v5.16b, v6.16b
> +       tbl             v2.16b, {v12.16b-v15.16b}, v4.16b
> +       tbx             v30.16b, {v24.16b-v27.16b}, v5.16b
> +       add             v4.16b, v4.16b, v6.16b
> +       add             v5.16b, v5.16b, v6.16b
> +       tbl             v3.16b, {v12.16b-v15.16b}, v4.16b
> +       tbx             v31.16b, {v24.16b-v27.16b}, v5.16b
> +
> +       eor             v28.16b, v28.16b, v0.16b
> +       eor             v29.16b, v29.16b, v1.16b
> +       eor             v30.16b, v30.16b, v2.16b
> +       eor             v31.16b, v31.16b, v3.16b
> +       st1             {v28.16b-v31.16b}, [x1]
> +       ret
>  ENDPROC(chacha_4block_xor_neon)
>
>  CTRINC:        .word           0, 1, 2, 3
>  ROT8:  .word           0x02010003, 0x06050407, 0x0a09080b, 0x0e0d0c0f
> +
> +       .align          L1_CACHE_SHIFT
> +       .set            .Lpermute, . + 64
> +       .set            .Li, 0
> +       .rept           192
> +       .byte           (.Li - 64)
> +       .set            .Li, .Li + 1
> +       .endr
> diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
> index 346eb85498a1..458d9b36cf9d 100644
> --- a/arch/arm64/crypto/chacha-neon-glue.c
> +++ b/arch/arm64/crypto/chacha-neon-glue.c
> @@ -32,41 +32,33 @@
>  asmlinkage void chacha_block_xor_neon(u32 *state, u8 *dst, const u8 *src,
>                                       int nrounds);
>  asmlinkage void chacha_4block_xor_neon(u32 *state, u8 *dst, const u8 *src,
> -                                      int nrounds);
> +                                      int nrounds, int bytes);
>  asmlinkage void hchacha_block_neon(const u32 *state, u32 *out, int nrounds);
>
>  static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
> -                         unsigned int bytes, int nrounds)
> +                         int bytes, int nrounds)
>  {
>         u8 buf[CHACHA_BLOCK_SIZE];
>
> -       while (bytes >= CHACHA_BLOCK_SIZE * 4) {
> +       if (bytes < CHACHA_BLOCK_SIZE) {
> +               memcpy(buf, src, bytes);
>                 kernel_neon_begin();
> -               chacha_4block_xor_neon(state, dst, src, nrounds);
> +               chacha_block_xor_neon(state, buf, buf, nrounds);
> +               kernel_neon_end();
> +               memcpy(dst, buf, bytes);
> +               return;
> +       }
> +
> +       while (bytes > 0) {
> +               kernel_neon_begin();
> +               chacha_4block_xor_neon(state, dst, src, nrounds,
> +                                      min(bytes, CHACHA_BLOCK_SIZE * 4));
>                 kernel_neon_end();
>                 bytes -= CHACHA_BLOCK_SIZE * 4;
>                 src += CHACHA_BLOCK_SIZE * 4;
>                 dst += CHACHA_BLOCK_SIZE * 4;
>                 state[12] += 4;
>         }
> -
> -       if (!bytes)
> -               return;
> -
> -       kernel_neon_begin();
> -       while (bytes >= CHACHA_BLOCK_SIZE) {
> -               chacha_block_xor_neon(state, dst, src, nrounds);
> -               bytes -= CHACHA_BLOCK_SIZE;
> -               src += CHACHA_BLOCK_SIZE;
> -               dst += CHACHA_BLOCK_SIZE;
> -               state[12]++;
> -       }
> -       if (bytes) {
> -               memcpy(buf, src, bytes);
> -               chacha_block_xor_neon(state, buf, buf, nrounds);
> -               memcpy(dst, buf, bytes);
> -       }
> -       kernel_neon_end();
>  }
>
>  static int chacha_neon_stream_xor(struct skcipher_request *req,
> --
> 2.19.1
>
>
> #include <stdlib.h>
> #include <string.h>
>
> extern void chacha_4block_xor_neon(unsigned int *state, unsigned char *dst,
>                                    unsigned char *src, int rounds, int bytes);
>
> extern void chacha_block_xor_neon(unsigned int *state, unsigned char *dst,
>                                   unsigned char *src, int rounds);
>
> int main(void)
> {
>         static char buf[1024];
>         unsigned int state[64];
>
>         srand(20181130);
>
>         for (int i = 0; i < 10 * 1000 * 1000; i++) {
>                 int l = 64 + rand() % (1024 - 64);
>
> #ifdef NEW
>                 while (l > 0) {
>                         chacha_4block_xor_neon(state, buf, buf, 20,
>                                                l > 256 ? 256 : l);
>                         l -= 256;
>                 }
> #else
>                 while (l >= 256) {
>                         chacha_4block_xor_neon(state, buf, buf, 20, 256);
>                         l -= 256;
>                 }
>                 while (l >= 64) {
>                         chacha_block_xor_neon(state, buf, buf, 20);
>                         l -= 64;
>                 }
>                 if (l > 0) {
>                         unsigned char tmp[64];
>
>                         memcpy(tmp, buf, l);
>                         chacha_block_xor_neon(state, tmp, tmp, 20);
>                         memcpy(buf, tmp, l);
>                 }
> #endif
>         }
>
>         return 0;
> }
