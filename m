From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 03/17] powerpc: Add PFO support to the VIO bus
Date: Thu, 10 May 2012 14:08:35 -0500
Message-ID: <20120510190835.GB12304@linux.vnet.ibm.com>
References: <1334242825.18090.4.camel@key-ThinkPad-W510>
 <1334243302.18090.10.camel@key-ThinkPad-W510>
 <1335841603.3621.8.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kent Yoder <key@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34032 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761489Ab2EJTJE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 May 2012 15:09:04 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <rcjenn@linux.vnet.ibm.com>;
	Thu, 10 May 2012 15:09:00 -0400
Content-Disposition: inline
In-Reply-To: <1335841603.3621.8.camel@pasglop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Benjamin Herrenschmidt (benh@kernel.crashing.org) wrote:
> Hrm... I don't like that much:
> 
> > +	if (op->timeout)
> > +		deadline = jiffies + msecs_to_jiffies(op->timeout);
> > +
> > +	while (true) {
> > +		hret = plpar_hcall_norets(H_COP, op->flags,
> > +				vdev->resource_id,
> > +				op->in, op->inlen, op->out,
> > +				op->outlen, op->csbcpb);
> > +
> > +		if (hret == H_SUCCESS ||
> > +		    (hret != H_NOT_ENOUGH_RESOURCES &&
> > +		     hret != H_BUSY && hret != H_RESOURCE) ||
> > +		    (op->timeout && time_after(deadline, jiffies)))
> > +			break;
> > +
> > +		dev_dbg(dev, "%s: hcall ret(%ld), retrying.\n", __func__, hret);
> > +	}
> > +
> 
> Is this meant to be called in atomic context ? If not, maybe it should
> at the very least do a cond_resched() ?
> 
> Else, what about ceding the processor ? Or at the very least reducing
> the thread priority for a bit ?
> 
> Shouldn't we also enforce to always have a timeout ? IE. Something like
> 30s or so if nothing specified to avoid having the kernel just hard
> lock...
> 
> In general I don't like that sort of synchronous code, I'd rather return
> the busy status up the chain which gives a chance to the caller to take
> more appropriate measures depending on what it's doing, but that really
> depends what you use that synchronous call for. I suppose if it's for
> configuration type operations, it's ok...

This function is called in atomic context, it is used by PFO-type device
drivers to perform operations with the nest accelerator unit (like
crypto acceleration).

Having the timeout and retries in this function is the wrong thing to do.
We'll resubmit this without the loop and the caller will be responsible for
retrying the operations.

I would rather have the caller cede the processor or alter thread
priority where appropriate than doing that in this function.  I don't
think this should be done in this crypto driver.

--Rob Jennings
