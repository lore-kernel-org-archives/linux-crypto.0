From: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH] arm/orion5x: add sram support for crypto
Date: Thu, 11 Jun 2009 23:35:13 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0906112332070.31536@xanadu.home>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
 <1244728999-8103-2-git-send-email-arm-kernel@ml.breakpoint.cc>
 <alpine.LFD.2.00.0906111513420.31536@xanadu.home>
 <20090611201530.GA11486@Chamillionaire.breakpoint.cc>
 <alpine.LFD.2.00.0906111625280.31536@xanadu.home>
 <20090611210734.GA11920@Chamillionaire.breakpoint.cc>
 <alpine.LFD.2.00.0906111712060.31536@xanadu.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:11025 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZFLDfa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 23:35:30 -0400
Received: from xanadu.home ([66.131.194.97]) by VL-MO-MR002.ip.videotron.ca
 (Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007; 32bit))
 with ESMTP id <0KL3009V7WMP8Z90@VL-MO-MR002.ip.videotron.ca> for
 linux-crypto@vger.kernel.org; Thu, 11 Jun 2009 23:35:13 -0400 (EDT)
In-reply-to: <alpine.LFD.2.00.0906111712060.31536@xanadu.home>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 11 Jun 2009, Nicolas Pitre wrote:

> On Thu, 11 Jun 2009, Sebastian Andrzej Siewior wrote:
> 
> > * Nicolas Pitre | 2009-06-11 16:36:42 [-0400]:
> > 
> > >> Adding a revision history is good thing... I could not find the ARM tree
> > >> but I've rebased this patch against the orion tree [0].
> > >
> > >Actually, I'm leaning towards the removal of such dynamic mappings 
> > >altogether and keep an unconditional static mapping instead, just like 
> > >Kirkwood does.
> > Oh now I remember: I've been counting the number possible window
> > mappings and they exceeded the number of availble slots. That's why I've
> > made it dynamic and board specific. However if this is not an issue than
> > static is probaly the better way.
> 
> There is no need for other physical mappings that I can see in the set 
> of boards we currently support.  So I'll make it static until there is a 
> real need for dynamic mapping.

I changed my mind.  Actually, it is not all Orion SoC variants that 
support the crypto unit.  I therefore kept the dynamic mapping and 
initialized it and registered the device only on those Socs that have 
crypto support.


Nicolas
