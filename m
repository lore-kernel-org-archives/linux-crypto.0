From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 2/2] crypto: qat - Enforce valid numa configuration.
Date: Fri, 10 Oct 2014 18:15:36 -0400
Message-ID: <54385A88.5040901@redhat.com>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1> <20141008173853.13714.47458.stgit@tstruk-mobl1> <54357B02.8080008@redhat.com> <54357E5B.2090401@intel.com> <54358400.5060405@redhat.com> <54358918.7030808@intel.com> <54358A06.2080605@redhat.com> <54358FC6.8060500@intel.com> <54367016.3070709@redhat.com> <5436B459.4090503@intel.com> <5436C6BA.2020404@redhat.com> <5436E818.5030809@intel.com> <54370163.6040305@redhat.com> <5437165E.6030008@intel.com> <5437C1C9.7050505@redhat.com> <5437DE2F.5080900@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bruce.w.allan@intel.com,
	qat-linux@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, naleksan@redhat.com,
	davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbaJJWQT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Oct 2014 18:16:19 -0400
In-Reply-To: <5437DE2F.5080900@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/10/2014 09:25 AM, Tadeusz Struk wrote:
> On 10/10/2014 04:23 AM, Prarit Bhargava wrote:
>>> Sure, but I still think that we are safe here.
>>>>
>> No, you're not.  Dropping a single CPU changes num_online_cpus(), which results in
>>
>> static uint8_t adf_get_dev_node_id(struct pci_dev *pdev)
>> {
>>         unsigned int bus_per_cpu = 0;
>>         struct cpuinfo_x86 *c = &cpu_data(num_online_cpus() - 1);  <<< this
>> being different.
>>
>>         if (!c->phys_proc_id)
>>                 return 0;
>>
>>         bus_per_cpu = 256 / (c->phys_proc_id + 1);  <<< this being different
>>
>>         if (bus_per_cpu != 0)
>>                 return pdev->bus->number / bus_per_cpu; <<< and this being different
>>         return 0;
>> }
> 
> You forgot to explain how this is not safe.

Sorry, I thought I did explain it.  My apologies.

So let's say you boot the system and load the driver.  At this time,

num_online_cpus@boot = 4 .  Crunch through the math above, and you reference the
cpuinfo_x86 struct for cpu 3 (the "fourth" cpu), and the calculation takes into
account c->phys_proc_id.

So let's say now you boot the system and disable a cpu.  In this case, now
num_online_cpus@module_load = 3.  Crunch through the math above and you're
referncing a different cpuinfo_x86 struct for cpu 2.  That may or may not point
at the same c->phys_proc_id.  That changes the calculation and gives an
incorrect value.

In addition to that I haven't even talked about the possibility of hot-adding
and hot-removing cpus in sockets which changes the numbering scheme completely.

In short, that calcuation is wrong.  Don't use it; stick with the widely
accepted and used dev_to_node of the pci_dev.  It is used in other cases IIRC to
determine the numa location of the device.  It shouldn't be any different for
this driver.

P.
> T.
> 
