Return-Path: <SRS0=XejO=AL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E820CC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 17:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C509720768
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 17:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593539869;
	bh=Jnq5DMKJw84O1kiP7BU34YGy6pOC9dKfoHImyR1ewxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vrrPEF1bhSnmK6B7UZqU8X7n5AFrC7xy3EqcMdWR4VgJO/xittfIkzwpo886WMIsy
	 Sr6NbjvL3d/0sMQJLFiKoqi+kbf7foekq5VExhwbjVhdVABI+vjTrAf+uTAWtGxiFs
	 eYGqWj/2Gx5HVuwBj87VaRR/MS4/nDnVvK5C+cVk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731169AbgF3R5t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgF3R5t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jun 2020 13:57:49 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4368520724;
        Tue, 30 Jun 2020 17:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593539868;
        bh=Jnq5DMKJw84O1kiP7BU34YGy6pOC9dKfoHImyR1ewxA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JZJYIopbjUPUilqoK83hIr6N0qAYGe4QCb3/BCGQwqmwuIccz1UpvWSgFXGREa8ud
         eRNdINxZG8Z06UuwWY6mFWneD57JuReNMgQAvEgi8X80vW2xqXvaVatgKXpgGFH4bj
         R+RF1WbNhwesgaRy1M0mjC+pL7FDVl9CeRf+zwtE=
Date:   Tue, 30 Jun 2020 10:57:46 -0700
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
Message-ID: <20200630175746.GA2026704@gmail.com>
References: <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626044534.GA2870@gondor.apana.org.au>
 <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006261215480.13882@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626164617.GA211634@gmail.com>
 <alpine.LRH.2.02.2006281505250.347@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006300954150.15237@file01.intranet.prod.int.rdu2.redhat.com>
 <20200630163552.GA837@sol.localdomain>
 <alpine.LRH.2.02.2006301256110.30526@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006301256110.30526@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 30, 2020 at 01:01:16PM -0400, Mikulas Patocka wrote:
> > diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> > index 7240e8bbdebb..643f7f1cc91c 100644
> > --- a/crypto/pcrypt.c
> > +++ b/crypto/pcrypt.c
> > @@ -232,12 +232,15 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
> >  	struct crypto_attr_type *algt;
> >  	struct aead_instance *inst;
> >  	struct aead_alg *alg;
> > +	u32 mask;
> >  	int err;
> >  
> >  	algt = crypto_get_attr_type(tb);
> >  	if (IS_ERR(algt))
> >  		return PTR_ERR(algt);
> >  
> > +	mask = crypto_alg_inherited_mask(algt->type, algt->mask);
> > +
> >  	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
> >  	if (!inst)
> >  		return -ENOMEM;
> > @@ -254,7 +257,7 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
> >  		goto err_free_inst;
> >  
> >  	err = crypto_grab_aead(&ctx->spawn, aead_crypto_instance(inst),
> > -			       crypto_attr_alg_name(tb[1]), 0, 0);
> > +			       crypto_attr_alg_name(tb[1]), 0, mask);
> >  	if (err)
> >  		goto err_free_inst;
> >  
> 
> I added "mask" there - but there is still a "mask" argument that is 
> unused - is it a bug to have two "mask" variables?

Right, I didn't see that algt->type and algt->mask are already being passed to 
pcrypt_create_aead().  It's redundant because pcrypt_create_aead() has access to
those via crypto_get_attr_type() anyway.

How about just removing those two arguments for now?

- Eric
