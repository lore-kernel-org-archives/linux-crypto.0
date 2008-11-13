From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v3]
Date: Thu, 13 Nov 2008 11:13:01 -0500
Message-ID: <20081113111301.32acf396@zod.rchland.ibm.com>
References: <1226097047.5078.23.camel@jhsiao-usb>
	<20081112183359.2ba1e894.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jhsiao@amcc.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57884 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbYKMQN0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Nov 2008 11:13:26 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e1.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id mADGDG6c014403
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2008 11:13:16 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mADGDIOx466986
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2008 11:13:19 -0500
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mADGD8Uw009763
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2008 09:13:09 -0700
In-Reply-To: <20081112183359.2ba1e894.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 12 Nov 2008 18:33:59 -0600
Kim Phillips <kim.phillips@freescale.com> wrote:

> On Fri, 07 Nov 2008 14:30:47 -0800
> James Hsiao <jhsiao@amcc.com> wrote:
> > + * Changes:
> > + *	James Hsiao:	10/04/08
> > + *			replace global variable lsec_core with data in
> > + *			in struct device.
> > + *			add parameter to various functions due to
> > + *			to remove of global variable lsec_core
> > + *			crypto4xx_alloc_sa now return error code.
> > + *			not using PVR to identify which CPU, using DTS.
> > + *			move this into the probe function.
> > + *			pass struct device pointer to dma_alloc_coherent
> > + *			and dma_free_coherent functions.
> > + *			make function static where ever is possible.
> > + *			remove crypto4xx_start_device.
> > + *			remove crypt4xx_setup_crypto.
> > + *			in crypto4xx_crypt_remove add kill tasklet.
> > + *			in crypto4xx_stop_all unmap ce_base and free core_dev.
> > + *			add lock to all get/put pd/sd/gd functions.
> > + *			change PPC4XX_SEC_VERSION_STR to "0.3"
> 
> no changes list please.

If you want to do a changelog for the patch itself to describe the
differences between patch v2 and v3 and so-on, that is fine and actually
very helpful to reviewers. Just do it after the commit log of the
patch, but outside of the actual patch itself.

> ..this is the type of reason why linuxppc-dev must be cc'd on this
> patch; one is supposed to dynamically allocate and populate the
> descriptor for the h/w, then grab the queue lock, quickly instruct the
> h/w where to find it, and then immediately release it.  This is covered
> in the Linux Device Drivers book, and further details can be found under
> Documentation/, see e.g. spinlocks.txt.
> 
> I recommend you seek to get Josh Boyer's (amcc maintainer) acceptance
> of this patch.

Fixing the things Kim highlighted would be a good start.  And please CC
me, or at least linuxppc-dev, on future revisions.

josh
