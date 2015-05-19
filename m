From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing
 nonblocking_pool
Date: Tue, 19 May 2015 22:18:05 +0800
Message-ID: <20150519141805.GA32663@gondor.apana.org.au>
References: <1921857.OvxEu6y28S@tachyon.chronox.de>
 <6511355.kQJsTdtLzf@tachyon.chronox.de>
 <20150519072227.GA28837@gondor.apana.org.au>
 <2404915.vbuKFfjVR8@tachyon.chronox.de>
 <20150519075155.GA29242@gondor.apana.org.au>
 <20150519135028.GC20421@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150519135028.GC20421@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 19, 2015 at 09:50:28AM -0400, Theodore Ts'o wrote:
>
> Finally, this is only going to block *once*, when the system is
> initially botting up.  Why is it so important that we get the
> asynchronous nature of this right, and why can't we solve it simply by
> just simply doing the work in a workqueue, with a completion barrier
> getting triggered once /dev/random initializes itself, and just simply
> blocking the module unload until /dev/random is initialized?

I guess I'm still thinking of the old work queue code before
Tejun's cmwq work.  Yes blocking in a work queue should be fine
as there is usually just one DRBG instance.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
