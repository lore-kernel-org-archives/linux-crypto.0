From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 2/2] crypto: qat - Enforce valid numa configuration.
Date: Thu, 09 Oct 2014 07:23:02 -0400
Message-ID: <54367016.3070709@redhat.com>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1> <20141008173853.13714.47458.stgit@tstruk-mobl1> <54357B02.8080008@redhat.com> <54357E5B.2090401@intel.com> <54358400.5060405@redhat.com> <54358918.7030808@intel.com> <54358A06.2080605@redhat.com> <54358FC6.8060500@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, naleksan@redhat.com,
	davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaJILXX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Oct 2014 07:23:23 -0400
In-Reply-To: <54358FC6.8060500@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[sorry ... accidentally hit reply instead of reply all ... resending to everyone]

On 10/08/2014 03:25 PM, Tadeusz Struk wrote:
> On 10/08/2014 12:01 PM, Prarit Bhargava wrote:
>> No that isn't correct.  dev_to_node() will return the node the device is
>> connected to.
>
> include/linux/device.h:
>
> static inline int dev_to_node(struct device *dev)
> {
>   return dev->numa_node;
> }
>
> struct device {
> .....
>   int numa_node; /* NUMA node this device is close to */
> ...

That's just bad english.  The numa node value (for pci devices) is
read from the ACPI tables on the system and represents the node that
the pci_dev is connected to.

> };
>
> In case when there are two nodes and only node 0 has memory,
> dev->numa_node will be 0 even though the device will be connected to the
> pci root port of node 1.

Your calculation completely falls apart and returns incorrect values when
cpu hotplug is used or if there are multi-socket nodes (as was the case
on the system that panicked), or if one uses the new cluster-on-die mode.

P.
