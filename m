From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock: fix for non-64byte aligned data
Date: Thu, 2 Dec 2010 14:14:41 +0800
Message-ID: <20101202061441.GA22378@gondor.apana.org.au>
References: <1288893036-31704-1-git-send-email-phil@nwl.cc> <20101104184606.GA1994@gondor.apana.org.au> <20101105141238.GG29793@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
	Nico Erfurth <ne@erfurth.eu>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
To: Phil Sutter <phil@nwl.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:42963 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab0LBGOv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Dec 2010 01:14:51 -0500
Content-Disposition: inline
In-Reply-To: <20101105141238.GG29793@orbit.nwl.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 05, 2010 at 03:12:38PM +0100, Phil Sutter wrote:
> 
> Yes, kind of. With that trivial fix applied, the driver is stable most
> of the time.

Great.

> Yes, it does, but triggering the bug is not really trivial. I've had
> best results with a speed testing tool using the asynchronous interface,
> memory corruption occured in each run. The same tool operating
> synchronously doesn't crash as soon, but having three or more instances
> running in parallel yields the same result.
> 
> This problem is so racey, a simple printk statement at the beginning of
> padlock_xcrypt_ecb() fixes it. Enclosing the same function's content in
> lock_kernel()/unlock_kernel() statements helps as well.

Interesting.  Do you have preemption enabled?

Can you share the test program with us?
 
> > Can you provide some information on the CPU where you're seeing
> > this?
> 
> This is the faulty one:
> | -bash-4.0# cat /proc/cpuinfo 
> | processor	: 0
> | vendor_id	: CentaurHauls
> | cpu family	: 6
> | model		: 15
> | model name	: VIA Nano processor L2200@1600MHz
> | stepping	: 2

Is there anyone else on the list who has this hardware?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
