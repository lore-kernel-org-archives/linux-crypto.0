Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 772F2C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 03:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 483242077B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 03:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576035003;
	bh=rL6mjdc9TGH2Fkus6v41HaNIfAyZh1R7cAWqn5MXyPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=AJcWTNBUq1wzsbzpH/uDzyRhiWYcGamXnbUUFDQon0WAvUF5U8Bi2ZFpvt9+nv3k3
	 fi9FfrdPhmHS9xZf153EgHgqhvL/yO/ZoVGH3ISjKp+mbkMnaxdC0UqfNK5GMAJgI7
	 cRLDDalCYOr+Ybv0OQJa+sF5eRFDSJHrV7acgCJ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLKDaC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 22:30:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:60308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbfLKDaC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 22:30:02 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0600D20718;
        Wed, 11 Dec 2019 03:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576035002;
        bh=rL6mjdc9TGH2Fkus6v41HaNIfAyZh1R7cAWqn5MXyPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BD5g3VQQknfj6ZeNXFYDxw73379ZZt97NNIqd1jFyye4jqNreXfc+hU15HzCjjgEU
         dV7td7q9lZjnq7wrIXHj13yFBNdcJld3QedE/hBBRIqvFu+f6l+NyXaxNDpusGtkmc
         jeNyZvfq4ulaKbSTtc1CxE+w6EyYKg8UwzuCRCAc=
Date:   Tue, 10 Dec 2019 19:30:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 1/3] crypto: shash - Add init_tfm/exit_tfm and verify
 descsize
Message-ID: <20191211033000.GD732@sol.localdomain>
References: <20191208054229.h4smagmiuqhxxc6w@gondor.apana.org.au>
 <E1idpLH-0008RO-Hn@gondobar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1idpLH-0008RO-Hn@gondobar>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 08, 2019 at 01:42:51PM +0800, Herbert Xu wrote:
> The shash interface supports a dynamic descsize field because of
> the presence of fallbacks (it's just padlock-sha actually, perhaps
> we can remove it one day).  As it is the API does not verify the
> setting of descsize at all.  It is up to the individual algorithms
> to ensure that descsize does not exceed the specified maximum value
> of HASH_MAX_DESCSIZE (going above would cause stack corruption).
> 
> In order to allow the API to impose this limit directly, this patch
> adds init_tfm/exit_tfm hooks to the shash_alg structure.  We can
> then verify the descsize setting in the API directly.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  crypto/shash.c        |   25 +++++++++++++++++++++++++
>  include/crypto/hash.h |   13 +++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/crypto/shash.c b/crypto/shash.c
> index e83c5124f6eb..63a7ea368eb1 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -386,15 +386,40 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
>  	return 0;
>  }
>  
> +static void crypto_shash_exit_tfm(struct crypto_tfm *tfm)
> +{
> +	struct crypto_shash *hash = __crypto_shash_cast(tfm);
> +	struct shash_alg *alg = crypto_shash_alg(hash);
> +
> +	alg->exit_tfm(hash);
> +}
> +
>  static int crypto_shash_init_tfm(struct crypto_tfm *tfm)
>  {
>  	struct crypto_shash *hash = __crypto_shash_cast(tfm);
>  	struct shash_alg *alg = crypto_shash_alg(hash);
> +	int err;
>  
>  	hash->descsize = alg->descsize;
>  
>  	shash_set_needkey(hash, alg);
>  
> +	if (alg->exit_tfm)
> +		tfm->exit = crypto_shash_exit_tfm;
> +
> +	if (!alg->init_tfm)
> +		return 0;
> +
> +	err = alg->init_tfm(hash);
> +	if (err)
> +		return err;
> +
> +	if (WARN_ON_ONCE(hash->descsize > HASH_MAX_DESCSIZE)) {
> +		if (alg->exit_tfm)
> +			alg->exit_tfm(hash);
> +		return -EINVAL;
> +	}

Nit: it would be helpful to have a comment just above the WARN_ON_ONCE() like:

	/* ->init_tfm() may have increased the descsize. */

- Eric
