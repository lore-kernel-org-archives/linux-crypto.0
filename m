Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D651029BDB1;
	Sat, 28 Mar 2026 11:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774697939; cv=none; b=P8GWC0/uWLP0BGcavg9MU6UyBfokecDXFELwHdnfvBhWHy7FA5JOJ7sBsNoDUrGckYYy5IypVTdlTFnLDsAtpb2eeu8tkU2T5OfUHtPjdjOmYWZDKZm14jTvKLrz4fyeMEqReYXlJGnngylIvcJs9i7dwzH+Zt5XAISdUQasdQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774697939; c=relaxed/simple;
	bh=SzK5nPoEiGS477vhoKIdwTSGJXbtrTPNCQW9iaoIAzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TvNiVFJa3mBDKj9JMkjP2QJ8TZc26CZ86jQkXCzF8cqwdcg5IiQN4Sjre89TXz7xl2UrXjHZYXWj6V+zfFWhViNXDytAeJ8AC6Ngmw0W0VWgNz6gZWGTrklMNyZIENVnk+hW9z5fIwC3dRUx8E3z/2zkfW4Q69bsNmgomBSeUF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=MUyRvNF/; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MUyRvNF/"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6BBC840E0194;
	Sat, 28 Mar 2026 11:38:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MpBsUlLNL1J8; Sat, 28 Mar 2026 11:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1774697922; bh=yYRUBeKI4GxFrfkBTAqDsQVqXSkD2HBmGvw1C3u3BYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MUyRvNF/8ndNKMdEqXino+Dby3JtJ7hKgujzsqwQiJLpiU1M08JLhy5Zl20j1nffv
	 jPGX/d141lGi0qfmcg5AqNqI7vO/0ro4kNu/cLtNBYUXFUf4DhZJGVY3u3NvNvcqGS
	 SccCoSgIor/zerbXIUY4Pr1QnS08xutVPUGp8xdZ21RqLPmRBWGnBHHWM60BYc//hb
	 QjmKmi8hIiwXAibPdSEmw4B14p86zW5eeadgvvfC6wuG0d1pVT5PnC45REUeFESMtj
	 4LzomwkkQcAGR5EI5enCBfkBrjkHNEsI/zsrNsc3Wi3J2ookBnLXHnzH8Y+lWfiPhn
	 Vq4UwLYvNT4sDJjnJME/NgJ0uk27JIo99DQoIGCalaGKLV8OGzyIv03gkgZAQ1d1My
	 SFGDE58kYmZRub6kZWkCUiLhrVM73ZVXC6bwsJjqtKXt1YbfQpV5Cxad3/8d7+rUGA
	 Z5YrB/GhuhHIAWiPIJXrwW7stZOdNFFpyJ7UuI96WzEXtXyMZUTUO4iJF0obiPx4Ht
	 rtcpAb602/ovtKlCMLzBuO1qMp4ms0DC25c6GSJeGoRtV9rLN3eFeWr0m2vAimUgK+
	 sQn4pFgQnaEJzmxzV/NUX6ajhTQwVnRCrDk/UUTT3cKk7KUJk8HFWUTPCjyBm4EtNG
	 J0jciPZLyAmsgi3sogaksh1Q=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 8E87B40E0163;
	Sat, 28 Mar 2026 11:38:21 +0000 (UTC)
Date: Sat, 28 Mar 2026 12:38:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tycho Andersen <tycho@kernel.org>
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
Message-ID: <20260328113814.GSace9ppUByOyRrTFI@fat_crate.local>
References: <20260324161301.1353976-1-tycho@kernel.org>
 <6A6AA56D-6B4C-4C32-A639-18C14BC0C358@alien8.de>
 <acP-UdjBy06MnBgY@tycho.pizza>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <acP-UdjBy06MnBgY@tycho.pizza>

