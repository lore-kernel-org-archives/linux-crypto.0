From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: New Linux accelerators discussion list [was: Re: Fostering
 linux community collaboration on hardware accelerators]
Date: Tue, 17 Oct 2017 13:53:46 +0100
Message-ID: <20171017135346.000031b9@huawei.com>
References: <201710101132.v9ABUs28138304@mx0a-001b2d01.pphosted.com>
        <07d49485-e583-8434-5681-92a0b54005ca@au1.ibm.com>
        <20171016150701.00004260@huawei.com>
        <a2031056-9ab4-cd03-1a18-f60d338ce090@au1.ibm.com>
        <20171017134810.000049a9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, <jic23@kernel.org>,
        "Liguozhu (Kenneth)" <liguozhu@hisilicon.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        <francois.ozog@linaro.org>, <Prasad.Athreya@cavium.com>,
        <arndbergmann@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Frederic Barrat <fbarrat@linux.vnet.ibm.com>,
        Mark Brown <broonie@kernel.org>,
        <Tirumalesh.Chalamarla@cavium.com>, <jcm@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jean-Philippe Brucker" <jean-philippe.brucker@arm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alistair Po
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171017134810.000049a9@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

+ linux-accelerators@lists.ozlabs.org

Seems sensible to have this email actually go to the new list so
at least it appears in the archive.

Sorry all, I should have thought of this before pressing send,

Jonathan

On Tue, 17 Oct 2017 13:48:10 +0100
Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:

> On Tue, 17 Oct 2017 11:00:40 +1100
> Andrew Donnellan <andrew.donnellan@au1.ibm.com> wrote:
> 
> > On 17/10/17 01:07, Jonathan Cameron wrote:  
> > > <snip>
> > >     
> > >>> So as ever with a linux community focusing on a particular topic, the
> > >>> obvious solution is a mailing list. There are a number of options on how
> > >>> do this.
> > >>>
> > >>> 1) Ask one of the industry bodies to host? Who?
> > >>>
> > >>> 2) Put together a compelling argument for linux-accelerators@vger.kernel.org
> > >>> as probably the most generic location for such a list.    
> > >>
> > >> Happy to offer linux-accelerators@lists.ozlabs.org, which I can get set
> > >> up immediately (and if we want patchwork, patchwork.ozlabs.org is
> > >> available as always, no matter where the list is hosted).
> > >>    
> > > 
> > > That would be great! Thanks for doing this. Much easier to find out what
> > > such a list is useful for by the practical option of having a list and
> > > see what people do with it.    
> > 
> > [+ LKML]
> > 
> > We now have a mailing list:
> > 
> >    List:      linux-accelerators@lists.ozlabs.org
> >    Info:      https://lists.ozlabs.org/listinfo/linux-accelerators
> >    Archives:  https://lists.ozlabs.org/pipermail/linux-accelerators
> > 
> > I haven't set up Patchwork as yet, but if people think that's a good 
> > idea I can get that done too.
> > 
> > 
> > Andrew
> >   
> 
> Thanks Andrew.
> 
> A quick summary of initial thoughts on scope of this list for anyone
> entering the discussion at this point.
> Note it will hopefully evolve in whatever direction people find helpful.
> This contains some suggestions not a barrier to wider scope!
> 
> There are a number of projects / applications involving what are
> termed hardware accelerators.  These include:
> * Traditional offload engines
> 	- Crypto, compression, media transcoding and similar accelerators
> 	- usecases including kTLS, Storage Encryption etc.
> * Dynamic FPGA type accelerators
> * ODP, DPDK and similar networking data plane - particularly dual stack
>   solutions where the kernel 'plays nicely' with userspace drivers.
> * AI Accelerators
> * Shared Virtual Memory (SVM) bus systems including Open-CAPI, CCIX etc
> * Fast data flow to/from userspace applications.
> 
> A number of existing project focus on these:
> * Mainline kernel drivers
> 	- Numerous crypto drivers etc
> 	- Open-CAPI
> * Various networking data plane activities
> * VFIO based and similar userspace drivers
> Hopefully this list can provide a broader forum where more general
> questions are being considered.
> 
> The discussion that lead to this list was that a number of people would
> like a general open forum on which to discuss ideas with scope beyond
> simply one kernel subsystem or one particular userspace framework.
> 
> Topics might include
> * RFCs and early reviews of new approaches.
> * Similar hardware - who is trying to solve the same problems?
> * What would we ideally want from new hardware iterations?
> * Hardware description - the question of how to chose a particular
>   crypto engine is very dependent on the particular data flows.
>   Sometimes hardware accelerators don't actually help due to overheads.
>   Understanding those barriers would be very useful.
> * Upstream paths - blockers and how to work with the communities to
>   overcome them.
> * Fostering stronger userspace communities to allow these accelerators to 
>   be easily harnessed.
> 	- A number of projects have been highlighted in this thread
> 	  OpenStack (cyborg project), openMP accelerator support 
> * Robustness / security of userspace frameworks.
> * Virtualisation of accelerators
> 
> Anyhow, this email was just meant to draw together some thoughts.
> It will be interesting to see what the list actually gets used for :)
> 
> Jonathan
