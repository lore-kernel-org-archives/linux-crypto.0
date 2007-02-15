From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Thu, 15 Feb 2007 17:32:50 +0000
Message-ID: <32081.1171560770@redhat.com>
References: <Pine.LNX.4.64.0702151530260.14458@scrub.home>  <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Cc: torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, davej@redhat.com,
	arjan@infradead.org, linux-crypto@vger.kernel.org,
	dhowells@redhat.com
To: Roman Zippel <zippel@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030345AbXBORdF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Feb 2007 12:33:05 -0500
In-Reply-To: <Pine.LNX.4.64.0702151530260.14458@scrub.home> 
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Roman Zippel <zippel@linux-m68k.org> wrote:

> > Now, this is not a complete solution by any means: the core kernel is not
> > protected, and nor are /dev/mem or /dev/kmem, but it denies (or at least
> > controls) one relatively simple attack vector.
> 
> This is really the weak point - it offers no advantage over an equivalent 
> implementation in user space (e.g. in the module tools). So why has to be 
> done in the kernel?

Because the init_module() system call is the common point of module submission
to the kernel, not any particular userspace program.  There is no requirement
for userspace to load a module by invoking a module tools program or library,
and so userspace can bypass the checks entirely by just calling init_module().
Assume for a moment that you can't trust userspace...  (Obviously, if you can't
trust the kernel then you're already stuffed.)

It is possible to protect /dev/mem and /dev/kmem or make them unavailable and
it is possible to protect the kernel's memory whilst it is running (provided
you don't have nommu or broken hardware and you don't let userspace concoct any
DMA request it likes) which mostly closes those other vectors I mentioned.
This isn't something I intended to look at with this patch.  Those are separate
holes.

Making the core kernel load image inaccessible or immutable to root is not
something I can provide a generic solution for and security checking the core
kernel load image has to be done at an earlier layer as you can't rely on
something guaranteeing its own integrity because if someone can alter that
something, then they can bypass the self-checking too...

However, modules permits arbitrary modification of the running kernel to be
attempted.

David
