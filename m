From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in af_alg_free_areq_sgls
Date: Tue, 28 Nov 2017 10:39:32 -0800
Message-ID: <20171128183932.GA45321@gmail.com>
References: <001a1140f578d9710d055efb76a9@google.com>
 <20171128090252.GB23413@zzz.localdomain>
 <2008707.GtIZiUutxC@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzbot
        <bot+ff72ab869817b6ea60bc570f638ee030f4fc73e5@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:38872 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753875AbdK1Sjg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 13:39:36 -0500
Content-Disposition: inline
In-Reply-To: <2008707.GtIZiUutxC@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 28, 2017 at 10:10:55AM +0100, Stephan Mueller wrote:
> > diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> > index 358749c38894..415a54ced4d6 100644
> > --- a/crypto/af_alg.c
> > +++ b/crypto/af_alg.c
> > @@ -672,14 +672,15 @@ void af_alg_free_areq_sgls(struct af_alg_async_req
> > *areq) }
> > 
> >  	tsgl = areq->tsgl;
> > -	for_each_sg(tsgl, sg, areq->tsgl_entries, i) {
> > -		if (!sg_page(sg))
> > -			continue;
> > -		put_page(sg_page(sg));
> > -	}
> > +	if (tsgl) {
> > +		for_each_sg(tsgl, sg, areq->tsgl_entries, i) {
> > +			if (!sg_page(sg))
> > +				continue;
> > +			put_page(sg_page(sg));
> > +		}
> > 
> > -	if (areq->tsgl && areq->tsgl_entries)
> 
> Why do you want to remove the check for areq->tsgl_entries? I know in the 
> current code that cannot happen. But it should be caught in case of a 
> programming error.
> 
> Thus, should we add a BUG_ON(!areq->tsgl_entries)?
> 

sock_kfree_s() works even if the size is 0.  So there's no reason to check.

Eric
