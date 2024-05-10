Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D60B12C488
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 13:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715349043; cv=none; b=WL6HygN5cT+qPSvUZqZnacdUQgS/75cUeamqFcq4BqJKNG2+QmoM2lo1h7yTtr5mzklp7v4p8bMNrC6lNc1Zyz0NA2beF0qgRKD3H3jebN5zPtMbTsYMT5ezWyAaO54eUlgoqxcDQBm2y+Qw4Qnt53GuWWQzY76WwuMC6dHoPJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715349043; c=relaxed/simple;
	bh=I7z5nYT1NGtQi+9Q7VZZIxP3Ystgb6nUWLm9idhStWw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TTF2XE8nW5ivutEK8hDbKx0vXkqNEzVbjGTxK5QZDuzHFu+bLTNIsx5D1s1SxBkr4lyeAOMlvwgBiINnJ2MDiKdGEzT7NAyNsezMXWclTtKiXmOcPZKAFnXYn8b8VLL7h1FZHQEuvwSRhjZtlkWDzNmITYGD4twi/YI+SkV0ZpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RfdWIkN3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RfdWIkN3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715349041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pzf9kZEryhnm+5290e4qBYeBBj+VU2djvO6AxGd9L7w=;
	b=RfdWIkN3VJkyeoi/fjRKbE3gcA3DhsSOBEJJj9kQ0HB4Dr8taEMxdBs2g/9jpUwxIkkIug
	E8CDXESGdx+1o5gDNjVRedQFDzZi/iKA+68NUAgrY92ze5J7t20kHg04XDZrEuAd6ZMLxl
	m/KPUixkfR86Jlf7sX4O69qNVxcz1eE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-tcTGw1QBNnKhCYI0pkzdcg-1; Fri, 10 May 2024 09:50:40 -0400
X-MC-Unique: tcTGw1QBNnKhCYI0pkzdcg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-34d7861a1f4so1089615f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 06:50:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715349039; x=1715953839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pzf9kZEryhnm+5290e4qBYeBBj+VU2djvO6AxGd9L7w=;
        b=L+Wlkmp7NSeja8oit68Yfltm/c13HGZeJFRjxw0eMjfLOpw0rLEDbCflU9LaIwLi93
         qYVeHcM1JtpHHyjHjBlnHjTPcaXzs3DPp8Iw6OtQMDZoHlAhP4WAeXeevKoVmMX9oXlQ
         yHxgPVzDJfPCIJ84xgTxBTods1mbhfH31QVMXhyboF7ZYvdgWM56yMt32I4xxia++Q3V
         +oVtllaRCEyw0wYN34RTXpudSMP3ffnPkU2JvH4Ne3HpyJU+kVO4Sf2PJnC6vaE1d5wD
         izaHc8bdpDIimCYSnpr+M9lAQlQUZlAFQJBNQmMDp+R9BvN8wC0NOV174uwAvwZXZt3E
         47Ig==
X-Forwarded-Encrypted: i=1; AJvYcCV0Td/YJZTY7qVQMf96SE1IcMjemrB9VC3Ja3l8mPjDrpEzZYJrAMcH2r6w9xObyHVpBxxise149mr5QSHAxmVHaUcBDF1SYLRPWh2w
X-Gm-Message-State: AOJu0YzIESYuGyB94K51fECcpGJkbEispj4/UgXeoxNlstuYX/QAzzv6
	pNblyE4odl3qu87MGD1EcX7BeivkCzN5XItnhVBiUEaLTUnDLltLSQEwV9kh4NAAvWyDYedGhD1
	B/i1VTjCpCV5kq01txP+bLjs8I6gJLasZ6Hb3Brv2P9qehLyGcSy2q9vSCCAzMQUG1kL99hjsHV
	IVgxgIR5+uYgLBX7PlLBZDtWFAV5tAR/+Z3bSR
X-Received: by 2002:a5d:5351:0:b0:343:e02f:1a46 with SMTP id ffacd0b85a97d-3504a62fb12mr2102101f8f.2.1715349038957;
        Fri, 10 May 2024 06:50:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHucRBfWSHvPvamu1WRWuBFTrQrQkQyBe+ROxdfO0QRjONS8tJPWThU8+2GOiv3nf4H2QrNLg23m2TZKw0gXJM=
X-Received: by 2002:a5d:5351:0:b0:343:e02f:1a46 with SMTP id
 ffacd0b85a97d-3504a62fb12mr2102054f8f.2.1715349038422; Fri, 10 May 2024
 06:50:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com> <Zj4lebCMsRvGn7ws@google.com>
In-Reply-To: <Zj4lebCMsRvGn7ws@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 10 May 2024 15:50:26 +0200
Message-ID: <CABgObfboqrSw8=+yZMDi_k9d6L3AoiU5o8d-sRb9Y5AXDTmp5w@mail.gmail.com>
Subject: Re: [PATCH v15 21/23] KVM: MMU: Disable fast path for private memslots
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 10, 2024 at 3:47=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> > +      * Since software-protected VMs don't have a notion of a shared v=
s.
> > +      * private that's separate from what KVM is tracking, the above
> > +      * KVM_EXIT_MEMORY_FAULT condition wouldn't occur, so avoid the
> > +      * special handling for that case for now.
>
> Very technically, it can occur if userspace _just_ modified the attribute=
s.  And
> as I've said multiple times, at least for now, I want to avoid special ca=
sing
> SW-protected VMs unless it is *absolutely* necessary, because their sole =
purpose
> is to allow testing flows that are impossible to excercise without SNP/TD=
X hardware.

Yep, it is not like they have to be optimized.

> > +      */
> > +     if (kvm_slot_can_be_private(fault->slot) &&
> > +         !(IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) &&
> > +           vcpu->kvm->arch.vm_type =3D=3D KVM_X86_SW_PROTECTED_VM))
>
> Heh, !(x && y) kills me, I misread this like 4 times.
>
> Anyways, I don't like the heuristic.  It doesn't tie the restriction back=
 to the
> cause in any reasonable way.  Can't this simply be?
>
>         if (fault->is_private !=3D kvm_mem_is_private(vcpu->kvm, fault->g=
fn)
>                 return false;

You beat me to it by seconds. And it can also be guarded by a check on
kvm->arch.has_private_mem to avoid the attributes lookup.

> Which is much, much more self-explanatory.

Both more self-explanatory and more correct.

Paolo

