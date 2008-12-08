From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v4]
Date: Mon, 8 Dec 2008 12:09:36 -0600
Message-ID: <20081208120936.28721efb.kim.phillips@freescale.com>
References: <1228256232.4770.47.camel@jhsiao-usb>
	<20081204193256.12dbc306.kim.phillips@freescale.com>
	<1228519451.5444.59.camel@jhsiao-usb>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, jwboyer@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org
To: jhsiao@amcc.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:39255 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbYLHSGf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2008 13:06:35 -0500
In-Reply-To: <1228519451.5444.59.camel@jhsiao-usb>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 05 Dec 2008 15:24:11 -0800
James Hsiao <jhsiao@amcc.com> wrote:

> Without the check, nbytes could become negative. The aead test case
> with .np will crash(ie. gcm tests), those test  have sg->length >
> nbytes.
> 
> About aad_len, we didn't release code that use aad yet. We did test this
> function with aad_len none zero(the gcm tests).

ok - btw, it would be nice if these submissions were more
self-consistent, that way we could see how aad_len is being assigned.

> About the irq_disable or spin_lock. 
> The driver could be used by a kernel thread and esp4 at same time. As I
> know process is preemptable. When the driver is used by a process it is
> possible to be preempted. The hardware require scatter/gather descriptor
> to be consecutive. So, if the process get a gather descriptor and then
> it is preempted by another process or esp4 which get a gather descriptor
> and return to the original process, the origianl process could get a non
> consecutive gather descriptor.   
> So, if spin_lock is recommended then I have to use spin_lock_irq_save,
> which use irq_disable too. Do you think that is acceptable? 

yes.

Thanks,

Kim
