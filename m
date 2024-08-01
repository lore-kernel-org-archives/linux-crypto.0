Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F12714265C
	for <linux-crypto@vger.kernel.org>; Thu,  1 Aug 2024 18:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722536140; cv=none; b=YxGIm42DP0ILQrfCaROjap36RGnepj6qcV2FaXZRFiGOLcCr6B29o0TWfQPHF7Ng3Lao6LOYvglEHoKhwqnWM28U7sTj/02u979J9sWMFtx/7OQGMLcjFW5nhhNZMIh/6eUkSvjPZyQ6WxbQ92d0AgWnvy09VdWm3ruqeRB7y1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722536140; c=relaxed/simple;
	bh=SUfyZKUo0IFCp9KDhlQwd3l6b/z5WFA0jaDZUeAQ/tg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TyJHyY4d4Q/dbbOeRwu/OqDPVQIt155FZLAC+Kdy0y0nnKIl2E/KB+msglyETP2uGXu9nuN4EX5ITHxDVlBVEplUdHgm7FtczOHtv9fpHEPUHE00pP5I0YDOdmkh2iZa9/MaODSugIwQ673TqrVstYWVbWjF+8ZeYcCjy8W/834=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FRyqCXED; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FRyqCXED"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722536138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UaZOROEvjpdbqu1dopLC2Lkrj6Dr9/VPZUA+DhTI8M4=;
	b=FRyqCXED3g4TlgEg3hUZE1QCOsfddKzdRZ04Ep79zo/pCyYmE9wTgI7PWu14lEW5pg/UDi
	ixuZf+6Hr0M620wPFZJU71WV5oF92ZG3aYStlPIgQsGIbsh+fus10adx7npG8K5RCrVgHZ
	nU2W1I4tZzscMe86gun58HCikRsENAM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-xfhNG_qOMRqUPmIhNMLqoQ-1; Thu, 01 Aug 2024 14:15:36 -0400
X-MC-Unique: xfhNG_qOMRqUPmIhNMLqoQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52eff5a4faaso8897753e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 01 Aug 2024 11:15:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722536135; x=1723140935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UaZOROEvjpdbqu1dopLC2Lkrj6Dr9/VPZUA+DhTI8M4=;
        b=okKV/HGwSHhCpZW5NbYnRqxaB3iLms3CAjerYHJx+TxwbXyxx64ZHpPYPC9SwwrCeI
         R7+hQeoJwV0c24+x+Kvv4GzikQCkJAhAS8MEVMbMeGEYkq4pp8meiyjGVxw0mQhTsE+h
         1W9E4phBE5WDFhrD+6pBETklvtWxHgZFiFWEO2fYo2XasnlWjWxLumLOkRXgEWvCS8Ui
         0et6o1MYGDzJ/drCmBz10JhGEpqJw/eVDMis/cp3zVTyQKfwaNHSNXF7NhZDGHfiZURU
         Z9VFjv2nGgId/lAZR2Hrz19mg1jrJyNty+JdydjEeRMyIgtw6jh9Ooq7SHch04f9okwc
         IBhw==
X-Forwarded-Encrypted: i=1; AJvYcCX0U3UrBblvIdBr9HPt1It2WBjCchoEIkaEdJzNRUeOoy5pmrHElax17ORauTWp8ufKMgz3WisP185JhJw0wP1zUHMOiyV3sNQcbs/t
X-Gm-Message-State: AOJu0Yw6/zgV2G0LHuyh7Q4JyZj9AbwNlrDkkNulodHaLau0+pUUonJz
	mqwQmZlz0eqLXX06aQgPksW+nRKPuTmMzg7eTYUyRXjP/j4hRan2Gz4dWvgj/ZrMry6Q9J7ll5d
	BaPD/zQSXbtO4AO5tHHSkyGuj8EqOmCbdubiLfz6rg0xPOslHxup1nyMfxCMBi39QW4XxoMRIxB
	wshclCtVvLLLtdfyukKgAeipV1+Yt1SaH38B/6
X-Received: by 2002:a2e:874b:0:b0:2ef:29b7:18a7 with SMTP id 38308e7fff4ca-2f15ab0c224mr8026951fa.37.1722536134883;
        Thu, 01 Aug 2024 11:15:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEW/QthBnS2n2JpnEiBTz7UDN3Rn0ZpSHt4zKv0qUnmJfmwCaik8m91bLxVWR1bJoJl2RmwJ89dnkiDtZdyq7c=
X-Received: by 2002:a2e:874b:0:b0:2ef:29b7:18a7 with SMTP id
 38308e7fff4ca-2f15ab0c224mr8026601fa.37.1722536134319; Thu, 01 Aug 2024
 11:15:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501085210.2213060-3-michael.roth@amd.com> <20240801173955.1975034-1-ackerleytng@google.com>
In-Reply-To: <20240801173955.1975034-1-ackerleytng@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 1 Aug 2024 20:15:22 +0200
Message-ID: <CABgObfZbS7LsKM_w2ZSpb82oBAHF=pJfVJ+45k7=vVVWHK5Y6A@mail.gmail.com>
Subject: Re: [PATCH] Fixes: f32fb32820b1 ("KVM: x86: Add hook for determining
 max NPT mapping level")
To: Ackerley Tng <ackerleytng@google.com>
Cc: michael.roth@amd.com, ak@linux.intel.com, alpergun@google.com, 
	ardb@kernel.org, ashish.kalra@amd.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, dovmurik@linux.ibm.com, hpa@zytor.com, 
	jarkko@kernel.org, jmattson@google.com, vannapurve@google.com, 
	erdemaktas@google.com, jroedel@suse.de, kirill@shutemov.name, 
	kvm@vger.kernel.org, liam.merwick@oracle.com, linux-coco@lists.linux.dev, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com, 
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com, peterz@infradead.org, 
	pgonda@google.com, rientjes@google.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, seanjc@google.com, slp@redhat.com, 
	srinivas.pandruvada@linux.intel.com, tglx@linutronix.de, 
	thomas.lendacky@amd.com, tobin@ibm.com, tony.luck@intel.com, vbabka@suse.cz, 
	vkuznets@redhat.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 7:40=E2=80=AFPM Ackerley Tng <ackerleytng@google.com=
> wrote:
>
> The `if (req_max_level)` test was meant ignore req_max_level if
> PG_LEVEL_NONE was returned. Hence, this function should return
> max_level instead of the ignored req_max_level.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Change-Id: I403898aacc379ed98ba5caa41c9f1c52f277adc2

It's worth pointing out that this is only a latent issue for now,
since guest_memfd does not support large pages ( __kvm_gmem_get_pfn
always returns 0).

Queued with a small note in the commit message and fixed subject.

Thanks,

Paolo


> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 901be9e420a4..e6b73774645d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4335,7 +4335,7 @@ static u8 kvm_max_private_mapping_level(struct kvm =
*kvm, kvm_pfn_t pfn,
>         if (req_max_level)
>                 max_level =3D min(max_level, req_max_level);
>
> -       return req_max_level;
> +       return max_level;
>  }
>
>  static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
> --
> 2.46.0.rc2.264.g509ed76dc8-goog
>

