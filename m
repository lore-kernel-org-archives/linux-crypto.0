Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8558C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 05:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjBPFqi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 00:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBPFqh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 00:46:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75F827988
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 21:46:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 711BE61E8B
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A1AC433D2;
        Thu, 16 Feb 2023 05:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676526395;
        bh=Ipreet7Db5wkpsS22erbXlndQs99gj0Cjz6jAFaxKqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=APsuhBLxZoOCKvH0NBlt45S+DiT6gDmUcfd9sOdHCSOPDBeqWZpbyTOSK5Uog+72b
         jsUVO6Jc7/GK8zBUDETs/TXXl4jpYoN1afq4YDlqLXz8+vKZbAHXWBgLHCWFTGol+1
         j75q/kYy/4R1IAUH/OuVcnQDAcor+/rp025ZtrlzxSYQbgyKLfMC8FkJy37Thdxom0
         BBwH9h7oo/ufRNE+b6y9nsJg9vFHVFoA5nnSoPblpn3+NOZr9lUVVrIqU2OnGZUf+B
         v7+YngK9woKwJ0cPVS2mBxMlQyR6OEjFs8FRr1913fGFm2uByQ74Nr7CdnGFl02Fe6
         pIy72ryAYzIHA==
Date:   Wed, 15 Feb 2023 21:46:34 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 8/10] crypto: rng - Count error stats differently
Message-ID: <Y+3DOhaA7F4/nUwT@sol.localdomain>
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
 <E1pSE2T-00BVlo-VL@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pSE2T-00BVlo-VL@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 15, 2023 at 05:25:21PM +0800, Herbert Xu wrote:
>  /**
>   * struct rng_alg - random number generator definition
>   *
> @@ -30,6 +46,7 @@ struct crypto_rng;
>   *		size of the seed is defined with @seedsize .
>   * @set_ent:	Set entropy that would otherwise be obtained from
>   *		entropy source.  Internal use only.
> + * @stat:	Statistics for rng algorithm
>   * @seedsize:	The seed size required for a random number generator
>   *		initialization defined with this variable. Some
>   *		random number generators does not require a seed
> @@ -39,6 +56,8 @@ struct crypto_rng;
>   * @base:	Common crypto API algorithm data structure.
>   */
>  struct rng_alg {
> +	struct crypto_alg base;
> +

Please keep field comments in the same order as the fields themselves.

- Eric
