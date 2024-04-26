Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0C722EF8
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 20:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714162476; cv=none; b=qXnhpysVH0iVjbT87mevtYbpc4iekSi8fOmnaIrTsSAc3Gr/9SJMrXglrVRa1T3ZJf8omBoDxa/WotMxX5K77r0jMu/r/ObbQU/n3zM7U6IpcC5Z7KM6//q7YhMXXo9H321CNIIzUJPPl/c+ImkKppTUprt+uhtSyOXAsct7Qro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714162476; c=relaxed/simple;
	bh=Z2Hmk9m0Llx/IUQH/S7TpxHTL0emnGLH/LAZ4N5+s1c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ojCJeZQpCyO/d5ADhyzfhpbmK6G7wn9hnM7SkDISznjaUJkeMugZBsY2e0dYhcGkKajtDuyt4QiyYZSK8HF8BHb4dkqroV2LBn05zNa+nFyEHXFPWn/0WC7y04BnlLcB7KO4osadYtoUvY4hRFb9JWi5yVBZJqJ+yJe0FK+hm4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mdB8yNO5; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mdB8yNO5"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e604136b6dso22671285ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 13:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714162474; x=1714767274; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p6QNNeN/iKbfPmZLz+NRuv/dqoduuTvyudHMEjnn2zM=;
        b=mdB8yNO5CKZoFfpuHGsyAXXxlHmhbGvcBuxKSId/PUs/VSVC47LQQsRqiR37a/zCmn
         0RuraAUYS595hgXjw5eCK43FHfXcyVMeobuKz2YO/HQCwY1UfCACZNLDMg04uuUE2swp
         qQHRwvdfvSqA4ZfwWGpjO2DcM9vZ8tKcgFGi6J85lF1bqr5SRg6a/+PJTo51YRyC28Yn
         KGm7/quFaVQzWLNU/61vsO8kIrnptf7fY9K7YqIQivCt+roiT4nKafn3i8+7RMZaEOTi
         OoeXU251K9RNQxo3QvGxSAVMm36yakj+efhidMsI9qp0AFyvlHVFRxqJKbYN2rzBxmc6
         657w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714162474; x=1714767274;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p6QNNeN/iKbfPmZLz+NRuv/dqoduuTvyudHMEjnn2zM=;
        b=rxtD0WSxd8O0s65XV82p/uPQymDIA+tu/x5z6mp15UiA/ZdBQ6nro5R85Nqt6X5Ykk
         vaRj/ZUhXqfBbpassb5Y5ruFSquDU8AzCrvd852ZPaD3Y31Usabq6xu5rdhya9Z4auxS
         RXnxpRW3tPHea6MXX31GhbkwgYN0gp9Hx2iF+CweDrILeND/LySH6zGAx+3WdCSMRMmJ
         0PLTMxPWIFbaYtVX1RL7I2RWDPFYxmYYYx5ITFSzhDOGUjj6dOEpz9o2cJ5pfNrrn4mx
         Uv8sU9718fGCMVbZASU8/qa/N2Q4aZAQWcpc1jDHYOfBgY/FyJSv4g4QfK+68HMhipuf
         hs3A==
X-Forwarded-Encrypted: i=1; AJvYcCXSvXobxkP1Kzn1DG7eMrtdE3kxkZqdMnLD/cr9y+M8aNM5/K8NJ1AdtCpzwTRm3s/EQKLCaOfue0ESxKbFKXF0L0s0WzWxK5P2twmL
X-Gm-Message-State: AOJu0YxpeEBLrk3HwkkM7AcGTEnvzJaEDPW8NLPQ8nzwJSeC3hB1WLHW
	frO+1f3kOsAQHUmNXL1tWTc8zIfK8UGe55OpzOgwUiY958wariH/r7vLrHFFrMhzyTlux027/Sk
	TFg==
X-Google-Smtp-Source: AGHT+IHm+XgF6B2SsiuKWzSl3HesgNNUnTRITMzai0EsO8nj/1UyX71FX031Lz6TZHENt4ygoNWm2wDt2xQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:124a:b0:1e2:8bce:b334 with SMTP id
 u10-20020a170903124a00b001e28bceb334mr11581plh.9.1714162473746; Fri, 26 Apr
 2024 13:14:33 -0700 (PDT)
Date: Fri, 26 Apr 2024 13:14:32 -0700
In-Reply-To: <20240426171644.r6dvvfvduzvlrv5c@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-10-michael.roth@amd.com> <ZilyxFnJvaWUJOkc@google.com>
 <20240425220008.boxnurujlxbx62pg@amd.com> <ZirVlF-zQPNOOahU@google.com> <20240426171644.r6dvvfvduzvlrv5c@amd.com>
Message-ID: <ZiwLKI_xtZk3BG_B@google.com>
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

