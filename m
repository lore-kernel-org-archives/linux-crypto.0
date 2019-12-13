Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDE4C751F4
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EAE6247D0
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:39:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g4B6xNwW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfLMQMb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Dec 2019 11:12:31 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36360 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbfLMQMb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Dec 2019 11:12:31 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so21164wru.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Dec 2019 08:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SrVo+ZIc/NfSFRgawxAVcQf2YAkFHM22jdPAUHR72UA=;
        b=g4B6xNwWYBi+29SOTVWrsdyi/gow01ov9XktmDorS1/8eYtIPzylUZRy0cRCfWYbAZ
         Mwn6I/i3VQq+DnNHlIBxfJ4r7S5pgX4IHe0T4ZoULYSNFpUZd9Cl/fhRHAWKbRt0jaXQ
         ozHiGzxIhQrHp0Xc+YTrmVV8t1z0O6Fh30roZ9EWynK/fUHxWjrtwq/lEBHmsE8KriB1
         LbUsYlT7hJHQlz5JxmNSeEMi+44S2o8Y05pqtlwF0L8rwha5DLod8h1fx0H0vN46EU26
         rzZ3FhrLI+L6d4EbmNsZk6CRWN01QV3vPqhLgdLsnxhEqUUxEqHb5NgdQDjUi8zZgR7a
         WQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SrVo+ZIc/NfSFRgawxAVcQf2YAkFHM22jdPAUHR72UA=;
        b=QushcuWB7neX0EmvUXjsTj1TAvQTG+S1jMrGfTMmbVqSZSHN2jrYRU9/Ffq5aWeuXh
         mkUXyRFdSnnpDusol/5I6Ek5Rmh7X6v5e8E71HUm2YgYO8Xj5Ru7vNKJmpI8o8aHsPNI
         5hp41Ujty74dSN2oE3mPaI+FbCZWGQC44UkZKHKTiXNGPPyL15RVv2nzIilRi0q75MdA
         yzEx0m9D63F+utYjYJ72rmJQDtASVqj5e36KPC/zaDxg9PgjU1iw6y0RKWwmYaIWdOB8
         xf66N+zs4ERA247MD/bX8ZUxdkGxOipBrXcoL6DD5fnJ5wu+WYzaLWxO6/GhvaQ8Mvxm
         oaKQ==
X-Gm-Message-State: APjAAAWiAJNqpYD9LSQ42B4fq37C01biOX4VskFU5ZuiWRLyNC3VQwSJ
        cTcakhNVetsXlcdrHJpDIxKbgyFh6IU6hu4BB1XAxg==
X-Google-Smtp-Source: APXvYqxK5IJhD/Op+d93+5Ov25lg6j1e5zUY1ZV+Xa+0NDae0NVxLi4JFbEsAa8izXynyeovdr00Kh/NJ4EY8SHJ9R4=
X-Received: by 2002:adf:cf0a:: with SMTP id o10mr13048391wrj.325.1576253545861;
 Fri, 13 Dec 2019 08:12:25 -0800 (PST)
MIME-Version: 1.0
References: <20191213154910.32479-1-broonie@kernel.org>
In-Reply-To: <20191213154910.32479-1-broonie@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 13 Dec 2019 17:12:14 +0100
Message-ID: <CAKv+Gu_V2wAwkRMHh1EaBSQozAAFL3x=MKtmnhY03evEaEKiCQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: crypto: Use modern annotations for assembly functions
To:     Mark Brown <broonie@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 13 Dec 2019 at 16:49, Mark Brown <broonie@kernel.org> wrote:
>
> In an effort to clarify and simplify the annotation of assembly functions
> in the kernel new macros have been introduced. These replace ENTRY and
> ENDPROC and also add a new annotation for static functions which previously
> had no ENTRY equivalent. Update the annotations in the crypto code to the
> new macros.
>
> There are a small number of files imported from OpenSSL where the assembly
> is generated using perl programs, these are not currently annotated at all
> and have not been modified.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Seems straightforward enough.

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>
> I'm intending to do this for all the rest of the asm too, this is the
> simplest directory and there's no direct interdependencies so starting
> here.
>

It will also go through another tree, so good to keep this separate.


