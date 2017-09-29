From: Harsh Jain <Harsh@chelsio.com>
Subject: Re: DMA error when sg->offset value is greater than PAGE_SIZE in
 Intel IOMMU
Date: Fri, 29 Sep 2017 11:07:36 +0530
Message-ID: <e950a8e0-5ad2-b4e7-196a-065dbf33f2c3@chelsio.com>
References: <afa02763-4556-0e14-7d1b-1c044cdc1ff7@chelsio.com>
 <6d2af675-7b97-6eaf-4daa-d7bf80a05923@chelsio.com>
 <437a9bd8-d4d6-22ca-1a64-1a3e73f1101a@arm.com>
 <MWHPR12MB1600694D099E1CFAD6849A68C87B0@MWHPR12MB1600.namprd12.prod.outlook.com>
 <CAPcyv4jtYMZJ6V5VoXkGrcZ+ykWvYp1=qXrqJkjknk8Q_BVwgA@mail.gmail.com>
 <MWHPR12MB160060436AC70CB5BE8C0C6EC8780@MWHPR12MB1600.namprd12.prod.outlook.com>
 <20170927181802.3dcd7efb@m750.lan> <20170927144847.GA95654@otc-nc-03>
 <MWHPR12MB16005D59D7A33F3D5BE43395C8780@MWHPR12MB1600.namprd12.prod.outlook.com>
 <26d68681-a157-26d3-84cb-6684dcaf3135@chelsio.com>
 <20170928130549.GA99456@otc-nc-03>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Casey Leedom <leedom@chelsio.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Michael Werner <werner@chelsio.com>, "nd@arm.com" <nd@arm.com>
To: "Raj, Ashok" <ashok.raj@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:34556 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdI2Fif (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2017 01:38:35 -0400
In-Reply-To: <20170928130549.GA99456@otc-nc-03>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 28-09-2017 18:35, Raj, Ashok wrote:
> Thanks for trying that Harsh. 
>
> sp_off turns of super page support. Which this mode, do you still see offsets greater than 4k?
Yes, offset greater than 4k is still there. Refer below.
[56732.774872] offset 4110 len 76 dma addr 3a531200e dma len 76
[56732.804187] offset 4110 len 84 dma addr 3a63b200e dma len 84
[56732.805104] offset 4110 len 68 dma addr 3a531200e dma len 68
[56732.806870] offset 4110 len 56 dma addr 3a531200e dma len 56
[56732.808987] offset 4110 len 56 dma addr 3a531200e dma len 56
[56732.811215] offset 4110 len 56 dma addr 3a531200e dma len 56
[56732.813155] offset 4110 len 56 dma addr 3a531200e dma len 56
[56732.814823] offset 4110 len 56 dma addr 3a531200e dma len 56
[56732.816481] offset 4110 len 56 dma addr 3a531200e dma len 56
[56732.818159] offset 4110 len 56 dma addr 3a531200e dma len 56
[56732.819712] offset 4110 len 56 dma addr 3a531200e dma len 56
[56732.821629] offset 4110 len 56 dma addr 3a531200e dma len 56
[root@heptagon linux_t4_build]#
[root@heptagon linux_t4_build]#
[root@heptagon linux_t4_build]# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-4.9.51 root=UUID=ccbb7f18-b3f0-43df-89de-07521e9c02fe ro intel_iommu=sp_off crashkernel=auto rhgb quiet rhgb quiet console=ttyS0,115200, console=tty0 LANG=en_US.UTF-8

>
> On Thu, Sep 28, 2017 at 07:08:21PM +0530, Harsh Jain wrote:
>>
>> Today I tried with "Intel_iommu=sp_off" boot option. Traffic runs without any error for more than 1 hrs. What magic this option did? :)
> Cheers,
> Ashok
