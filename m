From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.1/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Mon, 9 Oct 2017 17:21:30 +0200
Message-ID: <20171009152130.vo2lpwdvcs4lyb2l@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007184049.jrbxebb4jlciu3hj@pd.tnic>
 <c6ec79f7-5192-8ed3-4df3-260c09ceccb9@amd.com>
 <20171008140019.flvyovgq2xpqdcoq@pd.tnic>
 <7131ad30-6c07-16d5-8cfc-06d446a66dca@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7131ad30-6c07-16d5-8cfc-06d446a66dca@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 08, 2017 at 07:11:04PM -0500, Brijesh Singh wrote:
> There is a single security processor driver (ccp) which provides the
> complete functionality including PSP.  But the driver should be able to
> work with multiple devices. e.g In my 2P EPYC configuration, security
> processor driver is used for the following devices
> 
> 02:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
> 1456

So we have a lot of drivers which claim more than one PCI device. It is
not mandatory to have a driver per PCI device. Actually, the decisive
argument is what is the easiest way to manage those devices and what
makes the communication between them the easiest.

> 03:00.1 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
> 1468
> 13:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device
> 1456

Btw, what do those PCI functions each do? Public PPR doesn't have them
documented.

> Some of the these devices support CCP only and some support both PSP and
> CCP. It's possible that multiple devices support the PSP functionality
> but only one of them is master which can be used for issuing SEV
> commands. There isn't a register which we can read to determine whether
> the device is master. We have to probe all the devices which supports
> the PSP to determine which one of them is a master.

Sure, and if you manage all the devices in a single driver, you can
simply keep them all in a linked list or in an array and iterating over
them is trivial.

Because right now you have

1. sp-pci.c::sp_pci_probe() execute upon the PCI device detection

2. at some point, it does sp-dev.c::sp_init() which decides whether CCP or PSP

3. If PSP, it calls pcp-dev.c::psp_dev_init() which gets that
sp->dev_vdata->psp_vdata which is nothing more than a simple offset
0x10500 which is where the PSP io regs are. For example, if this offset
is hardcoded, why are we even passing that vdata? Just set psp->io_regs =
0x10500. No need for all that passing of structs around.

4. and finally, after that *whole* init has been done, you get to do
->set_psp_master_device(sp);

Or, you can save yourself all that jumping through hoops, merge sp-pci.c
and sp-dev.c into a single sp.c and put *everything* sp-related into
it. And then do the whole work of picking hw apart, detection and
configuration in sp_pci_probe() and have helper functions preparing and
configuring the device.

At the end, it adds it to the list of devices sp.c manages and done. You
actually have that list already:

static LIST_HEAD(sp_units);

in sp-dev.c.

You don't need the set_master thing either - you simply set the
sp_dev_master pointer inside sp.c

sp_init() can then go and you can replace it with its function body,
deciding whether it is a CCP or PSP and then call the respective
function which is also in sp.c or ccp-dev.c

And then all those separate compilation units and the interfaces between
them disappear - you have only the calls into the PSP and that's it.

Btw, the CCP thing could remain separate initially, I guess, with all
that ccp-* stuff in there.

> I was trying to follow the CCP  model -- in which sp-dev.c simply
> forwards the call to ccp-dev.c which does the real work.

And you don't really need that - you can do the real work directly in
sp-dev.c or sp.c or whatever.

> Currently, sev-dev.c contains barebone common code. IMO, keeping all
> the PSP private functions and data structure outside the sp-dev.c/.h
> is right thing.

By this model probably, but it causes all that init and registration
jump-through-hoops for no real reason. It is basically wasting cycles
and energy.

I'm all for splitting if it makes sense. But right now I don't see much
sense in this - it is basically a bunch of small compilation units
calling each other. And they could be merged into a single sp.c which
does it all in one go, without a lot of blabla.

> Additionally, I would like to highlight that if we decide to go with
> moving all the PSP functionality in sp-dev.c then we have to add #ifdef
> CONFIG_CRYPTO_DEV_SP_PSP because PSP feature depends on X86_66, whereas
> the sp-dev.c gets compiled for all architectures (including aarch64,
> i386 and x86_64).

That's fine. You can build it on 32-bit but add to the init function

	if (IS_ENABLED(CONFIG_X86_32))
		return -ENODEV;

and be done with it. No need for the ifdeffery.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
