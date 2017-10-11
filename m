From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: Fostering linux community collaboration on hardware
 accelerators
Date: Wed, 11 Oct 2017 15:43:31 +0100
Message-ID: <20171011154331.000014bb@huawei.com>
References: <20171009112425.00003966@huawei.com>
        <CAHFG_=UfO54nkM68RmLmZWLtYROhaUu9U866kqTzpU=MgxfCkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: <jic23@kernel.org>, "Liguozhu (Kenneth)" <liguozhu@hisilicon.com>,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        <Prasad.Athreya@cavium.com>, <arndbergmann@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Frederic Barrat <fbarrat@linux.vnet.ibm.com>,
        Andrew Donnellan <andrew.donnellan@au1.ibm.com>,
        Mark Brown <broonie@kernel.org>,
        <Tirumalesh.Chalamarla@cavium.com>, Jon Masters <jcm@redhat.com>,
        "Ard Biesheuvel" <ard.biesheuvel@linaro.org>,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Eric Auger" <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        Andrea Gallo <andrea.gallo@linaro.org>, <grant.likely@arm.com>
To: Francois Ozog <francois.ozog@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:8003 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbdJKOuA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2017 10:50:00 -0400
In-Reply-To: <CAHFG_=UfO54nkM68RmLmZWLtYROhaUu9U866kqTzpU=MgxfCkA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 10 Oct 2017 16:55:06 +0200
Francois Ozog <francois.ozog@linaro.org> wrote:

> Hi,
Hi Francois,

Firstly, to anyone seeing this on the mailing lists, there was an attachment so
it presumably bounced.

> 
> I am really happy you started this thread. I think we need to have Grant
> Likely from Arm involved in the topic. I only have his HPE mail and not his
> new Arm. I also added Andrea Gallo who has visibility of all segment groups
> in Linaro.

Good idea. Given the simple nature of your average ARM email address I've one with
guessing Grant's *crosses fingers*.

> 
> 
> As you say, there are more questions than answers at this stage and I'd
> like to share thoughts and related activities I already conducted so that
> you can take those into account (if they are relevant) to build your action
> plan.
> 
> 
> On the scope of accelerators I include media related (transcoding...) and
> FPGAs.

Two more for the list - I knew I've forget some big groups ;)

> I kicked off discussions with various parties on how to build an
> FPGA focused community (see attached document on FPGAs). The FPGAs will
> need proper "factory" of userland drivers and I expect WD to be
> instrumental in this.
> 
> On the "ODP type" requirements: I think we have to include both ODP and
> DPDK.
> 
> Robustness/security of the userland framework: if anything happens to
> userland, the kernel has to recover.

This issue is a key one I'd missed when drawing up my list. Glad you
raised it.

> Exposing pieces of PCI config space or
> portions of MMIOs may be a new area of intellectual property for Arm.
> 
> I was leading acceleration activities in ETSI NFV (IFA stream 2 group that
> was created by Yun-Chao Hu@ Huawei, Bruno Chatras@Orange and myself) and
> talked to Orange, BT, Telecom Italia and AT&T yesterday. The guys I know
> are keen to participate to an advisory board related to acceleration in
> Opensource Communities. They see the value of continuing the work done in
> SDOs (ETSI, IETF, IEEE...) in OCs (Linaro, Linux Foundation...). 

Interesting - of course such a structure might be useful. Of course their
input along with that of others would be of great assistance.

However, any formal arrangement or consortium does bring costs that may put
some individuals or companies off involvement.   To my mind, any Linux
focused effort needs to incorporate those interests, but take in wider views.
That's not to say that any Linux community focused effort would not be a
good place for ideas coming out of industry consortiums / advisory groups
to be presented and evaluated as an integral part of the community.

