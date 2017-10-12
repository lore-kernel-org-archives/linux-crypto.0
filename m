From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: Fostering linux community collaboration on hardware
 accelerators
Date: Thu, 12 Oct 2017 15:57:10 +0100
Message-ID: <20171012155710.000063d1@huawei.com>
References: <201710101132.v9ABUs28138304@mx0a-001b2d01.pphosted.com>
        <07d49485-e583-8434-5681-92a0b54005ca@au1.ibm.com>
        <b7ceffd0-a07b-87c8-aec4-6a5effe997f4@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Andrew Donnellan <andrew.donnellan@au1.ibm.com>,
        <jic23@kernel.org>, "Liguozhu (Kenneth)" <liguozhu@hisilicon.com>,
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
        <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>
To: Douglas Miller <dougmill@linux.vnet.ibm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <b7ceffd0-a07b-87c8-aec4-6a5effe997f4@linux.vnet.ibm.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 12 Oct 2017 08:31:36 -0500
Douglas Miller <dougmill@linux.vnet.ibm.com> wrote:

> Not sure if you're already plugged-in to this, but the OpenMP group is 
> (has been) working on Accelerator support.
> 
> http://www.openmp.org/updates/openmp-accelerator-support-gpus/
> 
> Maybe you are talking about a different aspect of accelerator support, 
> but it seems prudent to involve OpenMP as much as makes sense.

That's certainly interesting and sits in the area of 'standard'
userspace code but it is (I think) really addressing only one aspect
of the wider support problem.

I do like the emphasis on balancing between CPU and accelerator,
that is certainly an open question even a the lowest levels in
areas such as cryptography acceleration where you either run
out of hardware resources on your accelerator or you actually
have a usage pattern that would be quicker on the CPU due
to inherent overheads in (current) non cpu crypto engines.

Thanks for the pointer.  I can see we are going to need some location
for resources like this to be gathered together.

Jonathan

> 
> 
> On 10/12/2017 12:22 AM, Andrew Donnellan wrote:
> > On 10/10/17 22:28, Jonathan Cameron wrote:  
> >> Hi All,
> >>
> >> Please forward this email to anyone you think may be interested.  
> >
> > Have forwarded this to a number of relevant IBMers.
> >  
> >> On behalf of Huawei, I am looking into options to foster a wider 
> >> community
> >> around the various ongoing projects related to Accelerator support 
> >> within
> >> Linux.  The particular area of interest to Huawei is that of harnessing
> >> accelerators from userspace, but in a collaborative way with the kernel
> >> still able to make efficient use of them, where appropriate.
> >>
> >> We are keen to foster a wider community than one just focused on
> >> our own current technology.  This is a field with no clear answers, 
> >> so the
> >> widest possible range of input is needed!
> >>
> >> The address list of this email is drawn from people we have had 
> >> discussions
> >> with or who have been suggested in response to Kenneth Lee's wrapdrive
> >> presentation at Linaro Connect and earlier presentations on the more 
> >> general
> >> issue. A few relevant lists added to hopefully catch anyone we missed.
> >> My apologies to anyone who got swept up in this and isn't interested!
> >>
> >> Here we are defining accelerators fairly broadly - suggestions for a 
> >> better
> >> term are also welcome.
> >>
> >> The infrastructure may be appropriate for:
> >> * Traditional offload engines - cryptography, compression and similar
> >> * Upcoming AI accelerators
> >> * ODP type requirements for access to elements of networking
> >> * Systems utilizing SVM including CCIX and other cache coherent buses
> >> * Many things we haven't thought of yet...
> >>
> >> As I see it, there are several aspects to this:
> >>
> >> 1) Kernel drivers for accelerators themselves.
> >>     * Traditional drivers such as crypto etc
> >>     - These already have their own communities. The main
> >>            focus of such work will always be through them.
> >>          - What a more general community could add here would be an
> >>            overview of the shared infrastructure of such devices.
> >>       This is particularly true around VFIO based (or similar)
> >>       userspace interfaces with a non trivial userspace component.
> >>     * How to support new types of accelerator?
> >>
> >> 2) The need for lightweight access paths from userspace that 'play 
> >> well' and
> >>     share resources etc with standard in-kernel drivers.  This is the 
> >> area
> >>     that Kenneth Lee and Huawei have been focusing on with their 
> >> wrapdrive
> >>     effort. We know there are other similar efforts going on in other 
> >> companies.
> >>     * This may involve interacting with existing kernel communities 
> >> such as
> >>       those around VFIO and mdev.
> >>     * Resource management when we may have many consumers - not all 
> >> hardware
> >>       has appropriate features to deal with this.
> >>
> >> 3) Usecases for accelerators. e.g.
> >>     * kTLS
> >>     * Storage encryption
> >>     * ODP - networking dataplane
> >>     * AI toolkits
> >>
> >> Discussions we want to get started include:
> >> * A wider range of hardware than we are currently considering. What 
> >> makes
> >>    sense to target / what hardware do people have they would like to 
> >> support?
> >> * Upstream paths - potential blockers and how to overcome them. The 
> >> standard
> >>    kernel drivers should be fairly straightforward, but once we start 
> >> looking at
> >>    systems with a heavier userspace component, things will get more
> >>    controversial!
> >> * Fostering stronger userspace communities to allow these these 
> >> accelerators
> >>    to be easily harnessed.
> >>
> >> So as ever with a linux community focusing on a particular topic, the
> >> obvious solution is a mailing list. There are a number of options on how
> >> do this.
> >>
> >> 1) Ask one of the industry bodies to host? Who?
> >>
> >> 2) Put together a compelling argument for 
> >> linux-accelerators@vger.kernel.org
> >> as probably the most generic location for such a list.  
> >
> > Happy to offer linux-accelerators@lists.ozlabs.org, which I can get 
> > set up immediately (and if we want patchwork, patchwork.ozlabs.org is 
> > available as always, no matter where the list is hosted).
> >  
> >> More open questions are
> >> 1) Scope?
> >>   * Would anyone ever use such an overarching list?
> >>   * Are we better off with the usual adhoc list of 'interested 
> >> parties' + lkml?
> >>   * Do we actually need to define the full scope - are we better with 
> >> a vague
> >>     definition?  
> >
> > I think a list with a broad and vaguely defined scope is a good idea - 
> > it would certainly be helpful to us to be able to follow what other 
> > contributors are doing that could be relevant to our CAPI and OpenCAPI 
> > work.
> >  
> >>
> >> 2) Is there an existing community we can use to discuss these issues?
> >>     (beyond the obvious firehose of LKML).
> >>
> >> 3) Who else to approach for input on these general questions?
> >>
> >> In parallel to this there are elements such as git / patchwork etc but
> >> they can all be done as they are needed.
> >>
> >> Thanks
> >>
> >> -- 
> >> Jonathan Cameron
> >> Huawei
> >>  
> >  
> 
