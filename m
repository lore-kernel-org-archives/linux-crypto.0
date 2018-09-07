From: Kenneth Lee <liguozhu@hisilicon.com>
Subject: Re: [PATCH 1/7] vfio/sdmdev: Add documents for WarpDrive framework
Date: Fri, 7 Sep 2018 10:21:15 +0800
Message-ID: <20180907022115.GH230707@Turing-Arch-b>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
 <20180903005204.26041-2-nek.in.cn@gmail.com>
 <56f5f66d-f6d9-f4fa-40ca-e4a8bad170c1@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Kenneth Lee <nek.in.cn@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Fang <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, <linux-accelerators@lists.ozlabs.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>, <linuxarm@huawei.com>
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56f5f66d-f6d9-f4fa-40ca-e4a8bad170c1@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 06, 2018 at 11:36:36AM -0700, Randy Dunlap wrote:
> Date: Thu, 6 Sep 2018 11:36:36 -0700
> From: Randy Dunlap <rdunlap@infradead.org>
> To: Kenneth Lee <nek.in.cn@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
>  Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
>  <davem@davemloft.net>, Joerg Roedel <joro@8bytes.org>, Alex Williamson
>  <alex.williamson@redhat.com>, Kenneth Lee <liguozhu@hisilicon.com>, Hao
>  Fang <fanghao11@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>, Zaibo Xu
>  <xuzaibo@huawei.com>, Philippe Ombredanne <pombredanne@nexb.com>, Greg
>  Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner
>  <tglx@linutronix.de>, linux-doc@vger.kernel.org,
>  linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
>  iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
>  linux-accelerators@lists.ozlabs.org, Lu Baolu <baolu.lu@linux.intel.com>,
>  Sanjay Kumar <sanjay.k.kumar@intel.com>
> CC: linuxarm@huawei.com
> Subject: Re: [PATCH 1/7] vfio/sdmdev: Add documents for WarpDrive framework
> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
>  Thunderbird/52.9.1
> Message-ID: <56f5f66d-f6d9-f4fa-40ca-e4a8bad170c1@infradead.org>
> 
> Hi,
> 
> On 09/02/2018 05:51 PM, Kenneth Lee wrote:
> > From: Kenneth Lee <liguozhu@hisilicon.com>
> > 
> > WarpDrive is a common user space accelerator framework.  Its main component
> > in Kernel is called sdmdev, Share Domain Mediated Device. It exposes
> > the hardware capabilities to the user space via vfio-mdev. So processes in
> > user land can obtain a "queue" by open the device and direct access the
> > hardware MMIO space or do DMA operation via VFIO interface.
> > 
> > WarpDrive is intended to be used with Jean Philippe Brucker's SVA
> > patchset to support multi-process. But This is not a must.  Without the
> > SVA patches, WarpDrive can still work for one process for every hardware
> > device.
> > 
> > This patch add detail documents for the framework.
> > 
> > Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> > ---
> >  Documentation/00-INDEX                |   2 +
> >  Documentation/warpdrive/warpdrive.rst | 100 ++++
> >  Documentation/warpdrive/wd-arch.svg   | 728 ++++++++++++++++++++++++++
> >  3 files changed, 830 insertions(+)
> >  create mode 100644 Documentation/warpdrive/warpdrive.rst
> >  create mode 100644 Documentation/warpdrive/wd-arch.svg
> 
> > diff --git a/Documentation/warpdrive/warpdrive.rst b/Documentation/warpdrive/warpdrive.rst
> > new file mode 100644
> > index 000000000000..6d2a5d1e08c4
> > --- /dev/null
> > +++ b/Documentation/warpdrive/warpdrive.rst
> > @@ -0,0 +1,100 @@
> > +Introduction of WarpDrive
> > +=========================
> > +
> > +*WarpDrive* is a general accelerator framework for user space. It intends to
> > +provide interface for the user process to send request to hardware
> > +accelerator without heavy user-kernel interaction cost.
> > +
> > +The *WarpDrive* user library is supposed to provide a pipe-based API, such as:
> 
> Do you say "is supposed to" because it doesn't do that (yet)?
> Or you could just change that to say:
> 
>    The WarpDrive user library provides a pipe-based API, such as:
> 

Actually, I tried to say it can be defined like this. But people can choose
other implementation with the same kernel API.

I will say it explicitly in the future version. Thank you.

