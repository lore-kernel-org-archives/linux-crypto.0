Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001BD3B2FEF;
	Mon, 23 Mar 2026 15:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279889; cv=none; b=HZidIzupDe77hWMR64+KDVABrx2/+kx7I7OAKpR22IyGSEWnCfqrCIHDBmFFDfZT1gheuxvDCKkUQ8Hfn4Olnsm7WGPR4lemV5RCaK+U0uiXF6KcUOxxSeePnoYL2+JRsc/giDZdRE+zxJmKxBa/CK9ZIvLWYxywHF4cJiWCN5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279889; c=relaxed/simple;
	bh=/KVZ0Xx5CO2qrabb+CqN5wRNDciiQdwQb7WKLXunJdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZGb+oczXhzulpmyEYt4BfYmC3ue6l4Xedy9Qt/IG1+jc4Rno56Jn/J1yyiwxx90bGNJhIWoLhwlzpqioNaH1I75eEbj4nhKJsFkUHvcx8TCv6merfa91Th5krWmLIMVq51hU7TJ2YMXPJlhBSMcCuKhf0k8cCj35vInvlm8PlLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eGo0hOw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eGo0hOw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6CCC4CEF7;
	Mon, 23 Mar 2026 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774279888;
	bh=/KVZ0Xx5CO2qrabb+CqN5wRNDciiQdwQb7WKLXunJdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eGo0hOw/J3eQbmic7DT+3UzEHvxKAe+cRhUXQgZElVPUZc/H7DikEjZ2u5MtR3dHn
	 B3pDhnqjhny4++G4mPh2DAh/dbOfHxeTj8Ncg8oCFCSFDGL0ej5M+0qEjBY82D/Kch
	 cP885hjjAGQP73yA0fvjjeEBm/Odf28eu2z8Ol7cpHlDUmMXIXgK2M66sjZxMD3GSH
	 9fM4ZaoVLO9TVxA9T0zjP/J1lSCTrQiHL0y6Bg3MBE89XIluBGCCAzVKkGzIgCaH4r
	 j4LmEpJTwzyQ9AmKA6LYe2Kh+EV/IV0yEhYmOn3pn98fKBJa2zt5Y0gHEaTwvQcPVM
	 W4vRc9DYjC+Aw==
Date: Mon, 23 Mar 2026 09:31:25 -0600
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
Subject: Re: [PATCH v3 3/7] x86/snp: create snp_x86_shutdown()
Message-ID: <acFczQda7Xsx4oJg@tycho.pizza>
References: <20260317162157.150842-1-tycho@kernel.org>
 <20260317162157.150842-4-tycho@kernel.org>
 <20260321170534.GBab7P3t0jJsRmPUE3@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260321170534.GBab7P3t0jJsRmPUE3@fat_crate.local>

Hi Boris,

On Sat, Mar 21, 2026 at 06:05:34PM +0100, Borislav Petkov wrote:
> On Tue, Mar 17, 2026 at 10:21:53AM -0600, Tycho Andersen wrote:
> > Subject: Re: [PATCH v3 3/7] x86/snp: create snp_x86_shutdown()
> 
> "x86/sev: ..."
> 
> The tip tree preferred format for patch subject prefixes is
> 'subsys/component:', e.g. 'x86/apic:', 'x86/mm/fault:', 'sched/fair:',
> 'genirq/core:'. Please do not use file names or complete file paths as
> prefix. 'git log path/to/file' should give you a reasonable hint in most
> cases.
> 
> The condensed patch description in the subject line should start with a
> uppercase letter and should be written in imperative tone.
> 
> Check your whole set pls.

Will do.

> > From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> > 
> > After SNP_SHUTDOWN, two architecture-level things should be done:
> 
> "architecture-level things"?

I'll just drop this entirely, i.e. "two things should be done:"

> 
> > 1. clear the RMP table
> > 2. disable MFDM to prevent the FW_WARN in k8_check_syscfg_dram_mod_en() in
> >    the event of a kexec
> > 
> > Create and export to the CCP driver a function that does them.
> > 
> > Also change the MFDM helper to allow for disabling the bit, since the SNP
> > x86 shutdown path needs to disable MFDM. The comment for
> > k8_check_syscfg_dram_mod_en() notes, the "BIOS" is supposed clear it, or
> > the kernel in the case of module unload and shutdown followed by kexec.
> > 
> > Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> > Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> > ---
> >  arch/x86/include/asm/sev.h |  2 ++
> >  arch/x86/virt/svm/sev.c    | 23 ++++++++++++++++++++---
> >  2 files changed, 22 insertions(+), 3 deletions(-)
> 
> ...
> 
> > @@ -521,12 +524,26 @@ void snp_prepare_for_snp_init(void)
> >  	 * MtrrFixDramModEn is not shared between threads on a core,
> >  	 * therefore it must be set on all CPUs prior to enabling SNP.
> >  	 */
> > -	on_each_cpu(mfd_enable, NULL, 1);
> > +	on_each_cpu(mfd_reconfigure, (void *)1, 1);
> 				     ^^^^^^^^^
> ew.

:) I can add a macro for this. Let me know if you want a full args
struct instead.

> >  	on_each_cpu(snp_enable, NULL, 1);
> >  }
> >  EXPORT_SYMBOL_FOR_MODULES(snp_prepare_for_snp_init, "ccp");
> >  
> > +void snp_x86_shutdown(void)
> 
> "snp" and "x86" prefixes?

My intent here was to indicate that it's doing the x86 (i.e.
non-firmware) parts of the SNP shutdown process. I will change it to
just snp_shutdown(), but that will still have a prefix. Just
shutdown() seemed to generic...

Will fix the rest.

Thanks,

Tycho
