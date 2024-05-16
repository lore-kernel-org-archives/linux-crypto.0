Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8498C156F22
	for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 17:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715880233; cv=none; b=eTrPHIFsXM9mdbFgqJuVw2SRW6hNVj9PAtXGYRYV9Cyv8An9ugeGvHQepObd1xK5DiC29pojeFdw2N1A2CQDKL8KHr7sx79LCxo1K5lTPFoCAlkKUlOY0qezxGqQpLHRXGLcNKgGapkZ0zPNLvPs7uEb0j2EW9ReezwyGEa2n00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715880233; c=relaxed/simple;
	bh=HMh7HuasJa24BhZCwWokjmjfgzo6MrZ9NA4F5skwANU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l7ieBd6pjIQwWordstG0+H+LqF0kUWrU7q9lBLtFve7cq4/hB2TFM4yhec74/boQ/WfDchabgvczdIXolOqhT7cYXcZymjDZgvqhU0DPw1hawjtPb/SYL83qn7txGdYp5iK+sRV9XQaxn2QHatH7qlO7Si8S1MHdV4X0jRL1psk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NKhWMF4n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NKhWMF4n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715880230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=19E7GPCN1ivTDhWTuCbZE7KnAa8A5iElKF7+ifU05tY=;
	b=NKhWMF4nw42o4kzrADMRjLnJH6EC4oZTBjhB4awxUyZGALktlflffhzdjNevuQbiw2sKy9
	Th28oT7K2H6cwo06OELFOL9ZQiUtFkmBMg75Pv1RE1rQ4FJziAKPC49TIOZiJddVlndItz
	OgSfFHDjzk2XuoaBm0Yi/VX0WYYxuOU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-9naiIyVLM_K8sYzZFxB2HA-1; Thu, 16 May 2024 13:23:49 -0400
X-MC-Unique: 9naiIyVLM_K8sYzZFxB2HA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-34f1b148725so3726378f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 10:23:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715880228; x=1716485028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=19E7GPCN1ivTDhWTuCbZE7KnAa8A5iElKF7+ifU05tY=;
        b=eHBLIVqgFNl20ecIH2KvV6Y8dA+XD7HReiLDvvV/1tPbTaIVodq2gL3KNwkaSNR51l
         5z34yW47x5XM2tTjhTliYI9+KoPm9vTsaHCG57ajt0P/3RKzRELBaqtC6QXiyUxufevi
         YJuzn0iITtlvbCmf9D2dIEUOfRN/nSR88y0ubTuzhIPAtc2ljxpOMO35JRQProMLuM6H
         ccHwW1BH4a1klrv6Qus5veDfQ5vQhI0uoiTg1tCy+7EKjbxrPUXhxDlPPOFd0g3OnrYx
         2LB5ObToL1LBvQ3ehfewMQ9gJMUmy6/McLzoIbzg/HmQXec9LbptWBruvS2rusoC6iw7
         d4qw==
X-Forwarded-Encrypted: i=1; AJvYcCULoAdAWgdbz87cGTKcYYZUUN8JA+5/m4rrBVOQKM9MgDrn7XYBvYCCp+UglfksbnKDJmVkHQs32VJIkwZDWqOh3JEzzPSCDRAfSbWD
X-Gm-Message-State: AOJu0YzmPHnLdvd85H2M8/vMR7HInUtSxnTiwk0QclqLuXCO/q+J91ID
	y2BwDG4xn1Lyh5Fl2xSsjP43Gg/D1rW/HfZFrJvkwG1GHpfqqNJFJi/x2K/FBNap9qPj5oSlfTG
	Vo1+oDGTzJzRikSQwbrkKr8idq+uf78xxjyVpOlnDY9t9cVILt+r8wc+uBBIUH0PlJit2G+TcdP
	Gsz/jszEXoXk1VjO3vng0Bo1jaedVmOxmXx12V
X-Received: by 2002:adf:ff92:0:b0:34c:9b4d:a7ee with SMTP id ffacd0b85a97d-3504aa66822mr15744045f8f.67.1715880228124;
        Thu, 16 May 2024 10:23:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTVOF6tCwOyYT/m1XvAI/L4WEGf+ijDm6MmFZ5m37aa8PPPlxqPrapghhXVBONg9RhqurSX3MAN+Jlfejb4GQ=
