From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] crypto: add missing KERN_* constants to printks
Date: Fri, 6 Feb 2009 18:03:15 +0300
Message-ID: <20090206150315.GA28249@x200.localdomain>
References: <498C46DE.8040700@suse.de> <20090206145838.GA28197@x200.localdomain> <498C4F2E.1070204@f-seidel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Frank Seidel <fseidel@suse.de>,
	linux kernel <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	jarod@redhat.com
To: Frank Seidel <frank@f-seidel.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:43570 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZBFO5Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Feb 2009 09:57:16 -0500
Content-Disposition: inline
In-Reply-To: <498C4F2E.1070204@f-seidel.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 06, 2009 at 03:54:38PM +0100, Frank Seidel wrote:
> Alexey Dobriyan schrieb:
> > On Fri, Feb 06, 2009 at 03:19:10PM +0100, Frank Seidel wrote:
> >> According to kerneljanitors todo list all printk calls (beginning
> >> a new line) should have an according KERN_* constant.
> > 
> > Forget about kernel janitors todo list, fix a bug instead.
> 
> Sure, i am eager to get my hands dirty in the kernel ;-),
> but i needed to start somewhere and everybody told me
> that the janitors todo list would be good place to start.
> 
> >> Those are the missing pieces here for the crypto subsystem.
> > 
> > You're inserting KERN_WARNING everywhere, what for?
> 
> Because every new line should have KERN_* constant and
> KERN_WARNING is default/doesn't change current printout
> behaviour.

Some messages there were truly debugging and some clearly weren't
WARNING, but INFO.
