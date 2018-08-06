From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [RFC PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Mon, 6 Aug 2018 11:32:58 -0400
Message-ID: <20180806153257.GB6002@redhat.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
 <20180801165644.GA3820@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D191290E1A@SHSMSX101.ccr.corp.intel.com>
 <20180802040557.GL160746@Turing-Arch-b>
 <20180802142243.GA3481@redhat.com>
 <20180803034721.GC91035@Turing-Arch-b>
 <20180803143944.GA4079@redhat.com>
 <20180806031252.GG91035@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        Hao Fang <fanghao11@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kenneth Lee <nek.in.cn@
To: Kenneth Lee <liguozhu@hisilicon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180806031252.GG91035@Turing-Arch-b>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 06, 2018 at 11:12:52AM +0800, Kenneth Lee wrote:
> On Fri, Aug 03, 2018 at 10:39:44AM -0400, Jerome Glisse wrote:
> > On Fri, Aug 03, 2018 at 11:47:21AM +0800, Kenneth Lee wrote:
> > > On Thu, Aug 02, 2018 at 10:22:43AM -0400, Jerome Glisse wrote:
> > > > On Thu, Aug 02, 2018 at 12:05:57PM +0800, Kenneth Lee wrote:
> > > > > On Thu, Aug 02, 2018 at 02:33:12AM +0000, Tian, Kevin wrote:
> > > > > > > On Wed, Aug 01, 2018 at 06:22:14PM +0800, Kenneth Lee wrote:
> > > > > > > >

[...]

> > > > > But doorbell is just a notification. Except for DOS (to make hardware busy) it
> > > > > cannot actually take or change anything from the kernel space. And the DOS
> > > > > problem can be always taken as the problem that a group of processes share the
> > > > > same kernel entity.
> > > > > 
> > > > > In the coming HIP09 hardware, the doorbell will come with a random number so
> > > > > only the process who allocated the queue can knock it correctly.
> > > > 
> > > > When doorbell is ring the hardware start fetching commands from
> > > > the queue and execute them ? If so than a rogue process B might
> > > > ring the doorbell of process A which would starts execution of
> > > > random commands (ie whatever random memory value there is left
> > > > inside the command buffer memory, could be old commands i guess).
> > > > 
> > > > If this is not how this doorbell works then, yes it can only do
> > > > a denial of service i guess. Issue i have with doorbell is that
> > > > i have seen 10 differents implementations in 10 differents hw
> > > > and each are different as to what ringing or value written to the
> > > > doorbell does. It is painfull to track what is what for each hw.
> > > > 
> > > 
> > > In our implementation, doorbell is simply a notification, just like an interrupt
> > > to the accelerator. The command is all about what's in the queue.
> > > 
> > > I agree that there is no simple and standard way to track the shared IO space.
> > > But I think we have to trust the driver in some way. If the driver is malicious,
> > > even a simple ioctl can become an attack.
> > 
> > Trusting kernel space driver is fine, trusting user space driver is
> > not in my view. AFAICT every driver developer so far always made
> > sure that someone could not abuse its device to do harmfull thing to
> > other process.
> > 
> 
> Fully agree. That is why this driver shares only the doorbell space. There is
> only the doorbell is shared in the whole page, nothing else.
> 
> Maybe you are concerning the user driver will give malicious command to the
> hardware? But these commands cannot influence the other process. If we can trust
> the hardware design, the process cannot do any harm.

My questions was what happens if a process B ring the doorbell of
process A.

On some hardware the value written in the doorbell is use as an
index in command buffer. On other it just wakeup the hardware to go
look at a structure private to the process. They are other variations
of those themes.

If it is the former ie the value is use to advance in the command
buffer then a rogue process can force another process to advance its
command buffer and what is in the command buffer can be some random
old memory values which can be more harmfull than just Denial Of
Service.


> > > > > > > My more general question is do we want to grow VFIO to become
> > > > > > > a more generic device driver API. This patchset adds a command
> > > > > > > queue concept to it (i don't think it exist today but i have
> > > > > > > not follow VFIO closely).
> > > > > > > 
> > > > > 
> > > > > The thing is, VFIO is the only place to support DMA from user land. If we don't
> > > > > put it here, we have to create another similar facility to support the same.
> > > > 
> > > > No it is not, network device, GPU, block device, ... they all do
> > > > support DMA. The point i am trying to make here is that even in
> > > 
> > > Sorry, wait a minute, are we talking the same thing? I meant "DMA from user
> > > land", not "DMA from kernel driver". To do that we have to manipulate the
> > > IOMMU(Unit). I think it can only be done by default_domain or vfio domain. Or
> > > the user space have to directly access the IOMMU.
> > 
> > GPU do DMA in the sense that you pass to the kernel a valid
> > virtual address (kernel driver do all the proper check) and
> > then you can use the GPU to copy from or to that range of
> > virtual address. Exactly how you want to use this compression
> > engine. It does not rely on SVM but SVM going forward would
> > still be the prefered option.
> > 
> 
> No, SVM is not the reason why we rely on Jean's SVM(SVA) series. We rely on
> Jean's series because of multi-process (PASID or substream ID) support.
> 
> But of couse, WarpDrive can still benefit from the SVM feature.

We are getting side tracked here. PASID/ID do not require VFIO.


> > > > your mechanisms the userspace must have a specific userspace
> > > > drivers for each hardware and thus there are virtually no
> > > > differences between having this userspace driver open a device
> > > > file in vfio or somewhere else in the device filesystem. This is
> > > > just a different path.
> > > > 
> > > 
> > > The basic problem WarpDrive want to solve it to avoid syscall. This is important
> > > to accelerators. We have some data here:
> > > https://www.slideshare.net/linaroorg/progress-and-demonstration-of-wrapdrive-a-accelerator-framework-sfo17317
> > > 
> > > (see page 3)
> > > 
> > > The performance is different on using kernel and user drivers.
> > 
> > Yes and example i point to is exactly that. You have a one time setup
> > cost (creating command buffer binding PASID with command buffer and
> > couple other setup steps). Then userspace no longer have to do any
> > ioctl to schedule work on the GPU. It is all down from userspace and
> > it use a doorbell to notify hardware when it should go look at command
> > buffer for new thing to execute.
> > 
> > My point stands on that. You have existing driver already doing so
> > with no new framework and in your scheme you need a userspace driver.
> > So i do not see the value add, using one path or the other in the
> > userspace driver is litteraly one line to change.
> > 
> 
> Sorry, I'd got confuse here. I partially agree that the user driver is
> redundance of kernel driver. (But for WarpDrive, the kernel driver is a full
> driver include all preparation and setup stuff for the hardware, the user driver
> is simply to send request and receive answer). Yes, it is just a choice of path.
> But the user path is faster if the request come from use space. And to do that,
> we need user land DMA support. Then why is it invaluable to let VFIO involved?

Some drivers in the kernel already do exactly what you said. The user
space emit commands without ever going into kernel by directly scheduling
commands and ringing a doorbell. They do not need VFIO either and they
can map userspace address into the DMA address space of the device and
again they do not need VFIO for that.

My point is the you do not need VFIO for DMA in user land, nor do you need
it to allow a device to consume user space commands without IOCTL.

Moreover as you already need a device specific driver in both kernel and
user space then there is not added value in trying to have all kind of
devices under the same devfs hierarchy.

Cheers,
Jérôme
