Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB74C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 17:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E7ED21508
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 17:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592329364;
	bh=wzCSrtD+bv67Pc6WyKHwxnorzN1Ym43w4yPdOi2yMbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NuLrX+G6s/IuEPQjefHVjBWHSuE9Vu9boEqbAtdMcR/QVgjvFwHp7tQJInJmmTBpW
	 GK6W1LzosDYwttFZbeaaDZcDYgxfd6L2S2SIXPReJvri7gJCRRGKLyvqwUkr0PiK0F
	 kfiLlAs5z9SxvbRXKG54IsWz2w7Cd+ArQ54KgsrE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgFPRmo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 13:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729771AbgFPRmn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 13:42:43 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46E93214DB;
        Tue, 16 Jun 2020 17:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592329362;
        bh=wzCSrtD+bv67Pc6WyKHwxnorzN1Ym43w4yPdOi2yMbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OSrp/li3M4T475n9dAUkoKBU4tIm+0xg7jQPIGvpVXN+Au3PgOtGcSEykcgww9/6S
         KMUTbQ0Ctjao7KL8Gs2pPj6M6XBqwH4TRGnvG4FFAa1HJPtPwo2AV7izArJyFTjqso
         8XuHxyp6hTawbE97Y6WlZZvETjSTlOVHMGU3N+Ew=
Date:   Tue, 16 Jun 2020 10:42:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <msnitzer@redhat.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/4] crypto: pass the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Message-ID: <20200616174240.GB207319@gmail.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610010450.GA6449@gondor.apana.org.au>
 <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com>
 <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161101380.28052@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006161101380.28052@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 16, 2020 at 11:01:58AM -0400, Mikulas Patocka wrote:
> Pass the flag CRYPTO_ALG_ALLOCATES_MEMORY down through the crypto API.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  crypto/adiantum.c         |    3 ++-
>  crypto/authenc.c          |    5 +++--
>  crypto/authencesn.c       |    5 +++--
>  crypto/ccm.c              |    7 ++++---
>  crypto/chacha20poly1305.c |    5 +++--
>  crypto/cryptd.c           |    7 +++++--
>  crypto/ctr.c              |    3 ++-
>  crypto/cts.c              |    5 +++--
>  crypto/essiv.c            |    5 +++--
>  crypto/gcm.c              |   15 +++++++++------
>  crypto/geniv.c            |    3 ++-
>  crypto/lrw.c              |    5 +++--
>  crypto/rsa-pkcs1pad.c     |    5 +++--
>  crypto/xts.c              |    2 +-
>  include/crypto/algapi.h   |    9 +++++++++
>  15 files changed, 55 insertions(+), 29 deletions(-)
> 
> Index: linux-2.6/crypto/authenc.c
> ===================================================================
> --- linux-2.6.orig/crypto/authenc.c
> +++ linux-2.6/crypto/authenc.c
> @@ -388,7 +388,8 @@ static int crypto_authenc_create(struct
>  	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
>  		return -EINVAL;
>  
> -	mask = crypto_requires_sync(algt->type, algt->mask);
> +	mask = crypto_requires_sync(algt->type, algt->mask) |
> +	       crypto_requires_nomem(algt->type, algt->mask);
>  
>  	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
>  	if (!inst)
> @@ -424,7 +425,7 @@ static int crypto_authenc_create(struct
>  		goto err_free_inst;
>  
>  	inst->alg.base.cra_flags = (auth_base->cra_flags |
> -				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
> +				    enc->base.cra_flags) & (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY);

ASYNC and ALLOCATES_MEMORY are both handled the same way.  They're both
"inherited" from inner algorithms to the template instance.  And if someone
requests that one of these flags be clear when instantiating a template, then we
have to honor the same for the inner algorithms too.

So, shouldn't we define something like crypto_algt_mask() and
CRYPTO_ALG_INHERITED_FLAGS and make them handle both ASYNC and ALLOCATES_MEMORY,
rather than explicitly handling each of these flags everywhere again?

- Eric
