Return-Path: <SRS0=vlpe=AJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1968C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jun 2020 19:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0071206A1
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jun 2020 19:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593373602;
	bh=Ezo07td5DwwHp76rybCIqbuSLH9bu67PkKqFw8Mpmzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=k6D9OseWxQGj2aTYHKzYdNe+6CTjKo4VrUGbq8wQ6bLCRI0x4/ZSubR86Uppu5KYF
	 xXNn81R20lrsRAwRxYEs0Y2azUNxm9+l392/Or1NMPFtKSQyBcCDhMwQUYsNSPaNmG
	 XpUT/4s4SV8VUJBwQL1nPe5aTMt5MSKg7kbRfARk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgF1Tqm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Jun 2020 15:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbgF1Tql (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Jun 2020 15:46:41 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 966E620578;
        Sun, 28 Jun 2020 19:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593373600;
        bh=Ezo07td5DwwHp76rybCIqbuSLH9bu67PkKqFw8Mpmzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GqdbIERtsL/GPnLBRdl97fpH9pOHvdOYskVrXWx/vDagKGMJlGHDea/RKrpsfLbOk
         iSplVvWXCk/yyifC3aPVnlUSiIl6gNXN3+LJhsZkgKbnhNYW6o2IE0l5mOG0QpIYk5
         C+Kbokri1y/jvcupQY9aw63t5mhA0QVN5Q3fE1As=
Date:   Sun, 28 Jun 2020 12:46:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <msnitzer@redhat.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        George Cherian <gcherian@marvell.com>,
        Wei Xu <xuwei5@hisilicon.com>, Zaibo Xu <xuzaibo@huawei.com>
Subject: Re: [PATCH 1/3 v2] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
Message-ID: <20200628194639.GC11197@sol.localdomain>
References: <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616173620.GA207319@gmail.com>
 <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626044534.GA2870@gondor.apana.org.au>
 <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626164617.GA211634@gmail.com>
 <alpine.LRH.2.02.2006281501230.347@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006281501230.347@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jun 28, 2020 at 03:04:22PM -0400, Mikulas Patocka wrote:
> > > Index: linux-2.6/crypto/authenc.c
> > > ===================================================================
> > > --- linux-2.6.orig/crypto/authenc.c	2020-06-26 17:24:03.566417000 +0200
> > > +++ linux-2.6/crypto/authenc.c	2020-06-26 17:24:03.566417000 +0200
> > > @@ -388,7 +388,8 @@ static int crypto_authenc_create(struct
> > >  	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
> > >  		return -EINVAL;
> > >  
> > > -	mask = crypto_requires_sync(algt->type, algt->mask);
> > > +	mask = crypto_requires_sync(algt->type, algt->mask) |
> > > +	       crypto_requires_nomem(algt->type, algt->mask);
> > 
> > As I suggested earlier, shouldn't there be a function that returns the mask for
> > all inherited flags, rather than handling each flag individually?
> 
> Yes - I've created crypto_requires_inherited for this purpose.

Since all callers pass in 'struct crypto_attr_type', a better helper might be:

static inline int crypto_algt_inherited_mask(struct crypto_attr_type *algt)
{
	return crypto_requires_off(algt->type, algt->mask,
				   CRYPTO_ALG_INHERITED_FLAGS);
}

> > > @@ -424,7 +425,7 @@ static int crypto_authenc_create(struct
> > >  		goto err_free_inst;
> > >  
> > >  	inst->alg.base.cra_flags = (auth_base->cra_flags |
> > > -				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
> > > +			enc->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;
> > 
> > Strange indentation here.  Likewise in most of the other files.
> 
> I was told that the code should be 80-characters wide.

You could use:

	inst->alg.base.cra_flags =
		(auth_base->cra_flags | enc->base.cra_flags) &
		CRYPTO_ALG_INHERITED_FLAGS;

Just a suggestion, it's not a big deal...  Your indentation of the continuation
line just seems weird.

> > > --- linux-2.6.orig/crypto/xts.c	2020-06-26 17:24:03.566417000 +0200
> > > +++ linux-2.6/crypto/xts.c	2020-06-26 17:24:03.566417000 +0200
> > > @@ -415,7 +415,7 @@ static int create(struct crypto_template
> > >  	} else
> > >  		goto err_free_inst;
> > >  
> > > -	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
> > > +	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS;
> > >  	inst->alg.base.cra_priority = alg->base.cra_priority;
> > >  	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
> > >  	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
> > 
> > Need to set the mask correctly in this file.
> 
> I don't know what do you mean.

I mean that the CRYPTO_ALG_ALLOCATES_MEMORY flag is not handled when the 'mask'
variable is assigned to earlier in this function.

It should use your new helper function, like all the other places in this patch.

- Eric
