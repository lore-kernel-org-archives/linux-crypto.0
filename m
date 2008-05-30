From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 2/2] talitos: Freescale integrated security engine (SEC) driver
Date: Sat, 31 May 2008 01:12:08 +0400
Message-ID: <20080530211204.GA15768@2ka.mipt.ru>
References: <20080529141250.0946b02c.kim.phillips@freescale.com> <20080530180904.GA18945@2ka.mipt.ru> <20080530143614.1e675228.kim.phillips@freescale.com> <4840585D.8050805@freescale.com> <20080530151638.087970ab.kim.phillips@freescale.com> <4840615F.4070103@freescale.com> <20080530153505.21eb1ec4.kim.phillips@freescale.com> <48406562.4010306@freescale.com> <20080530154820.6e56b625.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
	mr.scada@gmail.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53101 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbYE3VM0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2008 17:12:26 -0400
Content-Disposition: inline
In-Reply-To: <20080530154820.6e56b625.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 30, 2008 at 03:48:20PM -0500, Kim Phillips (kim.phillips@freescale.com) wrote:
> sorry, by ISR I meant interrupt status registers.  but I can't tell
> where the suspected simultaneous accesses are.  Evgeniy, can you point
> out the register accesses you're talking about?

priv->status is accessed from tasklets, although readonly, but that rises
a red flag... Also callback invocation tasklet drops the lock around
callback, during that time cached status and priv itself (and tail like
in two simultaneous flushes) could change (or not?)

-- 
	Evgeniy Polyakov
