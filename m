From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Mon, 13 Aug 2018 17:29:31 +0800
Message-ID: <20180813092931.GL91035@Turing-Arch-b>
References: <20180803143944.GA4079@redhat.com>
 <20180806031252.GG91035@Turing-Arch-b>
 <20180806153257.GB6002@redhat.com>
 <11bace0e-dc14-5d2c-f65c-25b852f4e9ca@gmail.com>
 <20180808151835.GA3429@redhat.com>
 <20180809080352.GI91035@Turing-Arch-b>
 <20180809144613.GB3386@redhat.com>
 <20180810033913.GK91035@Turing-Arch-b>
 <0f6bac9b-8381-1874-9367-46b5f4cef56e@arm.com>
 <6ea4dcfd-d539-93e4-acf1-d09ea35f0ddc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Jerome Glisse <jglisse@redhat.com>,
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
        Tho
To: Kenneth Lee <nek.in.cn@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6ea4dcfd-d539-93e4-acf1-d09ea35f0ddc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Aug 11, 2018 at 11:26:48PM +0800, Kenneth Lee wrote:
> Date: Sat, 11 Aug 2018 23:26:48 +0800
> From: Kenneth Lee <nek.in.cn@gmail.com>
> To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, Kenneth Lee
>  <liguozhu@hisilicon.com>, Jerome Glisse <jglisse@redhat.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>, "kvm@vger.kernel.org"
>  <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Greg
>  Kroah-Hartman <gregkh@linuxfoundation.org>, Zaibo Xu <xuzaibo@huawei.com>,
>  "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "Kumar, Sanjay K"
>  <sanjay.k.kumar@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
>  "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
>  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
>  "linuxarm@huawei.com" <linuxarm@huawei.com>, Alex Williamson
>  <alex.williamson@redhat.com>, "linux-crypto@vger.kernel.org"
>  <linux-crypto@vger.kernel.org>, Philippe Ombredanne
>  <pombredanne@nexb.com>, Thomas Gleixner <tglx@linutronix.de>, Hao Fang
>  <fanghao11@huawei.com>, "David S . Miller" <davem@davemloft.net>,
>  "linux-accelerators@lists.ozlabs.org"
>  <linux-accelerators@lists.ozlabs.org>
> Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
>  Thunderbird/52.9.1
> Message-ID: <6ea4dcfd-d539-93e4-acf1-d09ea35f0ddc@gmail.com>
> 
> 
> 
> 在 2018年08月10日 星期五 09:12 下午, Jean-Philippe Brucker 写道:
> >Hi Kenneth,
> >
> >On 10/08/18 04:39, Kenneth Lee wrote:
> >>>You can achieve everything you want to achieve with existing upstream
> >>>solution. Re-inventing a whole new driver infrastructure should really
> >>>be motivated with strong and obvious reasons.
> >>I want to understand better of your idea. If I create some unified helper
> >>APIs in drivers/iommu/, say:
> >>
> >>	wd_create_dev(parent_dev, wd_dev)
> >>	wd_release_dev(wd_dev)
> >>
> >>The API create chrdev to take request from user space for open(resource
> >>allocation), iomap, epoll (irq), and dma_map(with pasid automatically).
> >>
> >>Do you think it is acceptable?
> >Maybe not drivers/iommu/ :) That subsystem only contains tools for
> >dealing with DMA, I don't think epoll, resource enumeration or iomap fit
> >in there.
> Yes. I should consider where to put it carefully.
> >
> >Creating new helpers seems to be precisely what we're trying to avoid in
> >this thread, and vfio-mdev does provide the components that you
> >describe, so I wouldn't discard it right away. When the GPU, net, block
> >or another subsystem doesn't fit your needs, either because your
> >accelerator provides some specialized function, or because for
> >performance reasons your client wants direct MMIO access, you can at
> >least build your driver and library on top of those existing VFIO
> >components:
> >
> >* open allocates a partition of an accelerator.
> >* vfio_device_info, vfio_region_info and vfio_irq_info enumerates
> >available resources.
> >* vfio_irq_set deals with epoll.
> >* mmap gives you a private MMIO doorbell.
> >* vfio_iommu_type1 provides the DMA operations.
> >
> >Currently missing:
> >
> >* Sharing the parent IOMMU between mdev, which is also what the "IOMMU
> >aware mediated device" series tackles, and seems like a logical addition
> >to VFIO. I'd argue that the existing IOMMU ops (or ones implemented by
> >the SVA series) can be used to deal with this
> >
> >* The interface to discover an accelerator near your memory node, or one
> >that you can chain with other devices. If I understood correctly the
> >conclusion was that the API (a topology description in sysfs?) should be
> >common to various subsystems, in which case vfio-mdev (or the mediating
> >driver) could also use it.
> >
> >* The queue abstraction discussed on patch 3/7. Perhaps the current vfio
> >resource description of MMIO and IRQ is sufficient here as well, since
> >vendors tend to each implement their own queue schemes. If you need
> >additional features, read/write fops give the mediating driver a lot of
> >freedom. To support features that are too specific for drivers/vfio/ you
> >can implement a config space with capabilities and registers of your
> >choice. If you're versioning the capabilities, the code to handle them
> >could even be shared between different accelerator drivers and libraries.
> Thank you, Jean,
> 
> The major reason that I want to remove dependency to VFIO is: I
> accepted that the whole logic of VFIO was built on the idea of
> creating virtual device.
> 
> Let's consider it in this way: We have hardware with IOMMU support.
> So we create a default_domain to the particular IOMMU (unit) in the
> group for the kernel driver to use it. Now the device is going to be
> used by a VM or a Container. So we unbind it from the original
> driver, and put the default_domain away,  create a new domain for
> this particular use case.  So now the device shows up as a platform
> or pci device to the user space. This is what VFIO try to provide.
> Mdev extends the scenario but dose not change the intention. And I
> think that is why Alex emphasis pre-allocating resource to the mdev.
> 
> But what WarpDrive need is to get service from the hardware itself
> and set mapping to its current domain, aka defaut_domain. If we do
> it in VFIO-mdev, it looks like the VFIO framework takes all the
> effort to put the default_domain away and create a new one and be
> ready for user space to use. But I tell him stop using the new
> domain and try the original one...
> 
> It is not reasonable, isn't it:)
> 
> So why don't I just take the request and set it into the
> default_domain directly? The true requirement of WarpDrive is to let
> process set the page table for particular pasid or substream id, so
> it can accept command with address in the process space. It needs no
> device.
> 
> From this perspective, it seems there is no reason to keep it in VFIO.
> 

I made a quick change basing on the RFCv1 here: 

https://github.com/Kenneth-Lee/linux-kernel-warpdrive/commits/warpdrive-v0.6

I just made it compilable and not test it yet. But it shows how the idea is
going to be.

The Pros is: most of the virtual device stuff can be removed. Resource
management is on the openned files only.

The Cons is: as Jean said, we have to redo something that has been done by VFIO.
These mainly are:

1. Track the dma operation and remove them on resource releasing
2. Pin the memory with gup and do accounting

It not going to be easy to make a decision...

> Thanks
> Kenneth
> >
> >Thanks,
> >Jean
> >