On Fri, Apr 26, 2024, Michael Roth wrote:
> On Thu, Apr 25, 2024 at 03:13:40PM -0700, Sean Christopherson wrote:
> > On Thu, Apr 25, 2024, Michael Roth wrote:
> > > On Wed, Apr 24, 2024 at 01:59:48PM -0700, Sean Christopherson wrote:
> > > > On Sun, Apr 21, 2024, Michael Roth wrote:
> > > > > +static int snp_begin_psc_msr(struct kvm_vcpu *vcpu, u64 ghcb_msr)
> > > > > +{
> > > > > +	u64 gpa = gfn_to_gpa(GHCB_MSR_PSC_REQ_TO_GFN(ghcb_msr));
> > > > > +	u8 op = GHCB_MSR_PSC_REQ_TO_OP(ghcb_msr);
> > > > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > > > +
> > > > > +	if (op != SNP_PAGE_STATE_PRIVATE && op != SNP_PAGE_STATE_SHARED) {
> > > > > +		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
> > > > > +		return 1; /* resume guest */
> > > > > +	}
> > > > > +
> > > > > +	vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
> > > > > +	vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_PSC_MSR;
> > > > > +	vcpu->run->vmgexit.psc_msr.gpa = gpa;
> > > > > +	vcpu->run->vmgexit.psc_msr.op = op;
> > > > 
> > > > Argh, no.
> > > > 
> > > > This is the same crud that TDX tried to push[*].  Use KVM's existing user exits,
> > > > and extend as *needed*.  There is no good reason page state change requests need
> > > > *two* exit reasons.  The *only* thing KVM supports right now is private<=>shared
> > > > conversions, and that can be handled with either KVM_HC_MAP_GPA_RANGE or
> > > > KVM_EXIT_MEMORY_FAULT.
> > > > 
> > > > The non-MSR flavor can batch requests, but I'm willing to bet that the overwhelming
> > > > majority of requests are contiguous, i.e. can be combined into a range by KVM,
> > > > and that handling any outliers by performing multiple exits to userspace will
> > > > provide sufficient performance.
> > > 
> > > That does tend to be the case. We won't have as much granularity with
> > > the per-entry error codes, but KVM_SET_MEMORY_ATTRIBUTES would be
> > > expected to be for the entire range anyway, and if that fails for
> > > whatever reason then we KVM_BUG_ON() anyway. We do have to have handling
> > > for cases where the entries aren't contiguous however, which would
> > > involve multiple KVM_EXIT_HYPERCALLs until everything is satisfied. But
> > > not a huge deal since it doesn't seem to be a common case.
> > 
> > If it was less complex overall, I wouldn't be opposed to KVM marshalling everything
> > into a buffer, but I suspect it will be simpler to just have KVM loop until the
> > PSC request is complete.
> 
> Agreed. But *if* we decided to introduce a buffer, where would you
> suggest adding it? The kvm_run union fields are set to 256 bytes, and
> we'd need close to 4K to handle a full GHCB PSC buffer in 1 go. Would
> additional storage at the end of struct kvm_run be acceptable?

Don't even need more memory, just use vcpu->arch.pio_data, which is always
allocated and is mmap()able by userspace via KVM_PIO_PAGE_OFFSET.

> > > KVM_HC_MAP_GPA_RANGE seems like a nice option because we'd also have the
> > > flexibility to just issue that directly within a guest rather than
> > > relying on SNP/TDX specific hcalls. I don't know if that approach is
> > > practical for a real guest, but it could be useful for having re-usable
> > > guest code in KVM selftests that "just works" for all variants of
> > > SNP/TDX/sw-protected. (though we'd still want stuff that exercises
> > > SNP/TDX->KVM_HC_MAP_GPA_RANGE translation).
> > > 
> > > I think we'd there is some potential baggage there with the previous SEV
> > > live migration use cases. There's some potential that existing guest kernels
> > > will use it once it gets advertised and issue them alongside GHCB-based
> > > page-state changes. It might make sense to use one of the reserved bits
> > > to denote this flavor of KVM_HC_MAP_GPA_RANGE as being for
> > > hardware/software-protected VMs and not interchangeable with calls that
> > > were used for SEV live migration stuff.
> > 
> > I don't think I follow, what exactly wouldn't be interchangeable, and why?
> 
> For instance, if KVM_FEATURE_MIGRATION_CONTROL is advertised, then when
> amd_enc_status_change_finish() is triggered as a result of
> set_memory_encrypted(), we'd see
> 
>   1) a GHCB PSC for SNP, which will get forwarded to userspace via
>      KVM_HC_MAP_GPA_RANGE
>   2) KVM_HC_MAP_GPA_RANGE issued directly by the guest.
> 
> In that case, we'd be duplicating PSCs but it wouldn't necessarily hurt
> anything. But ideally we'd be able to distinguish the 2 cases so we
> could rightly treat 1) as only being expected for SNP, and 2) as only
> being expected for SEV/SEV-ES.

Why would the guest issue both?  That's a guest bug.  Or if supressing the second
hypercall is an issue, simply don't enumerate MIGRATION_CONTROL for SNP guests.
