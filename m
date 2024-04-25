Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C469A15666A
	for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2024 22:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714083224; cv=none; b=oj+B51IgvM8F/Zk8OmEmbkZuESA1G0hxUzyikdyILuIrlrlSWu9J5jbg7nPWJ12C7roqqUuu1lDkPGU2mCUJm2dN+YArDp7cZLo6WVmK7Al2eE4LDi34ObH62cpEhyJqjJqNTg1ES53JwsTsBMoHEiSWVVkhbmtbaB4aPb7rQiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714083224; c=relaxed/simple;
	bh=cbz4VgLAc5b9NzezYzcfU9eqcXCaDYCWqPxj/avxGRE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R/vtnEzAOTgWm3TEvremrJIFRilKLP4uKDwUjdt+zO/gCrM3EslNXRG1y3SmT/t604FM84fmX6rG1wcOWy1vxI2z/NN8S0qvkwji7SyVHUlMdjIxUIy9sKUpQj3BVgeVg+Re3SC/Z38zXIFuLeBYUvI8mHPALhqyAPQKgiysWck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wa+ABr0d; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wa+ABr0d"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61892d91207so26662117b3.3
        for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2024 15:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714083222; x=1714688022; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VlD1vrF3NmiYyeEP9cJyDUHce3FgvPJuIrigqLvvs0A=;
        b=Wa+ABr0dRKy5uBBoTbIO69ZD9ZdW/I5+Br+SBV5Qwd1TDelcfwrliyUbeUIyVtkWTH
         RkvVjHudYYhXoUBXHgc5iXYgGUff8E/uER8cBzysOn5/qZvZ2YxV3mCiNTu48BhzieYO
         dT1ETzNlNvJfw66ykWkYpD6pRMuDDMKbglKy1AveR4oLEKdoU2jlBnBRmFFfxipkeexH
         Nu5C7FHKanQdO7/oRU8KoEs26sGphSffvt6mCAKYDBWSnn4f79YK0sHxEhRwtdtenYGP
         GWubh7jV6EpHPn/co0agZzK/acQgZgWNw2KqI4oEEUZuKK0JwJrhofUTTyuVir2QLRFx
         m7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714083222; x=1714688022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VlD1vrF3NmiYyeEP9cJyDUHce3FgvPJuIrigqLvvs0A=;
        b=cyCFXTpej4ZciSxY5mHfnLll4QynP2QuRlUSF0IV2biqnZOl3nb84eY128mWAC1nCO
         GUjl/B3ppOkZxwPTHbAn0JngvdSZJPD5VS3+rAZXK+nzZXSe95R97RU8/BS6aWncDjsG
         q/5/zEg+ofDR0nOAPbpOVYk9UiqbJapCU5BGFrGvpirFZkCEl2sh7TtP1nfjO7uZVZqF
         FV+qatJ6Cdh2TM3JhN5e08eNlhJg+KZB9JAjcvjkBvurtYyZ3Do02L9+EEjWYYm7CItI
         pJHHeDaOy2neu04cN6bzTwEOvXhqXA9PLp/Fo/sATzNrQY+1fMlKlgoa06+C+ymOk6C8
         9hqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzsTOx0tnjPMWZ5m9zYqQybNskVXu1b+A8ucm6MdgkL93ROiTlht56gAexdCW2T9gRHfmHswkgQ2SNRAoNWqWyV0BoboerUf34cvkG
X-Gm-Message-State: AOJu0Yyl94iufct2BZpzFeNaRzQVDLxRu9UZzH91XiF4is6G3JYyRvzB
	RRyMvYYqshDarT/tnQEoVsRREcgODQerHo9YIaipWapA5M/RId8cXp2c6PHAiXDnrsbgMmE5GKs
	EjQ==
X-Google-Smtp-Source: AGHT+IHzHjxcfIPYRO/0ZR+/PU18iR8U2AlUK3bDXYPmThs8oWF6MVloZCgQa8+8/V5cYRymgqjaTVn5F6o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a097:0:b0:61a:b41a:2ef5 with SMTP id
 x145-20020a81a097000000b0061ab41a2ef5mr194759ywg.10.1714083221862; Thu, 25
 Apr 2024 15:13:41 -0700 (PDT)
Date: Thu, 25 Apr 2024 15:13:40 -0700
In-Reply-To: <20240425220008.boxnurujlxbx62pg@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-10-michael.roth@amd.com> <ZilyxFnJvaWUJOkc@google.com>
 <20240425220008.boxnurujlxbx62pg@amd.com>
