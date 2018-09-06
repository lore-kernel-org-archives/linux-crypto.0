From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Thu, 6 Sep 2018 17:45:32 +0800
Message-ID: <20180906094532.GG230707@Turing-Arch-b>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
 <20180904150019.GA4024@redhat.com>
 <20180904101509.62314b67@t450s.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Jerome Glisse <jglisse@redhat.com>,
        Kenneth Lee <nek.in.cn@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        "Hao Fang" <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <linux-accelerators@lists.ozlabs.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>, <linuxarm@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180904101509.62314b67@t450s.home>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 04, 2018 at 10:15:09AM -0600, Alex Williamson wrote:
> Date: Tue, 4 Sep 2018 10:15:09 -0600
> From: Alex Williamson <alex.williamson@redhat.com>
> To: Jerome Glisse <jglisse@redhat.com>
> CC: Kenneth Lee <nek.in.cn@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
>  Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
>  <davem@davemloft.net>, Joerg Roedel <joro@8bytes.org>, Kenneth Lee
>  <liguozhu@hisilicon.com>, Hao Fang <fanghao11@huawei.com>, Zhou Wang
>  <wangzhou1@hisilicon.com>, Zaibo Xu <xuzaibo@huawei.com>, Philippe
>  Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman
>  <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>,
>  linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
>  linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
>  kvm@vger.kernel.org, linux-accelerators@lists.ozlabs.org, Lu Baolu
>  <baolu.lu@linux.intel.com>, Sanjay Kumar <sanjay.k.kumar@intel.com>,
>  linuxarm@huawei.com
> Subject: Re: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
> Message-ID: <20180904101509.62314b67@t450s.home>
> 
> On Tue, 4 Sep 2018 11:00:19 -0400
> Jerome Glisse <jglisse@redhat.com> wrote:
> 
> > On Mon, Sep 03, 2018 at 08:51:57AM +0800, Kenneth Lee wrote:
> > > From: Kenneth Lee <liguozhu@hisilicon.com>
> > > 
> > > WarpDrive is an accelerator framework to expose the hardware capabilities
> > > directly to the user space. It makes use of the exist vfio and vfio-mdev
> > > facilities. So the user application can send request and DMA to the
> > > hardware without interaction with the kernel. This removes the latency
> > > of syscall.
> > > 
> > > WarpDrive is the name for the whole framework. The component in kernel
> > > is called SDMDEV, Share Domain Mediated Device. Driver driver exposes its
> > > hardware resource by registering to SDMDEV as a VFIO-Mdev. So the user
> > > library of WarpDrive can access it via VFIO interface.
> > > 
> > > The patchset contains document for the detail. Please refer to it for more
> > > information.
> > > 
> > > This patchset is intended to be used with Jean Philippe Brucker's SVA
> > > patch [1], which enables not only IO side page fault, but also PASID
> > > support to IOMMU and VFIO.
> > > 
> > > With these features, WarpDrive can support non-pinned memory and
> > > multi-process in the same accelerator device.  We tested it in our SoC
> > > integrated Accelerator (board ID: D06, Chip ID: HIP08). A reference work
> > > tree can be found here: [2].
> > > 
> > > But it is not mandatory. This patchset is tested in the latest mainline
> > > kernel without the SVA patches.  So it supports only one process for each
> > > accelerator.
> > > 
> > > We have noticed the IOMMU aware mdev RFC announced recently [3].
> > > 
> > > The IOMMU aware mdev has similar idea but different intention comparing to
> > > WarpDrive. It intends to dedicate part of the hardware resource to a VM.
> > > And the design is supposed to be used with Scalable I/O Virtualization.
> > > While sdmdev is intended to share the hardware resource with a big amount
> > > of processes.  It just requires the hardware supporting address
> > > translation per process (PCIE's PASID or ARM SMMU's substream ID).
> > > 
> > > But we don't see serious confliction on both design. We believe they can be
> > > normalized as one.
> > >   
> > 
> > So once again i do not understand why you are trying to do things
> > this way. Kernel already have tons of example of everything you
> > want to do without a new framework. Moreover i believe you are
> > confuse by VFIO. To me VFIO is for VM not to create general device
> > driver frame work.
> 
> VFIO is a userspace driver framework, the VM use case just happens to
> be a rather prolific one.  VFIO was never intended to be solely a VM
> device interface and has several other userspace users, notably DPDK
> and SPDK, an NVMe backend in QEMU, a userspace NVMe driver, a ruby
> wrapper, and perhaps others that I'm not aware of.  Whether vfio is
> appropriate interface here might certainly still be a debatable topic,
> but I would strongly disagree with your last sentence above.  Thanks,
> 
> Alex
> 

