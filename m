From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-integrity: don't store cipher request on the stack (was:
 [QUESTION] hash import and request initialization)
Date: Wed, 10 Jan 2018 10:13:53 -0500
Message-ID: <20180110151353.GA23626@redhat.com>
References: <CAOtvUMdsqEpUSSBZXxHPzuO-84B3VKxRLLN=y1cxfNbt+5qpSQ@mail.gmail.com>
 <20171226030751.GA11758@gondor.apana.org.au>
 <CAOtvUMfkGgyhCTUpfpegfmR3DNYhvfRN4oHL1tY9RMRh5sfCfQ@mail.gmail.com>
 <20171226104010.GA28275@gondor.apana.org.au>
 <CAOtvUMeEw88mYVjb7bDLwGb67aXi2p5e-uRXn0XrDe0uddyT6g@mail.gmail.com>
 <20171227033500.GA32764@gondor.apana.org.au>
 <alpine.LRH.2.02.1801100931240.7460@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964976AbeAJPOJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jan 2018 10:14:09 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1801100931240.7460@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 10 2018 at  9:32am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Wed, 27 Dec 2017, Herbert Xu wrote:
> 
> > On Tue, Dec 26, 2017 at 02:21:53PM +0200, Gilad Ben-Yossef wrote:
> > > 
> > > See how SKCIPHER_REQUEST_ON_STACK is being used with an asymmetric skcipher
> > > in drivers/md/dm-integrity.c
> > 
> > That's just broken.  SKCIPHER_REQUEST_ON_STACK is only meant for
> > sync algorithms and this code needs to be changed to either do the
> > proper request allocation or switch over to allocating sync
> > algorithms.
> > 
> > Cheers,
> 
> Hi
> 
> Here I send a patch that moves those allocations to the heap.

Thanks, I'll review and hope to stage for 4.16 today.

Mike
