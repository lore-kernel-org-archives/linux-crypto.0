From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/2] talitos: Freescale integrated security engine (SEC)
 driver
Date: Mon, 2 Jun 2008 14:06:03 -0500
Message-ID: <20080602140603.02d5f40f.kim.phillips@freescale.com>
References: <4840615F.4070103@freescale.com>
	<20080530153505.21eb1ec4.kim.phillips@freescale.com>
	<48406562.4010306@freescale.com>
	<20080530154820.6e56b625.kim.phillips@freescale.com>
	<20080530211204.GA15768@2ka.mipt.ru>
	<20080530171930.61965d59.kim.phillips@freescale.com>
	<20080531095901.GA16281@2ka.mipt.ru>
	<20080602092701.9d0d56e8.kim.phillips@freescale.com>
	<20080602160012.GB32511@2ka.mipt.ru>
	<20080602115021.cdda8647.kim.phillips@freescale.com>
	<20080602175751.GA7807@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
	mr.scada@gmail.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:42225 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbYFBT0O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 15:26:14 -0400
In-Reply-To: <20080602175751.GA7807@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2 Jun 2008 21:57:51 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> On Mon, Jun 02, 2008 at 11:50:21AM -0500, Kim Phillips (kim.phillips@freescale.com) wrote:
> > > But can it be changed? You write to it without lock, but read under the
> > > one (different for each channel though), so it attracted attention.
> > 
> > can you point where in the code your concern is?
> 
> talitos_submit() writes to hdr (initially I think?) without locks.

ok, the desc whose hdr is being written was allocated by
talitos_submit's caller, and it hasn't been made part of the circular
buffer at that point.  It becomes a part of the buffer (eligible for
contention with the consumer side) when desc is assigned.

> It is read in flush_channel() under tail lock, but then it is dropped,
> so I rised a question, if it can be modified during that time, since if
> it can, status value, calculated from it, can be different and thus
> error check result can be false. Or this is not an issue?

it would be an issue if flush_cannel didn't save off the data required
to call the callback with in saved_req.  flush_channel does this on
purpose to be able to call the callback outside of lock (as is
commented).  Note desc gets assigned NULL prior to releasing the lock,
after copying its contents to saved_req.

Kim
