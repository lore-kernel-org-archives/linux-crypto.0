Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B4EC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 17:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCA9E207E8
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 17:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593190842;
	bh=Ep5w0n0x0kpCsEM51CkTVFeUvlkyp4jxK0RnRCz1oAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=KNzq+eJAYL/cw3DE7ipqwIZVutMfPtffu8oZ/XGUcOhrTsI3rt9pmJAhN21grap8Y
	 OHm3xXBnYQzzg8JQ8sqqalcwVrQyO7Ue+wcjAtyKoDdkckFvoL4FYTZPX8aEv1UFkO
	 zahvMC1fFxjA4tVJTO53kPvKtPklE3RK4PFoFux4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgFZRAm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 13:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgFZRAm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 13:00:42 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4A1C206BE;
        Fri, 26 Jun 2020 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593190841;
        bh=Ep5w0n0x0kpCsEM51CkTVFeUvlkyp4jxK0RnRCz1oAk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vDE2rR6FzM6Pz07Jcs4drmT/oc5tD0ahQYTXUqZoVdUvF4tlYa8zurHaNSDzub2DM
         DktzkKpfWJ9ZtnjKy9lBpPPrLPCD/h00E7uX1IClo2uf+9nwCypqXrUNqtcAH+Bflz
         ObK93WNiVf4KNZSShjU/5CKo9eLVD5+474g4jbMY=
Date:   Fri, 26 Jun 2020 10:00:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Mike Snitzer <msnitzer@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Zaibo Xu <xuzaibo@Huawei.com>, linux-kernel@vger.kernel.org,
        Wei Xu <xuwei5@hisilicon.com>, dm-devel@redhat.com,
        George Cherian <gcherian@marvell.com>,
        linux-crypto@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/3 v2] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Message-ID: <20200626170039.GB211634@gmail.com>
References: <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616173620.GA207319@gmail.com>
 <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626044534.GA2870@gondor.apana.org.au>
 <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626164617.GA211634@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626164617.GA211634@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 26, 2020 at 09:46:17AM -0700, Eric Biggers wrote:
> On Fri, Jun 26, 2020 at 12:16:33PM -0400, Mikulas Patocka wrote:
> > +/*
> > + * Pass these flags down through the crypto API.
> > + */
> > +#define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)
> 
> This comment is useless.  How about:
> 
> /*
>  * When an algorithm uses another algorithm (e.g., if it's an instance of a
>  * template), these are the flags that always get set on the "outer" algorithm
>  * if any "inner" algorithm has them set.  In some cases other flags are
>  * inherited too; these are just the flags that are *always* inherited.
>  */
> #define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)
> 
> Also I wonder about the case where the inner algorithm is a fallback rather than
> part of a template instance.  This patch only handles templates, not fallbacks.
> Is that intentional?  Isn't that technically a bug?

Also is CRYPTO_ALG_ALLOCATES_MEMORY meant to apply for algorithms of type
"cipher" and "shash"?  The code doesn't handle those, so presumably not?

What about "akcipher"?

> > Index: linux-2.6/crypto/xts.c
> > ===================================================================
> > --- linux-2.6.orig/crypto/xts.c	2020-06-26 17:24:03.566417000 +0200
> > +++ linux-2.6/crypto/xts.c	2020-06-26 17:24:03.566417000 +0200
> > @@ -415,7 +415,7 @@ static int create(struct crypto_template
> >  	} else
> >  		goto err_free_inst;
> >  
> > -	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
> > +	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
> >  	inst->alg.base.cra_priority = alg->base.cra_priority;
> >  	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
> >  	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
> 
> Need to set the mask correctly in this file.

cryptd_create_skcipher(), cryptd_create_hash(), cryptd_create_aead(), and
crypto_rfc4309_create() are also missing setting the mask.

pcrypt_create_aead() is missing both setting the mask and inheriting the flags.

Also, "seqiv" instances can be created without CRYPTO_ALG_ALLOCATES_MEMORY set,
despite seqiv_aead_encrypt() allocating memory.

- Eric
