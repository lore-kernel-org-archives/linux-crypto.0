From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 2/2] talitos: Freescale integrated security engine (SEC) driver
Date: Mon, 2 Jun 2008 21:57:51 +0400
Message-ID: <20080602175751.GA7807@2ka.mipt.ru>
References: <4840615F.4070103@freescale.com> <20080530153505.21eb1ec4.kim.phillips@freescale.com> <48406562.4010306@freescale.com> <20080530154820.6e56b625.kim.phillips@freescale.com> <20080530211204.GA15768@2ka.mipt.ru> <20080530171930.61965d59.kim.phillips@freescale.com> <20080531095901.GA16281@2ka.mipt.ru> <20080602092701.9d0d56e8.kim.phillips@freescale.com> <20080602160012.GB32511@2ka.mipt.ru> <20080602115021.cdda8647.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
	mr.scada@gmail.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:39607 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbYFBR6X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 13:58:23 -0400
Content-Disposition: inline
In-Reply-To: <20080602115021.cdda8647.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 02, 2008 at 11:50:21AM -0500, Kim Phillips (kim.phillips@freescale.com) wrote:
> > But can it be changed? You write to it without lock, but read under the
> > one (different for each channel though), so it attracted attention.
> 
> can you point where in the code your concern is?

talitos_submit() writes to hdr (initially I think?) without locks.
It is read in flush_channel() under tail lock, but then it is dropped,
so I rised a question, if it can be modified during that time, since if
it can, status value, calculated from it, can be different and thus
error check result can be false. Or this is not an issue?

-- 
	Evgeniy Polyakov
