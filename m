From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: Fix out-of-bounds access of the AAD
 buffer in generic-gcm-aesni
Date: Wed, 20 Dec 2017 00:42:10 -0800
Message-ID: <20171220084210.GC6565@zzz.localdomain>
References: <20171219221750.34148-1-junaids@google.com>
 <20171220044259.61106-3-junaids@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        andreslc@google.com, davem@davemloft.net, gthelen@google.com
To: Junaid Shahid <junaids@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:46541 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932403AbdLTImN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 03:42:13 -0500
Received: by mail-pg0-f54.google.com with SMTP id b11so11658204pgu.13
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 00:42:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171220044259.61106-3-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 19, 2017 at 08:42:59PM -0800, Junaid Shahid wrote:
> The aesni_gcm_enc/dec functions can access memory after the end of
> the AAD buffer if the AAD length is not a multiple of 4 bytes.
> It didn't matter with rfc4106-gcm-aesni as in that case the AAD was
> always followed by the 8 byte IV, but that is no longer the case with
> generic-gcm-aesni. This can potentially result in accessing a page that
> is not mapped and thus causing the machine to crash. This patch fixes
> that by reading the last <16 byte block of the AAD byte-by-byte and
> optionally via an 8-byte load if the block was at least 8 bytes.
> 
> Fixes: 0487ccac ("crypto: aesni - make non-AVX AES-GCM work with any aadlen")
[...]
> -_get_AAD_rest0\num_initial_blocks\operation:
> -	/* finalize: shift out the extra bytes we read, and align
> -	left. since pslldq can only shift by an immediate, we use
> -	vpshufb and an array of shuffle masks */
> -	movq	   %r12, %r11
> -	salq	   $4, %r11
> -	movdqu	   aad_shift_arr(%r11), \TMP1
> -	PSHUFB_XMM \TMP1, %xmm\i

aad_shift_arr is no longer used, so it should be removed.

> -_get_AAD_rest_final\num_initial_blocks\operation:
> +	READ_PARTIAL_BLOCK %r10, %r12, %r11, \TMP1, \TMP2, %xmm\i

It seems that INITIAL_BLOCKS_DEC and INITIAL_BLOCKS_ENC maintain both %r11 and
%r12 as the AAD length.  %r11 is used for real earlier, but here %r12 is used
for real while %r11 is a temporary register.  Can this be simplified to have the
AAD length in %r11 only?

Eric