On Wed, Mar 25, 2026 at 09:25:05AM -0600, Tycho Andersen wrote:
> You did complain about this call chain before off-list though, maybe
> we should clear CC_ATTR_HOST_SEV_SNP in more places directly vs.
> returning an errno to make it more obvious?

iommu_snp_enable() already has the disable_snp label where it does that. If
you wanna clear the flag in snp_rmptable_init() you'll simply have to sprinkle
flag clearing across more places. I dunno if that is really better frankly...

> > Is there a race condition with CPU hotplug here?
> >
> > Since snp_prepare() lacks cpus_read_lock() protection, a CPU could
> > come online exactly between the two passes, missing the mfd_enable step
> > but receiving snp_enable.
> 
> I think it makes sense to do the operations on the same set of CPUs
> even if we don't support hotplug. I will resend with
> cpus_read_lock().

Right, especially if that function would run now at arbitrary points in time
- as this is the main reason we're doing this whole dance.

BUT!

If you grab the hotplug lock and you realize that you don't have all CPUs
online and since we zapped the hotplug notifier and since SNP enable would
fail anyway, we should simply check if all CPUs are online and return error
if not instead of running the IPIs.

> > Could placing snp_prepare() here cause prolonged blocking of all SEV
> > operations? Since __sev_snp_init_locked() holds sev_cmd_mutex, the long
> > execution time of clear_rmp() (which zeroes the entire RMP table and scales
> > with system RAM) might block SEV firmware ioctls and VM lifecycle operations
> > globally for several seconds.
> 
> Yes, it does :). Actually the firmware call is the expensive part, not
> the rmp zeroing, but it definitely blocks for a while.

But we've delayed this init to the latest possible moment.

So much so that when this "prolonged blocking" happens, that is very much
absolutely indispensable.

And besides, we're not really running SNP guests here so to me that feedback
doesn't really make much sense...

> > This isn't a bug introduced by this commit, but if SEV initialization
> > fails and KVM is actively running normal VMs, could a userspace process
> > trigger this code path via /dev/sev ioctls (e.g., SEV_PDH_GEN) and zero out
> > MSR_VM_HSAVE_PA globally? Would the next VMRUN execution for an active VM
> > trigger a general protection fault and crash the host?
> 
> Oof, yes. I wonder if we shouldn't set psp_dead = true if
> sev_platform_init() sees an error. After this series, if
> the error is e.g. init_ex_path failure, you can unload, fix the
> failure, and try again.

Let's slow down here.

So the LLM is talking about a use case where you have unencrypted VMs running
and then userspace can go and poke /dev/sev, zero out that MSR_VM_HSAVE_PA in
the process but that's the MSR which contains the physical address where host
state is saved on a VMRUN and if that MSR is cleared because SNP init needs
it, the machine would explode.

Ok, so far so good, I don't see anything wrong with the use case - nothing's
stopping the admin from modprobing ccp and then launching SNP guests.

Now, you're talking about some psp_dead - yet another silly boolean folks love
to introduce in the SEV code - and then something about that init_ex_path
hack. I don't know what that means, frankly.

What my simple intuition says is, *if* snp_prepare() runs,  then no guests
should do VMRUN anymore until they're ready to do that again.

Which begs the question: if snp_prepare() clears MSR_VM_HSAVE_PA, how can you
even run normal VMs after that?

Hmmm.

> >  	if (sev_version_greater_or_equal(SNP_MIN_API_MAJOR, 52)) {
> [ ... ]
> >  		memset(&data, 0, sizeof(data));
> [ ... ]
> >  		data.tio_en = tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();
> [ ... ]
> >  	} else {
> >  		cmd = SEV_CMD_SNP_INIT;
> >  		arg = NULL;
> >  	}
> > This isn't a bug introduced by this commit, but is the stack variable
> > data left uninitialized when taking the else branch? Since data.tio_en is
> > later evaluated unconditionally, could stack garbage cause it to evaluate
> > to true, leading to erroneous attempts to allocate pages and initialize
> > SEV-TIO on unsupported hardware?
> 
> No, arg is the actual pointer passed, and it is set to NULL. non-EX
> init doesn't support TIO anyway...