Yes, that is also my standpoint here.

> > So here is your use case as i understand it. You have a device
> > with a limited number of command queues (can be just one) and in
> > some case it can support SVA/SVM (when hardware support it and it
> > is not disabled). Final requirement is being able to schedule cmds
> > from userspace without ioctl. All of this exists already exists
> > upstream in few device drivers.
> > 
> > 
> > So here is how every body else is doing it. Please explain why
> > this does not work.
> > 
> > 1 Userspace open device file driver. Kernel device driver create
> >   a context and associate it with on open. This context can be
> >   uniq to the process and can bind hardware resources (like a
> >   command queue) to the process.
> > 2 Userspace bind/acquire a commands queue and initialize it with
> >   an ioctl on the device file. Through that ioctl userspace can
> >   be inform wether either SVA/SVM works for the device. If SVA/
> >   SVM works then kernel device driver bind the process to the
> >   device as part of this ioctl.
> > 3 If SVM/SVA does not work userspace do an ioctl to create dma
> >   buffer or something that does exactly the same thing.
> > 4 Userspace mmap the command queue (mmap of the device file by
> >   using informations gather at step 2)
> > 5 Userspace can write commands into the queue it mapped
> > 6 When userspace close the device file all resources are release
> >   just like any existing device drivers.

Hi, Jerome,

Just one thing, as I said in the cover letter, dma-buf requires the application
to use memory created by the driver for DMA. I did try the dma-buf way in
WrapDrive (refer to [4] in the cover letter), it is a good backup for NOIOMMU
mode or we cannot solve the problem in VFIO.

But, in many of my application scenario, the application already has some memory
in hand, maybe allocated by the framework or libraries. Anyway, they don't get
memory from my library, and they pass the poiter for data operation. And they
may also have pointer in the buffer. Those pointer may be used by the
accelerator. So I need hardware fully share the address space with the
application. That is what dmabuf cannot do.

> > 
> > Now if you want to create a device driver framework that expose
> > a device file with generic API for all of the above steps fine.
> > But it does not need to be part of VFIO whatsoever or explain
> > why.
> > 
> > 
> > Note that if IOMMU is fully disabled you probably want to block
> > userspace from being able to directly scheduling commands onto
> > the hardware as it would allow userspace to DMA anywhere and thus
> > would open the kernel to easy exploits. In this case you can still
> > keeps the same API as above and use page fault tricks to valid
> > commands written by userspace into fake commands ring. This will
> > be as slow or maybe even slower than ioctl but at least it allows
> > you to validate commands.
> > 
> > Cheers,
> > Jérôme

-- 
			-Kenneth(Hisilicon)

================================================================================
本邮件及其附件含有华为公司的保密信息，仅限于发送给上面地址中列出的个人或群组。禁
止任何其他人以任何形式使用（包括但不限于全部或部分地泄露、复制、或散发）本邮件中
的信息。如果您错收了本邮件，请您立即电话或邮件通知发件人并删除本邮件！
This e-mail and its attachments contain confidential information from HUAWEI,
which is intended only for the person or entity whose address is listed above.
Any use of the 
information contained herein in any way (including, but not limited to, total or
partial disclosure, reproduction, or dissemination) by persons other than the
intended 
recipient(s) is prohibited. If you receive this e-mail in error, please notify
the sender by phone or email immediately and delete it!