>I think
> their participation to the acceleration efforts is key to ensure we solve
> the right problem the right way. I am trying to organize an accelerator
> workshop "accelerators: from SDO to Opensource) at the ETSI NFV F2F meeting
> (NFV#20 December 4-8th in Sophia Antipolis, France). An agenda item is also
> how to deal with Intel EPA that introduce bias in platform and accelerator
> "scheduling" in Openstack terminology.
> 
> As of particular interest is accelerator management in the context of Cloud
> and NFV. Huawei is leading efforts in Cyborg project (OpenStack) and I
> think, while it should be kept  as a separate effort, we should be aligning
> our efforts in a way or the other.

Management, in a more general sense isn't something I had really considered.
Efforts such as Cyborg seem to sit at a higher level in the stack but clearly
you are correct in suggesting that aligning efforts makes sense.

> 
> CCIX will have a massive impact on networking. With DMA it is all about
> packet MOVEMENT. With CCIX this is about cacheline games. Dealing with
> headroom and tail room of packets will no longer be an issue. Achieving
> 50Gbps and above line rate bumped into DMA transactions per second problem.
> Wit CCIX this is no longer an issue (at least on paper).

This is true of both CCIX and some competing / alternative technologies.
I am very keen to embrace that competition as well so that any results
of collaboration help everyone!  Not to mention there is plenty of
existing hardware with adhoc solutions in place already.

The one big element I clearly forgot to mention in the below scope is
virtualization (oops).  Any solutions clearly need to take that into
account as well.

Jonathan

> 
> 
> 
> Cordially,
> 
> François-Frédéric
> 
> On 10 October 2017 at 13:28, Jonathan Cameron <Jonathan.Cameron@huawei.com>
> wrote:
> 
> > Hi All,
> >
> > Please forward this email to anyone you think may be interested.
> >
> > On behalf of Huawei, I am looking into options to foster a wider community
> > around the various ongoing projects related to Accelerator support within
> > Linux.  The particular area of interest to Huawei is that of harnessing
> > accelerators from userspace, but in a collaborative way with the kernel
> > still able to make efficient use of them, where appropriate.
> >
> > We are keen to foster a wider community than one just focused on
> > our own current technology.  This is a field with no clear answers, so the
> > widest possible range of input is needed!
> >
> > The address list of this email is drawn from people we have had discussions
> > with or who have been suggested in response to Kenneth Lee's wrapdrive
> > presentation at Linaro Connect and earlier presentations on the more
> > general
> > issue. A few relevant lists added to hopefully catch anyone we missed.
> > My apologies to anyone who got swept up in this and isn't interested!
> >
> > Here we are defining accelerators fairly broadly - suggestions for a better
> > term are also welcome.
> >
> > The infrastructure may be appropriate for:
> > * Traditional offload engines - cryptography, compression and similar
> > * Upcoming AI accelerators
> > * ODP type requirements for access to elements of networking
> > * Systems utilizing SVM including CCIX and other cache coherent buses
> > * Many things we haven't thought of yet...
> >
> > As I see it, there are several aspects to this:
> >
> > 1) Kernel drivers for accelerators themselves.
> >    * Traditional drivers such as crypto etc
> >         - These already have their own communities. The main
> >           focus of such work will always be through them.
> >         - What a more general community could add here would be an
> >           overview of the shared infrastructure of such devices.
> >           This is particularly true around VFIO based (or similar)
> >           userspace interfaces with a non trivial userspace component.
> >    * How to support new types of accelerator?
> >
> > 2) The need for lightweight access paths from userspace that 'play well'
> > and
> >    share resources etc with standard in-kernel drivers.  This is the area
> >    that Kenneth Lee and Huawei have been focusing on with their wrapdrive
> >    effort. We know there are other similar efforts going on in other
> > companies.
> >    * This may involve interacting with existing kernel communities such as
> >      those around VFIO and mdev.
> >    * Resource management when we may have many consumers - not all hardware
> >      has appropriate features to deal with this.
> >
> > 3) Usecases for accelerators. e.g.
> >    * kTLS
> >    * Storage encryption
> >    * ODP - networking dataplane
> >    * AI toolkits
> >
> > Discussions we want to get started include:
> > * A wider range of hardware than we are currently considering. What makes
> >   sense to target / what hardware do people have they would like to
> > support?
> > * Upstream paths - potential blockers and how to overcome them. The
> > standard
> >   kernel drivers should be fairly straightforward, but once we start
> > looking at
> >   systems with a heavier userspace component, things will get more
> >   controversial!
> > * Fostering stronger userspace communities to allow these these
> > accelerators
> >   to be easily harnessed.
> >
> > So as ever with a linux community focusing on a particular topic, the
> > obvious solution is a mailing list. There are a number of options on how
> > do this.
> >
> > 1) Ask one of the industry bodies to host? Who?
> >
> > 2) Put together a compelling argument for linux-accelerators@vger.
> > kernel.org
> > as probably the most generic location for such a list.
> >
> > More open questions are
> > 1) Scope?
> >  * Would anyone ever use such an overarching list?
> >  * Are we better off with the usual adhoc list of 'interested parties' +
> > lkml?
> >  * Do we actually need to define the full scope - are we better with a
> > vague
> >    definition?
> >
> > 2) Is there an existing community we can use to discuss these issues?
> >    (beyond the obvious firehose of LKML).
> >
> > 3) Who else to approach for input on these general questions?
> >
> > In parallel to this there are elements such as git / patchwork etc but
> > they can all be done as they are needed.
> >
> > Thanks
> >
> > --
> > Jonathan Cameron
> > Huawei
> >  
> 
> 
> 