Message-ID: <ZirVlF-zQPNOOahU@google.com>
Subject: Re: [PATCH v14 09/22] KVM: SEV: Add support to handle MSR based Page
 State Change VMGEXIT
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 25, 2024, Michael Roth wrote:
> On Wed, Apr 24, 2024 at 01:59:48PM -0700, Sean Christopherson wrote:
> > On Sun, Apr 21, 2024, Michael Roth wrote:
> > > +static int snp_begin_psc_msr(struct kvm_vcpu *vcpu, u64 ghcb_msr)
> > > +{
> > > +	u64 gpa = gfn_to_gpa(GHCB_MSR_PSC_REQ_TO_GFN(ghcb_msr));
> > > +	u8 op = GHCB_MSR_PSC_REQ_TO_OP(ghcb_msr);
> > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > +
> > > +	if (op != SNP_PAGE_STATE_PRIVATE && op != SNP_PAGE_STATE_SHARED) {
> > > +		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
> > > +		return 1; /* resume guest */
> > > +	}
> > > +
> > > +	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
> > > +	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_PSC_MSR;
> > > +	vcpu->run->vmgexit.psc_msr.gpa = gpa;
> > > +	vcpu->run->vmgexit.psc_msr.op = op;
> > 
> > Argh, no.
> > 
> > This is the same crud that TDX tried to push[*].  Use KVM's existing user exits,
> > and extend as *needed*.  There is no good reason page state change requests need
> > *two* exit reasons.  The *only* thing KVM supports right now is private<=>shared
> > conversions, and that can be handled with either KVM_HC_MAP_GPA_RANGE or
> > KVM_EXIT_MEMORY_FAULT.
> > 
> > The non-MSR flavor can batch requests, but I'm willing to bet that the overwhelming
> > majority of requests are contiguous, i.e. can be combined into a range by KVM,
> > and that handling any outliers by performing multiple exits to userspace will
> > provide sufficient performance.
> 
> That does tend to be the case. We won't have as much granularity with
> the per-entry error codes, but KVM_SET_MEMORY_ATTRIBUTES would be
> expected to be for the entire range anyway, and if that fails for
> whatever reason then we KVM_BUG_ON() anyway. We do have to have handling
> for cases where the entries aren't contiguous however, which would
> involve multiple KVM_EXIT_HYPERCALLs until everything is satisfied. But
> not a huge deal since it doesn't seem to be a common case.

If it was less complex overall, I wouldn't be opposed to KVM marshalling everything
into a buffer, but I suspect it will be simpler to just have KVM loop until the
PSC request is complete.

> KVM_HC_MAP_GPA_RANGE seems like a nice option because we'd also have the
> flexibility to just issue that directly within a guest rather than
> relying on SNP/TDX specific hcalls. I don't know if that approach is
> practical for a real guest, but it could be useful for having re-usable
> guest code in KVM selftests that "just works" for all variants of
> SNP/TDX/sw-protected. (though we'd still want stuff that exercises
> SNP/TDX->KVM_HC_MAP_GPA_RANGE translation).
> 
> I think we'd there is some potential baggage there with the previous SEV
> live migration use cases. There's some potential that existing guest kernels
> will use it once it gets advertised and issue them alongside GHCB-based
> page-state changes. It might make sense to use one of the reserved bits
> to denote this flavor of KVM_HC_MAP_GPA_RANGE as being for
> hardware/software-protected VMs and not interchangeable with calls that
> were used for SEV live migration stuff.

I don't think I follow, what exactly wouldn't be interchangeable, and why?

> If this seems reasonable I'll give it a go and see what it looks like.
> 
> > 
> > And the non-MSR version that comes in later patch is a complete mess.  It kicks
> > the PSC out to userspace without *any* validation.  As I complained in the TDX
> > thread, that will create an unmaintable ABI for KVM.
> > 
> > KVM needs to have its own, well-defined ABI.  Splitting functionality between
> > KVM and userspace at seemingly random points is not maintainable.
> > 
> > E.g. if/when KVM supports UNSMASH, upgrading to the KVM would arguably break
> > userspace as PSC requests that previously exited would suddenly be handled by
> > KVM.  Maybe.  It's impossible to review this because there's no KVM ABI, KVM is
> > little more than a dumb pipe parroting information to userspace.
> 
> It leans on the GHCB spec to avoid re-inventing structs/documentation
> for things like Page State Change buffers, but do have some control
> as we want over how much we farm out versus lock into the KVM ABI. For
> instance the accompanying Documentation/ update mentions we only send a
> subset of GHCB requests that need to be handled by userspace, so we
> could handle SMASH/UNSMASH in KVM without breaking expectations (or if
> SMASH/UNSMASH were intermixed with PSCs, documentation that only PSC
> opcodes could be updated by userspace).
> 
> But I'm certainly not arguing it wouldn't be better to have a
> guest-agnostic alternative if we can reach an agreement on that, and
> KVM_HC_MAP_GPA_RANGE seems like it could work.

Yeah, I want to at least _try_ to achieve common ground, because the basic
functionality of all this stuff is the exact same.
