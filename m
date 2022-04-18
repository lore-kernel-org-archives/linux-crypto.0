Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F633C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 21:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiDRVjm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 17:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiDRVjm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 17:39:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8682E9FB
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 14:37:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71C3BCE126E
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 21:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49577C385A1;
        Mon, 18 Apr 2022 21:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650317818;
        bh=0esn0ZH9jB3UkEnwylL/XnIYQGl+ogu9/kfSDs3o3eM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=byYpAVVOjxv+V5btrjCBxU52fJE5kp6fjOhg6cTgLyFuU8k1+Q8EckIdcdEUIX4Kp
         6tMevuZ6lyCDJ7teGYTdPquoraepyHDwQg/5ke9qVD1D6wkbKvWeaonG9ngt+DJjCh
         7Po370AuSB3zEkfcvSAZLAFWF3wdSWQpySVIe648FjT+lSc9lDqQYlwPESFhHMT+iK
         cLEVtF4OI7pXAf8YMdge1gL0UvSrT2iPpM53bwekFjh0oPSJ76tW0+K5HLtdKdm0Jk
         IT0jyuYECLc7GE7CE17rRfTo6W5k8Q4jvPGLcAtFzBwnU1l+wi18rBmnId1LUquCWN
         0u0AKlkgR02gw==
Date:   Mon, 18 Apr 2022 14:36:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 6/8] crypto: x86/polyval: Add PCLMULQDQ accelerated
 implementation of POLYVAL
Message-ID: <Yl3Z+CqZIZOBTfOs@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-7-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172816.917723-7-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A few more comments:

On Tue, Apr 12, 2022 at 05:28:14PM +0000, Nathan Huckleberry wrote:
> +/*
> + * Computes the 256-bit polynomial represented by LO, HI, MI. Stores
> + * the result in PL, PH.
> + *   [PH :: PL] = [HI_1 : HI_0 + MI_1 :: LO_1 + MI_0 : LO_0]
> + */

It is unclear what the double colon means.  Maybe you meant for it to indicate
128-bit boundaries, as opposed to 64-bit boundaries?  It is not used
consistently, though.

> +/*
> + * Computes the 128-bit reduction of PL : PH. Stores the result in dest.

This should use the order "PH : PL", to be consistent with the notation
elsewhere.

> diff --git a/arch/x86/crypto/polyval-clmulni_glue.c b/arch/x86/crypto/polyval-clmulni_glue.c
[...]
> +struct polyval_ctx {
> +	/*
> +	 * These powers must be in the order h^8, ..., h^1.
> +	 */
> +	u8 key_powers[NUM_PRECOMPUTE_POWERS][POLYVAL_BLOCK_SIZE];
> +};
> +
> +struct polyval_desc_ctx {
> +	u8 buffer[POLYVAL_BLOCK_SIZE];
> +	u32 bytes;
> +};

As I've mentioned elsewhere, it is confusing to have both ctx and desc_ctx.  The
former should be called polyval_tfm_ctx, like it is in polyval-generic.c.

> +asmlinkage void clmul_polyval_update(const u8 *in, struct polyval_ctx *keys,
> +				     size_t nblocks, u8 *accumulator);

The argument order here is a bit weird.  It would be more logical to have it be
(keys, in, nblocks, accumulator), similar to crypto_shash_digest().

Also, 'keys' should be const.

- Eric
