Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24390C04FF3
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 21:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBCCA61413
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 21:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhEXVrf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 May 2021 17:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232693AbhEXVrf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 May 2021 17:47:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3FB6613F5;
        Mon, 24 May 2021 21:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621892767;
        bh=GKBkDVTR6U4A8LLVKMf0yBj3svKYZlzUW+v2aVViaJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NJWTjTUZALSTvd/Re0iNJkunzZ18jSfygkanIFmlZC7HvVKCcf5xZfCeFdSGQ9g6Y
         LeYhrSk2Z4sqjsq6Ns4EOO14aBuTTWiLdbg+xF2c7L8JekA5ZsC4QwHDAWUzzogwyM
         8OTjhjaj03NZb3tsa5ngevR06nlziacJPVvK3GoOCIF/63F+P4pCRppin+kaGpPb0U
         n+PP6UXYCugdH4vxiCGpdg8MH+wnqRZzSvthnz/HLakYcClvYx3b7uJbK91FKFAuP+
         Ixv+oMfR1SQspm5vnST8sQC8dZ8p6Fpd1seTOUBkwRu19x5YnMr1ZVidV5Y4Wfoss7
         sBxsLPTKfAaTA==
Date:   Mon, 24 May 2021 14:46:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v5 1/5] crypto: arm64/gcm-aes-ce - remove non-SIMD
 fallback path
Message-ID: <YKwenSYKlQF77Dz2@gmail.com>
References: <20210521102053.66609-1-ardb@kernel.org>
 <20210521102053.66609-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521102053.66609-2-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 21, 2021 at 12:20:49PM +0200, Ard Biesheuvel wrote:
> Now that kernel mode SIMD is guaranteed to be available when executing
> in task or softirq context, we no longer need scalar fallbacks to use
> when the NEON is unavailable. So get rid of them.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/ghash-ce-glue.c | 209 +++++---------------
>  1 file changed, 51 insertions(+), 158 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>
