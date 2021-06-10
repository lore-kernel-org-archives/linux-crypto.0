Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D09C48BE0
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 23:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C2BA613E1
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 23:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhFJX3u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Jun 2021 19:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230212AbhFJX3u (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jun 2021 19:29:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9886613CB;
        Thu, 10 Jun 2021 23:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623367673;
        bh=hOK0J1uI//q3YZets8JX6ACpEoV1vqm/HHQw5zocAqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vfs5YsUpOIzAcog1ud+K4bqVRr77Q/lChQyoH13m2lGR+SA6jipEJRDB6nQSxgNh3
         QcG0ZcftfzSxVLFH33sgBniohcrNDCxB8GQK8LEVgig7IsUtbxuc7oR1ak2q+rXS+K
         zxBa7dVmNZ9qQaAHxYZpzJyRhAMvv4lmDeo8JGqpDdfa5I6tWCG3Z46rx/vF6JVHEU
         lJ1bqZESazgK+eHCjoAzJ2WBNK8QAC7XqFybpsrk//ZLry2nuMy5Od7GzyUdz/hzX1
         VizpdcVaimCdwF9rYeFtj1QA2LyID4T6W7Cl/kKeXvAdKia91nsKyQp23Eh63NkN1t
         C0WEX+Vxuf4Zg==
Date:   Thu, 10 Jun 2021 16:27:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] crypto: x86/sm4 - add AES-NI/AVX/x86_64 assembler
 implementation
Message-ID: <YMKf93/cnPGGtRW3@gmail.com>
References: <20210610134459.28541-1-tianjia.zhang@linux.alibaba.com>
 <20210610134459.28541-4-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610134459.28541-4-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 10, 2021 at 09:44:59PM +0800, Tianjia Zhang wrote:
> This patch adds AES-NI/AVX/x86_64 assembler implementation of SM4
> block cipher. Through two affine transforms, we can use the AES
> S-Box to simulate the SM4 S-Box to achieve the effect of instruction
> acceleration.
> 

Benchmark results, please.

Also, is this passing the self-tests, including the fuzz tests?

> +/*
> + * void sm4_aesni_avx_expand_key(const u8 *key, u32 *rk_enc,
> + *                  u32 *rk_dec, const u32 *fk, const u32 *ck);
> + */
> +SYM_FUNC_START(sm4_aesni_avx_expand_key)
> +	/* input:
> +	 *	%rdi: 128-bit key
> +	 *	%rsi: rkey_enc
> +	 *	%rdx: rkey_dec
> +	 *	%rcx: fk array
> +	 *	%r8: ck array
> +	 */
> +	FRAME_BEGIN

Key expansion isn't performance-critical.  Can the C library version be used, or
does the key need to be expanded in a way specific to this x86 implementation?

> +/*
> + * void sm4_aesni_avx_crypt4(const u32 *rk, u8 *dst,
> + *                          const u8 *src, int nblocks)
> + */
> +SYM_FUNC_START(sm4_aesni_avx_crypt4)
> +	/* input:
> +	 *	%rdi: round key array, CTX
> +	 *	%rsi: dst (1..4 blocks)
> +	 *	%rdx: src (1..4 blocks)
> +	 *	%rcx: num blocks (1..4)
> +	 */
> +	FRAME_BEGIN
[...]

> +static void sm4_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +{
> +	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +	if (crypto_simd_usable()) {
> +		kernel_fpu_begin();
> +		sm4_aesni_avx_crypt4(ctx->rkey_enc, out, in, 1);
> +		kernel_fpu_end();
> +	} else
> +		crypto_sm4_do_crypt(ctx->rkey_enc, out, in);
> +}
> +
> +static void sm4_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +{
> +	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +	if (crypto_simd_usable()) {
> +		kernel_fpu_begin();
> +		sm4_aesni_avx_crypt4(ctx->rkey_dec, out, in, 1);
> +		kernel_fpu_end();
> +	} else
> +		crypto_sm4_do_crypt(ctx->rkey_dec, out, in);
> +}

Your assembly code appears to handle encrypting up to 4 blocks at a time.
However you have only wired this up to the "cipher" API which does 1 block at a
time.  Is this intentional?

What are your performance results with real-world chaining modes like XTS, and
do you plan to implement any of these modes directly?

> +
> +static struct crypto_alg sm4_asm_alg = {
> +	.cra_name		= "sm4",
> +	.cra_driver_name	= "sm4-asm",

In arch/x86/crypto/, "-asm" usually means a vanilla x86 assembly implementation
without any AES-NI, SSE, AVX, etc. instructions.  Calling this something like
"sm4-aesni-avx" would make more sense.  (Or is it actually avx2, not avx?)

> +config CRYPTO_SM4_AESNI_AVX_X86_64
> +	tristate "SM4 cipher algorithm (x86_64/AES-NI/AVX)"
> +	depends on X86 && 64BIT
> +	select CRYPTO_SKCIPHER
> +	select CRYPTO_SIMD
> +	select CRYPTO_ALGAPI
> +	select CRYPTO_LIB_SM4

As-is, neither CRYPTO_SKCIPHER nor CRYPTO_SIMD needs to be selected here.

> +	help
> +	  SM4 cipher algorithms (OSCCA GB/T 32907-2016) (x86_64/AES-NI/AVX).
> +
> +	  SM4 (GBT.32907-2016) is a cryptographic standard issued by the
> +	  Organization of State Commercial Administration of China (OSCCA)
> +	  as an authorized cryptographic algorithms for the use within China.
> +
> +	  SMS4 was originally created for use in protecting wireless
> +	  networks, and is mandated in the Chinese National Standard for
> +	  Wireless LAN WAPI (Wired Authentication and Privacy Infrastructure)
> +	  (GB.15629.11-2003).
> +
> +	  The latest SM4 standard (GBT.32907-2016) was proposed by OSCCA and
> +	  standardized through TC 260 of the Standardization Administration
> +	  of the People's Republic of China (SAC).
> +
> +	  The input, output, and key of SMS4 are each 128 bits.
> +
> +	  See also: <https://eprint.iacr.org/2008/329.pdf>
> +
> +	  If unsure, say N.

This is the help text for the x86 implementation specifically.  Please don't
have boilerplate text about the algorithm here; that already exists for the
generic implementation.  The text should explain about the x86 implementation.

- Eric
