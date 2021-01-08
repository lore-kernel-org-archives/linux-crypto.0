Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511B9C43381
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 21:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ECA523A80
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 21:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbhAHVRS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 16:17:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729330AbhAHVRS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 16:17:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA67423A80;
        Fri,  8 Jan 2021 21:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610140597;
        bh=bjigwf/89JSjEVHxRjfk2laNrhGqBpQX0mFubaEYXK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PSXY5/10M+CaVwDHwLXOBFKTWUgz1wlFmhUSA2wYDQcbe5VsSyDQ3dw68w2PF0O0l
         Rm94rM7z9EhSX8bJvDadessVDdZcLlkAndL9OPFcG/lJbOjmncvt723W+yRt0nMjpi
         h7JcyMmGi4pDZ4TURomy+8BFx+LeiRkOfS0AB+C166PbDQjnWs1aJzWnlfUFTpkh6Y
         HMHfPL7haPtHD4yCzAOp31Bj2iJzEZe96U0n5pLRjYWJ97l4JI46M5ai+Bt6AKatiu
         Nnq6gvH/zJQsG9NFFPwhoxviSh3p0kL2Cjs193B+RY1nApcreOCveq7wI1iJQKGx4V
         3uE9y8G+q93og==
Date:   Fri, 8 Jan 2021 13:16:36 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, arnd@arndb.de
Subject: Re: [PATCH v2] crypto: reduce minimum alignment of on-stack
 structures
Message-ID: <X/jLtI1m96DD+QLO@sol.localdomain>
References: <20210108171706.10306-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108171706.10306-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 08, 2021 at 06:17:06PM +0100, Ard Biesheuvel wrote:
> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> index 6a733b171a5d..aa133dc3bf39 100644
> --- a/include/crypto/skcipher.h
> +++ b/include/crypto/skcipher.h
> @@ -128,7 +128,7 @@ struct skcipher_alg {
>  			     MAX_SYNC_SKCIPHER_REQSIZE + \
>  			     (!(sizeof((struct crypto_sync_skcipher *)1 == \
>  				       (typeof(tfm))1))) \
> -			    ] CRYPTO_MINALIGN_ATTR; \
> +			    ] __aligned(ARCH_SLAB_MINALIGN); \
>  	struct skcipher_request *name = (void *)__##name##_desc
>  

Are you sure this is okay?  __alignof__(struct skcipher_request) will still be
CRYPTO_MINALIGN_ATTR, since it contains a field with that alignment.  So
technically isn't the full alignment still needed, as the compiler can assume
that struct skcipher_request is CRYPTO_MINALIGN_ATTR-aligned?

- Eric