>  arch/arm64/crypto/aes-ce-ccm-core.S   | 16 +++++------
>  arch/arm64/crypto/aes-ce-core.S       | 16 +++++------
>  arch/arm64/crypto/aes-ce.S            |  4 +--
>  arch/arm64/crypto/aes-cipher-core.S   |  8 +++---
>  arch/arm64/crypto/aes-modes.S         | 16 +++++------
>  arch/arm64/crypto/aes-neon.S          |  4 +--
>  arch/arm64/crypto/aes-neonbs-core.S   | 40 +++++++++++++--------------
>  arch/arm64/crypto/chacha-neon-core.S  | 16 +++++------
>  arch/arm64/crypto/crct10dif-ce-core.S | 12 ++++----
>  arch/arm64/crypto/ghash-ce-core.S     |  8 +++---
>  arch/arm64/crypto/nh-neon-core.S      |  4 +--
>  arch/arm64/crypto/sha1-ce-core.S      |  4 +--
>  arch/arm64/crypto/sha2-ce-core.S      |  4 +--
>  arch/arm64/crypto/sha3-ce-core.S      |  4 +--
>  arch/arm64/crypto/sha512-ce-core.S    |  4 +--
>  arch/arm64/crypto/sm3-ce-core.S       |  4 +--
>  arch/arm64/crypto/sm4-ce-core.S       |  4 +--
>  17 files changed, 84 insertions(+), 84 deletions(-)
>
> diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
> index 9add9bbc48d8..99a028e298ed 100644
> --- a/arch/arm64/crypto/aes-ce-ccm-core.S
> +++ b/arch/arm64/crypto/aes-ce-ccm-core.S
> @@ -15,7 +15,7 @@
>          * void ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
>          *                           u32 *macp, u8 const rk[], u32 rounds);
>          */
> -ENTRY(ce_aes_ccm_auth_data)
> +SYM_FUNC_START(ce_aes_ccm_auth_data)
>         ldr     w8, [x3]                        /* leftover from prev round? */
>         ld1     {v0.16b}, [x0]                  /* load mac */
>         cbz     w8, 1f
> @@ -81,13 +81,13 @@ ENTRY(ce_aes_ccm_auth_data)
>         st1     {v0.16b}, [x0]
>  10:    str     w8, [x3]
>         ret
> -ENDPROC(ce_aes_ccm_auth_data)
> +SYM_FUNC_END(ce_aes_ccm_auth_data)
>
>         /*
>          * void ce_aes_ccm_final(u8 mac[], u8 const ctr[], u8 const rk[],
>          *                       u32 rounds);
>          */
> -ENTRY(ce_aes_ccm_final)
> +SYM_FUNC_START(ce_aes_ccm_final)
>         ld1     {v3.4s}, [x2], #16              /* load first round key */
>         ld1     {v0.16b}, [x0]                  /* load mac */
>         cmp     w3, #12                         /* which key size? */
> @@ -121,7 +121,7 @@ ENTRY(ce_aes_ccm_final)
>         eor     v0.16b, v0.16b, v1.16b          /* en-/decrypt the mac */
>         st1     {v0.16b}, [x0]                  /* store result */
>         ret
> -ENDPROC(ce_aes_ccm_final)
> +SYM_FUNC_END(ce_aes_ccm_final)
>
>         .macro  aes_ccm_do_crypt,enc
>         ldr     x8, [x6, #8]                    /* load lower ctr */
> @@ -212,10 +212,10 @@ CPU_LE(   rev     x8, x8                  )
>          *                         u8 const rk[], u32 rounds, u8 mac[],
>          *                         u8 ctr[]);
>          */
> -ENTRY(ce_aes_ccm_encrypt)
> +SYM_FUNC_START(ce_aes_ccm_encrypt)
>         aes_ccm_do_crypt        1
> -ENDPROC(ce_aes_ccm_encrypt)
> +SYM_FUNC_END(ce_aes_ccm_encrypt)
>
> -ENTRY(ce_aes_ccm_decrypt)
> +SYM_FUNC_START(ce_aes_ccm_decrypt)
>         aes_ccm_do_crypt        0
> -ENDPROC(ce_aes_ccm_decrypt)
> +SYM_FUNC_END(ce_aes_ccm_decrypt)
> diff --git a/arch/arm64/crypto/aes-ce-core.S b/arch/arm64/crypto/aes-ce-core.S
> index 76a30fe4ba8b..e52e13eb8fdb 100644
> --- a/arch/arm64/crypto/aes-ce-core.S
> +++ b/arch/arm64/crypto/aes-ce-core.S
> @@ -8,7 +8,7 @@
>
>         .arch           armv8-a+crypto
>
> -ENTRY(__aes_ce_encrypt)
> +SYM_FUNC_START(__aes_ce_encrypt)
>         sub             w3, w3, #2
>         ld1             {v0.16b}, [x2]
>         ld1             {v1.4s}, [x0], #16
> @@ -34,9 +34,9 @@ ENTRY(__aes_ce_encrypt)
>         eor             v0.16b, v0.16b, v3.16b
>         st1             {v0.16b}, [x1]
>         ret
> -ENDPROC(__aes_ce_encrypt)
> +SYM_FUNC_END(__aes_ce_encrypt)
>
> -ENTRY(__aes_ce_decrypt)
> +SYM_FUNC_START(__aes_ce_decrypt)
>         sub             w3, w3, #2
>         ld1             {v0.16b}, [x2]
>         ld1             {v1.4s}, [x0], #16
> @@ -62,23 +62,23 @@ ENTRY(__aes_ce_decrypt)
>         eor             v0.16b, v0.16b, v3.16b
>         st1             {v0.16b}, [x1]
>         ret
> -ENDPROC(__aes_ce_decrypt)
> +SYM_FUNC_END(__aes_ce_decrypt)
>
>  /*
>   * __aes_ce_sub() - use the aese instruction to perform the AES sbox
>   *                  substitution on each byte in 'input'
>   */
> -ENTRY(__aes_ce_sub)
> +SYM_FUNC_START(__aes_ce_sub)
>         dup             v1.4s, w0
>         movi            v0.16b, #0
>         aese            v0.16b, v1.16b
>         umov            w0, v0.s[0]
>         ret
> -ENDPROC(__aes_ce_sub)
> +SYM_FUNC_END(__aes_ce_sub)
>
> -ENTRY(__aes_ce_invert)
> +SYM_FUNC_START(__aes_ce_invert)
>         ld1             {v0.4s}, [x1]
>         aesimc          v1.16b, v0.16b
>         st1             {v1.4s}, [x0]
>         ret
> -ENDPROC(__aes_ce_invert)
> +SYM_FUNC_END(__aes_ce_invert)
> diff --git a/arch/arm64/crypto/aes-ce.S b/arch/arm64/crypto/aes-ce.S
> index c132c49c89a8..45062553467f 100644
> --- a/arch/arm64/crypto/aes-ce.S
> +++ b/arch/arm64/crypto/aes-ce.S
> @@ -9,8 +9,8 @@
>  #include <linux/linkage.h>
>  #include <asm/assembler.h>
>
> -#define AES_ENTRY(func)                ENTRY(ce_ ## func)
> -#define AES_ENDPROC(func)      ENDPROC(ce_ ## func)
> +#define AES_ENTRY(func)                SYM_FUNC_START(ce_ ## func)
> +#define AES_ENDPROC(func)      SYM_FUNC_END(ce_ ## func)
>
>         .arch           armv8-a+crypto
>
> diff --git a/arch/arm64/crypto/aes-cipher-core.S b/arch/arm64/crypto/aes-cipher-core.S
> index 423d0aebc570..c9d6955f8404 100644
> --- a/arch/arm64/crypto/aes-cipher-core.S
> +++ b/arch/arm64/crypto/aes-cipher-core.S
> @@ -122,11 +122,11 @@ CPU_BE(   rev             w7, w7          )
>         ret
>         .endm
>
> -ENTRY(__aes_arm64_encrypt)
> +SYM_FUNC_START(__aes_arm64_encrypt)
>         do_crypt        fround, crypto_ft_tab, crypto_ft_tab + 1, 2
> -ENDPROC(__aes_arm64_encrypt)
> +SYM_FUNC_END(__aes_arm64_encrypt)
>
>         .align          5
> -ENTRY(__aes_arm64_decrypt)
> +SYM_FUNC_START(__aes_arm64_decrypt)
>         do_crypt        iround, crypto_it_tab, crypto_aes_inv_sbox, 0
> -ENDPROC(__aes_arm64_decrypt)
> +SYM_FUNC_END(__aes_arm64_decrypt)
> diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
> index 131618389f1f..8a2faa42b57e 100644
> --- a/arch/arm64/crypto/aes-modes.S
> +++ b/arch/arm64/crypto/aes-modes.S
> @@ -22,26 +22,26 @@
>  #define ST5(x...) x
>  #endif
>
> -aes_encrypt_block4x:
> +SYM_FUNC_START_LOCAL(aes_encrypt_block4x)
>         encrypt_block4x v0, v1, v2, v3, w3, x2, x8, w7
>         ret
> -ENDPROC(aes_encrypt_block4x)
> +SYM_FUNC_END(aes_encrypt_block4x)
>
> -aes_decrypt_block4x:
> +SYM_FUNC_START_LOCAL(aes_decrypt_block4x)
>         decrypt_block4x v0, v1, v2, v3, w3, x2, x8, w7
>         ret
> -ENDPROC(aes_decrypt_block4x)
> +SYM_FUNC_END(aes_decrypt_block4x)
>
>  #if MAX_STRIDE == 5
> -aes_encrypt_block5x:
> +SYM_FUNC_START_LOCAL(aes_encrypt_block5x)
>         encrypt_block5x v0, v1, v2, v3, v4, w3, x2, x8, w7
>         ret
> -ENDPROC(aes_encrypt_block5x)
> +SYM_FUNC_END(aes_encrypt_block5x)
>
> -aes_decrypt_block5x:
> +SYM_FUNC_START_LOCAL(aes_decrypt_block5x)
>         decrypt_block5x v0, v1, v2, v3, v4, w3, x2, x8, w7
>         ret
> -ENDPROC(aes_decrypt_block5x)
> +SYM_FUNC_END(aes_decrypt_block5x)
>  #endif
>
>         /*
> diff --git a/arch/arm64/crypto/aes-neon.S b/arch/arm64/crypto/aes-neon.S
> index 22d9b110cf78..247d34ddaab0 100644
> --- a/arch/arm64/crypto/aes-neon.S
> +++ b/arch/arm64/crypto/aes-neon.S
> @@ -8,8 +8,8 @@
>  #include <linux/linkage.h>
>  #include <asm/assembler.h>
>
> -#define AES_ENTRY(func)                ENTRY(neon_ ## func)
> -#define AES_ENDPROC(func)      ENDPROC(neon_ ## func)
> +#define AES_ENTRY(func)                SYM_FUNC_START(neon_ ## func)
> +#define AES_ENDPROC(func)      SYM_FUNC_END(neon_ ## func)
>
>         xtsmask         .req    v7
>         cbciv           .req    v7
> diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
> index 65982039fa36..b357164379f6 100644
> --- a/arch/arm64/crypto/aes-neonbs-core.S
> +++ b/arch/arm64/crypto/aes-neonbs-core.S
> @@ -380,7 +380,7 @@ ISRM0:      .octa           0x0306090c00070a0d01040b0e0205080f
>         /*
>          * void aesbs_convert_key(u8 out[], u32 const rk[], int rounds)
>          */
> -ENTRY(aesbs_convert_key)
> +SYM_FUNC_START(aesbs_convert_key)
>         ld1             {v7.4s}, [x1], #16              // load round 0 key
>         ld1             {v17.4s}, [x1], #16             // load round 1 key
>
> @@ -425,10 +425,10 @@ ENTRY(aesbs_convert_key)
>         eor             v17.16b, v17.16b, v7.16b
>         str             q17, [x0]
>         ret
> -ENDPROC(aesbs_convert_key)
> +SYM_FUNC_END(aesbs_convert_key)
>
>         .align          4
> -aesbs_encrypt8:
> +SYM_FUNC_START_LOCAL(aesbs_encrypt8)
>         ldr             q9, [bskey], #16                // round 0 key
>         ldr             q8, M0SR
>         ldr             q24, SR
> @@ -488,10 +488,10 @@ aesbs_encrypt8:
>         eor             v2.16b, v2.16b, v12.16b
>         eor             v5.16b, v5.16b, v12.16b
>         ret
> -ENDPROC(aesbs_encrypt8)
> +SYM_FUNC_END(aesbs_encrypt8)
>
>         .align          4
> -aesbs_decrypt8:
> +SYM_FUNC_START_LOCAL(aesbs_decrypt8)
>         lsl             x9, rounds, #7
>         add             bskey, bskey, x9
>
> @@ -553,7 +553,7 @@ aesbs_decrypt8:
>         eor             v3.16b, v3.16b, v12.16b
>         eor             v5.16b, v5.16b, v12.16b
>         ret
> -ENDPROC(aesbs_decrypt8)
> +SYM_FUNC_END(aesbs_decrypt8)
>
>         /*
>          * aesbs_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
> @@ -621,21 +621,21 @@ ENDPROC(aesbs_decrypt8)
>         .endm
>
>         .align          4
> -ENTRY(aesbs_ecb_encrypt)
> +SYM_FUNC_START(aesbs_ecb_encrypt)
>         __ecb_crypt     aesbs_encrypt8, v0, v1, v4, v6, v3, v7, v2, v5
> -ENDPROC(aesbs_ecb_encrypt)
> +SYM_FUNC_END(aesbs_ecb_encrypt)
>
>         .align          4
> -ENTRY(aesbs_ecb_decrypt)
> +SYM_FUNC_START(aesbs_ecb_decrypt)
>         __ecb_crypt     aesbs_decrypt8, v0, v1, v6, v4, v2, v7, v3, v5
> -ENDPROC(aesbs_ecb_decrypt)
> +SYM_FUNC_END(aesbs_ecb_decrypt)
>
>         /*
>          * aesbs_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
>          *                   int blocks, u8 iv[])
>          */
>         .align          4
> -ENTRY(aesbs_cbc_decrypt)
> +SYM_FUNC_START(aesbs_cbc_decrypt)
>         frame_push      6
>
>         mov             x19, x0
> @@ -720,7 +720,7 @@ ENTRY(aesbs_cbc_decrypt)
>
>  2:     frame_pop
>         ret
> -ENDPROC(aesbs_cbc_decrypt)
> +SYM_FUNC_END(aesbs_cbc_decrypt)
>
>         .macro          next_tweak, out, in, const, tmp
>         sshr            \tmp\().2d,  \in\().2d,   #63
> @@ -736,7 +736,7 @@ ENDPROC(aesbs_cbc_decrypt)
>          * aesbs_xts_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
>          *                   int blocks, u8 iv[])
>          */
> -__xts_crypt8:
> +SYM_FUNC_START_LOCAL(__xts_crypt8)
>         mov             x6, #1
>         lsl             x6, x6, x23
>         subs            w23, w23, #8
> @@ -789,7 +789,7 @@ __xts_crypt8:
>  0:     mov             bskey, x21
>         mov             rounds, x22
>         br              x7
> -ENDPROC(__xts_crypt8)
> +SYM_FUNC_END(__xts_crypt8)
>
>         .macro          __xts_crypt, do8, o0, o1, o2, o3, o4, o5, o6, o7
>         frame_push      6, 64
> @@ -854,13 +854,13 @@ ENDPROC(__xts_crypt8)
>         ret
>         .endm
>
> -ENTRY(aesbs_xts_encrypt)
> +SYM_FUNC_START(aesbs_xts_encrypt)
>         __xts_crypt     aesbs_encrypt8, v0, v1, v4, v6, v3, v7, v2, v5
> -ENDPROC(aesbs_xts_encrypt)
> +SYM_FUNC_END(aesbs_xts_encrypt)
>
> -ENTRY(aesbs_xts_decrypt)
> +SYM_FUNC_START(aesbs_xts_decrypt)
>         __xts_crypt     aesbs_decrypt8, v0, v1, v6, v4, v2, v7, v3, v5
> -ENDPROC(aesbs_xts_decrypt)
> +SYM_FUNC_END(aesbs_xts_decrypt)
>
>         .macro          next_ctr, v
>         mov             \v\().d[1], x8
> @@ -874,7 +874,7 @@ ENDPROC(aesbs_xts_decrypt)
>          * aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
>          *                   int rounds, int blocks, u8 iv[], u8 final[])
>          */
> -ENTRY(aesbs_ctr_encrypt)
> +SYM_FUNC_START(aesbs_ctr_encrypt)
>         frame_push      8
>
>         mov             x19, x0
> @@ -1002,4 +1002,4 @@ CPU_LE(   rev             x8, x8          )
>  7:     cbz             x25, 8b
>         st1             {v5.16b}, [x25]
>         b               8b
> -ENDPROC(aesbs_ctr_encrypt)
> +SYM_FUNC_END(aesbs_ctr_encrypt)
> diff --git a/arch/arm64/crypto/chacha-neon-core.S b/arch/arm64/crypto/chacha-neon-core.S
> index 706c4e10e9e2..e90386a7db8e 100644
> --- a/arch/arm64/crypto/chacha-neon-core.S
> +++ b/arch/arm64/crypto/chacha-neon-core.S
> @@ -36,7 +36,7 @@
>   *
>   * Clobbers: w3, x10, v4, v12
>   */
> -chacha_permute:
> +SYM_FUNC_START_LOCAL(chacha_permute)
>
>         adr_l           x10, ROT8
>         ld1             {v12.4s}, [x10]
> @@ -104,9 +104,9 @@ chacha_permute:
>         b.ne            .Ldoubleround
>
>         ret
> -ENDPROC(chacha_permute)
> +SYM_FUNC_END(chacha_permute)
>
> -ENTRY(chacha_block_xor_neon)
> +SYM_FUNC_START(chacha_block_xor_neon)
>         // x0: Input state matrix, s
>         // x1: 1 data block output, o
>         // x2: 1 data block input, i
> @@ -143,9 +143,9 @@ ENTRY(chacha_block_xor_neon)
>
>         ldp             x29, x30, [sp], #16
>         ret
> -ENDPROC(chacha_block_xor_neon)
> +SYM_FUNC_END(chacha_block_xor_neon)
>
> -ENTRY(hchacha_block_neon)
> +SYM_FUNC_START(hchacha_block_neon)
>         // x0: Input state matrix, s
>         // x1: output (8 32-bit words)
>         // w2: nrounds
> @@ -163,7 +163,7 @@ ENTRY(hchacha_block_neon)
>
>         ldp             x29, x30, [sp], #16
>         ret
> -ENDPROC(hchacha_block_neon)
> +SYM_FUNC_END(hchacha_block_neon)
>
>         a0              .req    w12
>         a1              .req    w13
> @@ -183,7 +183,7 @@ ENDPROC(hchacha_block_neon)
>         a15             .req    w28
>
>         .align          6
> -ENTRY(chacha_4block_xor_neon)
> +SYM_FUNC_START(chacha_4block_xor_neon)
>         frame_push      10
>
>         // x0: Input state matrix, s
> @@ -845,7 +845,7 @@ CPU_BE(       rev           a15, a15        )
>         eor             v31.16b, v31.16b, v3.16b
>         st1             {v28.16b-v31.16b}, [x1]
>         b               .Lout
> -ENDPROC(chacha_4block_xor_neon)
> +SYM_FUNC_END(chacha_4block_xor_neon)
>
>         .section        ".rodata", "a", %progbits
>         .align          L1_CACHE_SHIFT
> diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
> index e545b42e6a46..5a95c2628fbf 100644
> --- a/arch/arm64/crypto/crct10dif-ce-core.S
> +++ b/arch/arm64/crypto/crct10dif-ce-core.S
> @@ -131,7 +131,7 @@
>         tbl             bd4.16b, {\bd\().16b}, perm4.16b
>         .endm
>
> -__pmull_p8_core:
> +SYM_FUNC_START_LOCAL(__pmull_p8_core)
>  .L__pmull_p8_core:
>         ext             t4.8b, ad.8b, ad.8b, #1                 // A1
>         ext             t5.8b, ad.8b, ad.8b, #2                 // A2
> @@ -194,7 +194,7 @@ __pmull_p8_core:
>         eor             t4.16b, t4.16b, t5.16b
>         eor             t6.16b, t6.16b, t3.16b
>         ret
> -ENDPROC(__pmull_p8_core)
> +SYM_FUNC_END(__pmull_p8_core)
>
>         .macro          __pmull_p8, rq, ad, bd, i
>         .ifnc           \bd, fold_consts
> @@ -488,9 +488,9 @@ CPU_LE(     ext             v7.16b, v7.16b, v7.16b, #8      )
>  //
>  // Assumes len >= 16.
>  //
> -ENTRY(crc_t10dif_pmull_p8)
> +SYM_FUNC_START(crc_t10dif_pmull_p8)
>         crc_t10dif_pmull        p8
> -ENDPROC(crc_t10dif_pmull_p8)
> +SYM_FUNC_END(crc_t10dif_pmull_p8)
>
>         .align          5
>  //
> @@ -498,9 +498,9 @@ ENDPROC(crc_t10dif_pmull_p8)
>  //
>  // Assumes len >= 16.
>  //
> -ENTRY(crc_t10dif_pmull_p64)
> +SYM_FUNC_START(crc_t10dif_pmull_p64)
>         crc_t10dif_pmull        p64
> -ENDPROC(crc_t10dif_pmull_p64)
> +SYM_FUNC_END(crc_t10dif_pmull_p64)
>
>         .section        ".rodata", "a"
>         .align          4
> diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
> index a791c4adf8e6..084c6a30b03a 100644
> --- a/arch/arm64/crypto/ghash-ce-core.S
> +++ b/arch/arm64/crypto/ghash-ce-core.S
> @@ -350,13 +350,13 @@ CPU_LE(   rev64           T1.16b, T1.16b  )
>          * void pmull_ghash_update(int blocks, u64 dg[], const char *src,
>          *                         struct ghash_key const *k, const char *head)
>          */
> -ENTRY(pmull_ghash_update_p64)
> +SYM_FUNC_START(pmull_ghash_update_p64)
>         __pmull_ghash   p64
> -ENDPROC(pmull_ghash_update_p64)
> +SYM_FUNC_END(pmull_ghash_update_p64)
>
> -ENTRY(pmull_ghash_update_p8)
> +SYM_FUNC_START(pmull_ghash_update_p8)
>         __pmull_ghash   p8
> -ENDPROC(pmull_ghash_update_p8)
> +SYM_FUNC_END(pmull_ghash_update_p8)
>
>         KS0             .req    v8
>         KS1             .req    v9
> diff --git a/arch/arm64/crypto/nh-neon-core.S b/arch/arm64/crypto/nh-neon-core.S
> index e05570c38de7..51c0a534ef87 100644
> --- a/arch/arm64/crypto/nh-neon-core.S
> +++ b/arch/arm64/crypto/nh-neon-core.S
> @@ -62,7 +62,7 @@
>   *
>   * It's guaranteed that message_len % 16 == 0.
>   */
> -ENTRY(nh_neon)
> +SYM_FUNC_START(nh_neon)
>
>         ld1             {K0.4s,K1.4s}, [KEY], #32
>           movi          PASS0_SUMS.2d, #0
> @@ -100,4 +100,4 @@ ENTRY(nh_neon)
>         addp            T1.2d, PASS2_SUMS.2d, PASS3_SUMS.2d
>         st1             {T0.16b,T1.16b}, [HASH]
>         ret
> -ENDPROC(nh_neon)
> +SYM_FUNC_END(nh_neon)
> diff --git a/arch/arm64/crypto/sha1-ce-core.S b/arch/arm64/crypto/sha1-ce-core.S
> index c2ce1f820706..92d0d2753e81 100644
> --- a/arch/arm64/crypto/sha1-ce-core.S
> +++ b/arch/arm64/crypto/sha1-ce-core.S
> @@ -65,7 +65,7 @@
>          * void sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
>          *                        int blocks)
>          */
> -ENTRY(sha1_ce_transform)
> +SYM_FUNC_START(sha1_ce_transform)
>         frame_push      3
>
>         mov             x19, x0
> @@ -160,4 +160,4 @@ CPU_LE(     rev32           v11.16b, v11.16b        )
>         str             dgb, [x19, #16]
>         frame_pop
>         ret
> -ENDPROC(sha1_ce_transform)
> +SYM_FUNC_END(sha1_ce_transform)
> diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
> index 6f728a419009..3f9d0f326987 100644
> --- a/arch/arm64/crypto/sha2-ce-core.S
> +++ b/arch/arm64/crypto/sha2-ce-core.S
> @@ -75,7 +75,7 @@
>          *                        int blocks)
>          */
>         .text
> -ENTRY(sha2_ce_transform)
> +SYM_FUNC_START(sha2_ce_transform)
>         frame_push      3
>
>         mov             x19, x0
> @@ -166,4 +166,4 @@ CPU_LE(     rev32           v19.16b, v19.16b        )
>  4:     st1             {dgav.4s, dgbv.4s}, [x19]
>         frame_pop
>         ret
> -ENDPROC(sha2_ce_transform)
> +SYM_FUNC_END(sha2_ce_transform)
> diff --git a/arch/arm64/crypto/sha3-ce-core.S b/arch/arm64/crypto/sha3-ce-core.S
> index a7d587fa54f6..1cfb768df350 100644
> --- a/arch/arm64/crypto/sha3-ce-core.S
> +++ b/arch/arm64/crypto/sha3-ce-core.S
> @@ -40,7 +40,7 @@
>          * sha3_ce_transform(u64 *st, const u8 *data, int blocks, int dg_size)
>          */
>         .text
> -ENTRY(sha3_ce_transform)
> +SYM_FUNC_START(sha3_ce_transform)
>         frame_push      4
>
>         mov     x19, x0
> @@ -218,7 +218,7 @@ ENTRY(sha3_ce_transform)
>         st1     {v24.1d}, [x19]
>         frame_pop
>         ret
> -ENDPROC(sha3_ce_transform)
> +SYM_FUNC_END(sha3_ce_transform)
>
>         .section        ".rodata", "a"
>         .align          8
> diff --git a/arch/arm64/crypto/sha512-ce-core.S b/arch/arm64/crypto/sha512-ce-core.S
> index ce65e3abe4f2..cde606c0323e 100644
> --- a/arch/arm64/crypto/sha512-ce-core.S
> +++ b/arch/arm64/crypto/sha512-ce-core.S
> @@ -106,7 +106,7 @@
>          *                        int blocks)
>          */
>         .text
> -ENTRY(sha512_ce_transform)
> +SYM_FUNC_START(sha512_ce_transform)
>         frame_push      3
>
>         mov             x19, x0
> @@ -216,4 +216,4 @@ CPU_LE(     rev64           v19.16b, v19.16b        )
>  3:     st1             {v8.2d-v11.2d}, [x19]
>         frame_pop
>         ret
> -ENDPROC(sha512_ce_transform)
> +SYM_FUNC_END(sha512_ce_transform)
> diff --git a/arch/arm64/crypto/sm3-ce-core.S b/arch/arm64/crypto/sm3-ce-core.S
> index d50d187906cb..ef97d3187cb7 100644
> --- a/arch/arm64/crypto/sm3-ce-core.S
> +++ b/arch/arm64/crypto/sm3-ce-core.S
> @@ -73,7 +73,7 @@
>          *                       int blocks)
>          */
>         .text
> -ENTRY(sm3_ce_transform)
> +SYM_FUNC_START(sm3_ce_transform)
>         /* load state */
>         ld1             {v8.4s-v9.4s}, [x0]
>         rev64           v8.4s, v8.4s
> @@ -131,7 +131,7 @@ CPU_LE(     rev32           v3.16b, v3.16b          )
>         ext             v9.16b, v9.16b, v9.16b, #8
>         st1             {v8.4s-v9.4s}, [x0]
>         ret
> -ENDPROC(sm3_ce_transform)
> +SYM_FUNC_END(sm3_ce_transform)
>
>         .section        ".rodata", "a"
>         .align          3
> diff --git a/arch/arm64/crypto/sm4-ce-core.S b/arch/arm64/crypto/sm4-ce-core.S
> index af3bfbc3f4d4..4ac6cfbc5797 100644
> --- a/arch/arm64/crypto/sm4-ce-core.S
> +++ b/arch/arm64/crypto/sm4-ce-core.S
> @@ -15,7 +15,7 @@
>          * void sm4_ce_do_crypt(const u32 *rk, u32 *out, const u32 *in);
>          */
>         .text
> -ENTRY(sm4_ce_do_crypt)
> +SYM_FUNC_START(sm4_ce_do_crypt)
>         ld1             {v8.4s}, [x2]
>         ld1             {v0.4s-v3.4s}, [x0], #64
>  CPU_LE(        rev32           v8.16b, v8.16b          )
> @@ -33,4 +33,4 @@ CPU_LE(       rev32           v8.16b, v8.16b          )
>  CPU_LE(        rev32           v8.16b, v8.16b          )
>         st1             {v8.4s}, [x1]
>         ret
> -ENDPROC(sm4_ce_do_crypt)
> +SYM_FUNC_END(sm4_ce_do_crypt)
> --
> 2.20.1
>
