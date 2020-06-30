Return-Path: <SRS0=XejO=AL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CC8C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 16:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F50F2074F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 16:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593534965;
	bh=oYCSw4PCki/SDdawcCRdB1g+bOTmh7QoW+EwDPjWJjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=zV99ZdkWdq0oNwgOhRn+sWElQOpS/khiH1ZIm7ZRarG/UXqZdn1Wq+WrE+wrBFXXH
	 hwLTMBMX0PRfgVA8r6xf/9acUAppcI/BoVBF9821A5MsVcURYFjxClLVKETZ08TAqM
	 jMi/Q4XlURrhiTtDy9CvWyVxNVws1oD6YPPu31Co=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389150AbgF3QgF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jun 2020 12:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389026AbgF3QgE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jun 2020 12:36:04 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CCC320724;
        Tue, 30 Jun 2020 16:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593534964;
        bh=oYCSw4PCki/SDdawcCRdB1g+bOTmh7QoW+EwDPjWJjs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=noDzOs3heH2s23yBmSBcGq/OZohTqVn/ojDBf6gA96/4WN2xjKm4lG9twKUxbMMP6
         /6Mu7njaHhCw40O1BjBNqlxJKQx/UwhBVi59PLW4+qPEmQy12oBARxLGCu5TGYIZwk
         Rc/Er/Xmw8xInG6ajcNADFdvHSTbvJYg8LdH5rdQ=
Date:   Tue, 30 Jun 2020 09:35:52 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Mike Snitzer <msnitzer@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org,
        Wei Xu <xuwei5@hisilicon.com>, dm-devel@redhat.com,
        George Cherian <gcherian@marvell.com>,
        linux-crypto@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/3 v4] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Message-ID: <20200630163552.GA837@sol.localdomain>
References: <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616173620.GA207319@gmail.com>
 <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626044534.GA2870@gondor.apana.org.au>
 <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626164617.GA211634@gmail.com>
 <alpine.LRH.2.02.2006281505250.347@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006300954150.15237@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006300954150.15237@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 30, 2020 at 09:56:22AM -0400, Mikulas Patocka wrote:
> Index: linux-2.6/crypto/cryptd.c
> ===================================================================
> --- linux-2.6.orig/crypto/cryptd.c	2020-06-29 16:03:07.346417000 +0200
> +++ linux-2.6/crypto/cryptd.c	2020-06-30 15:49:04.206417000 +0200
> @@ -202,6 +202,7 @@ static inline void cryptd_check_internal
>  
>  	*type |= algt->type & CRYPTO_ALG_INTERNAL;
>  	*mask |= algt->mask & CRYPTO_ALG_INTERNAL;
> +	*mask |= algt->mask & CRYPTO_ALG_INHERITED_FLAGS;
>  }

This needs to use the correct logic (crypto_alg_inherited_mask) to decide which
inherited flags to set in 'mask'.

> --- linux-2.6.orig/crypto/adiantum.c	2020-06-29 16:03:07.346417000 +0200
> +++ linux-2.6/crypto/adiantum.c	2020-06-29 16:03:07.346417000 +0200
> @@ -507,7 +507,7 @@ static int adiantum_create(struct crypto
>  	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
>  		return -EINVAL;
>  
> -	mask = crypto_requires_sync(algt->type, algt->mask);
> +	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
>  
>  	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
>  	if (!inst)

This is still missing setting the flags correctly on the template instance being
constructed.  The flags need to be inherited from all "inner" algorithms:

	inst->alg.base.cra_flags = (streamcipher_alg->base.cra_flags |
				    blockcipher_alg->cra_flags |
				    hash_alg->base.cra_flags) &
				   CRYPTO_ALG_INHERITED_FLAGS;

If we don't do that, the template instance may allocate memory but not have
CRYPTO_ALG_ALLOCATES_MEMORY set.

> Index: linux-2.6/crypto/pcrypt.c
> ===================================================================
> --- linux-2.6.orig/crypto/pcrypt.c	2020-06-29 16:03:07.346417000 +0200
> +++ linux-2.6/crypto/pcrypt.c	2020-06-30 15:47:32.776417000 +0200
> @@ -263,7 +263,9 @@ static int pcrypt_create_aead(struct cry
>  	if (err)
>  		goto err_free_inst;
>  
> -	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC;
> +	inst->alg.base.cra_flags =
> +		CRYPTO_ALG_ASYNC |
> +		(alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS);
>  
>  	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
>  	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);

And this is still missing setting the mask:

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 7240e8bbdebb..643f7f1cc91c 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -232,12 +232,15 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 	struct crypto_attr_type *algt;
 	struct aead_instance *inst;
 	struct aead_alg *alg;
+	u32 mask;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
 		return PTR_ERR(algt);
 
+	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
+
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
@@ -254,7 +257,7 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 		goto err_free_inst;
 
 	err = crypto_grab_aead(&ctx->spawn, aead_crypto_instance(inst),
-			       crypto_attr_alg_name(tb[1]), 0, 0);
+			       crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 

Can you please think logically about what you're trying to accomplish?

In particular, if someone requests an algorithm that doesn't allocate memory
(which is indicated by type=0, mask=CRYPTO_ALG_ALLOCATES_MEMORY), that request
needs to be honored.

- Eric
