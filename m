From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v7 1/5] random: Blocking API for accessing nonblocking_pool
Date: Wed, 20 May 2015 20:49:45 +0200
Message-ID: <3555912.bTyystq8tU@tachyon.chronox.de>
References: <1693038.ndeE0L22jl@tachyon.chronox.de> <143216583.t5fUODkLsI@tachyon.chronox.de> <20150520184535.GA15438@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58038 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbbETSts (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 May 2015 14:49:48 -0400
In-Reply-To: <20150520184535.GA15438@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 21. Mai 2015, 02:45:35 schrieb Herbert Xu:

Hi Herbert,

> On Wed, May 20, 2015 at 07:44:39PM +0200, Stephan Mueller wrote:
> > +	if (unlikely(nonblocking_pool.initialized == 0)) {
> > +		do {
> > +			rc = wait_event_interruptible(urandom_init_wait,
> > +						nonblocking_pool.initialized);
> > +		} while (rc == -ERESTARTSYS);
> 
> This is just a convoluted way of doing an uninterruptible sleep.
> Either make it uninterruptible or allow the function to return
> an error.

Sorry, I overlooked the availability of wait_event. I was looking for it 
initially, but missed it. I will fix it right away.

-- 
Ciao
Stephan
