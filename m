Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C44FC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 18:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbiKRStj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 13:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235374AbiKRSti (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 13:49:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAE56A684
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 10:49:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9672EB824F8
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 18:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D46BC433D6;
        Fri, 18 Nov 2022 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668797374;
        bh=Q96OIlQHZc6beG3N9u+m/eFfBbPlUi1pB02JIeAD/dI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oafyf24NKJ43CU+tXfOrvCLNSwWbfipVIkoTIZFwuegSdVr5tiZZCtutZYpbuaM4W
         ucmJB75jqHW80dfc58NH4haoK7VVvm9BE9qEkeNjoMxQb7htVQQ/LpPukJSW2Y0XSg
         PPtCNWUzTtlzdJFgtP4eiEkzR+yxb0hEU1uBBNBsbV95EmrYU4ONEydT+2zYQ9Othq
         YqMX0N8TzA3+mgA2i49cW+X72DMUzzCpGdDiQOKDx/rN+3eVRSwRTTF1swztwRXeYv
         9dS7F0YMUIbg2el/OtSC+DXX3tcMUnaL0CnuG8tQwXmepdnxbmbIsf+Kvio0r5uq2y
         1APAWfJpUFuhQ==
Date:   Fri, 18 Nov 2022 10:49:32 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH 0/11] crypto: CFI fixes
Message-ID: <Y3fTvOKW1txyDOJE@sol.localdomain>
References: <20221118090220.398819-1-ebiggers@kernel.org>
 <MW5PR84MB18424C160896BF9081E8CFCAAB099@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR84MB18424C160896BF9081E8CFCAAB099@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 18, 2022 at 03:43:55PM +0000, Elliott, Robert (Servers) wrote:
> 
> > -----Original Message-----
> > From: Eric Biggers <ebiggers@kernel.org>
> > Sent: Friday, November 18, 2022 3:02 AM
> > To: linux-crypto@vger.kernel.org
> > Cc: x86@kernel.org; linux-arm-kernel@lists.infradead.org; Sami Tolvanen
> > <samitolvanen@google.com>
> > Subject: [PATCH 0/11] crypto: CFI fixes
> > 
> > This series fixes some crashes when CONFIG_CFI_CLANG (Control Flow
> > Integrity) is enabled, with the new CFI implementation that was merged
> > in 6.1 and is supported on x86.  Some of them were unconditional
> > crashes, while others depended on whether the compiler optimized out the
> > indirect calls or not.  This series also simplifies some code that was
> > intended to work around limitations of the old CFI implementation and is
> > unnecessary for the new CFI implementation.
> 
> Some of the x86 modules EXPORT their asm functions. Does that leave them
> at risk of being called indirectly?
> 
> arch/x86/crypto/camellia-aesni-avx-asm_64.S:SYM_FUNC_START(camellia_ecb_dec_16way)
> arch/x86/crypto/camellia-aesni-avx-asm_64.S:SYM_FUNC_START(camellia_ecb_enc_16way)
> arch/x86/crypto/camellia-aesni-avx-asm_64.S:SYM_FUNC_START(camellia_cbc_dec_16way)
> arch/x86/crypto/camellia_aesni_avx_glue.c:asmlinkage void camellia_ecb_enc_16way(const void *ctx, u8 *dst, const u8 *src);
> arch/x86/crypto/camellia_aesni_avx_glue.c:EXPORT_SYMBOL_GPL(camellia_ecb_enc_16way);
> arch/x86/crypto/camellia_aesni_avx_glue.c:asmlinkage void camellia_ecb_dec_16way(const void *ctx, u8 *dst, const u8 *src);
> arch/x86/crypto/camellia_aesni_avx_glue.c:EXPORT_SYMBOL_GPL(camellia_ecb_dec_16way);
> arch/x86/crypto/camellia_aesni_avx_glue.c:asmlinkage void camellia_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
> arch/x86/crypto/camellia_aesni_avx_glue.c:EXPORT_SYMBOL_GPL(camellia_cbc_dec_16way);
> 
> arch/x86/crypto/twofish-x86_64-asm_64-3way.S:SYM_FUNC_START(__twofish_enc_blk_3way)
> arch/x86/crypto/twofish.h:asmlinkage void __twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src,
> arch/x86/crypto/twofish_glue_3way.c:EXPORT_SYMBOL_GPL(__twofish_enc_blk_3way);

No, that doesn't matter at all.  Whether a symbol is exported or not just has to
do with how the code is divided into modules.  It doesn't have anything to do
with indirect calls.

> A few of the x86 asm functions used by C code are not referenced with
> asmlinkage like all the others. They're not EXPORTed, though, so whether
> they're indirectly used can be determined.
> 
> u32 crc32_pclmul_le_16(unsigned char const *buffer, size_t len, u32 crc32);
> 
> void clmul_ghash_mul(char *dst, const u128 *shash);
> 
> void clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
>                         const u128 *shash);

No, the above functions are only called directly.

I did do another search and found that some of the sm4 functions are called
indirectly, though, so I'll send out an updated patchset that fixes those too.

- Eric
