Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409F7C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 20:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237431AbiDRUtM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 16:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiDRUtM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 16:49:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A392E20BE1
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 13:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB512B810BF
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 20:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F35FC385A1;
        Mon, 18 Apr 2022 20:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650314788;
        bh=7WRNotIpr2rO8OMkXe6YR/zlvSemzZ4fIi0nEfMDJYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fuRqt7FG6MkXGSPG9Xyy8NtPLvZNq3MVVMJGnHNlOfKVmaA+5n9ekx5C7G4v0JXSd
         WScDQ0ugZREHhjqlICMCiTvHVMvxjYURdYX8FvKw3bYJRKPCN0XR/oAzX/GBal7ceA
         4Z7+EZK3gwV14W7yGYNO5dLsrjWogNlcUdMdP5AgrfJpg6T/zngMqijrXkvKXy0izA
         rQpfxFf9qCefHKEX2+J/CTAx2ZsJOh9eOPxWpwC3NTsWBf/in7CsRJjJqtp5FH4vyK
         g21yo8KeA+/TdYLAIyIE2WWthZkRzb5uH6olAN/4pV0wI433QAMeSpzl54lbWkmhrM
         bgQhaiGqNl86w==
Date:   Mon, 18 Apr 2022 13:46:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 3/8] crypto: hctr2 - Add HCTR2 support
Message-ID: <Yl3OIuhhnEN+E9fp@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-4-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172816.917723-4-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

One more comment:

On Tue, Apr 12, 2022 at 05:28:11PM +0000, Nathan Huckleberry wrote:
> +/*
> + * Check for a supported set of inner algorithms.
> + * See the comment at the beginning of this file.
> + */
> +static bool hctr2_supported_algorithms(struct skcipher_alg *xctr_alg,
> +				       struct crypto_alg *blockcipher_alg,
> +				       struct shash_alg *polyval_alg)
> +{
> +	if (strncmp(xctr_alg->base.cra_name, "xctr(", 4) != 0)
> +		return false;
> +
> +	if (blockcipher_alg->cra_blocksize != BLOCKCIPHER_BLOCK_SIZE)
> +		return false;
> +
> +	if (strcmp(polyval_alg->base.cra_name, "polyval") != 0)
> +		return false;
> +
> +	return true;
> +}

There are a couple issues here:

- "See the comment at the beginning of this file" doesn't make sense.  I guess
  this was copied from adiantum.c where there is indeed a comment at the
  beginning of the file that explains which "inner" algorithms are allowed.
  However, in hctr2.c there is no such comment (and that's fine; there aren't as
  many special considerations in this area for hctr2 as for adiantum).

- The strncmp() expression uses a string of 5 characters but only compares 4.
  Also this check is redundant anyway, since hctr2_create_common() already does
  this check (correctly, with 5 characters).

How about deleting the hctr2_supported_algorithms() function and putting the 2
needed checks directly in hctr2_create_common()?  I.e., check
blockcipher_alg->cra_blocksize right after the line:

	blockcipher_alg = crypto_spawn_cipher_alg(&ictx->blockcipher_spawn);

... and check polyval_alg->base.cra_name right after the line:

	polyval_alg = crypto_spawn_shash_alg(&ictx->polyval_spawn);

Note, the pr_warn() message "Unsupported HCTR2 instantiation" isn't very
important, and it arguably shouldn't be there since it is user-triggerable.
So you can just delete it.

- Eric
