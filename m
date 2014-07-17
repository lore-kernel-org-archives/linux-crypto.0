From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 17:28:06 -0400
Message-ID: <20140717212806.GV1491@thunk.org>
References: <201407171848.s6HImBb4027900@glazunov.sibelius.xs4all.nl>
 <53C83383.4040507@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Kettenis <mark.kettenis@xs4all.nl>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	beck@openbsd.org
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41858 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaGQV2P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2014 17:28:15 -0400
Content-Disposition: inline
In-Reply-To: <53C83383.4040507@amacapital.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 17, 2014 at 01:35:15PM -0700, Andy Lutomirski wrote:
> 
> Can we please have a mode in which getrandom(2) can neither block nor
> fail?  If that gets added, then this can replace things like AT_RANDOM.

AT_RANDOM has been around for a long time; it's not something we can
remove. 

> There are non-crypto things out there that will want this.  There are
> also probably VM systems (especially ones that have something like my
> KVM_GET_RNG_SEED patches applied, or many VMs on Haswell, for that
> matter) that will have perfectly fine cryptographically secure urandom
> output immediately after bootup but that won't consider themselves
> "initialized" for a while.  At least these will be perfectly fine from
> the POV of those who trust their hypervisor and Intel :)

If you trust Intel, then you can either use RDRAND directly, or you
can use rngd.  There is also plans to set up an hw_random RDRAND that
can be configured to automatically fill the entropy pool using the new
khwrngd, which could be configured using the appropriate boot options
for those who want to blindly trus their hypervisor and/or Intel.

However, I don't think that should be the default.  And on x86 systems
at least, this is largely a moot point, since the /dev/urandom pool
gets initialized *very* quickly after the system boots.  It's only on
the !@#! ARM systems that don't have a cycle counter, or apparently no
reliable way to make sure the cycle counter is present, which seems to
be the place where we have problems.  But I'd much rather gradually
apply more pressure to the ARM folks so they finally fix their CPU
architecture, and this is one step down that path without forcibly
breaking existing userspace.

						- Ted
