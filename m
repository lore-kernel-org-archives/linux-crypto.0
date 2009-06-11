From: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH] arm/orion5x: add sram support for crypto
Date: Thu, 11 Jun 2009 17:19:22 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0906111712060.31536@xanadu.home>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
 <1244728999-8103-2-git-send-email-arm-kernel@ml.breakpoint.cc>
 <alpine.LFD.2.00.0906111513420.31536@xanadu.home>
 <20090611201530.GA11486@Chamillionaire.breakpoint.cc>
 <alpine.LFD.2.00.0906111625280.31536@xanadu.home>
 <20090611210734.GA11920@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:21544 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZFKVTk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 17:19:40 -0400
Received: from xanadu.home ([66.131.194.97]) by VL-MH-MR001.ip.videotron.ca
 (Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007; 32bit))
 with ESMTP id <0KL300G88F8AIQB0@VL-MH-MR001.ip.videotron.ca> for
 linux-crypto@vger.kernel.org; Thu, 11 Jun 2009 17:19:22 -0400 (EDT)
In-reply-to: <20090611210734.GA11920@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 11 Jun 2009, Sebastian Andrzej Siewior wrote:

> * Nicolas Pitre | 2009-06-11 16:36:42 [-0400]:
> 
> >> Adding a revision history is good thing... I could not find the ARM tree
> >> but I've rebased this patch against the orion tree [0].
> >
> >Actually, I'm leaning towards the removal of such dynamic mappings 
> >altogether and keep an unconditional static mapping instead, just like 
> >Kirkwood does.
> Oh now I remember: I've been counting the number possible window
> mappings and they exceeded the number of availble slots. That's why I've
> made it dynamic and board specific. However if this is not an issue than
> static is probaly the better way.

There is no need for other physical mappings that I can see in the set 
of boards we currently support.  So I'll make it static until there is a 
real need for dynamic mapping.

> >> Since the driver got renamed, I'm going to send a delta if nothing else
> >> comes up.
> >
> >What is your plan for this driver?  Submit it now and add incremental 
> >improvements afterward or wait until it is more functional?
> I would like to get it squeezed into this merge window unless there are
> any objections and improve it afterwards.
> If you thing it is too early I can keep hacking in my own git tree until
> I get the dmac_flush_range() hack out or so.

I have no problem with you submitting it now.  It is not complete yet 
but what is there is plenty functional.  However I'd prefer if you used 
the API based on sg_copy_buffer() which includes a call to 
flush_kernel_dcache_page() already for mainline inclusion, so to have 
good style up front. ( a patch to fix flush_kernel_dcache_page() on ARM 
is already queued).


Nicolas
