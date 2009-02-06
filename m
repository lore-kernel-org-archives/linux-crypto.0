From: Frank Seidel <frank@f-seidel.de>
Subject: Re: [PATCH] crypto: add missing KERN_* constants to printks
Date: Fri, 06 Feb 2009 15:54:38 +0100
Message-ID: <498C4F2E.1070204@f-seidel.de>
References: <498C46DE.8040700@suse.de> <20090206145838.GA28197@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Frank Seidel <fseidel@suse.de>,
	linux kernel <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	jarod@redhat.com
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758627AbZBFOze@vger.kernel.org>
In-Reply-To: <20090206145838.GA28197@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Alexey Dobriyan schrieb:
> On Fri, Feb 06, 2009 at 03:19:10PM +0100, Frank Seidel wrote:
>> According to kerneljanitors todo list all printk calls (beginning
>> a new line) should have an according KERN_* constant.
> 
> Forget about kernel janitors todo list, fix a bug instead.

Sure, i am eager to get my hands dirty in the kernel ;-),
but i needed to start somewhere and everybody told me
that the janitors todo list would be good place to start.

>> Those are the missing pieces here for the crypto subsystem.
> 
> You're inserting KERN_WARNING everywhere, what for?

Because every new line should have KERN_* constant and
KERN_WARNING is default/doesn't change current printout
behaviour.

Thanks,
Frank
