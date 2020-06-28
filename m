Return-Path: <SRS0=vlpe=AJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBE4C433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jun 2020 19:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54428206C0
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jun 2020 19:04:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DqNG5xJc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgF1TEk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Jun 2020 15:04:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31304 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726635AbgF1TEj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Jun 2020 15:04:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593371077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qdgR0RgpHkxJCEWnlf/pJrRhdiwOUw/TUdJvr42dJW0=;
        b=DqNG5xJc9bKE9vBJ/CQPQf/rh5oPBK+e5rK0j/Ov9R3SHp0p1eZfvaqkV01bjBix+wCYjH
        vnaKFt1cBxOH17NMLY0c5hRdM0fH5QUKQvRdaBVIOmKN+7bYki5C55O9X62npwGtfhNib8
        uaddQHZR/i3VMZCbSlvEC+AJ72ZxmUw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-t_7acUYtP1WmQtIZ867Pvw-1; Sun, 28 Jun 2020 15:04:33 -0400
X-MC-Unique: t_7acUYtP1WmQtIZ867Pvw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9CDA802ED4;
        Sun, 28 Jun 2020 19:04:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E0E5B96B62;
        Sun, 28 Jun 2020 19:04:24 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05SJ4OPC003566;
        Sun, 28 Jun 2020 15:04:24 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05SJ4M56003562;
        Sun, 28 Jun 2020 15:04:22 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Sun, 28 Jun 2020 15:04:22 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Eric Biggers <ebiggers@kernel.org>
cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <msnitzer@redhat.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
        George Cherian <gcherian@marvell.com>,
        Wei Xu <xuwei5@hisilicon.com>, Zaibo Xu <xuzaibo@Huawei.com>
Subject: Re: [PATCH 1/3 v2] crypto: introduce the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
In-Reply-To: <20200626164617.GA211634@gmail.com>
Message-ID: <alpine.LRH.2.02.2006281501230.347@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com> <20200610121106.GA23137@gondor.apana.org.au> <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
 <20200616173620.GA207319@gmail.com> <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com> <20200626044534.GA2870@gondor.apana.org.au>
 <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com> <20200626164617.GA211634@gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Fri, 26 Jun 2020, Eric Biggers wrote:

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

I'm not an expert in crypto internals, so I don't know. I'll send version 
3 of this patch and I'd like to ask you or Herbert to fix it.

> > +
> > +/*
> >   * Transform masks and values (for crt_flags).
> >   */
> >  #define CRYPTO_TFM_NEED_KEY		0x00000001
> > Index: linux-2.6/crypto/authenc.c
> > ===================================================================
> > --- linux-2.6.orig/crypto/authenc.c	2020-06-26 17:24:03.566417000 +0200
> > +++ linux-2.6/crypto/authenc.c	2020-06-26 17:24:03.566417000 +0200
> > @@ -388,7 +388,8 @@ static int crypto_authenc_create(struct
> >  	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
> >  		return -EINVAL;
> >  
> > -	mask = crypto_requires_sync(algt->type, algt->mask);
> > +	mask = crypto_requires_sync(algt->type, algt->mask) |
> > +	       crypto_requires_nomem(algt->type, algt->mask);
> 
> As I suggested earlier, shouldn't there be a function that returns the mask for
> all inherited flags, rather than handling each flag individually?

Yes - I've created crypto_requires_inherited for this purpose.

> >  
> >  	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
> >  	if (!inst)
> > @@ -424,7 +425,7 @@ static int crypto_authenc_create(struct
> >  		goto err_free_inst;
> >  
> >  	inst->alg.base.cra_flags = (auth_base->cra_flags |
> > -				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
> > +			enc->base.cra_flags) & CRYPTO_ALG_INHERITED_FLAGS;
> 
> Strange indentation here.  Likewise in most of the other files.

I was told that the code should be 80-characters wide.

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

I don't know what do you mean.

> > Index: linux-2.6/crypto/adiantum.c
> > ===================================================================
> > --- linux-2.6.orig/crypto/adiantum.c	2020-06-26 17:24:03.566417000 +0200
> > +++ linux-2.6/crypto/adiantum.c	2020-06-26 17:24:03.566417000 +0200
> > @@ -507,7 +507,8 @@ static int adiantum_create(struct crypto
> >  	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
> >  		return -EINVAL;
> >  
> > -	mask = crypto_requires_sync(algt->type, algt->mask);
> > +	mask = crypto_requires_sync(algt->type, algt->mask) |
> > +	       crypto_requires_nomem(algt->type, algt->mask);
> >  
> >  	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
> >  	if (!inst)
> 
> Need to use CRYPTO_ALG_INHERITED_FLAGS in this file.

OK.

> - Eric

Mikulas

