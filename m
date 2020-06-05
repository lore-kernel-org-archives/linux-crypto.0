Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAB5C433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 16:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86A2C2075B
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 16:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591374113;
	bh=yXlHNujYNL2zAYwsJV+R7NnqHW/0LBT1FPOxbjdwRJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2aMm27jUkhvYa+qjy2MLb4hJNJ1P/u1Z4cLhCYtkXaefUAlHxt9SAoJNBjPXFy6zw
	 txMCq981itHVD6z09C2JAC278/M5vNVe+4AlWXJgqYQ7YZ28eDfbFDFD9b2Q5dj1h1
	 emoWRj+UvVDoYt5Vawt3ZAytIvztG3mwlYZaEzrA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgFEQVw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 12:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbgFEQVv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 12:21:51 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D067A2074B;
        Fri,  5 Jun 2020 16:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591374111;
        bh=yXlHNujYNL2zAYwsJV+R7NnqHW/0LBT1FPOxbjdwRJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yJIvkNDYzI7j7qwWd7DibhmEZte6uMEeS/RI1cJoQQ546UDZY532LtucZHSOGZlEt
         zHpD+dK/AyW3kmxG4Vc1jZdpBmj3CXP5kU62zXLreSpw2sCniKa1h4g6TPr9os6J8D
         2ELPKq/pTH2Ms6+PHCGtb9MJ20CnP6brn+e89zXc=
Date:   Fri, 5 Jun 2020 09:21:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2] crypto: DRBG - always try to free Jitter RNG instance
Message-ID: <20200605162149.GE1373@sol.localdomain>
References: <0000000000002a280b05a725cd93@google.com>
 <5789529.snvNDI1NMy@tauon.chronox.de>
 <20200605061646.GA107328@sol.localdomain>
 <4575667.y41LbVH5lo@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4575667.y41LbVH5lo@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 05, 2020 at 08:52:57AM +0200, Stephan Mueller wrote:
> Am Freitag, 5. Juni 2020, 08:16:46 CEST schrieb Eric Biggers:
> 
> Hi Eric,
> 
> > On Fri, Jun 05, 2020 at 07:58:15AM +0200, Stephan Mueller wrote:
> > > Am Freitag, 5. Juni 2020, 02:43:36 CEST schrieb Eric Biggers:
> > > 
> > > Hi Eric,
> > > 
> > > > On Thu, Jun 04, 2020 at 08:41:00AM +0200, Stephan Müller wrote:
> > > > > The Jitter RNG is unconditionally allocated as a seed source follwoing
> > > > > the patch 97f2650e5040. Thus, the instance must always be deallocated.
> > > > > 
> > > > > Reported-by: syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com
> > > > > Fixes: 97f2650e5040 ("crypto: drbg - always seeded with SP800-90B
> > > > > ...")
> > > > > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > > > > ---
> > > > > 
> > > > >  crypto/drbg.c | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > > 
> > > > > diff --git a/crypto/drbg.c b/crypto/drbg.c
> > > > > index 37526eb8c5d5..8a0f16950144 100644
> > > > > --- a/crypto/drbg.c
> > > > > +++ b/crypto/drbg.c
> > > > > @@ -1631,6 +1631,9 @@ static int drbg_uninstantiate(struct drbg_state
> > > > > *drbg)>
> > > > > 
> > > > >  	if (drbg->random_ready.func) {
> > > > >  	
> > > > >  		del_random_ready_callback(&drbg->random_ready);
> > > > >  		cancel_work_sync(&drbg->seed_work);
> > > > > 
> > > > > +	}
> > > > > +
> > > > > +	if (!IS_ERR_OR_NULL(drbg->jent)) {
> > > > > 
> > > > >  		crypto_free_rng(drbg->jent);
> > > > >  		drbg->jent = NULL;
> > > > >  	
> > > > >  	}
> > > > 
> > > > It it okay that ->jent can be left as an ERR_PTR() value?
> > > > 
> > > > Perhaps it should always be set to NULL?
> > > 
> > > The error value is used in the drbg_instantiate function. There it is
> > > checked whether -ENOENT (i.e. the cipher is not available) or any other
> > > error is present. I am not sure we should move that check.
> > > 
> > > Thanks for the review.
> > 
> > drbg_seed() and drbg_async_seed() check for drbg->jent being NULL.
> > 
> > Will that now break due it drbg->jent possibly being an ERR_PTR()?
> > 
> > Hence why I'm asking whether drbg_uninstantiate() should set it to NULL.
> 
> The allocation happens in drbg_prepare_hrng that is only invoked by 
> drbg_instantiate.
> 
> drbg_instantiate checks for the ERR_PTR and sets it to NULL in case the error 
> is deemed ok.
> 
> Thus, any subsequent functions would see either a valid pointer or NULL. The 
> only exception is drbg_uninstantiate when invoked from the error case 
> 
>                 ret = drbg_prepare_hrng(drbg);
>                 if (ret)
>                         goto free_everything;
> 
> Thus, I think that the two functions you mention will never see any values 
> other than NULL or a valid pointer.
> 

To be concrete, I'm suggesting:

	if (!IS_ERR_OR_NULL(drbg->jent))
		crypto_free_rng(drbg->jent);
	drbg->jent = NULL;

This would be similar to how drbg_dealloc_state() sets lots of other fields of
the drbg_state to NULL.

It's your call though.  I haven't properly read this code; the above is just
what makes sense to me at first glance...

- Eric
