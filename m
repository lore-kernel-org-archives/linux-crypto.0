Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1048FC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Mar 2022 01:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240020AbiCXBjR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 21:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbiCXBjQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 21:39:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C9892D25
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 18:37:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 444F86193C
        for <linux-crypto@vger.kernel.org>; Thu, 24 Mar 2022 01:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B169C340E9;
        Thu, 24 Mar 2022 01:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648085864;
        bh=a1kYGdgex96NKMG8cYYpKD+LeiQiL8pwC9I+H0A1ER8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S+QKPpcHrwUQ7wMwJahqQnSZ1XpEdl/9jrkggX3oLufEuLi01P5fM7z39y3pmqU57
         Rs/2ByH+J/PTJdyLHBfJkvZwt8UYE3BqNWlZSbleYnR4+hXzt4XKxDB6cyVrazsL9w
         ZsahPVNZSHXFwftn2S+JWvEnBuvdewYrou9mykvdp8hSuyR8JJmwxdAG6CKFaAJN/t
         7r2+rHFV8+ZuhL+fcz9SFgXoP95qb5E7uuBBqPO27+6tufVELTFiGutiAPUzHHtwiR
         KzsT0LMs20jEq94RyT8dGlrx5TzguCytV8iVNzDDKmwq+S3smWazfGLa5/MxGp763b
         C5mTEYjtPJMKQ==
Date:   Wed, 23 Mar 2022 18:37:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v3 7/8] crypto: arm64/polyval: Add PMULL accelerated
 implementation of POLYVAL
Message-ID: <YjvLZkjW2ts8qDfr@sol.localdomain>
References: <20220315230035.3792663-1-nhuck@google.com>
 <20220315230035.3792663-8-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315230035.3792663-8-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 15, 2022 at 11:00:34PM +0000, Nathan Huckleberry wrote:
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

> +/*
> + * Perform polynomial evaluation as specified by POLYVAL.  This computes:
> + * 	h^n * accumulator + h^n * m_0 + ... + h^1 * m_{n-1}
> + * where n=nblocks, h is the hash key, and m_i are the message blocks.
> + *
> + * x0 - pointer to message blocks
> + * x1 - pointer to precomputed key powers h^8 ... h^1
> + * x2 - number of blocks to hash
> + * x3 - pointer to accumulator
> + *
> + * void pmull_polyval_update(const u8 *in, const struct polyval_ctx *ctx,
> + *			     size_t nblocks, u8 *accumulator);
> + */
> +SYM_FUNC_START(pmull_polyval_update)
> +	adr		TMP, .Lgstar
> +	ld1		{GSTAR.2d}, [TMP]
> +	ld1		{SUM.16b}, [x3]
> +	ands		PARTIAL_LEFT, BLOCKS_LEFT, #7
> +	beq		.LskipPartial
> +	partial_stride
> +.LskipPartial:
> +	subs		BLOCKS_LEFT, BLOCKS_LEFT, #NUM_PRECOMPUTE_POWERS
> +	blt		.LstrideLoopExit
> +	ld1		{KEY8.16b, KEY7.16b, KEY6.16b, KEY5.16b}, [x1], #64
> +	ld1		{KEY4.16b, KEY3.16b, KEY2.16b, KEY1.16b}, [x1], #64
> +	full_stride 0
> +	subs		BLOCKS_LEFT, BLOCKS_LEFT, #NUM_PRECOMPUTE_POWERS
> +	blt		.LstrideLoopExitReduce
> +.LstrideLoop:
> +	full_stride 1
> +	subs		BLOCKS_LEFT, BLOCKS_LEFT, #NUM_PRECOMPUTE_POWERS
> +	bge		.LstrideLoop
> +.LstrideLoopExitReduce:
> +	montgomery_reduction
> +	mov		SUM.16b, PH.16b
> +.LstrideLoopExit:
> +	st1		{SUM.16b}, [x3]
> +	ret
> +SYM_FUNC_END(pmull_polyval_update)

Is there a reason why partial_stride is done first in the arm64 implementation,
but last in the x86 implementation?  It would be nice if the implementations
worked the same way.  Probably last would be better?  What is the advantage of
doing it first?

Besides that, many of the comments I made on the x86 implementation apply to the
arm64 implementation too.

- Eric
