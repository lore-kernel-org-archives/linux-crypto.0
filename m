From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] arm/orion5x: add sram support for crypto
Date: Thu, 11 Jun 2009 22:15:23 +0100
Message-ID: <20090611211523.GF21128@n2100.arm.linux.org.uk>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc> <1244728999-8103-2-git-send-email-arm-kernel@ml.breakpoint.cc> <alpine.LFD.2.00.0906111513420.31536@xanadu.home> <20090611201530.GA11486@Chamillionaire.breakpoint.cc> <alpine.LFD.2.00.0906111625280.31536@xanadu.home> <20090611210734.GA11920@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nicolas Pitre <nico@cam.org>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44292 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbZFKVP6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 17:15:58 -0400
Content-Disposition: inline
In-Reply-To: <20090611210734.GA11920@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 11, 2009 at 11:07:34PM +0200, Sebastian Andrzej Siewior wrote:
> If you thing it is too early I can keep hacking in my own git tree until
> I get the dmac_flush_range() hack out or so.

The problem that I percieve with these kinds of hacks is that they
tend to spread into other code, and then we end up with problems
when new architectures come along.

For these interfaces, I am a strong believer in purpose-defined
interfaces to caches and the like.  If what we have doesn't provide
what's required, we need to provide something else.

So, the question is what are you trying to do with this
dmac_flush_range() and your SRAM?  Are you trying to achieve I/D cache
coherency for data written there, so you can execute it later, or are
you trying to ensure DMA coherency from SRAM?
