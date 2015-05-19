From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing
 nonblocking_pool
Date: Tue, 19 May 2015 15:22:27 +0800
Message-ID: <20150519072227.GA28837@gondor.apana.org.au>
References: <1921857.OvxEu6y28S@tachyon.chronox.de>
 <2931045.EGfWxfUOa7@tauon>
 <20150518150234.GA4180@thunk.org>
 <6511355.kQJsTdtLzf@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47035 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbbESHWm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 May 2015 03:22:42 -0400
Content-Disposition: inline
In-Reply-To: <6511355.kQJsTdtLzf@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 19, 2015 at 07:58:25AM +0200, Stephan Mueller wrote:
> 
> Herbert, do you have any ideas?

On the /dev/random side,

1) Add a struct module argument in addition to func/data.
2) Grab module ref count when func/data is registered.
3) Drop module ref count after func returns.

On the drbg side,

1) Allocate data pointer before func/data registration, it should
contain a flag indicating whether drbg is still alive.
2) In cra_exit, zap the flag in allocated data.
3) In func immediately return if flag indicates drbg is dead.
4) Free allocated data pointer when func is done.

Obviously you need to add some locking so that func doesn't race
against cra_exit or any other drbg paths that it intersects.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
