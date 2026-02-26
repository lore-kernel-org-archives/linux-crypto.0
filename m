Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228B138BF70
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 22:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772144887; cv=none; b=IhysqWO+TuKM60x4wVUql/dHO/oDqPYwdh7cYjFvKmAHguH6J2pDk5NpEHJpBX20Mi2ZPkIOmtl35LFx9c8gJWy1ZJpDY0gEyHg2oR97mIieyUxSUDlajmcft4ohJwEQ8uLsM36VnVXX4RASwQkJWCozhR2HWpJV/JS2CGB3fa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772144887; c=relaxed/simple;
	bh=IgrG23jXKGivVbn7AQPcC0OLGqaf1C8vOPdQER9mxQs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZRGV2kgw16DDs3C+SopDdhdykYfaZASVkuHYIaBrg+9MpQIeCwerUeybUMhYtZanU9SKARFJ3EmuPhUprwNHID9nD3j6iJfB9nBITslRUTJTzghGIKEt/QfgJSjfuP5D1Mp4a87RBmHunKHg2wE4cz6mTTOWZxf5w78sbI96awY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q6iM5Woa; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q6iM5Woa"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2adba04421eso72352935ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 14:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772144885; x=1772749685; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W/j2ZyC9rj9YMlhwf1A/TlVZORUXpPQxiBPhNIX130A=;
        b=Q6iM5WoaqSfDo5nilkSNnoNT7gxxET93zuUc4YVBmogTH6uxzjP3Gt7n/OLC5178PN
         I93pbBrLMPUIjwJITpWv+E99f6lDOJXYAeKl1zreex5URAROSvSEHFKYlHUL8PuIEQ+A
         Dgi+23KCkZOcm9XLkkVK0i0fvSXhZ/usjn9hJhTmq99YQKIvRT06YfwBHB3yQzX/A/+5
         y8X3XI2YF1LllLWAOT1GC08wGuxTkqj4x8n5omsEYcWLHjpyCoB0srTyuFBMcvAB0t9J
         L7qZRP0zIbmOovygpcNILvSYkGs++qIPmXsWuBXGTXgNZUT8A7lCI2T2lGjWMhINF6nD
         isEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772144885; x=1772749685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W/j2ZyC9rj9YMlhwf1A/TlVZORUXpPQxiBPhNIX130A=;
        b=I6Bm9bMoSAPUM3FhsdhibPMDJPAuNUCJ2h0hEETAPB0m/cQRfn7WjgFt0//TaErBo1
         k7TwslatTy8ethuOjarOiM/e2rkpHSmcqzhKbZBw5I7oPeHpe9J/l74X2VBVykeDC5tY
         E5f825/pdbqnzyK5vxru1PTt5W2GfmOv6w7PHWGEsO5fi+L0xWamUPB1wkJBbxPxzqeT
         MftNJ68ZuX7QA6vzcdNAVDV7ATW9GDhxSAkZ7aXbKe1s7wsqDbHdmfWxjZxe5iZXmnMB
         n7BKB4+gF7BiVEjsqEXAB/qd5J5VePMN2y+9iyseaFXUXKgmbjxlijO8Lgg33ASbrWtL
         EURQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4KiaxKxz7dHQ9baA+yKmmyEDta8qT/GLk7+wXfe/Fl/a9ZtC0xHw7cybHJKvSgAIuDMmevgmt4SHctug=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC2fyd5FINF6KU4BYAt3xlXcm3I7RY2Jj9OaRcn9Mt8QEu6An+
	fkemy363YAmM4i7OmsGjKd+t4r71H0xz9PIfs6/tqd+ZUMfGDtvA9b1cPDBYFbJSd+DXvn8wznO
	DtBYKVg==
X-Received: from plbkb4.prod.google.com ([2002:a17:903:3384:b0:2a0:9439:b25b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3bac:b0:2aa:e6fa:2f6c
 with SMTP id d9443c01a7336-2ae2e41a277mr4596915ad.24.1772144885217; Thu, 26
 Feb 2026 14:28:05 -0800 (PST)
Date: Thu, 26 Feb 2026 14:28:03 -0800
In-Reply-To: <aaC0KGXmfhOMOrJ9@tycho.pizza>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223162900.772669-1-tycho@kernel.org> <20260223162900.772669-3-tycho@kernel.org>
 <aZyCEBo07EHw2Prk@google.com> <aZyE4zvPtujZ4-6X@tycho.pizza>
 <aZyLIWtffvEnmtYh@google.com> <aZzQy7c8VqCaZ_fE@tycho.pizza>
 <aZ3ntHUPXNTNoyx2@google.com> <aZ8xje-iM0_9ACie@tycho.pizza>
 <aZ8077EfpxRGmT-O@google.com> <aaC0KGXmfhOMOrJ9@tycho.pizza>
Message-ID: <aaDI83LDFj9Be-sH@google.com>
Subject: Re: [PATCH 2/4] selftests/kvm: check that SEV-ES VMs are allowed in
 SEV-SNP mode
From: Sean Christopherson <seanjc@google.com>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 26, 2026, Tycho Andersen wrote:
> On Wed, Feb 25, 2026 at 09:44:15AM -0800, Sean Christopherson wrote:
> > Ya, I don't have a better idea.  Bleeding VM types into the CCP driver might be
> > a bit wonky, though I guess it is uAPI so it's certainly not a KVM-internal detail.
> 
> Turns out this approach breaks the selftests, which is at least one
> userspace:
> 
> # ./sev_init2_tests
> Random seed: 0x6b8b4567
> ==== Test Assertion Failure ====
>   x86/sev_init2_tests.c:141: have_sev_es == !!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_ES_VM))
>   pid=12498 tid=12498 errno=0 - Success
>      1	0x0000000000402747: main at sev_init2_tests.c:141 (discriminator 2)
>      2	0x00007f9adae2a1c9: ?? ??:0
>      3	0x00007f9adae2a28a: ?? ??:0
>      4	0x0000000000402934: _start at ??:?
>   sev-es: KVM_CAP_VM_TYPES (15) does not match cpuid (checking 8)
> 
> As near as I can tell qemu doesn't do the same anywhere. SNP guests
> run fine, and SEV-ES says something reasonable:
> 
> qemu-system-x86_64: sev_launch_start: LAUNCH_START ret=1 fw_error=21 'Feature not supported'
> qemu-system-x86_64: sev_common_kvm_init: failed to create encryption context
> qemu-system-x86_64: failed to initialize kvm: Operation not permitted
> 
> Thoughts?

Breaking selftests is totally fine, they don't count as real users (the whole
point is to validate KVM behavior; if we weren't allowed to break selftests, we
literally couldn't fix a huge pile of KVM bugs).

Even if a real VMM has a similar sanity check, I wouldn't consider an assertion
firing to be a breaking flaw.  No matter what, the VMM won't be able to launch an
SEV-ES guest.

For selftests, something like this?

	have_sev_es = kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_ES_VM);
	TEST_ASSERT(!have_sev_es || kvm_cpu_has(X86_FEATURE_SEV_ES),
		    "sev-es: SEV_ES_VM supported without SEV_ES in CPUID");

	have_snp = kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SNP_VM);
	TEST_ASSERT(!have_snp || kvm_cpu_has(X86_FEATURE_SEV_SNP),
		    "sev-snp: SNP_VM supported with SEV_SNP in CPUID");

