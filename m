From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing
 nonblocking_pool
Date: Mon, 18 May 2015 11:02:34 -0400
Message-ID: <20150518150234.GA4180@thunk.org>
References: <1921857.OvxEu6y28S@tachyon.chronox.de>
 <20150518092131.GA18659@gondor.apana.org.au>
 <7743005.ngVOaoViLi@tauon>
 <2931045.EGfWxfUOa7@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42633 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbbERPCr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 May 2015 11:02:47 -0400
Content-Disposition: inline
In-Reply-To: <2931045.EGfWxfUOa7@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 18, 2015 at 03:26:13PM +0200, Stephan Mueller wrote:
> 
> I am just running into an interesting problem with a missing cancel operation: 
> a caller instantiates a DRBG handle and invokes the seeding operation. The 
> nonblocking_pool is not initialized. Therefore, the callback is put onto the 
> list for being processed later.
> 
> Now, the caller releases the DRBG handle *before* the callback is triggered.
> 
> The callback is triggered with a pointer that is invalid, but the pointer is 
> non-NULL. Therefore, I am not sure how to validate the pointer in the callback 
> function.

The simplest thing to do is to put a refcount on inside the DRBG
handle structure.  The caller instantiates the DRBG handle, and
invokes the the DRBG.  The DRBG, since it is kicking off an
asynchronous operation, increments the refcount.

Both the caller and the callback function, before they exit, drop the
refcount, and if they see the refcount is zero, they free the DRBG
handle and the memory where the random seed is to be (or has been)
deposited.

This is the same pattern that the block I/O layer uses with a bio
struct.  In the BIO case, it's important since the callback function
could have been called and returned before the caller gets control
back from the bio_submit() call.  Or the struct bio may contain an
EOPNOTSUPP error, in which case there will be no callback function
dispatched.  So long as everyone handles the refcount rules, it all
works out.

Regards,

					- Ted
