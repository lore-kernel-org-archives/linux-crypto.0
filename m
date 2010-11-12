From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [CRYPTO] obfuscating kernel pointers
Date: Fri, 12 Nov 2010 13:54:13 -0500
Message-ID: <20101112185413.GB26217@hmsreliant.think-freely.org>
References: <1289568721.3090.267.camel@Dan>
 <20101112172727.GA26217@hmsreliant.think-freely.org>
 <1289583581.2034.8.camel@dan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dan Rosenberg <drosenberg@vsecurity.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49067 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab0KLS45 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Nov 2010 13:56:57 -0500
Content-Disposition: inline
In-Reply-To: <1289583581.2034.8.camel@dan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 12, 2010 at 12:39:41PM -0500, Dan Rosenberg wrote:
> Thanks for your response.
> 
> > > 
> > Just use get_random_bytes, or initalize an instance of cprng with
> > get_random_bytes.
> > 
> 
> Will do.
> 
> > 
> > Depends on your goal, if you just wnat to hide the pointers, why not just print
> > NULL instead of the value?  If you want to maintain some level of uniqueness,
> > just pull sizeof (void *) random bytes from whatever method above and add it to
> > the pointer in question, and hope for the best.
> > 
> 
> Unfortunately, neither of these sound like an option.  It's been
> requested from the networking folks that any replacement value for the
> socket addresses be a consistent unique identifier for object tracking
> purposes.  The current plan is to expose the real address to privileged
> readers, and expose a consistent obfuscated address that's only useful
> for tracking to unprivileged readers.
> 
adding a consistent random value to a your void * pointers sounds like a fine
solution to the problem, then.  As long as you use the same random value for the
lifetime of the system, that will give you consistent values.  And you have to
use the same random input consistently to have consistent output on multiple
concatinations of the same file anyway.  This also has the advantage of not
having to do a crypto operation for every print/seq_sprintf/etc that contains a
%p.


> > Honestly, though, I'm having trouble seeing the value of this.  What interface in proc
> > are you seeing that exposes pointers from kernel space in any meaningful way?
> > and if those cases exist, isn't selinux the solution to preventing exposure of
> > these values to processes without sufficient privlidges?
> > Neil
> > 
> 
> Lots of packet families expose them...see, for
> example, /proc/net/{tcp,udp,raw,unix}.  Since socket structures have
> function pointers, they are an appealing target in the event of a kernel
> memory write vulnerability.  The goal here is to make exploitation of
> such issues more difficult, including for distros that don't use
> SELinux.
> 
huh, I guess they do spit out pointer values.  At any rate, I'm still having a
hard time seeing the value here.  If a distro doesn't enforce a security policy
sufficient to protect against information leaks from exposed files, I don't see
why the kernel should do that work for it.  But regardless, I suppose thats a
debate to hav when you post a patch :)

> Thanks,
> Dan
> 
> 
