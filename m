From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] random: make /dev/urandom scalable for silly
 userspace programs
Date: Mon, 30 May 2016 13:29:15 -0400
Message-ID: <20160530172915.GH12629@thunk.org>
References: <1464586765-14436-1-git-send-email-tytso@mit.edu>
 <1464586765-14436-3-git-send-email-tytso@mit.edu>
 <5245285.5ppKq7E4P6@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, cryptography@lakedaemon.net, jsd@av8n.com,
	hpa@zytor.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48016 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161249AbcE3R32 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 May 2016 13:29:28 -0400
Content-Disposition: inline
In-Reply-To: <5245285.5ppKq7E4P6@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 30, 2016 at 08:03:59AM +0200, Stephan Mueller wrote:
> >  static int rand_initialize(void)
> >  {
> > +#ifdef CONFIG_NUMA
> > +	int i;
> > +	int num_nodes = num_possible_nodes();
> > +	struct crng_state *crng;
> > +
> > +	crng_node_pool = kmalloc(num_nodes * sizeof(void *),
> > +				 GFP_KERNEL|__GFP_NOFAIL);
> > +
> > +	for (i=0; i < num_nodes; i++) {
> > +		crng = kmalloc(sizeof(struct crng_state),
> > +			       GFP_KERNEL | __GFP_NOFAIL);
> > +		initialize_crng(crng);
> 
> Could you please help me understand the logic flow here: The NUMA secondary 
> DRNGs are initialized before the input/blocking pools and the primary DRNG.
> 
> The initialization call uses get_random_bytes() for the secondary DRNGs. But 
> since the primary DRNG is not yet initialized, where does the get_random_bytes 
> gets its randomness from?

Yeah, I screwed up.  The hunk of code staring with "crng_node_pool =
kmalloc(..." and the for loop afterwards should be moved to after
_initialize_crng().  Serves me right for not testing CONFIG_NUMA
before sending out the patches.

This is *not* about adding entropy; as you've noted, this is done very
early in boot up, before there has been any chance for any kind of
entropy to be collected in any of the input pools.  It's more of a
insurance policy just in case on some platform, if it turns out that
assuming a bit's worth of entropy per interrupt was hopelessly
over-optimistic, at least the starting point will be different across
different kernels (and maybe different boot times, but on the sorts of
platforms where I'm most concerned, there may not be a real-time clock
and almost certainly not a architectural hwrng in the CPU).

	      		      	       - Ted