X-Received: by 2002:adf:ff92:0:b0:34c:9b4d:a7ee with SMTP id
 ffacd0b85a97d-3504aa66822mr15744026f8f.67.1715880227699; Thu, 16 May 2024
 10:23:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-10-michael.roth@amd.com> <84e8460d-f8e7-46d7-a274-90ea7aec2203@linux.intel.com>
In-Reply-To: <84e8460d-f8e7-46d7-a274-90ea7aec2203@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 16 May 2024 19:23:35 +0200
Message-ID: <CABgObfaXmMUYHEuK+D+2E9pybKMJqGZsKB033X1aOSQHSEqqVA@mail.gmail.com>
Subject: Re: [PATCH v15 09/20] KVM: SEV: Add support to handle MSR based Page
 State Change VMGEXIT
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	seanjc@google.com, vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024 at 10:29=E2=80=AFAM Binbin Wu <binbin.wu@linux.intel.c=
om> wrote:
>
>
>
> On 5/1/2024 4:51 PM, Michael Roth wrote:
> > SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
> > table to be private or shared using the Page State Change MSR protocol
> > as defined in the GHCB specification.
> >
> > When using gmem, private/shared memory is allocated through separate
> > pools, and KVM relies on userspace issuing a KVM_SET_MEMORY_ATTRIBUTES
> > KVM ioctl to tell the KVM MMU whether or not a particular GFN should be
> > backed by private memory or not.
> >
> > Forward these page state change requests to userspace so that it can
> > issue the expected KVM ioctls. The KVM MMU will handle updating the RMP
> > entries when it is ready to map a private page into a guest.
> >
> > Use the existing KVM_HC_MAP_GPA_RANGE hypercall format to deliver these
> > requests to userspace via KVM_EXIT_HYPERCALL.
> >
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > Co-developed-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >   arch/x86/include/asm/sev-common.h |  6 ++++
> >   arch/x86/kvm/svm/sev.c            | 48 ++++++++++++++++++++++++++++++=
+
> >   2 files changed, 54 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/s=
ev-common.h
> > index 1006bfffe07a..6d68db812de1 100644
> > --- a/arch/x86/include/asm/sev-common.h
> > +++ b/arch/x86/include/asm/sev-common.h
> > @@ -101,11 +101,17 @@ enum psc_op {
> >       /* GHCBData[11:0] */                            \
> >       GHCB_MSR_PSC_REQ)
> >
> > +#define GHCB_MSR_PSC_REQ_TO_GFN(msr) (((msr) & GENMASK_ULL(51, 12)) >>=
 12)
> > +#define GHCB_MSR_PSC_REQ_TO_OP(msr) (((msr) & GENMASK_ULL(55, 52)) >> =
52)
> > +
> >   #define GHCB_MSR_PSC_RESP           0x015
> >   #define GHCB_MSR_PSC_RESP_VAL(val)                  \
> >       /* GHCBData[63:32] */                           \
> >       (((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
> >
> > +/* Set highest bit as a generic error response */
> > +#define GHCB_MSR_PSC_RESP_ERROR (BIT_ULL(63) | GHCB_MSR_PSC_RESP)
> > +
> >   /* GHCB Hypervisor Feature Request/Response */
> >   #define GHCB_MSR_HV_FT_REQ          0x080
> >   #define GHCB_MSR_HV_FT_RESP         0x081
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index e1ac5af4cb74..720775c9d0b8 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3461,6 +3461,48 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u=
64 value)
> >       svm->vmcb->control.ghcb_gpa =3D value;
> >   }
> >
> > +static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
> > +{
> > +     struct vcpu_svm *svm =3D to_svm(vcpu);
> > +
> > +     if (vcpu->run->hypercall.ret)
>
> Do we have definition of ret? I didn't find clear documentation about it.
> According to the code, 0 means succssful. Is there any other error codes
> need to or can be interpreted?

They are defined in include/uapi/linux/kvm_para.h

#define KVM_ENOSYS        1000
#define KVM_EFAULT        EFAULT /* 14 */
#define KVM_EINVAL        EINVAL /* 22 */
#define KVM_E2BIG        E2BIG /* 7 */
#define KVM_EPERM        EPERM /* 1*/
#define KVM_EOPNOTSUPP        95

Linux however does not expect the hypercall to fail for SEV/SEV-ES; and
it will terminate the guest if the PSC operation fails for SEV-SNP.  So
it's best for userspace if the hypercall always succeeds. :)

> For TDX, it may also want to use KVM_HC_MAP_GPA_RANGE hypercall  to
> userspace via KVM_EXIT_HYPERCALL.

Yes, definitely.

Paolo

