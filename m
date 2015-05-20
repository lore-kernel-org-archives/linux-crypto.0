From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v9 3/5] crypto: drbg - add async seeding operation
Date: Thu, 21 May 2015 05:44:08 +0800
Message-ID: <20150520214408.GA17264@gondor.apana.org.au>
References: <3340545.QDDPvU7BuN@tachyon.chronox.de>
 <12904468.qCSNRrkb6t@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38051 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbbETVoW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 May 2015 17:44:22 -0400
Content-Disposition: inline
In-Reply-To: <12904468.qCSNRrkb6t@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 20, 2015 at 10:03:45PM +0200, Stephan Mueller wrote:
>> @@ -1487,6 +1514,7 @@ unlock:
>   */
>  static int drbg_uninstantiate(struct drbg_state *drbg)
>  {
> +	cancel_work_sync(&drbg->seed_work);

This will just block until the work is done, i.e., until the
pool is ready.  It's no different to an uninterruptible sleep.

So either just do an uninterruptible sleep, or allow the async
seed to fail.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
