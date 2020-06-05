Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BEAC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 06:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 495AC2081A
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 06:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591337809;
	bh=lQj9XObAGDgR1ex1yeP32vok/302Xza6LfEFxKwA3LI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=HCeJ3pbR/bmx89kcWmoLZKdG1RgA7H/sMVkdtf7Y3J9JQ4UNqP1YW3mR6Gl5E3ASe
	 +U4FdsTiDje+PgcY7a5O+BDG+3yqFKPVUnt8uhwj9bcHqP3xVsBTxd9cuxIIWyjlXN
	 kjB4Yc1vH/ydrBeSdcM8LI2AzI0QVDEiIUsZN5DI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgFEGQs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 02:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgFEGQs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 02:16:48 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB4B7207ED;
        Fri,  5 Jun 2020 06:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591337807;
        bh=lQj9XObAGDgR1ex1yeP32vok/302Xza6LfEFxKwA3LI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fq3qaSGbW3ebeiK+npkJTIjeQNSxvCOwtVxIlsaX+unoX65dJdXUIjnF6u+O1MvgP
         fHw+vOI/XQcSNNWQ8fCQUpBBsFaZrEIJk8AmAz4KPe7O6h2EGCblkQS5/TEwcwHosF
         g11J8O2dEvi0AwLETbplGhiM+fWNbPgCvsySMjvM=
Date:   Thu, 4 Jun 2020 23:16:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2] crypto: DRBG - always try to free Jitter RNG instance
Message-ID: <20200605061646.GA107328@sol.localdomain>
References: <0000000000002a280b05a725cd93@google.com>
 <2551009.mvXUDI8C0e@positron.chronox.de>
 <20200605004336.GC148196@sol.localdomain>
 <5789529.snvNDI1NMy@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5789529.snvNDI1NMy@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 05, 2020 at 07:58:15AM +0200, Stephan Mueller wrote:
> Am Freitag, 5. Juni 2020, 02:43:36 CEST schrieb Eric Biggers:
> 
> Hi Eric,
> 
> > On Thu, Jun 04, 2020 at 08:41:00AM +0200, Stephan Müller wrote:
> > > The Jitter RNG is unconditionally allocated as a seed source follwoing
> > > the patch 97f2650e5040. Thus, the instance must always be deallocated.
> > > 
> > > Reported-by: syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com
> > > Fixes: 97f2650e5040 ("crypto: drbg - always seeded with SP800-90B ...")
> > > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > > ---
> > > 
> > >  crypto/drbg.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/crypto/drbg.c b/crypto/drbg.c
> > > index 37526eb8c5d5..8a0f16950144 100644
> > > --- a/crypto/drbg.c
> > > +++ b/crypto/drbg.c
> > > @@ -1631,6 +1631,9 @@ static int drbg_uninstantiate(struct drbg_state
> > > *drbg)> 
> > >  	if (drbg->random_ready.func) {
> > >  	
> > >  		del_random_ready_callback(&drbg->random_ready);
> > >  		cancel_work_sync(&drbg->seed_work);
> > > 
> > > +	}
> > > +
> > > +	if (!IS_ERR_OR_NULL(drbg->jent)) {
> > > 
> > >  		crypto_free_rng(drbg->jent);
> > >  		drbg->jent = NULL;
> > >  	
> > >  	}
> > 
> > It it okay that ->jent can be left as an ERR_PTR() value?
> > 
> > Perhaps it should always be set to NULL?
> 
> The error value is used in the drbg_instantiate function. There it is checked 
> whether -ENOENT (i.e. the cipher is not available) or any other error is 
> present. I am not sure we should move that check.
> 
> Thanks for the review.
> > 

drbg_seed() and drbg_async_seed() check for drbg->jent being NULL.

Will that now break due it drbg->jent possibly being an ERR_PTR()?

Hence why I'm asking whether drbg_uninstantiate() should set it to NULL.

- Eric
