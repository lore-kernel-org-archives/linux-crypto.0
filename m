Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A400C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 06:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 503FD21A4A
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 06:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570774362;
	bh=008C3udiO3J+Gzey0FJ0h8E6uBpMFzTUm8F1ml5ih80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Nl0wMnDW5nfjGBYFI5ApueLMbLsjNZ3PPGjmDhFvdIl7MxXw1hH4Ybh4xC1lch2bm
	 9GqwiXBawn7v4jo7Gk3hQqrQvqnTf54ucmEeGMwrX76pkzj7gkl1/fbF5zLNKFHwJE
	 YFE7GGv2FG4mwKafQ5NnC6onfhmEnrqvU4NKm8nw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfJKGMl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 02:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfJKGMl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 02:12:41 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D95A82196E;
        Fri, 11 Oct 2019 06:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570774360;
        bh=008C3udiO3J+Gzey0FJ0h8E6uBpMFzTUm8F1ml5ih80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RUncrMu8diL+d/HOpnmj9zcCzOjYZleYcNZwO9iJaiyONUWaZqLTmdQl5vl2fsJHT
         Itfo90qg06K/jlOFJ/4HLoW4Yw2SOboSy716flYzBOlgdueo75NX1N8smh1oThIELx
         eyBLjx72rOBm1nTg0qCEwJVtLAS5r761Kd7cPjGo=
Date:   Thu, 10 Oct 2019 23:12:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH v3 07/29] crypto: arm/chacha - remove dependency on
 generic ChaCha driver
Message-ID: <20191011061238.GD23882@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-8-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007164610.6881-8-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 07, 2019 at 06:45:48PM +0200, Ard Biesheuvel wrote:
> diff --git a/arch/arm/crypto/chacha-scalar-core.S b/arch/arm/crypto/chacha-scalar-core.S
> index 2140319b64a0..0970ae107590 100644
> --- a/arch/arm/crypto/chacha-scalar-core.S
> +++ b/arch/arm/crypto/chacha-scalar-core.S
> @@ -41,14 +41,6 @@
>  	X14	.req	r12
>  	X15	.req	r14
>  
> -.Lexpand_32byte_k:
> -	// "expand 32-byte k"
> -	.word	0x61707865, 0x3320646e, 0x79622d32, 0x6b206574
> -
> -#ifdef __thumb2__
> -#  define adrl adr
> -#endif
> -
>  .macro __rev		out, in,  t0, t1, t2
>  .if __LINUX_ARM_ARCH__ >= 6
>  	rev		\out, \in
> @@ -391,61 +383,65 @@
>  .endm	// _chacha
>  
>  /*
> - * void chacha20_arm(u8 *out, const u8 *in, size_t len, const u32 key[8],
> - *		     const u32 iv[4]);
> + * void chacha_doarm(u8 *dst, const u8 *src, unsigned int bytes,
> + *		     u32 *state, int nrounds);
>   */
> -ENTRY(chacha20_arm)
> +ENTRY(chacha_doarm)
>  	cmp		r2, #0			// len == 0?
>  	reteq		lr
>  
> +	ldr		ip, [sp]
> +	cmp		ip, #12
> +
>  	push		{r0-r2,r4-r11,lr}
>  
>  	// Push state x0-x15 onto stack.
>  	// Also store an extra copy of x10-x11 just before the state.
>  
> -	ldr		r4, [sp, #48]		// iv
> -	mov		r0, sp
> -	sub		sp, #80
> -
> -	// iv: x12-x15
> -	ldm		r4, {X12,X13,X14,X15}
> -	stmdb		r0!, {X12,X13,X14,X15}
> +	add		X12, r3, #48
> +	ldm		X12, {X12,X13,X14,X15}
> +	push		{X12,X13,X14,X15}
> +	sub		sp, sp, #64
>  
> -	// key: x4-x11
> -	__ldrd		X8_X10, X9_X11, r3, 24
> +	__ldrd		X8_X10, X9_X11, r3, 40
>  	__strd		X8_X10, X9_X11, sp, 8
> -	stmdb		r0!, {X8_X10, X9_X11}
> -	ldm		r3, {X4-X9_X11}
> -	stmdb		r0!, {X4-X9_X11}
> -
> -	// constants: x0-x3
> -	adrl		X3, .Lexpand_32byte_k
> -	ldm		X3, {X0-X3}
> +	__strd		X8_X10, X9_X11, sp, 56
> +	ldm		r3, {X0-X9_X11}
>  	__strd		X0, X1, sp, 16
>  	__strd		X2, X3, sp, 24
> +	__strd		X4, X5, sp, 32
> +	__strd		X6, X7, sp, 40
> +	__strd		X8_X10, X9_X11, sp, 48
>  
> +	beq		1f
>  	_chacha		20
>  
> -	add		sp, #76
> +0:	add		sp, #76
>  	pop		{r4-r11, pc}
> -ENDPROC(chacha20_arm)
> +
> +1:	_chacha		12
> +	b		0b
> +ENDPROC(chacha_doarm)
>  
>  /*
> - * void hchacha20_arm(const u32 state[16], u32 out[8]);
> + * void hchacha_block_arm(const u32 state[16], u32 out[8], int nrounds);
>   */
> -ENTRY(hchacha20_arm)
> +ENTRY(hchacha_block_arm)
>  	push		{r1,r4-r11,lr}
>  
> +	cmp		r2, #12			// ChaCha12 ?
> +
>  	mov		r14, r0
>  	ldmia		r14!, {r0-r11}		// load x0-x11
>  	push		{r10-r11}		// store x10-x11 to stack
>  	ldm		r14, {r10-r12,r14}	// load x12-x15
>  	sub		sp, #8
>  
> +	beq		1f
>  	_chacha_permute	20
>  
>  	// Skip over (unused0-unused1, x10-x11)
> -	add		sp, #16
> +0:	add		sp, #16
>  
>  	// Fix up rotations of x12-x15
>  	ror		X12, X12, #drot
> @@ -458,4 +454,7 @@ ENTRY(hchacha20_arm)
>  	stm		r4, {X0,X1,X2,X3,X12,X13,X14,X15}
>  
>  	pop		{r4-r11,pc}
> -ENDPROC(hchacha20_arm)
> +
> +1:	_chacha_permute	12
> +	b		0b
> +ENDPROC(hchacha_block_arm)
> -- 

FYI, I've also had a version of this code supporting both the 12 and 20-round
variants sitting around here:
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/commit/?h=chacha-arm-scalar&id=fc51d8012742f591da3204b327a865f6109d472a
I'll take a closer look at this later, but you might want to take a quick look
at what I did, just in case I happened to do anything in a better way.

- Eric
