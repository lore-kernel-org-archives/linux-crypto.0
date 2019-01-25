Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787B8C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 07:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4142D218DE
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 07:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548400959;
	bh=ak0jQGsCGwAXDvw3LAmwsmQtXKwczU5i6LCEZhchIf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xGAaUJ/uqvHy8BiUfO/SwOXmb72i4bnkvOq9zqUYjSP+sD/rXShHPafDdK3zr4nyi
	 H/3ibw/WKjoKgb8JktXswlNkBD03MYIHg991qFCg0hCdNo1F+sXVZ4I1DDS3y0w3AT
	 B0oDEcGlBXAVVpVlCzSyk63r2OOFfKB6xNBtGKFM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfAYHWi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 02:22:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbfAYHWi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 02:22:38 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01314218D2;
        Fri, 25 Jan 2019 07:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548400957;
        bh=ak0jQGsCGwAXDvw3LAmwsmQtXKwczU5i6LCEZhchIf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V4MFnx7UYXtflfTv+xp7yByMM5hUiTzmINWyPrnRIbJQ3PWBJTQ2t0XLU+GPJ1QAh
         I1yljb14DnQymTezPdb1CZnKhgzwsVDYkPOTaz4asD7dC45MM5BapNddjE5f6i6E7A
         lixtpC8RsSGVeajF1rmz0pnkQNVqltfLFr0tlyrw=
Date:   Thu, 24 Jan 2019 23:22:35 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH 1/2] crypto: arm/crct10dif - revert to C code for short
 inputs
Message-ID: <20190125072234.GB700@sol.localdomain>
References: <20190124182712.7142-1-ard.biesheuvel@linaro.org>
 <20190124182712.7142-2-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124182712.7142-2-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 24, 2019 at 07:27:11PM +0100, Ard Biesheuvel wrote:
> The SIMD routine ported from x86 used to have a special code path
> for inputs < 16 bytes, which got lost somewhere along the way.
> Instead, the current glue code aligns the input pointer to permit
> the NEON routine to use special versions of the vld1 instructions
> that assume 16 byte alignment, but this could result in inputs of
> less than 16 bytes to be passed in. This not only fails the new
> extended tests that Eric has implemented, it also results in the
> code reading before the input pointer, which could potentially
> result in crashes when dealing with less than 16 bytes of input
> at the start of a page which is preceded by an unmapped page.
> 
> So update the glue code to only invoke the NEON routine if the
> input is more than 16 bytes.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Can you add proper tags?

Fixes: 1d481f1cd892 ("crypto: arm/crct10dif - port x86 SSE implementation to ARM")
Cc: <stable@vger.kernel.org> # v4.10+

Just double checking as I don't have a system immediately available to run this
one on -- I assume it passes with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y now?

Another comment below:

> ---
>  arch/arm/crypto/crct10dif-ce-core.S | 20 ++++++++---------
>  arch/arm/crypto/crct10dif-ce-glue.c | 23 +++++---------------
>  2 files changed, 16 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
> index ce45ba0c0687..3fd13d7c842c 100644
> --- a/arch/arm/crypto/crct10dif-ce-core.S
> +++ b/arch/arm/crypto/crct10dif-ce-core.S
> @@ -124,10 +124,10 @@ ENTRY(crc_t10dif_pmull)
>  	vext.8		q10, qzr, q0, #4
>  
>  	// receive the initial 64B data, xor the initial crc value
> -	vld1.64		{q0-q1}, [arg2, :128]!
> -	vld1.64		{q2-q3}, [arg2, :128]!
> -	vld1.64		{q4-q5}, [arg2, :128]!
> -	vld1.64		{q6-q7}, [arg2, :128]!
> +	vld1.64		{q0-q1}, [arg2]!
> +	vld1.64		{q2-q3}, [arg2]!
> +	vld1.64		{q4-q5}, [arg2]!
> +	vld1.64		{q6-q7}, [arg2]!
>  CPU_LE(	vrev64.8	q0, q0			)
>  CPU_LE(	vrev64.8	q1, q1			)
>  CPU_LE(	vrev64.8	q2, q2			)
> @@ -150,7 +150,7 @@ CPU_LE(	vrev64.8	q7, q7			)
>  	veor.8		q0, q0, q10
>  
>  	adr		ip, rk3
> -	vld1.64		{q10}, [ip, :128]	// xmm10 has rk3 and rk4
> +	vld1.64		{q10}, [ip]	// xmm10 has rk3 and rk4

