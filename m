From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing nonblocking_pool
Date: Tue, 19 May 2015 07:58:25 +0200
Message-ID: <6511355.kQJsTdtLzf@tachyon.chronox.de>
References: <1921857.OvxEu6y28S@tachyon.chronox.de> <2931045.EGfWxfUOa7@tauon> <20150518150234.GA4180@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34837 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbbESGsx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 May 2015 02:48:53 -0400
In-Reply-To: <20150518150234.GA4180@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 18. Mai 2015, 11:02:34 schrieb Theodore Ts'o:

Hi Theodore, Herbert,
> 
> The simplest thing to do is to put a refcount on inside the DRBG
> handle structure.  The caller instantiates the DRBG handle, and
> invokes the the DRBG.  The DRBG, since it is kicking off an
> asynchronous operation, increments the refcount.

That is a good idea. After experimenting with the refcount, I see that kernel 
crypto API release function of crypto_destroy_tfm unconditionally destroys the 
crypto handle by freeing it.

So, if a caller releases the DRBG handle, the DRBG code cannot prevent the 
destruction of its context with a refcount.

Herbert, do you have any ideas?

-- 
Ciao
Stephan
