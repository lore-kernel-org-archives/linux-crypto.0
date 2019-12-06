Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BBFC43603
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 21:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E78A524673
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 21:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575669293;
	bh=Zatf13vucKT+o7/x48D9+4ZaY8NfDyzy3K64k6syovM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FP3qJ3BAZoq1DKSV/FA6hFIcSfdg/kRljHPYJtxI+pAWwvP3b68e041uuF8O6cphI
	 7Qo4K7vs16GL+08FU8jIPZFdA2Eib2lkEVYylaQ007sDJ7w3URkg8P7PTaW9DSu+wJ
	 xnstHPWd9feU1zv6AJRLWEmHuCLME0xZCVSGgpGU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfLFVyw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 16:54:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfLFVyw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 16:54:52 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAB9320707;
        Fri,  6 Dec 2019 21:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575669291;
        bh=Zatf13vucKT+o7/x48D9+4ZaY8NfDyzy3K64k6syovM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QVi8YbEa5mzI8XwkVkqIaKwUjUrt0ZsOC/nF1MkBXHFP2JNVxFbMypo5+68C8b0F8
         vZIXccw+LwrtXHOUQd8hGp1CBclUkwnuNirK5UJiahDzLtsiC4xNCB6WC+tfII8R2p
         I/dQMVZ54zYCn4IGh5ZMe71HoBejzXuL8zGM4AVs=
Date:   Fri, 6 Dec 2019 13:54:50 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: shash - Add init_tfm/exit_tfm and verify
 descsize
Message-ID: <20191206215450.GB246840@gmail.com>
References: <20191206023527.k4kxngcsb7rpq2rz@gondor.apana.org.au>
 <E1id3Te-00077s-Ux@gondobar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1id3Te-00077s-Ux@gondobar>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 06, 2019 at 10:36:18AM +0800, Herbert Xu wrote:
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
>  include/crypto/hash.h |   14 ++++++++++++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/crypto/shash.c b/crypto/shash.c
> index e83c5124f6eb..40628712feec 100644
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
> +	if (hash->descsize > HASH_MAX_DESCSIZE) {

Use WARN_ON_ONCE() here?  If HASH_MAX_DESCSIZE is too low for some case, it's a
bug that needs to be fixed.

> + * @init_tfm: Initialize the cryptographic transformation object.
> + *	      This function is used to initialize the cryptographic
> + *	      transformation object.  This function is called only
> + *	      once at the instantiation time, right after the
> + *	      transformation context was allocated. In case the
> + *	      cryptographic hardware has some special requirements
> + *	      which need to be handled by software, this function
> + *	      shall check for the precise requirement of the
> + *	      transformation and put any software fallbacks in place.

The second sentence can be removed, since it's redundant with the first.

- Eric