This one is loading static data that is 16 byte aligned, so the :128 can be kept
here.  Same in the two other places below that load from [ip].

>  
>  	//
>  	// we subtract 256 instead of 128 to save one instruction from the loop
> @@ -167,7 +167,7 @@ CPU_LE(	vrev64.8	q7, q7			)
>  _fold_64_B_loop:
>  
>  	.macro		fold64, reg1, reg2
> -	vld1.64		{q11-q12}, [arg2, :128]!
> +	vld1.64		{q11-q12}, [arg2]!
>  
>  	vmull.p64	q8, \reg1\()h, d21
>  	vmull.p64	\reg1, \reg1\()l, d20
> @@ -203,13 +203,13 @@ CPU_LE(	vrev64.8	q12, q12		)
>  	// constants
>  
>  	adr		ip, rk9
> -	vld1.64		{q10}, [ip, :128]!
> +	vld1.64		{q10}, [ip]!
>  
>  	.macro		fold16, reg, rk
>  	vmull.p64	q8, \reg\()l, d20
>  	vmull.p64	\reg, \reg\()h, d21
>  	.ifnb		\rk
> -	vld1.64		{q10}, [ip, :128]!
> +	vld1.64		{q10}, [ip]!
>  	.endif
>  	veor.8		q7, q7, q8
>  	veor.8		q7, q7, \reg
> @@ -238,7 +238,7 @@ _16B_reduction_loop:
>  	vmull.p64	q7, d15, d21
>  	veor.8		q7, q7, q8
>  
> -	vld1.64		{q0}, [arg2, :128]!
> +	vld1.64		{q0}, [arg2]!
>  CPU_LE(	vrev64.8	q0, q0		)
>  	vswp		d0, d1
>  	veor.8		q7, q7, q0
> @@ -335,7 +335,7 @@ _less_than_128:
>  	vmov.i8		q0, #0
>  	vmov		s3, arg1_low32		// get the initial crc value
>  
> -	vld1.64		{q7}, [arg2, :128]!
> +	vld1.64		{q7}, [arg2]!
>  CPU_LE(	vrev64.8	q7, q7		)
>  	vswp		d14, d15
>  	veor.8		q7, q7, q0
> diff --git a/arch/arm/crypto/crct10dif-ce-glue.c b/arch/arm/crypto/crct10dif-ce-glue.c
> index d428355cf38d..14c19c70a841 100644
> --- a/arch/arm/crypto/crct10dif-ce-glue.c
> +++ b/arch/arm/crypto/crct10dif-ce-glue.c
> @@ -35,26 +35,15 @@ static int crct10dif_update(struct shash_desc *desc, const u8 *data,
>  			    unsigned int length)
>  {
>  	u16 *crc = shash_desc_ctx(desc);
> -	unsigned int l;
>  
> -	if (!may_use_simd()) {
> -		*crc = crc_t10dif_generic(*crc, data, length);
> +	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && may_use_simd()) {
> +		kernel_neon_begin();
> +		*crc = crc_t10dif_pmull(*crc, data, length);
> +		kernel_neon_end();
>  	} else {
> -		if (unlikely((u32)data % CRC_T10DIF_PMULL_CHUNK_SIZE)) {
> -			l = min_t(u32, length, CRC_T10DIF_PMULL_CHUNK_SIZE -
> -				  ((u32)data % CRC_T10DIF_PMULL_CHUNK_SIZE));
> -
> -			*crc = crc_t10dif_generic(*crc, data, l);
> -
> -			length -= l;
> -			data += l;
> -		}
> -		if (length > 0) {
> -			kernel_neon_begin();
> -			*crc = crc_t10dif_pmull(*crc, data, length);
> -			kernel_neon_end();
> -		}
> +		*crc = crc_t10dif_generic(*crc, data, length);
>  	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.17.1
> 
