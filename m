Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A2D823BC
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 11:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713527904; cv=none; b=WYmg2Ghg1f4D72ML0EE7waFlnF0JIoPk7CXHQX9yXZcgdUsyXIQqBd7dWEVRUAECyJDyZ+H1qmCmJeR/DXYfKIumINrbB3MbW9NtnKlN5LiHDO8cMOw27M2szDvT+BLKq0uPNO2tyrRjYqf9kaU5/Lj7Yf3raIl8ETWn4OJFXxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713527904; c=relaxed/simple;
	bh=wBbLhac8QaUF0O5nwHjFjj5cUq+nWt4AMbemYENl12c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S6tURDDBB0dBgGmC08ETYkYfd4zo7VwP+Hx+TCpFIqRikCWRvbUIzXhzyCAdYf8WzoIudQHzY2OeI+4xP14v2tKwCdvOVah1VAXGXePUZhAZmYCC3jpc+sxPHP3kXnvqNZf5/Iqs/tcZeIpricF60TGhfcCPG8kp2//ANNP9Xvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Im8fOYFq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Im8fOYFq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713527901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CwxWxYK6yFiOYVQyI4AiRXsN6yKGGl+jXN1TxSL+A3k=;
	b=Im8fOYFqW2uQiH2FdGj/kjrDq2Ge2hlx5Dx7E39iy6PuRTw/2Qo51ARU8uly2F2galkwRp
	HVIctYB9Vl+ItXC0YQRPAZOTdDXhxfopDfyke/C3D3E/ESRKXjNptxp8lLMblluS6CXSWF
	JlFFSksRgrPBjPQ0CjrO9O3TIz4nH2U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-XSyMLkmbNWeQ1mLWnIk-DQ-1; Fri, 19 Apr 2024 07:58:20 -0400
X-MC-Unique: XSyMLkmbNWeQ1mLWnIk-DQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-343f08542f8so1321483f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 04:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713527899; x=1714132699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CwxWxYK6yFiOYVQyI4AiRXsN6yKGGl+jXN1TxSL+A3k=;
        b=u0O4uovmDsvFDaR+QFLiSiRKhEiTztce3P8a9c49zPUwcwGlfVaVydXrX67o9iecUh
         7S+gYwvb+o/OCZzVAz8E7VItjx0QI0tW9iwH4QK0dhXxfkhC2tm8dh4OYHlkr3lQdPaa
         NLD4xf1qKtKyB2itt+0FbrsktFJWuW4saBw4L+cHWfxEw8KoVSszUQqFt2bQAOk0sf7/
         r7iy4r6pn/wDiJbOKyBZ7gc1vchFU/ICBSVVgVDKwuZODEd+JeF3KNccd5q094O0/r0b
         +9mXem2/RhpdrqXeKJFP4NJrZ4DP3kcnhF7kEWYhGYShuVrxt667HHgYwUmdzbj8YkdC
         x+gQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHKY6TR/GbD3Yk5ayBQQ5HSIjDA3kUBqm+MsY4GaUqTsX6+o/vZKHlq6RgHhY8E1MGpbox9yeEZrDDrenNmdVD9mq/yhsI9k1ifg4h
X-Gm-Message-State: AOJu0YwKxTWb2u0r2F8ivpaVb8XSCrzGWKWm/UwneZ0Hg4bgge08BSKo
	akB+l3Kxemw1PphTiR3LM40TZeTUaQezxqssOJClIS5dsoxgE22auLyA7xbM92QpiexP5wnZYAJ
	FAy7IQsiJ6rPEPBaDkVKLAyK82AUqJpwmLwWIQg8icAnrQlg6qkL3iSuIBQHQwuevl7BcRcwVaf
	YaUkXjlRt4qMX2OGHOV90HiSExRHD4/vdUruMI
X-Received: by 2002:a5d:50d1:0:b0:33d:b376:8a07 with SMTP id f17-20020a5d50d1000000b0033db3768a07mr1167224wrt.8.1713527899433;
        Fri, 19 Apr 2024 04:58:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHM7xQDK90cgpkqMe8qHCL2Dpb0GVAovL4zmOZ8Y/f+iUHPX7N3URgMIDSP1Agr9DUXYvSVNpPPSl3w69ic80Y=
X-Received: by 2002:a5d:50d1:0:b0:33d:b376:8a07 with SMTP id
 f17-20020a5d50d1000000b0033db3768a07mr1167205wrt.8.1713527899035; Fri, 19 Apr
 2024 04:58:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418194133.1452059-1-michael.roth@amd.com> <20240418194133.1452059-9-michael.roth@amd.com>
In-Reply-To: <20240418194133.1452059-9-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Apr 2024 13:58:07 +0200
Message-ID: <CABgObfbNd2Z85o3Wb-yr5qYSWYTadxZGuh6PP=r-5dNpa06ErA@mail.gmail.com>
Subject: Re: [PATCH v13 08/26] KVM: SEV: Add initial SEV-SNP support
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
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024 at 9:51=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 535018f152a3..d31404953bf1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4899,7 +4899,8 @@ static int svm_vm_init(struct kvm *kvm)
>
>         if (type !=3D KVM_X86_DEFAULT_VM &&
>             type !=3D KVM_X86_SW_PROTECTED_VM) {
> -               kvm->arch.has_protected_state =3D (type =3D=3D KVM_X86_SE=
V_ES_VM);
> +               kvm->arch.has_protected_state =3D
> +                       (type =3D=3D KVM_X86_SEV_ES_VM || type =3D=3D KVM=
_X86_SNP_VM);

I'd rather set has_private_mem here too, rather than in x86.c

Also this patch is the place to have

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d31404953bf1..6209f70ab11a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2056,6 +2056,9 @@ static int npf_interception(struct kvm_vcpu *vcpu)
     if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
         error_code &=3D ~PFERR_SYNTHETIC_MASK;

+    if (sev_snp_guest(vcpu) && (error_code & PFERR_GUEST_ENC_MASK))
+        error_code |=3D PFERR_PRIVATE_ACCESS;
+
     trace_kvm_page_fault(vcpu, fault_address, error_code);
     return kvm_mmu_page_fault(vcpu, fault_address, error_code,
             static_cpu_has(X86_FEATURE_DECODEASSISTS) ?


for the final shape of the MMU changes.

Paolo

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83b8260443a3..9923921904a2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12598,7 +12598,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lo=
ng type)
>
>         kvm->arch.vm_type =3D type;
>         kvm->arch.has_private_mem =3D
> -               (type =3D=3D KVM_X86_SW_PROTECTED_VM);
> +               (type =3D=3D KVM_X86_SW_PROTECTED_VM || type =3D=3D KVM_X=
86_SNP_VM);
>
>         ret =3D kvm_page_track_init(kvm);
>         if (ret)
> --
> 2.25.1
>

