Return-Path: <SRS0=vlpe=AJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FF4C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jun 2020 19:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FDC320702
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jun 2020 19:08:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DP/lyjP1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgF1TID (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Jun 2020 15:08:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20373 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726585AbgF1TID (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Jun 2020 15:08:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593371281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=808YBhmAcPYX0BlfP0ReMxTnZzyESxUCQ1m9Cs1fVs0=;
        b=DP/lyjP1yryxqgmAbo3oNFUmiHiIUVJIr+VOhXyXEZT+InRaxdeKjwVnAnjvNM+NcjLGCn
        kC0yOLdM6XwweToiDv1ZSwPh3ImzFvyA8rCQCdOHV0Cwa+Jy7nfQyM82Jht4mxLRTUJfu6
        vIy7BLNuQ77X3EIPV57MKf72Y69K7Ng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-R1Xja-j8Ppe6RRr2BPxMEw-1; Sun, 28 Jun 2020 15:07:54 -0400
X-MC-Unique: R1Xja-j8Ppe6RRr2BPxMEw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA5528010C4;
        Sun, 28 Jun 2020 19:07:52 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E50935C1D2;
        Sun, 28 Jun 2020 19:07:49 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05SJ7n1T003745;
        Sun, 28 Jun 2020 15:07:49 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05SJ7nbm003741;
        Sun, 28 Jun 2020 15:07:49 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Sun, 28 Jun 2020 15:07:49 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Eric Biggers <ebiggers@kernel.org>
cc:     Mike Snitzer <msnitzer@redhat.com>,
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
In-Reply-To: <20200626170039.GB211634@gmail.com>
Message-ID: <alpine.LRH.2.02.2006281505530.347@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200610121106.GA23137@gondor.apana.org.au> <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com> <20200616173620.GA207319@gmail.com>
 <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com> <20200626044534.GA2870@gondor.apana.org.au> <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com> <20200626164617.GA211634@gmail.com> <20200626170039.GB211634@gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Fri, 26 Jun 2020, Eric Biggers wrote:

> On Fri, Jun 26, 2020 at 09:46:17AM -0700, Eric Biggers wrote:
> > On Fri, Jun 26, 2020 at 12:16:33PM -0400, Mikulas Patocka wrote:
> > > +/*
> > > + * Pass these flags down through the crypto API.
> > > + */
> > > +#define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)
> > 
> > This comment is useless.  How about:
> > 
> > /*
> >  * When an algorithm uses another algorithm (e.g., if it's an instance of a
> >  * template), these are the flags that always get set on the "outer" algorithm
> >  * if any "inner" algorithm has them set.  In some cases other flags are
> >  * inherited too; these are just the flags that are *always* inherited.
> >  */
> > #define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)
> > 
> > Also I wonder about the case where the inner algorithm is a fallback rather than
> > part of a template instance.  This patch only handles templates, not fallbacks.
> > Is that intentional?  Isn't that technically a bug?
> 
> Also is CRYPTO_ALG_ALLOCATES_MEMORY meant to apply for algorithms of type
> "cipher" and "shash"?  The code doesn't handle those, so presumably not?
> 
> What about "akcipher"?

Yes - the patch should apply for these cases, but I don't know how to do 
it. Please, do it.

> > > Index: linux-2.6/crypto/xts.c
> > > ===================================================================
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
> cryptd_create_skcipher(), cryptd_create_hash(), cryptd_create_aead(), and
> crypto_rfc4309_create() are also missing setting the mask.
> 
> pcrypt_create_aead() is missing both setting the mask and inheriting the flags.

I added CRYPTO_ALG_ALLOCATES_MEMORY there.

> Also, "seqiv" instances can be created without CRYPTO_ALG_ALLOCATES_MEMORY set,
> despite seqiv_aead_encrypt() allocating memory.
> 
> - Eric

Mikulas

