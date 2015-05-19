From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing
 nonblocking_pool
Date: Tue, 19 May 2015 09:50:28 -0400
Message-ID: <20150519135028.GC20421@thunk.org>
References: <1921857.OvxEu6y28S@tachyon.chronox.de>
 <6511355.kQJsTdtLzf@tachyon.chronox.de>
 <20150519072227.GA28837@gondor.apana.org.au>
 <2404915.vbuKFfjVR8@tachyon.chronox.de>
 <20150519075155.GA29242@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150519075155.GA29242@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 19, 2015 at 03:51:55PM +0800, Herbert Xu wrote:
> On Tue, May 19, 2015 at 09:35:15AM +0200, Stephan Mueller wrote:
> > 
> > Thank you for the hints. I will follow your guidance.
> > 
> > Just for my edification: why is this (rather complex sounding) approach 
> > preferred over a simple cancel API? Other async APIs (e.g. the AIO syscalls 
> > with io_cancel) have such cancel operations.
> > 
> > Such cancel function would be as simple as:
> 
> You're right.  The cancel function is indeed simpler.  I can
> certainly live with that.

I'm not at all convinced it's simpler.  I see it add a huge amount of
hair to drivers/char/random.c that is only used by a single caller.

I'm also not sure I understand herbert's suggstion of adding a struct
module to the /dev/random code.  Why is this helpful, and what is the
race that you are trying to protect against?

Finally, this is only going to block *once*, when the system is
initially botting up.  Why is it so important that we get the
asynchronous nature of this right, and why can't we solve it simply by
just simply doing the work in a workqueue, with a completion barrier
getting triggered once /dev/random initializes itself, and just simply
blocking the module unload until /dev/random is initialized?

	     	    	   	 	     - Ted
