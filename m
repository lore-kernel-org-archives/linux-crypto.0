From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH v2 2/2] crypto: qat - Enforce valid numa configuration
Date: Tue, 14 Oct 2014 11:41:17 -0400
Message-ID: <543D441D.5090301@redhat.com>
References: <20141014012251.742.5500.stgit@tstruk-mobl1> <20141014012432.742.24559.stgit@tstruk-mobl1> <543D00C3.9000208@redhat.com> <543D381B.9080609@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, naleksan@redhat.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202AbaJNPno (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Oct 2014 11:43:44 -0400
In-Reply-To: <543D381B.9080609@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/14/2014 10:50 AM, Tadeusz Struk wrote:
> On 10/14/2014 03:53 AM, Prarit Bhargava wrote:
>>>
>>> -	node = adf_get_dev_node_id(pdev);
>>> -	accel_dev = kzalloc_node(sizeof(*accel_dev), GFP_KERNEL, node);
>>> +	if (num_possible_nodes() > 1 && dev_to_node(&pdev->dev) < 0) {
>>> +		/* If the accelerator is connected to a node with no memory
>>> +		 * there is no point in using the accelerator since the remote
>>> +		 * memory transaction will be very slow. */
>>> +		dev_err(&pdev->dev, "Invalid NUMA configuration.\n");
>>
>> This is a lot better.  Thank you for taking my comments into account here.
> 
> Thanks for taking the time to review my patch and providing your comments.
> 
>>
>> Let's say I have a non-functional qat device and I see the above message in
>> the boot log.  The log doesn't say what to do ... so perhaps change it to
>>
>> 	dev_err(&pdev->dev, FW_BUG "numa node is set to %d.  This can be overridden by
>> using the numa_node module parameter.",
>> 	        dev_to_node(&pdev->dev));
>>
>> and add a numa_node module parameter to let the user set that at module load
>> time in case their FW is broken?  I've found that sysadmins are knowledgeable
>> about these types of things these days and are more than capable of looking
>> at sysfs and numactl to determine where a device is.
>>
> 
> But then what if there are two devices and each belongs to different
> node. In this case we would fix one and break the other. I think if the

Oh, that's a really good point.  But can you at least change the message to do a
FW_BUG and dump the node information?  That would be useful for debugging.

P.

> FW is broken then using on core encryption will be safer. If a sysadmins
> is really knowledgeable, then she or he can change the code to customize
> it for a given platform and rebuild the module.
> Other than that as far as I know module parameters are not encouraged.
> T
> 
