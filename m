From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 2/2] crypto: qat - Enforce valid numa configuration.
Date: Wed, 08 Oct 2014 14:35:44 -0400
Message-ID: <54358400.5060405@redhat.com>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1> <20141008173853.13714.47458.stgit@tstruk-mobl1> <54357B02.8080008@redhat.com> <54357E5B.2090401@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, naleksan@redhat.com,
	davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbaJHSfw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Oct 2014 14:35:52 -0400
In-Reply-To: <54357E5B.2090401@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/08/2014 02:11 PM, Tadeusz Struk wrote:
> On 10/08/2014 10:57 AM, Prarit Bhargava wrote:
>>>  	node = adf_get_dev_node_id(pdev);
>> ^^^ I don't think you should ever make this call.  IMO it is wrong to do it that
>> way.  Just stick with
>>
>> 	node = dev_to_node(&pdev->dev)
>>
>> as the line below forces a default to that anyway.
> 
> But then how do I know which node I'm physically connected to?

The pci_dev maps to the bus which maps to a numa node.  The pci_dev's numa value
is copied directly from the bus (or busses depending on how deep it is).

I'd argue (strongly) that the pci_dev's numa ID better be correct o/w that is a
FW bug (and a bad one at that these days).

dev_to_node() should return the correct value.

>>
>>>> +	if (node != dev_to_node(&pdev->dev) && dev_to_node(&pdev->dev) > 0) {
>>>> +		/* If the accelerator is connected to a node with no memory
>>>> +		 * there is no point in using the accelerator since the remote
>>>> +		 * memory transaction will be very slow. */
>>>> +		dev_err(&pdev->dev, "Invalid NUMA configuration.\n");
>>>> +		return -EINVAL;
>> Hmm ... I wonder if it would be safe to do
>>
>> 	/* force allocations to node 0 */
>> 	node = 0;
>> 	dev_err(&pdev->dev, "Invalid NUMA configuration detected, node id = %d .
>> Defaulting node to 0.  \n",
>>                 node);
>>
>> and then continue?
> 
> As the comment say there is no point continuing if the configuration is
> wrong. Defaulting to 0 will cause the same panic you pointed out in your
> first patch if node 0 has no memory.

Okay, but at least fix up the warning message to output the node_id.  That's
sort of the important piece here.

P.

> 
>>
>> And maybe even a FW_WARN of some sort here might be appropriate to indicate that
>> something is wrong with the mapping?  In any case a better error message is a
>> always good idea IMO.
> 
