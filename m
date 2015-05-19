From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing
 nonblocking_pool
Date: Tue, 19 May 2015 15:51:55 +0800
Message-ID: <20150519075155.GA29242@gondor.apana.org.au>
References: <1921857.OvxEu6y28S@tachyon.chronox.de>
 <6511355.kQJsTdtLzf@tachyon.chronox.de>
 <20150519072227.GA28837@gondor.apana.org.au>
 <2404915.vbuKFfjVR8@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38005 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbbESHwI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 May 2015 03:52:08 -0400
Content-Disposition: inline
In-Reply-To: <2404915.vbuKFfjVR8@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 19, 2015 at 09:35:15AM +0200, Stephan Mueller wrote:
> 
> Thank you for the hints. I will follow your guidance.
> 
> Just for my edification: why is this (rather complex sounding) approach 
> preferred over a simple cancel API? Other async APIs (e.g. the AIO syscalls 
> with io_cancel) have such cancel operations.
> 
> Such cancel function would be as simple as:

You're right.  The cancel function is indeed simpler.  I can
certainly live with that.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
