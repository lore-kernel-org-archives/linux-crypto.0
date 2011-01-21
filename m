From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] Add RNG support to AF_ALG (v2)
Date: Fri, 21 Jan 2011 07:09:50 -0500
Message-ID: <20110121120950.GB30868@hmsreliant.think-freely.org>
References: <1292260317-2684-1-git-send-email-nhorman@tuxdriver.com>
 <1292275514-2488-1-git-send-email-nhorman@tuxdriver.com>
 <20110120233440.GA2451@localhost.localdomain>
 <20110121060005.GA9768@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58543 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1AUMJ7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Jan 2011 07:09:59 -0500
Content-Disposition: inline
In-Reply-To: <20110121060005.GA9768@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 21, 2011 at 05:00:05PM +1100, Herbert Xu wrote:
> On Thu, Jan 20, 2011 at 06:34:40PM -0500, Neil Horman wrote:
> >
> > Herbert, Sorry to bug you about this, but are you still planning on pulling this
> > now that Linus has the infrastructure scheduled for 2.6.38?
> 
> I think it's best if we leave this out for now, unless we can
> come up with some way of merging this with the hardware RNG
> interface so that we are not duplicating an existing user interface.
> 
I take your point, but I'm not certain I agree that we are duplicating an
existing user interface.  A cursory glance would say that we are, but
/dev/random and /dev/urandom really just provide access to the kernels entropy
pools, whereas the AF_ALG provides access to instances of any RNG the kernel has
to offer as well as the key management services that AF_ALG has, which I think
is adventageous, given that the CPRNG requires keying to work properly.

> Could we perhaps merge this with the HWRNG interface somehow?
We could certainly, add an ioctl to place /dev/[u]random in a cprng mode, and
another to allow key setting/resets/etc, but that seems fairly limiting in that
only one instace of a cprng could be accessed at a time.

> Or maybe we should just expose ansi_cprng (I presume you only
> need that) through the hwrng interface?
> 
Again, we could, but that doesn't seem wise if:
1) A user is expecting truly random data
2) A user needs to truly have predicitbility of their random number set (if
they're using the cprng, multiple un-cordinated users breaks the ability to
predict the rng data).

Another alternative (just off the top of my head), might be to eliminate the
hwrng interface in the kernel entirely, and replace it with the AF_ALG based
interface.  People requiring access to /dev/random until their applications can
be migrated could still access /dev/[u]random via a user space daemon that opens
2 unix sockets, binds them to /dev/[u]random, and proxies them to two AF_ALG
sockets connected to the blocking and non-blocking entropy pools in the kernel.

Not saying thats a great idea mind, just brainstorming ways we can eliminate
interface duplication without restricting the CPRNG to a character based
interface, when AF_ALG provides it so much more.
Neil

> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
