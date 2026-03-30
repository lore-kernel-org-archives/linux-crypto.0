Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BC8363C6F;
	Mon, 30 Mar 2026 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774885133; cv=none; b=A2wlP/MjxKpyim8PK8gI4iEcuoLdlivVX/5+gVddRSwHmyLtCx5M9eEuA8pEC8ugpy8Eey/C5QP+t9z4nU5FC67s+9r6spvdkZFoz5RQFH4UW/Jp+V1c7k7vx7+2dVif64iMDpVIDN4OGBJh68nR5yvGsDokvCKxyPF7Uc9+XZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774885133; c=relaxed/simple;
	bh=eLxEypI8QBApRQ3sdD4fMBa2d3tUuSgbVJXyuNnVOwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUMMHTgiKoKN9LT/uYdqboKjKkkgvuPVHMCeQbOZRn6y65oT0+VPnZJhqK3Yqisb8Z7zwVnuM/oO3uqW261/mZ6i4ueo9JchWHIaTTVJT9rLmkMyry3tc3ILR5L1V7b6KdYIdsWUFyOPgE5jflFCDsvOhsV75Ikt0YGnx21DuUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ShhnGkBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ShhnGkBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D27CC4CEF7;
	Mon, 30 Mar 2026 15:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774885133;
	bh=eLxEypI8QBApRQ3sdD4fMBa2d3tUuSgbVJXyuNnVOwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ShhnGkBhdmk+1FgyMHV0D8aig+eCJ8yIZnPjYPGIw5OXC0ooRhAA0HvlDUPC7d71I
	 lMphy0IgcUg2npZDjKmNf3RmewrITBbiuHy7Y3Ge18DbDde5Kp09h3X9R48d77sZep
	 wfM/Ex7Ea2txq1k5F0ChenekIg0GnZviN+hOSBpRwOQHubZkUZdVKeTa7S4p5s2F01
	 /ae4nrrtO/SpWbXHdoKP71sOyXh5slUAcm3hPwH1NG+UIcptK0GRSYjhXStkLucKXR
	 gZsZkLy4Pzyj7COBZ/jg3vUrjvwJGtB0nd5IO4o38JWMJyhW1/60VvpiPtWJdOTQRM
	 ekrP9sJFnZa0A==
Date: Mon, 30 Mar 2026 09:38:49 -0600
From: Tycho Andersen <tycho@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 0/7] Move SNP initialization to the CCP driver
Message-ID: <acqZCYwNdepPnNMB@tycho.pizza>
References: <20260324161301.1353976-1-tycho@kernel.org>
 <6A6AA56D-6B4C-4C32-A639-18C14BC0C358@alien8.de>
 <acP-UdjBy06MnBgY@tycho.pizza>
 <20260328113814.GSace9ppUByOyRrTFI@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260328113814.GSace9ppUByOyRrTFI@fat_crate.local>

On Sat, Mar 28, 2026 at 12:38:14PM +0100, Borislav Petkov wrote:
> > > Is there a race condition with CPU hotplug here?
> > >
> > > Since snp_prepare() lacks cpus_read_lock() protection, a CPU could
> > > come online exactly between the two passes, missing the mfd_enable step
> > > but receiving snp_enable.
> > 
> > I think it makes sense to do the operations on the same set of CPUs
> > even if we don't support hotplug. I will resend with
> > cpus_read_lock().
> 
> Right, especially if that function would run now at arbitrary points in time
> - as this is the main reason we're doing this whole dance.
> 
> BUT!
> 
> If you grab the hotplug lock and you realize that you don't have all CPUs
> online and since we zapped the hotplug notifier and since SNP enable would
> fail anyway, we should simply check if all CPUs are online and return error
> if not instead of running the IPIs.

Sure, I will send a patch on top with that.

> > > This isn't a bug introduced by this commit, but if SEV initialization
> > > fails and KVM is actively running normal VMs, could a userspace process
> > > trigger this code path via /dev/sev ioctls (e.g., SEV_PDH_GEN) and zero out
> > > MSR_VM_HSAVE_PA globally? Would the next VMRUN execution for an active VM
> > > trigger a general protection fault and crash the host?
> > 
> > Oof, yes. I wonder if we shouldn't set psp_dead = true if
> > sev_platform_init() sees an error. After this series, if
> > the error is e.g. init_ex_path failure, you can unload, fix the
> > failure, and try again.
> 
> Let's slow down here.
> 
> So the LLM is talking about a use case where you have unencrypted VMs running
> and then userspace can go and poke /dev/sev, zero out that MSR_VM_HSAVE_PA in
> the process but that's the MSR which contains the physical address where host
> state is saved on a VMRUN and if that MSR is cleared because SNP init needs
> it, the machine would explode.
> 
> Ok, so far so good, I don't see anything wrong with the use case - nothing's
> stopping the admin from modprobing ccp and then launching SNP guests.
> 
> Now, you're talking about some psp_dead - yet another silly boolean folks love
> to introduce in the SEV code - and then something about that init_ex_path
> hack. I don't know what that means, frankly.
> 
> What my simple intuition says is, *if* snp_prepare() runs,  then no guests
> should do VMRUN anymore until they're ready to do that again.
> 
> Which begs the question: if snp_prepare() clears MSR_VM_HSAVE_PA, how can you
> even run normal VMs after that?

IIUC, the normal flow is:

1. amd_iommu_init() -> snp_rmptable_init() // previously snp_prepare()
1. kvm load
1. ccp load, /dev/sev created  // now snp_prepare()
1. kvm_amd load, sev_init()
1. kvm_x86_vendor_init() -> sev_hardware_setup()
1. kvm_init() -> kvm_arch_enable_virtualization_cpu() ->
       svm_enable_virtualization_cpu() -> HSAVE_PA = $real_pa

