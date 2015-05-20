From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v7 1/5] random: Blocking API for accessing nonblocking_pool
Date: Wed, 20 May 2015 21:38:38 +0200
Message-ID: <1985784.azciXBjbjY@tachyon.chronox.de>
References: <1693038.ndeE0L22jl@tachyon.chronox.de> <20150520184535.GA15438@gondor.apana.org.au> <3555912.bTyystq8tU@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58047 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbbETTil (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 May 2015 15:38:41 -0400
In-Reply-To: <3555912.bTyystq8tU@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 20. Mai 2015, 20:49:45 schrieb Stephan Mueller:

Hi Herbert,

> > This is just a convoluted way of doing an uninterruptible sleep.
> > Either make it uninterruptible or allow the function to return
> > an error.
> 
> Sorry, I overlooked the availability of wait_event. I was looking for it
> initially, but missed it. I will fix it right away.

After checking a bit more, I see that an uninterruptible sleep cannot be 
canceled with cancel_work_sync. Therefore, replacing it with wait_event does 
not work.

Thus, go get an uninterruptible sleep which yet can be canceled seems to 
require wait_event_interruptible together with the check for ERESTARTSYS.

Nonetheless, I move the loop out to the DRBG code as requested.

-- 
Ciao
Stephan
