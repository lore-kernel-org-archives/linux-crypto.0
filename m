From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Fri, 10 Aug 2018 14:12:37 +0100
Message-ID: <0f6bac9b-8381-1874-9367-46b5f4cef56e@arm.com>
References: <20180802040557.GL160746@Turing-Arch-b>
 <20180802142243.GA3481@redhat.com> <20180803034721.GC91035@Turing-Arch-b>
 <20180803143944.GA4079@redhat.com> <20180806031252.GG91035@Turing-Arch-b>
 <20180806153257.GB6002@redhat.com>
 <11bace0e-dc14-5d2c-f65c-25b852f4e9ca@gmail.com>
 <20180808151835.GA3429@redhat.com> <20180809080352.GI91035@Turing-Arch-b>
 <20180809144613.GB3386@redhat.com> <20180810033913.GK91035@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Kenneth Lee <nek.in.cn@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hao Fang <fanghao11@h
To: Kenneth Lee <liguozhu@hisilicon.com>,
        Jerome Glisse <jglisse@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180810033913.GK91035@Turing-Arch-b>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Kenneth,

On 10/08/18 04:39, Kenneth Lee wrote:
>> You can achieve everything you want to achieve with existing upstream
>> solution. Re-inventing a whole new driver infrastructure should really
>> be motivated with strong and obvious reasons.
> 
> I want to understand better of your idea. If I create some unified helper
> APIs in drivers/iommu/, say:
> 
> 	wd_create_dev(parent_dev, wd_dev)
> 	wd_release_dev(wd_dev)
> 
> The API create chrdev to take request from user space for open(resource
> allocation), iomap, epoll (irq), and dma_map(with pasid automatically).
> 
> Do you think it is acceptable?

Maybe not drivers/iommu/ :) That subsystem only contains tools for
dealing with DMA, I don't think epoll, resource enumeration or iomap fit
in there.

Creating new helpers seems to be precisely what we're trying to avoid in
this thread, and vfio-mdev does provide the components that you
describe, so I wouldn't discard it right away. When the GPU, net, block
or another subsystem doesn't fit your needs, either because your
accelerator provides some specialized function, or because for
performance reasons your client wants direct MMIO access, you can at
least build your driver and library on top of those existing VFIO
components:

* open allocates a partition of an accelerator.
* vfio_device_info, vfio_region_info and vfio_irq_info enumerates
available resources.
* vfio_irq_set deals with epoll.
* mmap gives you a private MMIO doorbell.
* vfio_iommu_type1 provides the DMA operations.

Currently missing:

* Sharing the parent IOMMU between mdev, which is also what the "IOMMU
aware mediated device" series tackles, and seems like a logical addition
to VFIO. I'd argue that the existing IOMMU ops (or ones implemented by
the SVA series) can be used to deal with this

* The interface to discover an accelerator near your memory node, or one
that you can chain with other devices. If I understood correctly the
conclusion was that the API (a topology description in sysfs?) should be
common to various subsystems, in which case vfio-mdev (or the mediating
driver) could also use it.

* The queue abstraction discussed on patch 3/7. Perhaps the current vfio
resource description of MMIO and IRQ is sufficient here as well, since
vendors tend to each implement their own queue schemes. If you need
additional features, read/write fops give the mediating driver a lot of
freedom. To support features that are too specific for drivers/vfio/ you
can implement a config space with capabilities and registers of your
choice. If you're versioning the capabilities, the code to handle them
could even be shared between different accelerator drivers and libraries.

Thanks,
Jean
