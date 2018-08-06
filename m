From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 3/7] vfio: add spimdev support
Date: Mon, 6 Aug 2018 09:49:40 -0600
Message-ID: <20180806094940.47c70be9@t450s.home>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
        <20180801102221.5308-4-nek.in.cn@gmail.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D191290F7B@SHSMSX101.ccr.corp.intel.com>
        <20180802034727.GK160746@Turing-Arch-b>
        <AADFC41AFE54684AB9EE6CBC0274A5D19129102C@SHSMSX101.ccr.corp.intel.com>
        <20180802073440.GA91035@Turing-Arch-b>
        <20180802103528.0b863030.cohuck@redhat.com>
        <20180802124327.403b10ab@t450s.home>
        <20180806014004.GF91035@Turing-Arch-b>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
        Kenneth Lee <nek.in.cn@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        Hao Fang <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lin
To: Kenneth Lee <liguozhu@hisilicon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180806014004.GF91035@Turing-Arch-b>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 6 Aug 2018 09:40:04 +0800
Kenneth Lee <liguozhu@hisilicon.com> wrote:

> On Thu, Aug 02, 2018 at 12:43:27PM -0600, Alex Williamson wrote:
> > Date: Thu, 2 Aug 2018 12:43:27 -0600
> > From: Alex Williamson <alex.williamson@redhat.com>
> > To: Cornelia Huck <cohuck@redhat.com>
> > CC: Kenneth Lee <liguozhu@hisilicon.com>, "Tian, Kevin"
> >  <kevin.tian@intel.com>, Kenneth Lee <nek.in.cn@gmail.com>, Jonathan Corbet
> >  <corbet@lwn.net>, Herbert Xu <herbert@gondor.apana.org.au>, "David S .
> >  Miller" <davem@davemloft.net>, Joerg Roedel <joro@8bytes.org>, Hao Fang
> >  <fanghao11@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>, Zaibo Xu
> >  <xuzaibo@huawei.com>, Philippe Ombredanne <pombredanne@nexb.com>, "Greg
> >  Kroah-Hartman" <gregkh@linuxfoundation.org>, Thomas Gleixner
> >  <tglx@linutronix.de>, "linux-doc@vger.kernel.org"
> >  <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
> >  <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org"
> >  <linux-crypto@vger.kernel.org>, "iommu@lists.linux-foundation.org"
> >  <iommu@lists.linux-foundation.org>, "kvm@vger.kernel.org"
> >  <kvm@vger.kernel.org>, "linux-accelerators@lists.ozlabs.org\"
> >          <linux-accelerators@lists.ozlabs.org>, Lu Baolu
> >  <baolu.lu@linux.intel.com>,  Kumar", <Sanjay K "
> >  <sanjay.k.kumar@intel.com>, " linuxarm@huawei.com "
> >  <linuxarm@huawei.com>">
> > Subject: Re: [RFC PATCH 3/7] vfio: add spimdev support
> > Message-ID: <20180802124327.403b10ab@t450s.home>
> > 
> > On Thu, 2 Aug 2018 10:35:28 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> > > On Thu, 2 Aug 2018 15:34:40 +0800
> > > Kenneth Lee <liguozhu@hisilicon.com> wrote:
> > >   
> > > > On Thu, Aug 02, 2018 at 04:24:22AM +0000, Tian, Kevin wrote:    
> > >   
> > > > > > From: Kenneth Lee [mailto:liguozhu@hisilicon.com]
> > > > > > Sent: Thursday, August 2, 2018 11:47 AM
> > > > > >       
> > > > > > >      
> > > > > > > > From: Kenneth Lee
> > > > > > > > Sent: Wednesday, August 1, 2018 6:22 PM
> > > > > > > >
> > > > > > > > From: Kenneth Lee <liguozhu@hisilicon.com>
> > > > > > > >
> > > > > > > > SPIMDEV is "Share Parent IOMMU Mdev". It is a vfio-mdev. But differ      
> > > > > > from      
> > > > > > > > the general vfio-mdev:
> > > > > > > >
> > > > > > > > 1. It shares its parent's IOMMU.
> > > > > > > > 2. There is no hardware resource attached to the mdev is created. The
> > > > > > > > hardware resource (A `queue') is allocated only when the mdev is
> > > > > > > > opened.      
> > > > > > >
> > > > > > > Alex has concern on doing so, as pointed out in:
> > > > > > >
> > > > > > > 	https://www.spinics.net/lists/kvm/msg172652.html
> > > > > > >
> > > > > > > resource allocation should be reserved at creation time.      
> > > > > > 
> > > > > > Yes. That is why I keep telling that SPIMDEV is not for "VM", it is for "many
> > > > > > processes", it is just an access point to the process. Not a device to VM. I
> > > > > > hope
> > > > > > Alex can accept it:)
> > > > > >       
> > > > > 
> > > > > VFIO is just about assigning device resource to user space. It doesn't care
> > > > > whether it's native processes or VM using the device so far. Along the direction
> > > > > which you described, looks VFIO needs to support the configuration that
> > > > > some mdevs are used for native process only, while others can be used
> > > > > for both native and VM. I'm not sure whether there is a clean way to
> > > > > enforce it...      
> > > > 
> > > > I had the same idea at the beginning. But finally I found that the life cycle
> > > > of the virtual device for VM and process were different. Consider you create
> > > > some mdevs for VM use, you will give all those mdevs to lib-virt, which
> > > > distribute those mdev to VMs or containers. If the VM or container exits, the
> > > > mdev is returned to the lib-virt and used for next allocation. It is the
> > > > administrator who controlled every mdev's allocation.  
> > 
> > Libvirt currently does no management of mdev devices, so I believe
> > this example is fictitious.  The extent of libvirt's interaction with
> > mdev is that XML may specify an mdev UUID as the source for a hostdev
> > and set the permissions on the device files appropriately.  Whether
> > mdevs are created in advance and re-used or created and destroyed
> > around a VM instance (for example via qemu hooks scripts) is not a
> > policy that libvirt imposes.
> >    
> > > > But for process, it is different. There is no lib-virt in control. The
> > > > administrator's intension is to grant some type of application to access the
> > > > hardware. The application can get a handle of the hardware, send request and get
> > > > the result. That's all. He/She dose not care which mdev is allocated to that
> > > > application. If it crashes, it should be the kernel's responsibility to withdraw
> > > > the resource, the system administrator does not want to do it by hand.    
> > 
> > Libvirt is also not a required component for VM lifecycles, it's an
> > optional management interface, but there are also VM lifecycles exactly
> > as you describe.  A VM may want a given type of vGPU, there might be
> > multiple sources of that type and any instance is fungible to any
> > other.  Such an mdev can be dynamically created, assigned to the VM,
> > and destroyed later.  Why do we need to support "empty" mdevs that do
> > not reserve reserve resources until opened?  The concept of available
> > instances is entirely lost with that approach and it creates an
> > environment that's difficult to support, resources may not be available
> > at the time the user attempts to access them.
> >    
> > > I don't think that you should distinguish the cases by the presence of
> > > a management application. How can the mdev driver know what the
> > > intention behind using the device is?  
> > 
> > Absolutely, vfio is a userspace driver interface, it's not tailored to
> > VM usage and we cannot know the intentions of the user.
> >    
> > > Would it make more sense to use a different mechanism to enforce that
> > > applications only use those handles they are supposed to use? Maybe
> > > cgroups? I don't think it's a good idea to push usage policy into the
> > > kernel.  
> > 
> > I agree, this sounds like a userspace problem, mdev supports dynamic
> > creation and removal of mdev devices, if there's an issue with
> > maintaining a set of standby devices that a user has access to, this
> > sounds like a userspace broker problem.  It makes more sense to me to
> > have a model where a userspace application can make a request to a
> > broker and the broker can reply with "none available" rather than
> > having a set of devices on standby that may or may not work depending
> > on the system load and other users.  Thanks,
> > 
> > Alex  
> 
> I am sorry, I used a wrong mutt command when reply to Cornelia's last mail. The
> last reply dose not stay within this thread. So please let me repeat my point
> here.
> 
> I should not have use libvirt as the example. But WarpDrive works in such
> scenario:
> 
> 1. It supports thousands of processes. Take zip accelerator as an example, any
> application need data compression/decompression will need to interact with the
> accelerator. To support that, you have to create tens of thousands of mdev for
> their usage. I don't think it is a good idea to have so many devices in the
> system.

Each mdev is a device, regardless of whether there are hardware
resources committed to the device, so I don't understand this argument.
 
> 2. The application does not want to own the mdev for long. It just need an
> access point for the hardware service. If it has to interact with an management
> agent for allocation and release, this makes the problem complex.

I don't see how the length of the usage plays a role here either.  Are
you concerned that the time it takes to create and remove an mdev is
significant compared to the usage time?  Userspace is certainly welcome
to create a pool of devices, but why should it be the kernel's
responsibility to dynamically assign resources to an mdev?  What's the
usage model when resources are unavailable?  It seems there's
complexity in either case, but it's generally userspace's responsibility
to impose a policy.

> 3. The service is bound with the process. When the process exit, the resource
> should be released automatically. Kernel is the best place to monitor the state
> of the process.

Mdev already provides that when an mdev is removed, the hardware
resources attached to it are released back to the mdev parent device.
A process closing the device simply indicates the end of a usage
context of the device.  It seems like the request here is simply that
allocating resources on open allows userspace to be lazy and overcommit
physical resources without considering what happens when those
resources are unavailable.
 
> I agree this extending the concept of mdev. But again, it is cleaner than
> creating another facility for user land DMA. We just need to take mdev as an
> access point of the device: when it is open, the resource is given. It is not a
> device for a particular entity or instance. But it is still a device which can
> provide service of the hardware.

Cleaner for who?  It's asking the kernel to impose a policy for
delegating resources when we effectively already have a policy that
userspace is responsible for allocating and delegating resources.
 
> Cornelia is worrying about resource starving. I think that can be solved by set
> restriction on the mdev itself. Mdev management agent dose not help much here.
> Management on the mdev itself can still lead to the status of running out of
> resource.

The restriction on the mdev is that the mdev itself represents allocated
resources.  Of course we can always run out, but the current model is
that a user granted access to a vfio device, mdev or otherwise, has
ownership of the hardware provided through that interface.  I don't see
how not committing resources to an mdev is anything more than an
attempt to push policy and error handling from one place to another.
Thanks,

Alex
