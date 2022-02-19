Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1F0C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Feb 2022 01:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240864AbiBSBVj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Feb 2022 20:21:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240701AbiBSBVi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Feb 2022 20:21:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B8618406E
        for <linux-crypto@vger.kernel.org>; Fri, 18 Feb 2022 17:21:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 466F762018
        for <linux-crypto@vger.kernel.org>; Sat, 19 Feb 2022 01:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D7AC340E9;
        Sat, 19 Feb 2022 01:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645233679;
        bh=0yZROx1zfBGesuvOmp4yoXRqrpLpABCEUu2sb63C8RY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=INOT5CJig3IlpxmWZiE9M616AaKXVeyseAlLvygBfVKSHaFWNHylh8R3YCwV5EyZf
         tH1/UAKQ0QIa6agDDQ8osx75LCDGvBVlrd/CE1TfNLnH2QPxUFFDsbfOmIYyEbfD9K
         1y3uCorvlsG3kzN4B5bd9felDv4VBJt1JZFAB31uQFY6HH551jPFCrIgsreebAXTpx
         Ogxhg3AAf3pvnBFxJoQs3jpvPAVoBRhQngF6WTga+Roj+Jm86pcU1lk3gNKGvRZuMr
         fh+gIDv0QZfPk4HLcsKjYdm9LxXczaCnZ6ovlFbFGAdQ8r4yorj4AeznvMawauSX6D
         i+e6144L5FlmQ==
Date:   Fri, 18 Feb 2022 17:21:17 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [RFC PATCH v2 7/7] crypto: arm64/polyval: Add PMULL accelerated
 implementation of POLYVAL
Message-ID: <YhBGDbNOs2crcmzd@sol.localdomain>
References: <20220210232812.798387-1-nhuck@google.com>
 <20220210232812.798387-8-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210232812.798387-8-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A lot of the comments I made on the x86_64 version apply to the arm64 version,
but a few more comments below:

On Thu, Feb 10, 2022 at 11:28:12PM +0000, Nathan Huckleberry wrote:
> Add hardware accelerated version of POLYVAL for ARM64 CPUs with
> Crypto Extension support.

Nit: It's "Crypto Extensions", not "Crypto Extension".

> +config CRYPTO_POLYVAL_ARM64_CE
> +	tristate "POLYVAL using ARMv8 Crypto Extensions (for HCTR2)"
> +	depends on KERNEL_MODE_NEON
> +	select CRYPTO_CRYPTD
> +	select CRYPTO_HASH
> +	select CRYPTO_POLYVAL

CRYPTO_POLYVAL selects CRYPTO_HASH already, so there's no need to select it
here.

> /*
>  * Handle any extra blocks before
>  * full_stride loop.
>  */
> .macro partial_stride
> 	eor		LO.16b, LO.16b, LO.16b
> 	eor		MI.16b, MI.16b, MI.16b
> 	eor		HI.16b, HI.16b, HI.16b
> 	add		KEY_START, x1, #(NUM_PRECOMPUTE_POWERS << 4)
> 	sub		KEY_START, KEY_START, PARTIAL_LEFT, lsl #4
> 	ld1		{v0.16b}, [KEY_START]
> 	mov		v1.16b, SUM.16b
> 	karatsuba1 v0 v1
> 	karatsuba2
> 	montgomery_reduction
> 	mov		SUM.16b, PH.16b
> 	eor		LO.16b, LO.16b, LO.16b
> 	eor		MI.16b, MI.16b, MI.16b
> 	eor		HI.16b, HI.16b, HI.16b
> 	mov		IND, XZR
> .LloopPartial:
> 	cmp		IND, PARTIAL_LEFT
> 	bge		.LloopExitPartial
> 
> 	sub		TMP, IND, PARTIAL_LEFT
> 
> 	cmp		TMP, #-4
> 	bgt		.Lgt4Partial
> 	ld1		{M0.16b, M1.16b,  M2.16b, M3.16b}, [x0], #64
> 	// Clobber key registers
> 	ld1		{KEY8.16b, KEY7.16b, KEY6.16b,  KEY5.16b}, [KEY_START], #64
> 	karatsuba1 M0 KEY8
> 	karatsuba1 M1 KEY7
> 	karatsuba1 M2 KEY6
> 	karatsuba1 M3 KEY5
> 	add		IND, IND, #4
> 	b		.LoutPartial
> 
> .Lgt4Partial:
> 	cmp		TMP, #-3
> 	bgt		.Lgt3Partial
> 	ld1		{M0.16b, M1.16b, M2.16b}, [x0], #48
> 	// Clobber key registers
> 	ld1		{KEY8.16b, KEY7.16b, KEY6.16b}, [KEY_START], #48
> 	karatsuba1 M0 KEY8
> 	karatsuba1 M1 KEY7
> 	karatsuba1 M2 KEY6
> 	add		IND, IND, #3
> 	b		.LoutPartial
> 
> .Lgt3Partial:
> 	cmp		TMP, #-2
> 	bgt		.Lgt2Partial
> 	ld1		{M0.16b, M1.16b}, [x0], #32
> 	// Clobber key registers
> 	ld1		{KEY8.16b, KEY7.16b}, [KEY_START], #32
> 	karatsuba1 M0 KEY8
> 	karatsuba1 M1 KEY7
> 	add		IND, IND, #2
> 	b		.LoutPartial
> 
> .Lgt2Partial:
> 	ld1		{M0.16b}, [x0], #16
> 	// Clobber key registers
> 	ld1		{KEY8.16b}, [KEY_START], #16
> 	karatsuba1 M0 KEY8
> 	add		IND, IND, #1
> .LoutPartial:
> 	b .LloopPartial
> .LloopExitPartial:
> 	karatsuba2
> 	montgomery_reduction
> 	eor		SUM.16b, SUM.16b, PH.16b
> .endm

This sort of logic for handling different message lengths is necessary, but it's
partly why I think that testing different message lengths is so important --
there could be bugs that are specific to particular message lengths.

With CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, we do get test coverage from the fuzz
tests that compare implementations to the corresponding generic implementation.
But, it's preferable to not rely on that and have good default test vectors too.

It looks like you already do a relatively good job with the message lengths in
the polyval test vectors.  But it might be worth adding a test vector where the
length mod 128 is 112, so that the case where partial_stride processes 7 blocks
is tested.  Also one where the message length is greater than 128 (or even 256)
bytes but isn't a multiple of 128, so that the case where *both* partial_stride
and full_stride are executed is tested.

- Eric