This code is a total mess.

struct sev_data_snp_init_ex data;
...

... the else branch executes so you do

	arg = NULL;

...

and now *after* it, you're testing data:

        dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
                data.tio_en ? "enabled" : "disabled");

Which *is* uninitialized stack data.

So the AI is right AFAICT.

If I were the AI, I'd say, what a total mess this code is. This
__sev_snp_init_locked() thing needs serious cleanup because it is too
convoluted to exist. And silly bugs like that creep in, as a result.

If I were maintaining this, I'd enforce a mandatory driver cleanup before any
new features come in. For example, __sev_snp_init_locked() needs proper
splitting and streamlining instead of doing gazillion things and with
a conditional in it which has consequences about the code after it. :-\

> > Also, regarding the bounds check in snp_filter_reserved_mem_regions()
> > called via walk_iomem_res_desc(): does the check
> > if ((range_list->num_elements * 16 + 8) > PAGE_SIZE)
> > allow an off-by-one heap buffer overflow?
> >
> > If range_list->num_elements is 255, 255 * 16 + 8 = 4088, which is <= 4096.
> > Writing range->base (8 bytes) fills 4088-4095, but writing range->page_count
> > (4 bytes) would write to 4096-4099, overflowing the kzalloc-allocated
> > PAGE_SIZE buffer.

That's a good catch.

> Yes, this also looks real, and needs:
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 939fa8aa155c..3642226c0fc0 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1328,10 +1328,11 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  	size_t size;
>  
>  	/*
> -	 * Ensure the list of HV_FIXED pages that will be passed to firmware
> -	 * do not exceed the page-sized argument buffer.
> +	 * Ensure the list of HV_FIXED pages including the one we are about to

No "we" - use passive voice pls.

> +	 * use that will be passed to firmware do not exceed the page-sized
> +	 * argument buffer.
>  	 */
> -	if ((range_list->num_elements * sizeof(struct sev_data_range) +
> +	if (((range_list->num_elements + 1) * sizeof(struct sev_data_range) +
>  	     sizeof(struct sev_data_range_list)) > PAGE_SIZE)
>  		return -E2BIG;

Yes, this is a short-term fix for stable.

But that "handling" in there is just nuts. You have this:

	snp_range_list = kzalloc(PAGE_SIZE, GFP_KERNEL);

	...

        rc = walk_iomem_res_desc(IORES_DESC_NONE, IORESOURCE_MEM, 0, ~0,
				  snp_range_list, snp_filter_reserved_mem_regions);

That function calls

		snp_filter_reserved_mem_regions(resource *, snp_range_list);

and that resource walking BIOS-like yuck code is iterating over the resources
and calling ->func each time.

So we pass in a *page* but then that range list *array* we turn it into, is
not a multiple of the element size of 24 AFAICT.

So that last element can trail and overflow heap. Lovely.

So this thing needs complete change: *actually* pass in an array instead of
a page so that you're not trailing, check the current element index against
the array size instead of doing obscure struct size calculations which are
visible only to very motivated reviewers like an AI and then just get rid of
the overflow possibility in the first place.

> I have another bug that review-prompts found unrelated to this series.
> I can put the two fixes above with that or include them here, let me
> know what you prefer. Either way I'll resend one more with
> cpus_read_lock().

So, your set is kinda ready to go and I'll take it but if I were you, right
after this, I'll sit down and fix all that crap in sev-dev.c. Do a nice
patchset, simple backportable fixes first and proper refactoring and cleanup
ontop.

Just piling up more stuff ontop is not maintanable in the long run.

But hey, I'm not maintaining this thing so I'm off the chain here for
a change!

:-P :-P

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
