From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/2] crypto: qat - Enforce valid numa configuration.
Date: Wed, 08 Oct 2014 11:11:39 -0700
Message-ID: <54357E5B.2090401@intel.com>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1> <20141008173853.13714.47458.stgit@tstruk-mobl1> <54357B02.8080008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, naleksan@redhat.com,
	davem@davemloft.net
To: Prarit Bhargava <prarit@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39976 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaJHSOO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Oct 2014 14:14:14 -0400
In-Reply-To: <54357B02.8080008@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/08/2014 10:57 AM, Prarit Bhargava wrote:
>>  	node = adf_get_dev_node_id(pdev);
> ^^^ I don't think you should ever make this call.  IMO it is wrong to do it that
> way.  Just stick with
> 
> 	node = dev_to_node(&pdev->dev)
> 
> as the line below forces a default to that anyway.

But then how do I know which node I'm physically connected to?

> 
>> > +	if (node != dev_to_node(&pdev->dev) && dev_to_node(&pdev->dev) > 0) {
>> > +		/* If the accelerator is connected to a node with no memory
>> > +		 * there is no point in using the accelerator since the remote
>> > +		 * memory transaction will be very slow. */
>> > +		dev_err(&pdev->dev, "Invalid NUMA configuration.\n");
>> > +		return -EINVAL;
> Hmm ... I wonder if it would be safe to do
> 
> 	/* force allocations to node 0 */
> 	node = 0;
> 	dev_err(&pdev->dev, "Invalid NUMA configuration detected, node id = %d .
> Defaulting node to 0.  \n",
>                 node);
> 
> and then continue?

As the comment say there is no point continuing if the configuration is
wrong. Defaulting to 0 will cause the same panic you pointed out in your
first patch if node 0 has no memory.

> 
> And maybe even a FW_WARN of some sort here might be appropriate to indicate that
> something is wrong with the mapping?  In any case a better error message is a
> always good idea IMO.