So the happy path works fine. The problem is if e.g. the first
snp_prepare() fails, userspace can do ioctl(/dev/sev, SEV_PDH_GEN, ...)
or try to start an SNP VM, which will unconditionally do
sev_platform_init(). Both of those trigger the snp_prepare() again,
and you can't run normal VMs.

IMO if you fail SNP init once, you probably will again. I was
suggesting setting psp_dead to just kill everything.

But the real issue is that late-SNP initialization is problematic.
I'll see if there's some way we can figure out if we're in that path
and forbid it.

> > >  	if (sev_version_greater_or_equal(SNP_MIN_API_MAJOR, 52)) {
> > [ ... ]
> > >  		memset(&data, 0, sizeof(data));
> > [ ... ]
> > >  		data.tio_en = tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();
> > [ ... ]
> > >  	} else {
> > >  		cmd = SEV_CMD_SNP_INIT;
> > >  		arg = NULL;
> > >  	}
> > > This isn't a bug introduced by this commit, but is the stack variable
> > > data left uninitialized when taking the else branch? Since data.tio_en is
> > > later evaluated unconditionally, could stack garbage cause it to evaluate
> > > to true, leading to erroneous attempts to allocate pages and initialize
> > > SEV-TIO on unsupported hardware?
> > 
> > No, arg is the actual pointer passed, and it is set to NULL. non-EX
> > init doesn't support TIO anyway...
> 
> This code is a total mess.
> 
> struct sev_data_snp_init_ex data;
> ...
> 
> ... the else branch executes so you do
> 
> 	arg = NULL;
> 
> ...
> 
> and now *after* it, you're testing data:
> 
>         dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
>                 data.tio_en ? "enabled" : "disabled");
> 
> Which *is* uninitialized stack data.
> 
> So the AI is right AFAICT.

do'h, yes, I glossed over the printk(), thanks.

> If I were the AI, I'd say, what a total mess this code is. This
> __sev_snp_init_locked() thing needs serious cleanup because it is too
> convoluted to exist. And silly bugs like that creep in, as a result.
> 
> If I were maintaining this, I'd enforce a mandatory driver cleanup before any
> new features come in. For example, __sev_snp_init_locked() needs proper
> splitting and streamlining instead of doing gazillion things and with
> a conditional in it which has consequences about the code after it. :-\
> 
> > > Also, regarding the bounds check in snp_filter_reserved_mem_regions()
> > > called via walk_iomem_res_desc(): does the check
> > > if ((range_list->num_elements * 16 + 8) > PAGE_SIZE)
> > > allow an off-by-one heap buffer overflow?
> > >
> > > If range_list->num_elements is 255, 255 * 16 + 8 = 4088, which is <= 4096.
> > > Writing range->base (8 bytes) fills 4088-4095, but writing range->page_count
> > > (4 bytes) would write to 4096-4099, overflowing the kzalloc-allocated
> > > PAGE_SIZE buffer.
> 
> That's a good catch.
> 
> > Yes, this also looks real, and needs:
> > 
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > index 939fa8aa155c..3642226c0fc0 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -1328,10 +1328,11 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
> >  	size_t size;
> >  
> >  	/*
> > -	 * Ensure the list of HV_FIXED pages that will be passed to firmware
> > -	 * do not exceed the page-sized argument buffer.
> > +	 * Ensure the list of HV_FIXED pages including the one we are about to
> 
> No "we" - use passive voice pls.

Thanks, will fix.

> > +	 * use that will be passed to firmware do not exceed the page-sized
> > +	 * argument buffer.
> >  	 */
> > -	if ((range_list->num_elements * sizeof(struct sev_data_range) +
> > +	if (((range_list->num_elements + 1) * sizeof(struct sev_data_range) +
> >  	     sizeof(struct sev_data_range_list)) > PAGE_SIZE)
> >  		return -E2BIG;
> 
> Yes, this is a short-term fix for stable.
> 
> But that "handling" in there is just nuts. You have this:
> 
> 	snp_range_list = kzalloc(PAGE_SIZE, GFP_KERNEL);
> 
> 	...
> 
>         rc = walk_iomem_res_desc(IORES_DESC_NONE, IORESOURCE_MEM, 0, ~0,
> 				  snp_range_list, snp_filter_reserved_mem_regions);
> 
> That function calls
> 
> 		snp_filter_reserved_mem_regions(resource *, snp_range_list);
> 
> and that resource walking BIOS-like yuck code is iterating over the resources
> and calling ->func each time.
> 
> So we pass in a *page* but then that range list *array* we turn it into, is
> not a multiple of the element size of 24 AFAICT.
> 
> So that last element can trail and overflow heap. Lovely.
> 
> So this thing needs complete change: *actually* pass in an array instead of
> a page so that you're not trailing, check the current element index against
> the array size instead of doing obscure struct size calculations which are
> visible only to very motivated reviewers like an AI and then just get rid of
> the overflow possibility in the first place.
> 
> > I have another bug that review-prompts found unrelated to this series.
> > I can put the two fixes above with that or include them here, let me
> > know what you prefer. Either way I'll resend one more with
> > cpus_read_lock().
> 
> So, your set is kinda ready to go and I'll take it but if I were you, right
> after this, I'll sit down and fix all that crap in sev-dev.c. Do a nice
> patchset, simple backportable fixes first and proper refactoring and cleanup
> ontop.

Thanks for applying it. I have a stack of patches from this and my own
review-prompts use that I'm testing now, but they are just the simple
fixes. I'll work on trying to make things a little for the future
too...

Tycho
