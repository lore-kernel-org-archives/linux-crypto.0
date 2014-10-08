From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/2] crypto: qat - Enforce valid numa configuration.
Date: Wed, 08 Oct 2014 11:57:28 -0700
Message-ID: <54358918.7030808@intel.com>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1> <20141008173853.13714.47458.stgit@tstruk-mobl1> <54357B02.8080008@redhat.com> <54357E5B.2090401@intel.com> <54358400.5060405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, naleksan@redhat.com,
	davem@davemloft.net
To: Prarit Bhargava <prarit@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25395 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaJHS7Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Oct 2014 14:59:24 -0400
In-Reply-To: <54358400.5060405@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/08/2014 11:35 AM, Prarit Bhargava wrote:
>> But then how do I know which node I'm physically connected to?
> The pci_dev maps to the bus which maps to a numa node.  The pci_dev's numa value
> is copied directly from the bus (or busses depending on how deep it is).
> 
> I'd argue (strongly) that the pci_dev's numa ID better be correct o/w that is a
> FW bug (and a bad one at that these days).
> 
> dev_to_node() should return the correct value.

I'm not saying that the dev_to_node() returns incorrect value. It will
always return the closest numa node for the given device.
What we want to enforce is that the closest numa node is the node that
the device is physically connected to. In case if the closest numa node
is the remote node we don't want to use this accelerator.

> 
>>> >>
>>>>> >>>> +	if (node != dev_to_node(&pdev->dev) && dev_to_node(&pdev->dev) > 0) {
>>>>> >>>> +		/* If the accelerator is connected to a node with no memory
>>>>> >>>> +		 * there is no point in using the accelerator since the remote
>>>>> >>>> +		 * memory transaction will be very slow. */
>>>>> >>>> +		dev_err(&pdev->dev, "Invalid NUMA configuration.\n");
>>>>> >>>> +		return -EINVAL;
>>> >> Hmm ... I wonder if it would be safe to do
>>> >>
>>> >> 	/* force allocations to node 0 */
>>> >> 	node = 0;
>>> >> 	dev_err(&pdev->dev, "Invalid NUMA configuration detected, node id = %d .
>>> >> Defaulting node to 0.  \n",
>>> >>                 node);
>>> >>
>>> >> and then continue?
>> > 
>> > As the comment say there is no point continuing if the configuration is
>> > wrong. Defaulting to 0 will cause the same panic you pointed out in your
>> > first patch if node 0 has no memory.
> Okay, but at least fix up the warning message to output the node_id.  That's
> sort of the important piece here.

Sure, I can update the message add print both the numa node and node id
the device is connected to.
