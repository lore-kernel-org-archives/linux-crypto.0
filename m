From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing nonblocking_pool
Date: Mon, 18 May 2015 15:26:13 +0200
Message-ID: <2931045.EGfWxfUOa7@tauon>
References: <1921857.OvxEu6y28S@tachyon.chronox.de> <20150518092131.GA18659@gondor.apana.org.au> <7743005.ngVOaoViLi@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34829 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbbERN0R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 May 2015 09:26:17 -0400
In-Reply-To: <7743005.ngVOaoViLi@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 18. Mai 2015, 15:07:10 schrieb Stephan Mueller:

Hi Herbert,

>>
>>You can simplify this further and get rid of buf/nbytes.  All
>>we need to know is whether the pool is ready.  Everything else
>>can come from private.
>
>So, the async function is now just a notification of the caller. Sounds good
>with me.
>

I am just running into an interesting problem with a missing cancel operation: 
a caller instantiates a DRBG handle and invokes the seeding operation. The 
nonblocking_pool is not initialized. Therefore, the callback is put onto the 
list for being processed later.

Now, the caller releases the DRBG handle *before* the callback is triggered.

The callback is triggered with a pointer that is invalid, but the pointer is 
non-NULL. Therefore, I am not sure how to validate the pointer in the callback 
function.

I would think that there is no other way than to add a cancel API call that 
allows removing a list entry from the wait list.


Ciao
Stephan
