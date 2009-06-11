From: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH] arm/orion5x: add sram support for crypto
Date: Thu, 11 Jun 2009 16:36:42 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0906111625280.31536@xanadu.home>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
 <1244728999-8103-2-git-send-email-arm-kernel@ml.breakpoint.cc>
 <alpine.LFD.2.00.0906111513420.31536@xanadu.home>
 <20090611201530.GA11486@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:56082 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZFKUhA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 16:37:00 -0400
Received: from xanadu.home ([66.131.194.97]) by VL-MH-MR001.ip.videotron.ca
 (Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007; 32bit))
 with ESMTP id <0KL300IRBD96JE40@VL-MH-MR001.ip.videotron.ca> for
 linux-crypto@vger.kernel.org; Thu, 11 Jun 2009 16:36:43 -0400 (EDT)
In-reply-to: <20090611201530.GA11486@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 11 Jun 2009, Sebastian Andrzej Siewior wrote:

> * Nicolas Pitre | 2009-06-11 15:17:09 [-0400]:
> 
> >This one is already merged in the Orion and ARM tree, with a minor fix 
> >and device renamed to be more generic.  The equivalent registration for 
> >Kirkwood is merged as well already.
> 
> Adding a revision history is good thing... I could not find the ARM tree
> but I've rebased this patch against the orion tree [0].

Actually, I'm leaning towards the removal of such dynamic mappings 
altogether and keep an unconditional static mapping instead, just like 
Kirkwood does.

> Since the driver got renamed, I'm going to send a delta if nothing else
> comes up.

What is your plan for this driver?  Submit it now and add incremental 
improvements afterward or wait until it is more functional?


Nicolas
