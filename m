From: Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: [CRYPTO] obfuscating kernel pointers
Date: Fri, 12 Nov 2010 12:39:41 -0500
Message-ID: <1289583581.2034.8.camel@dan>
References: <1289568721.3090.267.camel@Dan>
	 <20101112172727.GA26217@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.vsecurity.com ([209.67.252.12]:51755 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0KLRjo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Nov 2010 12:39:44 -0500
In-Reply-To: <20101112172727.GA26217@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks for your response.

> > 
> Just use get_random_bytes, or initalize an instance of cprng with
> get_random_bytes.
> 

Will do.

> 
> Depends on your goal, if you just wnat to hide the pointers, why not just print
> NULL instead of the value?  If you want to maintain some level of uniqueness,
> just pull sizeof (void *) random bytes from whatever method above and add it to
> the pointer in question, and hope for the best.
> 

Unfortunately, neither of these sound like an option.  It's been
requested from the networking folks that any replacement value for the
socket addresses be a consistent unique identifier for object tracking
purposes.  The current plan is to expose the real address to privileged
readers, and expose a consistent obfuscated address that's only useful
for tracking to unprivileged readers.

> Honestly, though, I'm having trouble seeing the value of this.  What interface in proc
> are you seeing that exposes pointers from kernel space in any meaningful way?
> and if those cases exist, isn't selinux the solution to preventing exposure of
> these values to processes without sufficient privlidges?
> Neil
> 

Lots of packet families expose them...see, for
example, /proc/net/{tcp,udp,raw,unix}.  Since socket structures have
function pointers, they are an appealing target in the event of a kernel
memory write vulnerability.  The goal here is to make exploitation of
such issues more difficult, including for distros that don't use
SELinux.

Thanks,
Dan
