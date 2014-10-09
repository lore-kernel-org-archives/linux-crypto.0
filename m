From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 2/2] crypto: qat - Enforce valid numa configuration.
Date: Thu, 09 Oct 2014 13:32:42 -0400
Message-ID: <5436C6BA.2020404@redhat.com>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1> <20141008173853.13714.47458.stgit@tstruk-mobl1> <54357B02.8080008@redhat.com> <54357E5B.2090401@intel.com> <54358400.5060405@redhat.com> <54358918.7030808@intel.com> <54358A06.2080605@redhat.com> <54358FC6.8060500@intel.com> <54367016.3070709@redhat.com> <5436B459.4090503@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, naleksan@redhat.com,
	davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaJIRc5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Oct 2014 13:32:57 -0400
In-Reply-To: <5436B459.4090503@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/09/2014 12:14 PM, Tadeusz Struk wrote:
> On 10/09/2014 04:23 AM, Prarit Bhargava wrote:
>>>   int numa_node; /* NUMA node this device is close to */
>>>> ...
>> That's just bad english.  The numa node value (for pci devices) is
>> read from the ACPI tables on the system and represents the node that
>> the pci_dev is connected to.
>>
>>>> };
>>>>
>>>> In case when there are two nodes and only node 0 has memory,
>>>> dev->numa_node will be 0 even though the device will be connected to the
>>>> pci root port of node 1.
>> Your calculation completely falls apart and returns incorrect values when
>> cpu hotplug is used or if there are multi-socket nodes (as was the case
>> on the system that panicked), or if one uses the new cluster-on-die mode.
> 
> This calculation is sole for multi-socket configuration. This is why is
> was introduced and what it was tested for.
> There is no point discussing NUMA for single-socket configuration.
> Single socket configurations are not NUMA. In this case dev->numa_node
> is usually equal to NUMA_NO_NODE (-1) and adf_get_dev_node_id(pdev) will
> always return 0;

The fact that you return an incorrect value here for any configuration is simply
put, bad.  You shouldn't do that.

> Please confirm that, but I think the system it panicked on was a two
> sockets system with only node 0 populated with memory and accelerator
> plugged it to node 1 (phys_proc_id == 1).
> In this case adf_get_dev_node_id(pdev) returned 1 and this was passed to
> kzalloc_node(size, GFP_KERNEL, 1) and because there was no memory on
> node 1 kzalloc_node() panicked.

Yep; but my interpretation was that node 1 didn't exist at all and it panicked.

> This patch will make sure that this will not happen and that the
> configuration will be optimal.
> 

Yep, it will.  But what about cpu hotplug?

P.
