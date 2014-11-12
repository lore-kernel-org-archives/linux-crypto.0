From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [QUESTION] Crypto queue handling
Date: Wed, 12 Nov 2014 12:10:19 +0800
Message-ID: <20141112041019.GA24334@gondor.apana.org.au>
References: <201405261758.19425.marex@denx.de>
 <20140530093030.GC12760@gondor.apana.org.au>
 <A83C99F8370D4D42BEB2D2B3153A6BBC30807A82@NASANEXD02C.na.qualcomm.com>
 <20140530134135.GA14778@gondor.apana.org.au>
 <CAH=tA9E0h04HP70S8Ua4nYxZ=7ncmYe=wjNK=y5jSoY52Xrrug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>,
	Marek Vasut <marex@denx.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Pantelis Antoniou <panto@antoniou-consulting.com>
To: Nicolae Rosia <nicolae.rosia@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:54746 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaKLEKf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Nov 2014 23:10:35 -0500
Content-Disposition: inline
In-Reply-To: <CAH=tA9E0h04HP70S8Ua4nYxZ=7ncmYe=wjNK=y5jSoY52Xrrug@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 11, 2014 at 08:04:03PM +0200, Nicolae Rosia wrote:
> On Fri, May 30, 2014 at 4:41 PM, Herbert Xu <herbert@gondor.apana.org.au>
> wrote:
> 
> > [...]
> > This is because the user is supposed to back off once they get
> > EBUSY, until they're notified once the backlog entry is popped
> > off (but not processed, it must be resubmitted).
> > [...]
> >
> 
> I'm trying to understand the backlog mechanism and after reading the source
> of crypto_enqueue_request and Stephan Mueller's example [1], my
> understanding is that the user does not have to queue again the backlogged
> request because when it returned -EBUSY it was added to the
> crypto_queue->list. Am I missing something?

You're right, the backlogged request does not need to be resubmitted.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
