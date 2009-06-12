From: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH] arm/orion5x: add sram support for crypto
Date: Thu, 11 Jun 2009 21:02:37 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0906112041470.31536@xanadu.home>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
 <1244728999-8103-2-git-send-email-arm-kernel@ml.breakpoint.cc>
 <alpine.LFD.2.00.0906111513420.31536@xanadu.home>
 <20090611201530.GA11486@Chamillionaire.breakpoint.cc>
 <alpine.LFD.2.00.0906111625280.31536@xanadu.home>
 <20090611210734.GA11920@Chamillionaire.breakpoint.cc>
 <20090611211523.GF21128@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:35350 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZFLBCz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 21:02:55 -0400
Received: from xanadu.home ([66.131.194.97]) by VL-MH-MR001.ip.videotron.ca
 (Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007; 32bit))
 with ESMTP id <0KL300IJTPKDJEO0@VL-MH-MR001.ip.videotron.ca> for
 linux-crypto@vger.kernel.org; Thu, 11 Jun 2009 21:02:37 -0400 (EDT)
In-reply-to: <20090611211523.GF21128@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 11 Jun 2009, Russell King - ARM Linux wrote:

> For these interfaces, I am a strong believer in purpose-defined
> interfaces to caches and the like.  If what we have doesn't provide
> what's required, we need to provide something else.
> 
> So, the question is what are you trying to do with this
> dmac_flush_range() and your SRAM?  Are you trying to achieve I/D cache
> coherency for data written there, so you can execute it later, or are
> you trying to ensure DMA coherency from SRAM?

It is a typical case of cache coherency between kernel and user space.

The Orion crypto engine works on data stored in a block of SRAM.  
Currently the driver does not (yet) make use of the available DMA to 
copy data back and forth between SRAM and main memory.  At the 
moment it uses memcpy() which dirties the cache when the data is copied 
back to the kernel memory.

Amongst users of the crypto API you have dm_crypt which makes decrypted 
data visible to user space.  So we get the same classic corruption 
effect on ARM as with a hardware block driver using PIO without 
flush_dcache_page().  Other kernel based crypto users don't have that 
issue of course.

It is of course the goal to use DMA instead of memcpy() eventually, at 
which point there won't be any dirty data in the cache and this issue 
will go away.


Nicolas
