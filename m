From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/2] crypto: qat - Enforce valid numa configuration.
Date: Fri, 10 Oct 2014 06:25:03 -0700
Message-ID: <5437DE2F.5080900@intel.com>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1> <20141008173853.13714.47458.stgit@tstruk-mobl1> <54357B02.8080008@redhat.com> <54357E5B.2090401@intel.com> <54358400.5060405@redhat.com> <54358918.7030808@intel.com> <54358A06.2080605@redhat.com> <54358FC6.8060500@intel.com> <54367016.3070709@redhat.com> <5436B459.4090503@intel.com> <5436C6BA.2020404@redhat.com> <5436E818.5030809@intel.com> <54370163.6040305@redhat.com> <5437165E.6030008@intel.com> <5437C1C9.7050505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, naleksan@redhat.com,
	davem@davemloft.net
To: Prarit Bhargava <prarit@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27364 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbaJJN1B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Oct 2014 09:27:01 -0400
In-Reply-To: <5437C1C9.7050505@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/10/2014 04:23 AM, Prarit Bhargava wrote:
>> Sure, but I still think that we are safe here.
>> > 
> No, you're not.  Dropping a single CPU changes num_online_cpus(), which results in
> 
> static uint8_t adf_get_dev_node_id(struct pci_dev *pdev)
> {
>         unsigned int bus_per_cpu = 0;
>         struct cpuinfo_x86 *c = &cpu_data(num_online_cpus() - 1);  <<< this
> being different.
> 
>         if (!c->phys_proc_id)
>                 return 0;
> 
>         bus_per_cpu = 256 / (c->phys_proc_id + 1);  <<< this being different
> 
>         if (bus_per_cpu != 0)
>                 return pdev->bus->number / bus_per_cpu; <<< and this being different
>         return 0;
> }

You forgot to explain how this is not safe.
T.
