From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [CRYPTO] obfuscating kernel pointers
Date: Fri, 12 Nov 2010 12:27:27 -0500
Message-ID: <20101112172727.GA26217@hmsreliant.think-freely.org>
References: <1289568721.3090.267.camel@Dan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dan Rosenberg <drosenberg@vsecurity.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45572 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0KLRaX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Nov 2010 12:30:23 -0500
Content-Disposition: inline
In-Reply-To: <1289568721.3090.267.camel@Dan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 12, 2010 at 08:32:01AM -0500, Dan Rosenberg wrote:
> Hi Crypto people,
> 
> I'm planning on submitting a patch that introduces a new %p format
> specifier that obfuscates kernel pointers depending on privileges.  This
> change is for security reasons - many networking protocols expose
> pointers to socket structures in their /proc interfaces, which are
> attractive targets when exploiting other issues.
> 
> It's been suggested that I initialize a secret value at boot, and use
> that as the key to a crypto hash function.  I should use a function that
> is relatively fast (ideally), produces a unique output based on its
> input of a pointer, and produces consistent output when given the same
> input.  It should be difficult to infer the input given only the output.
> 
> I have two questions:
> 
> 1. What is a proper, safe way of initializing a random value at boot?
> Are there any existing examples that do this?
> 
Just use get_random_bytes, or initalize an instance of cprng with
get_random_bytes.

> 2. Can you recommend a crypto algorithm that would be well suited for
> this pointer obfuscation?
> 

Depends on your goal, if you just wnat to hide the pointers, why not just print
NULL instead of the value?  If you want to maintain some level of uniqueness,
just pull sizeof (void *) random bytes from whatever method above and add it to
the pointer in question, and hope for the best.

Honestly, though, I'm having trouble seeing the value of this.  What interface in proc
are you seeing that exposes pointers from kernel space in any meaningful way?
and if those cases exist, isn't selinux the solution to preventing exposure of
these values to processes without sufficient privlidges?
Neil

> Thanks,
> Dan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
