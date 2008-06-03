From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 2/2] talitos: Freescale integrated security engine (SEC) driver
Date: Tue, 3 Jun 2008 05:24:17 +0400
Message-ID: <20080603012416.GA20254@2ka.mipt.ru>
References: <48406562.4010306@freescale.com> <20080530154820.6e56b625.kim.phillips@freescale.com> <20080530211204.GA15768@2ka.mipt.ru> <20080530171930.61965d59.kim.phillips@freescale.com> <20080531095901.GA16281@2ka.mipt.ru> <20080602092701.9d0d56e8.kim.phillips@freescale.com> <20080602160012.GB32511@2ka.mipt.ru> <20080602115021.cdda8647.kim.phillips@freescale.com> <20080602175751.GA7807@2ka.mipt.ru> <20080602140603.02d5f40f.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
	mr.scada@gmail.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:42394 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYFCBZZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 21:25:25 -0400
Content-Disposition: inline
In-Reply-To: <20080602140603.02d5f40f.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Mon, Jun 02, 2008 at 02:06:03PM -0500, Kim Phillips (kim.phillips@freescale.com) wrote:
> it would be an issue if flush_cannel didn't save off the data required
> to call the callback with in saved_req.  flush_channel does this on
> purpose to be able to call the callback outside of lock (as is
> commented).  Note desc gets assigned NULL prior to releasing the lock,
> after copying its contents to saved_req.

Excellent! It looks like there are no more issues and second version
fixed found problem place.

-- 
	Evgeniy Polyakov
