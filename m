From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/2] talitos: Freescale integrated security engine (SEC)
 driver
Date: Mon, 2 Jun 2008 11:50:21 -0500
Message-ID: <20080602115021.cdda8647.kim.phillips@freescale.com>
References: <4840585D.8050805@freescale.com>
	<20080530151638.087970ab.kim.phillips@freescale.com>
	<4840615F.4070103@freescale.com>
	<20080530153505.21eb1ec4.kim.phillips@freescale.com>
	<48406562.4010306@freescale.com>
	<20080530154820.6e56b625.kim.phillips@freescale.com>
	<20080530211204.GA15768@2ka.mipt.ru>
	<20080530171930.61965d59.kim.phillips@freescale.com>
	<20080531095901.GA16281@2ka.mipt.ru>
	<20080602092701.9d0d56e8.kim.phillips@freescale.com>
	<20080602160012.GB32511@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
	mr.scada@gmail.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:40485 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbYFBQwP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 12:52:15 -0400
In-Reply-To: <20080602160012.GB32511@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2 Jun 2008 20:00:12 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> On Mon, Jun 02, 2008 at 09:27:01AM -0500, Kim Phillips (kim.phillips@freescale.com) wrote:
> > > I meant descriptor hdr value accessed via it - can it be checked in
> > > tasklet under the lock and in submit path without? Can they correlate
> > > somehow?
> > 
> > I believe the check for a non-null request->desc (under lock) before
> > the hdr value is accessed ensures this doesn't happen.
> 
> But can it be changed? You write to it without lock, but read under the
> one (different for each channel though), so it attracted attention.

can you point where in the code your concern is?

desc is assigned under head lock and cleared under tail lock, both after
an smp_wmb.  hdr data is assigned before desc is written, and read
after desc is found to be !NULL (i.e, hdr access is governed by if
(desc)). head and tail indices get advanced each within their
corresponding locks.  So afaict there shouldn't be a case where data
pointed to by desc can be accessed by both the consumer and the
producer at any one point in time.  Does that help?

Kim
