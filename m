Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85AE2575F
	for <linux-crypto@vger.kernel.org>; Mon, 12 Feb 2024 10:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707733903; cv=none; b=i3zhaiujTnHbOwxkruMciIx9FvAzz4Fkopm3+Ndq3V9/8BJILYODJ50Zq379OlbaUGzSq/AmcNXApc3f5+lnhCU9WdjB/nSqIlU66X9vCIZeEqPErwuALOUzpF4OOJ20q+LrSWygkga/YMnjPofoCQfcU5UGW7FmW8Ez0EhFYdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707733903; c=relaxed/simple;
	bh=czUfwp9Vd0O43dhgHlhoxm7n6b/o2RFsBWH5mKBRF/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VHgxQcLFpLB7rycIGyeYjdbVxjUR1DUp2/AMlpe7U3Ec0l2lm7dIy68wR9nkI96kapfZxy2IgwGc0FoUt22i9BWEqKbuVFTSGQnLVp4ZbvsjRA/mJNp0cAIqc4/7hVmnleNXDkwkfDZQ58d0ikZ6L5dQQBWdWFFuDsbo4piv4Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T1e6zcaX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1e6zcaX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707733901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1t318SRTxLpDaLWn2G/SymzKj/FNZHT6EAXxG8/aWeU=;
	b=T1e6zcaXAgJNSliltBE0yKqcVvrVpOxCET1og34UAjjYlj6AKG+LG/7XbFuRK3mQIJoT8K
	oogOyw6dn1idq+JZTX8q2ShiKLXjlRyObW1DlMevnjZQ7xzmffRhMB33PH2l5tQ5ztkcSG
	TdQ411BRSIoNpQvJSdi8kfc40Pi+Rlk=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-rCZyI7f9Nr6h9R5FEd2RZg-1; Mon, 12 Feb 2024 05:31:38 -0500
X-MC-Unique: rCZyI7f9Nr6h9R5FEd2RZg-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-46eb2bffbe7so117305137.2
        for <linux-crypto@vger.kernel.org>; Mon, 12 Feb 2024 02:31:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707733898; x=1708338698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1t318SRTxLpDaLWn2G/SymzKj/FNZHT6EAXxG8/aWeU=;
        b=PPHeRZEj3x4o6BUrLBCxg7aOwysmajXfgC5uiGOBYV7VGrGI5oo2UMHAFfyKKrd+vo
         zY0GdeIH8COSjDfOHf6YQ7Q3Ex5UJc33yH75Gn3eZgx0qfotVjiSce91t1I6FNuzHiP7
         afFbmc0jYCffUtytuI5F5nrl9bmDf7j1s85EqQCeYwo8oy36mVodP3or/Qct40AkGFZf
         WvJY3sf7KkuZecZWBHZxPwnmSP3I591DtuFdv0lfAIKxhECFI3YvUs8JTYDgOLBojbLv
         WNvHjhgca2WEDpDLB0Kyq9vM97lYbNw17qTmtQ3O60Ko0t1/LapdSeUXYYcArlYpUMbI
         9Wlw==
X-Forwarded-Encrypted: i=1; AJvYcCUrXaNKzxlfaw6efHx/MP76cf4ElDZPQr2NNfIC8n2U4uhCp75HnAiTQSFs10o3Laq92FdpZN2F1pIPvVDj40+AJL3x6G7hWh1e5BS2
X-Gm-Message-State: AOJu0Yy3Eak7ouGn3TvguGBQGuoiwCalMTVkR0Q5P+C8qxdJsuUSOhhq
	/IKOdL1d6I8Mgz3vBHHJiiDIa5JsKXH1dz+1Xdoekjmp4s6zRGEHJ7Y+JAa8xUBkT0EOvVck98u
	oCCHC7yNW717cfgX+zFF6Iub4QLKbN/DO/qV7J3o0XdBJpoTfSPDSVhm4KC+Ce3yuUTeBUKEdAk
	Bn4Mxp/i5khZdbTz0Zu5h1OSq/Vrjp7hn7pOAD
X-Received: by 2002:a05:6102:3161:b0:46d:240d:438c with SMTP id l1-20020a056102316100b0046d240d438cmr4076014vsm.27.1707733898453;
        Mon, 12 Feb 2024 02:31:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAYvRS4noCaEKl+zyb53gqyWRKi4M0jr6v0+jz+XbYaddB3PAXdhrXxq0wDIZfyRz3n9CnF4Xr88Nf35iyEnE=
X-Received: by 2002:a05:6102:3161:b0:46d:240d:438c with SMTP id
 l1-20020a056102316100b0046d240d438cmr4076001vsm.27.1707733898047; Mon, 12 Feb
 2024 02:31:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-10-michael.roth@amd.com>
In-Reply-To: <20231230172351.574091-10-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Feb 2024 11:31:26 +0100
Message-ID: <CABgObfanrHTL429Cr8tcMGqs-Ov+6LWeQbzghvjQiGu9tz0EUA@mail.gmail.com>
Subject: Re: [PATCH v11 09/35] KVM: x86: Determine shared/private faults based
 on vm_type
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 6:24=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> For KVM_X86_SNP_VM, only the PFERR_GUEST_ENC_MASK flag is needed to
> determine with an #NPF is due to a private/shared access by the guest.
> Implement that handling here. Also add handling needed to deal with
> SNP guests which in some cases will make MMIO accesses with the
> encryption bit.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 12 ++++++++++--
>  arch/x86/kvm/mmu/mmu_internal.h | 20 +++++++++++++++++++-
>  2 files changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d3fbfe0686a0..61213f6648a1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4331,6 +4331,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu =
*vcpu,
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_faul=
t *fault)
>  {
>         struct kvm_memory_slot *slot =3D fault->slot;
> +       bool private_fault =3D fault->is_private;

I think it's nicer to just make the fault !is_private in
kvm_mmu_do_page_fault().

> +static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err=
)
> +{
> +       bool private_fault =3D false;
> +
> +       if (kvm_is_vm_type(kvm, KVM_X86_SNP_VM)) {
> +               private_fault =3D !!(err & PFERR_GUEST_ENC_MASK);
> +       } else if (kvm_is_vm_type(kvm, KVM_X86_SW_PROTECTED_VM)) {
> +               /*
> +                * This handling is for gmem self-tests and guests that t=
reat
> +                * userspace as the authority on whether a fault should b=
e
> +                * private or not.
> +                */
> +               private_fault =3D kvm_mem_is_private(kvm, gpa >> PAGE_SHI=
FT);
> +       }

Any reason to remove the is_private page fault that was there in
previous versions of the patch?  I don't really like having both TDX
and SVM-specific code in this function.

Paolo

> +       return private_fault;
> +}
> +
>  /*
>   * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_pag=
e_fault(),
>   * and of course kvm_mmu_do_page_fault().
> @@ -298,7 +316,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vc=
pu *vcpu, gpa_t cr2_or_gpa,
>                 .max_level =3D KVM_MAX_HUGEPAGE_LEVEL,
>                 .req_level =3D PG_LEVEL_4K,
>                 .goal_level =3D PG_LEVEL_4K,
> -               .is_private =3D kvm_mem_is_private(vcpu->kvm, cr2_or_gpa =
>> PAGE_SHIFT),
> +               .is_private =3D kvm_mmu_fault_is_private(vcpu->kvm, cr2_o=
r_gpa, err),
>         };
>         int r;
>
> --
> 2.25.1
>

