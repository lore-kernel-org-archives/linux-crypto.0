Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B785712C530
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 13:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715349529; cv=none; b=g7HRn3tONmQrguFjrHCO1BYOCWiIECl6Pam8amd5JzfTdtFoIZvEEzI9MWe6+0XJYmoZb7CBJ5ga1U/IXEUEryMhhDd/AT/QGpa1Amwc6jp6wtWek9dt7nkVOJqw274s/ABHt8n5X/YBJ/yYDrEY7rZ8iC+HfrNKhAavzhYFhMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715349529; c=relaxed/simple;
	bh=t5yuscA7V0vIg2QlP/euKvy8XW4fyaHEu5o/y1dtA+M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K8IXSxZjAxOgIV818l58FQ9k8qyp07Hq+D/CGRxRdr1ThgabgOFT+l/3StoseviLexGM43U6jhCCi8bi304oKFqn/dvZtFV9iU7HeMCi9YGxSMRjdnKU08pJ9qF8bW2V/vW3shJC2x/jLlqgk4dzua6qXDsTEPiowWFb7Sj/BaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hts1P/z4; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hts1P/z4"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de0b4063e59so1592254276.3
        for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 06:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715349527; x=1715954327; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zXb1tTtHZSnRGr8DHQ0sXsDcFePLXbMaowVFp+PbHiA=;
        b=hts1P/z4hp0PGXJYu6UawyrnlY9KuIO9XEUB2sK0/cv6drFCLt8ZPqwpU80xn3jlkb
         dtRzl3dFEKS7HQWIGIGgIiBR02Xf6jv57ZK5bEasGLvxy3x0MUlLzmbADpKbqwutmUf5
         nelQ5hjwTvbgBJAlTWYwwbmGIGEZReMxx3f4K67j1uT800ScnyVMeelWwKJk3EwMsEnn
         EG2WqP1TaSDMW1e8RCrUAKiOjqQxWFOrV3XKpvmX2jPovKWd6R5OPBSUrmKSGV+PtEbQ
         6cCa1nyRckBgaLBm26im5ZJy6uUK5JthiNx5UfgN0E4vMZ/SibV2setj0M6PrV2e9hXZ
         J8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715349527; x=1715954327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zXb1tTtHZSnRGr8DHQ0sXsDcFePLXbMaowVFp+PbHiA=;
        b=Ob+ik6Vp2jELgIgA+XACbMY6orV2Vn3ak2iJEzUzxjEcsNctGtAviSxkqaIq505scl
         6/EE5S5BzHH8DGyoJIkiI4o+br4ZQzp0slHMSEAykKERQ65fe9nk2BLaTnFjXd7bP8Qh
         iXfBXemNzrZayrgHNtmsE7uinNpnCPa2vHNIFrNjpRUCT0BCyfT0aJOTskCv61f61OJn
         XmJD6e52R0l4h8DxuCcnjL5iOI0hSjftKs/uK1V8WptMkqZ3zyEhYP7vdY0IHlaiWnGg
         iFdIVBMtwAMKVfjP4mIh+U5W/KKXrp2cJMHhUFCATm8p7Y753gYqihvDm+H4QRp4HeNQ
         LEKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxiOY9/IvlNHIpNwEGSGL/B36AZlx9abzB0yGGkHV8KNKv6aHnjG3HoR7ElA3UVS+C1nfc4j0mKbTFCWGibGJ6i7bcrySPDphV4CSa
X-Gm-Message-State: AOJu0Yxv35NCRJNJbuvTlRtuMRFbVuiMXvF2Ln0x1HwqymCmjSCf5mZv
	/E9f30XpIAV+xHxnVz1STf3ETul5dJ+8qTE2jX4w0CAtmc5QGl0ASumfPyujiUBhA4iWnvKLX4B
	tMg==
X-Google-Smtp-Source: AGHT+IGef3UtqI5teaXhSDky2PH9t9XWbnO9HU0F8LPXySNaeV0PQq0Qu57IKZM57LTb/VaFi/Mcd40zVdg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1002:b0:de5:9f2c:c17c with SMTP id
 3f1490d57ef6-dee4f37bbfbmr661252276.9.1715349526730; Fri, 10 May 2024
 06:58:46 -0700 (PDT)
