From: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Subject: Re: [PATCH] arm/orion5x: add sram support for crypto
Date: Thu, 11 Jun 2009 23:07:34 +0200
Message-ID: <20090611210734.GA11920@Chamillionaire.breakpoint.cc>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc> <1244728999-8103-2-git-send-email-arm-kernel@ml.breakpoint.cc> <alpine.LFD.2.00.0906111513420.31536@xanadu.home> <20090611201530.GA11486@Chamillionaire.breakpoint.cc> <alpine.LFD.2.00.0906111625280.31536@xanadu.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Nicolas Pitre <nico@cam.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49203 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319AbZFKVHf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 17:07:35 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906111625280.31536@xanadu.home>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Nicolas Pitre | 2009-06-11 16:36:42 [-0400]:

>> Adding a revision history is good thing... I could not find the ARM tree
>> but I've rebased this patch against the orion tree [0].
>
>Actually, I'm leaning towards the removal of such dynamic mappings 
>altogether and keep an unconditional static mapping instead, just like 
>Kirkwood does.
Oh now I remember: I've been counting the number possible window
mappings and they exceeded the number of availble slots. That's why I've
made it dynamic and board specific. However if this is not an issue than
static is probaly the better way.

>> Since the driver got renamed, I'm going to send a delta if nothing else
>> comes up.
>
>What is your plan for this driver?  Submit it now and add incremental 
>improvements afterward or wait until it is more functional?
I would like to get it squeezed into this merge window unless there are
any objections and improve it afterwards.
If you thing it is too early I can keep hacking in my own git tree until
I get the dmac_flush_range() hack out or so.

>Nicolas

Sebastian
