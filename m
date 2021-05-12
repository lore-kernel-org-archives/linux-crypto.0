Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEBEC43617
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB52C61408
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238505AbhELVIH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 17:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385214AbhELUHL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 16:07:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7028C61408;
        Wed, 12 May 2021 20:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620849962;
        bh=QQfyPA2bVAhyX/rOl9YJ4esWVuFWaoi+C+eJcg9P1ZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qPbmnlRzEOq2EYn0QnCivlyyxTPzs67SCwCKbY/BC0Hec2HrNRKomvk/+GKtXsTKC
         gdGL9CDENOLpR/PxmhMdJc1iuwAobNUVf7Rr6E/fPItTVPkXY3Cmz4IZAN7xfwtAwG
         MGoRPT1Illjx+wtlYVEQUjbQkeoKq/xnCTf2FZL6tW2ZejnDJCRpZRiku9NgIfDqR9
         UiYkwC8TBrGvEo/b94tjKQua+0oDSeEtMF5lQVw0SwliIZli+amH1/HrqtGIGzvjP7
         DDxRm7JopOF3o3Jv+9BFaYZTHJEnZJyMcnT918RItEKTUFNYc6X4AxFvbC5vs0kF4e
         zQSFZN5WwAnvw==
Date:   Wed, 12 May 2021 13:06:00 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 2/7] crypto: aead - disallow en/decrypt for non-task
 or non-softirq context
Message-ID: <YJw1KLD8bCLTd+Oc@gmail.com>
References: <20210512184439.8778-1-ardb@kernel.org>
 <20210512184439.8778-3-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512184439.8778-3-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 12, 2021 at 08:44:34PM +0200, Ard Biesheuvel wrote:
> In order to ensure that kernel mode SIMD routines will not need a scalar
> fallback if they run with softirqs disabled, disallow any use of the
> AEAD encrypt and decrypt routines from outside of task or softirq context.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/aead.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/crypto/aead.c b/crypto/aead.c
> index 16991095270d..b5304b3d3314 100644
> --- a/crypto/aead.c
> +++ b/crypto/aead.c
> @@ -87,6 +87,11 @@ int crypto_aead_encrypt(struct aead_request *req)
>  	unsigned int cryptlen = req->cryptlen;
>  	int ret;
>  
> +	if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
> +	    WARN_ONCE(!in_task() && !in_serving_softirq(),
> +		      "synchronous call from invalid context\n"))
> +		return -EBUSY;
> +
>  	crypto_stats_get(alg);
>  	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
>  		ret = -ENOKEY;
> @@ -104,6 +109,11 @@ int crypto_aead_decrypt(struct aead_request *req)
>  	unsigned int cryptlen = req->cryptlen;
>  	int ret;
>  
> +	if (!(alg->cra_flags & CRYPTO_ALG_ASYNC) &&
> +	    WARN_ONCE(!in_task() && !in_serving_softirq(),
> +		      "synchronous call from invalid context\n"))
> +		return -EBUSY;
> +
>  	crypto_stats_get(alg);
>  	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
>  		ret = -ENOKEY;

This probably should go after crypto_stats_get() so that the error gets counted
in the stats (if stats are enabled) -- analogous to how the ENOKEY error is
counted.

Likewise for the skcipher patch.

- Eric