> 
> > +        ::
> > +        int wd_request_queue(struct wd_queue *q);
> > +        void wd_release_queue(struct wd_queue *q);
> > +
> > +        int wd_send(struct wd_queue *q, void *req);
> > +        int wd_recv(struct wd_queue *q, void **req);
> > +        int wd_recv_sync(struct wd_queue *q, void **req);
> > +        int wd_flush(struct wd_queue *q);
> > +
> > +*wd_request_queue* creates the pipe connection, *queue*, between the
> > +application and the hardware. The application sends request and pulls the
> > +answer back by asynchronized wd_send/wd_recv, which directly interact with the
> > +hardware (by MMIO or share memory) without syscall.
> > +
> > +*WarpDrive* maintains a unified application address space among all involved
> > +accelerators.  With the following APIs: ::
> 
> Seems like an extra '.' there.  How about:
> 
>   accelerators with the following APIs: ::
> 

Err, the "with..." clause belong to the following "The referred process
space...".

> > +
> > +        int wd_mem_share(struct wd_queue *q, const void *addr,
> > +                         size_t size, int flags);
> > +        void wd_mem_unshare(struct wd_queue *q, const void *addr, size_t size);
> > +
> > +The referred process space shared by these APIs can be directly referred by the
> > +hardware. The process can also dedicate its whole process space with flags,
> > +*WD_SHARE_ALL* (not in this patch yet).
> > +
> > +The name *WarpDrive* is simply a cool and general name meaning the framework
> > +makes the application faster. As it will be explained in this text later, the
> > +facility in kernel is called *SDMDEV*, namely "Share Domain Mediated Device".
> > +
> > +
> > +How does it work
> > +================
> > +
> > +*WarpDrive* is built upon *VFIO-MDEV*. The queue is wrapped as *mdev* in VFIO.
> > +So memory sharing can be done via standard VFIO standard DMA interface.
> > +
> > +The architecture is illustrated as follow figure:
> > +
> > +.. image:: wd-arch.svg
> > +        :alt: WarpDrive Architecture
> > +
> > +Accelerator driver shares its capability via *SDMDEV* API: ::
> > +
> > +        vfio_sdmdev_register(struct vfio_sdmdev *sdmdev);
> > +        vfio_sdmdev_unregister(struct vfio_sdmdev *sdmdev);
> > +        vfio_sdmdev_wake_up(struct spimdev_queue *q);
> > +
> > +*vfio_sdmdev_register* is a helper function to register the hardware to the
> > +*VFIO_MDEV* framework. The queue creation is done by *mdev* creation interface.
> > +
> > +*WarpDrive* User library mmap the mdev to access its mmio space and shared
> 
> s/mmio/MMIO/
> 
> > +memory. Request can be sent to, or receive from, hardware in this mmap-ed
> > +space until the queue is full or empty.
> > +
> > +The user library can wait on the queue by ioctl(VFIO_SDMDEV_CMD_WAIT) the mdev
> > +if the queue is full or empty. If the queue status is changed, the hardware
> > +driver use *vfio_sdmdev_wake_up* to wake up the waiting process.
> > +
> > +
> > +Multiple processes support
> > +==========================
> > +
> > +In the latest mainline kernel (4.18) when this document is written,
> > +multi-process is not supported in VFIO yet.
> > +
> > +Jean Philippe Brucker has a patchset to enable it[1]_. We have tested it
> > +with our hardware (which is known as *D06*). It works well. *WarpDrive* rely
> > +on them to support multiple processes. If it is not enabled, *WarpDrive* can
> > +still work, but it support only one mdev for a process, which will share the
> > +same io map table with kernel. (But it is not going to be a security problem,
> > +since the user application cannot access the kernel address space)
> > +
> > +When multiprocess is support, mdev can be created based on how many
> > +hardware resource (queue) is available. Because the VFIO framework accepts only
> > +one open from one mdev iommu_group. Mdev become the smallest unit for process
> > +to use queue. And the mdev will not be released if the user process exist. So
> > +it will need a resource agent to manage the mdev allocation for the user
> > +process. This is not in this document's range.
> > +
> > +
> > +Legacy Mode Support
> > +===================
> > +For the hardware on which IOMMU is not support, WarpDrive can run on *NOIOMMU*
> > +mode. That require some update to the mdev driver, which is not included in
> > +this version yet.
> > +
> > +
> > +References
> > +==========
> > +.. [1] https://patchwork.kernel.org/patch/10394851/
> > +
> > +.. vim: tw=78
> 
> thanks,
> -- 
> ~Randy

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
