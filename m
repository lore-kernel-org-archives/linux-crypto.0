From: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH] arm/orion5x: add sram support for crypto
Date: Sun, 02 Aug 2009 10:14:57 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0908021008450.3066@xanadu.home>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc>
 <1244728999-8103-2-git-send-email-arm-kernel@ml.breakpoint.cc>
 <alpine.LFD.2.00.0906111513420.31536@xanadu.home>
 <20090611201530.GA11486@Chamillionaire.breakpoint.cc>
 <alpine.LFD.2.00.0906111625280.31536@xanadu.home>
 <20090611210734.GA11920@Chamillionaire.breakpoint.cc>
 <alpine.LFD.2.00.0906111712060.31536@xanadu.home>
 <20090801093803.GA2362@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:51251 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZHBOPh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Aug 2009 10:15:37 -0400
Received: from xanadu.home ([66.130.28.92]) by VL-MO-MR003.ip.videotron.ca
 (Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007; 32bit))
 with ESMTP id <0KNR00EVF68X0A30@VL-MO-MR003.ip.videotron.ca> for
 linux-crypto@vger.kernel.org; Sun, 02 Aug 2009 10:14:57 -0400 (EDT)
In-reply-to: <20090801093803.GA2362@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 1 Aug 2009, Sebastian Andrzej Siewior wrote:

> * Nicolas Pitre | 2009-06-11 17:19:22 [-0400]:
> 
> >I have no problem with you submitting it now.  It is not complete yet 
> >but what is there is plenty functional.  However I'd prefer if you used 
> >the API based on sg_copy_buffer() which includes a call to 
> >flush_kernel_dcache_page() already for mainline inclusion, so to have 
> >good style up front. ( a patch to fix flush_kernel_dcache_page() on ARM 
> >is already queued).
> I just wanted to let you know, that since -rc5 I have the needful change
> in sg code [0]. On the other hand I have the IDMA somehow working so I
> probably should sit my ass down and make it work with cesa...

Please submit it with the sg as is.  You can submit incremental updates 
later.  That would have the effect of making it clearer what the DMA 
support entails in the git history, as well as allowing more people to 
test it more easily in the mean time, especially that DMA is somewhat 
different on Orion and Kirkwood.


Nicolas