Date: Fri, 10 May 2024 06:58:45 -0700
In-Reply-To: <20240510015822.503071-2-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com> <20240510015822.503071-2-michael.roth@amd.com>
Message-ID: <Zj4oFffc7OQivyV-@google.com>
Subject: Re: [PATCH v15 22/23] KVM: SEV: Fix return code interpretation for
 RMP nested page faults
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, May 09, 2024, Michael Roth wrote:
> The intended logic when handling #NPFs with the RMP bit set (31) is to
> first check to see if the #NPF requires a shared<->private transition
> and, if so, to go ahead and let the corresponding KVM_EXIT_MEMORY_FAULT
> get forwarded on to userspace before proceeding with any handling of
> other potential RMP fault conditions like needing to PSMASH the RMP
> entry/etc (which will be done later if the guest still re-faults after
> the KVM_EXIT_MEMORY_FAULT is processed by userspace).
> 
> The determination of whether any userspace handling of
> KVM_EXIT_MEMORY_FAULT is needed is done by interpreting the return code
> of kvm_mmu_page_fault(). However, the current code misinterprets the
> return code, expecting 0 to indicate a userspace exit rather than less
> than 0 (-EFAULT). This leads to the following unexpected behavior:
> 
>   - for KVM_EXIT_MEMORY_FAULTs resulting for implicit shared->private
>     conversions, warnings get printed from sev_handle_rmp_fault()
>     because it does not expect to be called for GPAs where
>     KVM_MEMORY_ATTRIBUTE_PRIVATE is not set. Standard linux guests don't
>     generally do this, but it is allowed and should be handled
>     similarly to private->shared conversions rather than triggering any
>     sort of warnings
> 
>   - if gmem support for 2MB folios is enabled (via currently out-of-tree
>     code), implicit shared<->private conversions will always result in
>     a PSMASH being attempted, even if it's not actually needed to
>     resolve the RMP fault. This doesn't cause any harm, but results in a
>     needless PSMASH and zapping of the sPTE
> 
> Resolve these issues by calling sev_handle_rmp_fault() only when
> kvm_mmu_page_fault()'s return code is greater than or equal to 0,
> indicating a KVM_MEMORY_EXIT_FAULT/-EFAULT isn't needed. While here,
> simplify the code slightly and fix up the associated comments for better
> clarity.
> 
> Fixes: ccc9d836c5c3 ("KVM: SEV: Add support to handle RMP nested page faults")
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 426ad49325d7..9431ce74c7d4 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2070,14 +2070,12 @@ static int npf_interception(struct kvm_vcpu *vcpu)
>  				svm->vmcb->control.insn_len);
>  
>  	/*
> -	 * rc == 0 indicates a userspace exit is needed to handle page
> -	 * transitions, so do that first before updating the RMP table.
> +	 * rc < 0 indicates a userspace exit may be needed to handle page
> +	 * attribute updates, so deal with that first before handling other
> +	 * potential RMP fault conditions.
>  	 */
> -	if (error_code & PFERR_GUEST_RMP_MASK) {
> -		if (rc == 0)
> -			return rc;
> +	if (rc >= 0 && error_code & PFERR_GUEST_RMP_MASK)

This isn't correct either.  A return of '0' also indiciates "exit to userspace",
it just doesn't happen with SNP because '0' is returned only when KVM attempts
emulation, and that too gets short-circuited by svm_check_emulate_instruction().

And I would honestly drop the comment, KVM's less-than-pleasant 1/0/-errno return
values overload is ubiquitous enough that it should be relatively self-explanatory.

Or if you prefer to keep a comment, drop the part that specifically calls out
attributes updates, because that incorrectly implies that's the _only_ reason
why KVM checks the return.  But my vote is to drop the comment, because it
essentially becomes "don't proceed to step 2 if step 1 failed", which kind of
makes the reader go "well, yeah".
