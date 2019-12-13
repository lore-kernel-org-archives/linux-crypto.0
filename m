Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FA3C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 03:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C8FE227BF
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 03:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576206216;
	bh=Bji1shXqHXuyxhupobyjBCj2RRBlxawy8KiooXFEgNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xdD6IkhGHnfB/mXC5xERhrpTEMg4x40nFJAoXRGqkIoVKdHeNtisBtwbjBetLsPNG
	 CVU1tQ1ernOWIN/nlLnoTsGUc3V0MFIc8HNesPCSvsdRpPekjgSEEFICm7bSaogTbF
	 bUpC1qLwCa7A8qDMNz83NNinyp9pefcdPeH87gsM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbfLMDDf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 22:03:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731884AbfLMDDf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 22:03:35 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B7D62253D;
        Fri, 13 Dec 2019 03:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576206214;
        bh=Bji1shXqHXuyxhupobyjBCj2RRBlxawy8KiooXFEgNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U3V25EzuiSlITbCZ+QLsCoioEK++wQ4nWqorwG+vdZ8bV+UpO0uzyMG/q21Pw8WqY
         mxa6SYNj+Z2DuMb8NPzDzatrcac6ccrauGXUT9XnUdcmCauTMk+zHjKFAYja/XxtIH
         xBH7w0jQO2HhtgsS3t1Pmcpxc3yXWUgG2wxtjTQY=
Date:   Thu, 12 Dec 2019 19:03:33 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH crypto-next v3 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
Message-ID: <20191213030333.GA1109@sol.localdomain>
References: <20191212173258.13358-1-Jason@zx2c4.com>
 <20191212173258.13358-2-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191212173258.13358-2-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 12, 2019 at 06:32:56PM +0100, Jason A. Donenfeld wrote:
> diff --git a/include/crypto/internal/poly1305.h b/include/crypto/internal/poly1305.h
> index 479b0cab2a1a..ad97819711eb 100644
> --- a/include/crypto/internal/poly1305.h
> +++ b/include/crypto/internal/poly1305.h
> @@ -11,11 +11,12 @@
>  #include <crypto/poly1305.h>
>  
>  /*
> - * Poly1305 core functions.  These implement the ε-almost-∆-universal hash
> + * Poly1305 core functions.  These can implement the ε-almost-∆-universal hash
>   * function underlying the Poly1305 MAC, i.e. they don't add an encrypted nonce
> - * ("s key") at the end.  They also only support block-aligned inputs.
> + * ("s key") at the end, by passing NULL to nonce.  They also only support
> + * block-aligned inputs.
>   */

This comment is now ambiguous because the "i.e." clause wasn't updated to match
the change "implement" => "can implement".

This comment also wasn't updated when the 'hibit' argument was added earlier
anyway.  So how about just rewriting it like:

/*
 * Poly1305 core functions.  These only accept whole blocks; the caller must
 * handle any needed block buffering and padding.  'hibit' must be 1 for any
 * full blocks, or 0 for the final block if it had to be padded.  If 'nonce' is
 * non-NULL, then it's added at the end to compute the Poly1305 MAC.  Otherwise,
 * only the ε-almost-∆-universal hash function (not the full MAC) is computed.
 */                                                          

> diff --git a/include/crypto/nhpoly1305.h b/include/crypto/nhpoly1305.h
> index 53c04423c582..a2f4e37b5107 100644
> --- a/include/crypto/nhpoly1305.h
> +++ b/include/crypto/nhpoly1305.h
> @@ -33,7 +33,7 @@
>  #define NHPOLY1305_KEY_SIZE	(POLY1305_BLOCK_SIZE + NH_KEY_BYTES)
>  
>  struct nhpoly1305_key {
> -	struct poly1305_key poly_key;
> +	struct poly1305_key poly_key[2];
>  	u32 nh_key[NH_KEY_WORDS];
>  };

I still feel that this makes the code worse.  Before, poly1305_key was an opaque
type that represented a Poly1305 key.  After, users would need to know that an
array of 2 "keys" is needed, despite there actually being only one key.

Given that this even caused an actual bug in v1 of this series, how about going
with a less error-prone approach?

> +void poly1305_core_blocks(struct poly1305_state *state,
> +			  const struct poly1305_key *key, const void *src,
> +			  unsigned int nblocks, u32 hibit)
> +{
> +	const u8 *input = src;
> +	u32 r0, r1, r2, r3, r4;
> +	u32 s1, s2, s3, s4;
> +	u32 h0, h1, h2, h3, h4;
> +	u64 d0, d1, d2, d3, d4;
> +	u32 c;
> +
> +	if (!nblocks)
> +		return;
> +
> +	hibit <<= 24;
> +
> +	r0 = key[0].r[0];
> +	r1 = key[0].r[1];
> +	r2 = key[0].r[2];
> +	r3 = key[0].r[3];
> +	r4 = key[0].r[4];
> +
> +	s1 = key[1].r[0];
> +	s2 = key[1].r[1];
> +	s3 = key[1].r[2];
> +	s4 = key[1].r[3];

And some of the function prototypes, like this one, still give no indication
that 2 "keys" are needed...

- Eric
