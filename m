Return-Path: <SRS0=XejO=AL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0F6C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 18:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 344CB20775
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 18:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UBfchpiO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgF3SOn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jun 2020 14:14:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23323 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730017AbgF3SOk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jun 2020 14:14:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593540879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vwOjSHtKwc8OVCty7AYbDN/CER37KH0m3LtXDwkTRGk=;
        b=UBfchpiOlyKBLMs/11xCNmnb5xyM7LPNGP9IoBdHVNxdmR9eWgCniVIaMyCbgxKid5Rbi8
        EfPFYQr4a56cjmyiwtJRzNggW9qOKwf6WS867VNHtWphvunmkaZ1XTqv6Ild1ggz7ojwyc
        mG2azLJuqQZNLOuYTj3DFRctZdCotrs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-HhljQ1tbP-2uXM1rJV2NtQ-1; Tue, 30 Jun 2020 14:14:34 -0400
X-MC-Unique: HhljQ1tbP-2uXM1rJV2NtQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33C49805EEE;
        Tue, 30 Jun 2020 18:14:30 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D88455C1B0;
        Tue, 30 Jun 2020 18:14:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05UIEQQb009464;
        Tue, 30 Jun 2020 14:14:26 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05UIEPPm009460;
        Tue, 30 Jun 2020 14:14:25 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 30 Jun 2020 14:14:25 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Eric Biggers <ebiggers@kernel.org>
cc:     Mike Snitzer <msnitzer@redhat.com>,
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
In-Reply-To: <20200630175746.GA2026704@gmail.com>
Message-ID: <alpine.LRH.2.02.2006301414120.30526@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com> <20200626044534.GA2870@gondor.apana.org.au> <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com> <20200626164617.GA211634@gmail.com> <alpine.LRH.2.02.2006281505250.347@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006300954150.15237@file01.intranet.prod.int.rdu2.redhat.com>
 <20200630163552.GA837@sol.localdomain> <alpine.LRH.2.02.2006301256110.30526@file01.intranet.prod.int.rdu2.redhat.com> <20200630175746.GA2026704@gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Tue, 30 Jun 2020, Eric Biggers wrote:

> On Tue, Jun 30, 2020 at 01:01:16PM -0400, Mikulas Patocka wrote:
> > > diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> > > index 7240e8bbdebb..643f7f1cc91c 100644
> > > --- a/crypto/pcrypt.c
> > > +++ b/crypto/pcrypt.c
> > > @@ -232,12 +232,15 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
> > >  	struct crypto_attr_type *algt;
> > >  	struct aead_instance *inst;
> > >  	struct aead_alg *alg;
> > > +	u32 mask;
> > >  	int err;
> > >  
> > >  	algt = crypto_get_attr_type(tb);
> > >  	if (IS_ERR(algt))
> > >  		return PTR_ERR(algt);
> > >  
> > > +	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
> > > +
> > >  	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
> > >  	if (!inst)
> > >  		return -ENOMEM;
> > > @@ -254,7 +257,7 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
> > >  		goto err_free_inst;
> > >  
> > >  	err = crypto_grab_aead(&ctx->spawn, aead_crypto_instance(inst),
> > > -			       crypto_attr_alg_name(tb[1]), 0, 0);
> > > +			       crypto_attr_alg_name(tb[1]), 0, mask);
> > >  	if (err)
> > >  		goto err_free_inst;
> > >  
> > 
> > I added "mask" there - but there is still a "mask" argument that is 
> > unused - is it a bug to have two "mask" variables?
> 
> Right, I didn't see that algt->type and algt->mask are already being passed to 
> pcrypt_create_aead().  It's redundant because pcrypt_create_aead() has access to
> those via crypto_get_attr_type() anyway.
> 
> How about just removing those two arguments for now?
> 
> - Eric

Yes.

Mikulas

