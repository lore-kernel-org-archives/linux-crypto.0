From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/2] crypto: qat - Enforce valid numa configuration.
Date: Thu, 09 Oct 2014 12:55:04 -0700
Message-ID: <5436E818.5030809@intel.com>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1> <20141008173853.13714.47458.stgit@tstruk-mobl1> <54357B02.8080008@redhat.com> <54357E5B.2090401@intel.com> <54358400.5060405@redhat.com> <54358918.7030808@intel.com> <54358A06.2080605@redhat.com> <54358FC6.8060500@intel.com> <54367016.3070709@redhat.com> <5436B459.4090503@intel.com> <5436C6BA.2020404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, naleksan@redhat.com,
	davem@davemloft.net
To: Prarit Bhargava <prarit@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6520 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbaJIT5S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Oct 2014 15:57:18 -0400
In-Reply-To: <5436C6BA.2020404@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/09/2014 10:32 AM, Prarit Bhargava wrote:
>> This calculation is sole for multi-socket configuration. This is why is
>> > was introduced and what it was tested for.
>> > There is no point discussing NUMA for single-socket configuration.
>> > Single socket configurations are not NUMA. In this case dev->numa_node
>> > is usually equal to NUMA_NO_NODE (-1) and adf_get_dev_node_id(pdev) will
>> > always return 0;
> The fact that you return an incorrect value here for any configuration is simply
> put, bad.  You shouldn't do that.

Well I wouldn't say it is incorrect. adf_get_dev_node_id() returns the
phys proc id the dev is connected to, so in single socket configuration
there is only one socket 0.

> 
>> > Please confirm that, but I think the system it panicked on was a two
>> > sockets system with only node 0 populated with memory and accelerator
>> > plugged it to node 1 (phys_proc_id == 1).
>> > In this case adf_get_dev_node_id(pdev) returned 1 and this was passed to
>> > kzalloc_node(size, GFP_KERNEL, 1) and because there was no memory on
>> > node 1 kzalloc_node() panicked.
> Yep; but my interpretation was that node 1 didn't exist at all and it panicked.

Why didn't exist? The fact that there was no memory on node 1 doesn't
make it disappear. There are two sockets in the platform 0 & 1 even
though only one (node 0) has memory. The only problem with that is - it
is far from optimal if device connected to node 1 uses memory on node 0.
And this is what would happen if we would use dev_to_node(dev) here.

> 
>> > This patch will make sure that this will not happen and that the
>> > configuration will be optimal.
>> > 
> Yep, it will.  But what about cpu hotplug?

I don't think cpu hotplug matters here. This is one (probe) time
determination if the configuration is optimal or not and if it makes
sense to use this accelerator or not.
