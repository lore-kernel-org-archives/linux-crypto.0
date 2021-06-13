Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF875C48BDF
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Jun 2021 10:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7FC161283
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Jun 2021 10:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhFMKQ6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 06:16:58 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:35255 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231671AbhFMKQ6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 06:16:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UcCrzkx_1623579293;
Received: from 30.25.254.38(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UcCrzkx_1623579293)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 13 Jun 2021 18:14:54 +0800
Subject: Re: [PATCH 3/3] crypto: x86/sm4 - add AES-NI/AVX/x86_64 assembler
 implementation
To:     Eric Biggers <ebiggers@kernel.org>
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
References: <20210610134459.28541-1-tianjia.zhang@linux.alibaba.com>
 <20210610134459.28541-4-tianjia.zhang@linux.alibaba.com>
 <YMKf93/cnPGGtRW3@gmail.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <d8df4d67-1a01-ff83-7739-af49b5b5e574@linux.alibaba.com>
Date:   Sun, 13 Jun 2021 18:14:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YMKf93/cnPGGtRW3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On 6/11/21 7:27 AM, Eric Biggers wrote:
> On Thu, Jun 10, 2021 at 09:44:59PM +0800, Tianjia Zhang wrote:
>> This patch adds AES-NI/AVX/x86_64 assembler implementation of SM4
>> block cipher. Through two affine transforms, we can use the AES
>> S-Box to simulate the SM4 S-Box to achieve the effect of instruction
>> acceleration.
>>
> 
> Benchmark results, please.
> 
> Also, is this passing the self-tests, including the fuzz tests?
> 

I will provide this information in the next version.

>> +/*
>> + * void sm4_aesni_avx_expand_key(const u8 *key, u32 *rk_enc,
>> + *                  u32 *rk_dec, const u32 *fk, const u32 *ck);
>> + */
>> +SYM_FUNC_START(sm4_aesni_avx_expand_key)
>> +	/* input:
>> +	 *	%rdi: 128-bit key
>> +	 *	%rsi: rkey_enc
>> +	 *	%rdx: rkey_dec
>> +	 *	%rcx: fk array
>> +	 *	%r8: ck array
>> +	 */
>> +	FRAME_BEGIN
> 
> Key expansion isn't performance-critical.  Can the C library version be used, or
> does the key need to be expanded in a way specific to this x86 implementation?
> 

It can be replaced by a common implementation of C library. For expand 
key that are not called frequently, the optimization of a specific 
instruction set does not bring much benefit. Of course, it is possible 
to delete this implementation.

>> +/*
>> + * void sm4_aesni_avx_crypt4(const u32 *rk, u8 *dst,
>> + *                          const u8 *src, int nblocks)
>> + */
>> +SYM_FUNC_START(sm4_aesni_avx_crypt4)
>> +	/* input:
>> +	 *	%rdi: round key array, CTX
>> +	 *	%rsi: dst (1..4 blocks)
>> +	 *	%rdx: src (1..4 blocks)
>> +	 *	%rcx: num blocks (1..4)
>> +	 */
>> +	FRAME_BEGIN
> [...]
> 
>> +static void sm4_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>> +{
>> +	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
>> +
>> +	if (crypto_simd_usable()) {
>> +		kernel_fpu_begin();
>> +		sm4_aesni_avx_crypt4(ctx->rkey_enc, out, in, 1);
>> +		kernel_fpu_end();
>> +	} else
>> +		crypto_sm4_do_crypt(ctx->rkey_enc, out, in);
>> +}
>> +
>> +static void sm4_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>> +{
>> +	const struct crypto_sm4_ctx *ctx = crypto_tfm_ctx(tfm);
>> +
>> +	if (crypto_simd_usable()) {
>> +		kernel_fpu_begin();
>> +		sm4_aesni_avx_crypt4(ctx->rkey_dec, out, in, 1);
>> +		kernel_fpu_end();
>> +	} else
>> +		crypto_sm4_do_crypt(ctx->rkey_dec, out, in);
>> +}
> 
> Your assembly code appears to handle encrypting up to 4 blocks at a time.
> However you have only wired this up to the "cipher" API which does 1 block at a
> time.  Is this intentional?
> 
> What are your performance results with real-world chaining modes like XTS, and
> do you plan to implement any of these modes directly?
> 

This implementation is intentional. First, a general block encryption is 
provided. There is no obvious performance improvement in this 
implementation. The key to optimization is to make full use of parallel 
four blocks encryption at a time. This is still under development, and I 
will continue to implement things like XTS in the future. Optimization 
of such specific modes.

>> +
>> +static struct crypto_alg sm4_asm_alg = {
>> +	.cra_name		= "sm4",
>> +	.cra_driver_name	= "sm4-asm",
> 
> In arch/x86/crypto/, "-asm" usually means a vanilla x86 assembly implementation
> without any AES-NI, SSE, AVX, etc. instructions.  Calling this something like
> "sm4-aesni-avx" would make more sense.  (Or is it actually avx2, not avx?)
> 

will do in next version patch.

>> +config CRYPTO_SM4_AESNI_AVX_X86_64
>> +	tristate "SM4 cipher algorithm (x86_64/AES-NI/AVX)"
>> +	depends on X86 && 64BIT
>> +	select CRYPTO_SKCIPHER
>> +	select CRYPTO_SIMD
>> +	select CRYPTO_ALGAPI
>> +	select CRYPTO_LIB_SM4
> 
> As-is, neither CRYPTO_SKCIPHER nor CRYPTO_SIMD needs to be selected here.
> 

ditto.

>> +	help
>> +	  SM4 cipher algorithms (OSCCA GB/T 32907-2016) (x86_64/AES-NI/AVX).
>> +
>> +	  SM4 (GBT.32907-2016) is a cryptographic standard issued by the
>> +	  Organization of State Commercial Administration of China (OSCCA)
>> +	  as an authorized cryptographic algorithms for the use within China.
>> +
>> +	  SMS4 was originally created for use in protecting wireless
>> +	  networks, and is mandated in the Chinese National Standard for
>> +	  Wireless LAN WAPI (Wired Authentication and Privacy Infrastructure)
>> +	  (GB.15629.11-2003).
>> +
>> +	  The latest SM4 standard (GBT.32907-2016) was proposed by OSCCA and
>> +	  standardized through TC 260 of the Standardization Administration
>> +	  of the People's Republic of China (SAC).
>> +
>> +	  The input, output, and key of SMS4 are each 128 bits.
>> +
>> +	  See also: <https://eprint.iacr.org/2008/329.pdf>
>> +
>> +	  If unsure, say N.
> 
> This is the help text for the x86 implementation specifically.  Please don't
> have boilerplate text about the algorithm here; that already exists for the
> generic implementation.  The text should explain about the x86 implementation.
> 

ditto.

> - Eric
> 

Thanks for your suggestion.

Cheers,
Tianjia
