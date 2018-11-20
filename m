Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:47956 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbeKTWsY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 17:48:24 -0500
Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
To: Jonathan Cameron <jonathan.cameron@huawei.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc: "liguozhu@hisilicon.com" <liguozhu@hisilicon.com>,
        Leon Romanovsky <leon@kernel.org>,
        Kenneth Lee <nek.in.cn@gmail.com>,
        Tim Sell <timothy.sell@unisys.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "haojian.zhuang@linaro.org" <haojian.zhuang@linaro.org>,
        Christoph Lameter <cl@linux.com>,
        Hao Fang <fanghao11@huawei.com>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Doug Ledford <dledford@redhat.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        David Kershner <david.kershner@unisys.com>,
        Johan Hovold <johan@kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@free-electrons.com>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Jens Axboe <axboe@kernel.dk>,
        "guodong.xu@linaro.org" <guodong.xu@linaro.org>,
        linux-netdev <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-accelerators@lists.ozlabs.org"
        <linux-accelerators@lists.ozlabs.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20181112075807.9291-1-nek.in.cn@gmail.com>
 <20181112075807.9291-2-nek.in.cn@gmail.com>
 <20181113002354.GO3695@mtr-leonro.mtl.com>
 <95310df4-b32c-42f0-c750-3ad5eb89b3dd@gmail.com>
 <20181114160017.GI3759@mtr-leonro.mtl.com>
 <20181115085109.GD157308@Turing-Arch-b>
 <20181115145455.GN3759@mtr-leonro.mtl.com>
 <20181119091405.GE157308@Turing-Arch-b> <20181119184954.GB4890@ziepe.ca>
 <20181120030702.GH157308@Turing-Arch-b> <20181120032939.GR4890@ziepe.ca>
 <20181120091650.0000419a@huawei.com>
From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <8872e7d1-2cfd-36a8-d0a7-131cd8516ba3@arm.com>
Date: Tue, 20 Nov 2018 12:19:07 +0000
MIME-Version: 1.0
In-Reply-To: <20181120091650.0000419a@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 20/11/2018 09:16, Jonathan Cameron wrote:
> +CC Jean-Phillipe and iommu list.

Thanks for the Cc, sorry I don't have enough bandwidth to follow this
thread at the moment.

>>>>> In WarpDrive/uacce, we make this simple. If you support IOMMU and it support
>>>>> SVM/SVA. Everything will be fine just like ODP implicit mode. And you don't need
>>>>> to write any code for that. Because it has been done by IOMMU framework. If it  
>>>>
>>>> Looks like the IOMMU code uses mmu_notifier, so it is identical to
>>>> IB's ODP. The only difference is that IB tends to have the IOMMU page
>>>> table in the device, not in the CPU.
>>>>
>>>> The only case I know if that is different is the new-fangled CAPI
>>>> stuff where the IOMMU can directly use the CPU's page table and the
>>>> IOMMU page table (in device or CPU) is eliminated.  
>>>
>>> Yes. We are not focusing on the current implementation. As mentioned in the
>>> cover letter. We are expecting Jean Philips' SVA patch:
>>> git://linux-arm.org/linux-jpb.  
>>
>> This SVA stuff does not look comparable to CAPI as it still requires
>> maintaining seperate IOMMU page tables.

With SVA, we use the same page tables in the IOMMU and CPU. It's the
same pgd pointer, there is no mirroring of mappings. We bind the process
page tables with the device using a PASID (Process Address Space ID).

After fork(), the child's mm is different from the parent's one, and is
not automatically bound to the device. The device driver will have to
issue a new bind() request, and the child mm will be bound with a
different PASID.

There could be a problem if the child inherits the parent's device
handle. Then depending on the device, the child could be able to program
DMA and possibly access the parent's address space. The parent needs to
be aware of that when using the bind() API, and close the device fd in
the child after fork().

We use MMU notifiers for some address space changes:

* The IOTLB needs to be invalidated after any unmap() to the process
address space. On Arm systems the SMMU IOTLBs can be invalidated by the
CPU TLBI instructions, but we still need to invalidate TLBs private to
devices that are arch-agnostic (Address Translation Cache in PCI ATS).

* When the process mm exits, we need to remove the associated PASID
configuration in the IOMMU and invalidate the TLBs.

Thanks,
Jean
