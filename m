Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231962BE64B
	for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 19:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757706097; cv=none; b=kS3NR9FwvL0CihXQDaBrwXstKCpCEnfOHNPsRqfRYW09ffsqdbSw1vkOM4mOptTz4YjV2Lyd0oViUkc2KIu9d+uTQL4STIr1h2s0s3si2WkMSZGL9EZ2kFAEyyo8lyBCZEFsZOq8JyjyLoWYjbbHg5p3GTPOMv1NBlW0XCgWUzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757706097; c=relaxed/simple;
	bh=iM2MQBIk1Q/STF9xiEDF7k36NWkR2MjnD2gJk1fRtX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qe3IrjzywsGcxF+CrDWoZQ9EmmA7ioPqob7pUBJPWw5YeZGa2o6hqvv0SDdQEjZb125qX2TjZC1CVZ5nMVhhV02A77s7m2Q8nsc5ICsdZyoH4znyu2CpbkBLLbq6goynlxEIlvEF759HKCcMZf5MZ+1cjah+H17NoM6t2SLwM4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4jTGG7cr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4jTGG7cr"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32df881dcc5so462333a91.0
        for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 12:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757706095; x=1758310895; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hwAmkdSsh2ald981eddTLE3mG7L8NIno0Q78eoK7RXU=;
        b=4jTGG7crT1Kt263fE2BI+Kb+Mk6nju+iHWV1PleBpPMgt10uJds61bxwiFIllI5mAE
         H5ADg2dTYX7pyGj4GzykP15bhZOC2w/w6BaFbK0+XPEaNrXsZfEPmdBcMa3BfwB1T90T
         KPAFmsQJI3IphVy8jqdmAL8oBH5uHqLlRY2PyOH5kQfUpfjm+z5KjcyZShhHR3v0QsOV
         V0q8POK5y/1APvaZNHOO8FbMERMM98+N4dhvnxCUUT2V+8Roq6eOSSi/sXCuJH5M257C
         9j/8cfImStTUylrGB8j8J6ZhdW67szuvUjqV/7IBNwuPLGczRX4IuzH4E4fe/6psy9eM
         U+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757706095; x=1758310895;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hwAmkdSsh2ald981eddTLE3mG7L8NIno0Q78eoK7RXU=;
        b=PZKd3O2flR2rOSA3/C0i88JLz7ZgnKjl9etwn4Jfh+PmoOz3VpneDOgpO6ORzn1+ac
         zre3ARhcV37keP9WLiS0ErixS1nZtGhtIOOs3JAJkXNrLciqJ7GDmpvHN5djYoxYacTs
         TNNm7EitcrAm/8x9jkvBE9MLlV2waVPqu0+nTpOHx4fUyg0sS2ZxsyzW6Agnj8CycZdd
         ArQ6kUShwpnhIaMt4wtHE9RBTGs/mXBWte59tRc58gmaekCOqvKFYWanJPdX9jdr324h
         SfRF1CbdfaBkEF11U2Sf1kCkP8Z3/ZI0ybYzVFfqBuWDaoRmBO2HoEgzjgG3T4YnrSqH
         +EZA==
X-Forwarded-Encrypted: i=1; AJvYcCWgrAyV2S+sqA9TZjczJuJqUwbAo1nFc88cvfvfpVC3LgF3PQ29JDEGtkHv5ijicPPD95da6+hFXvTuNi8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQt1vz47GNEl2FU39SS4yzl8h3ip37rEjQIBk5TDoTKcWx2iOi
	gfi48mom4lKqZYkcWRSX9+Qki35xZIXA1DDxs8LTLcPUlaYhYSCd1vnFOH2dYLyXwYPXRMucHck
	P30qkrA==
X-Google-Smtp-Source: AGHT+IFiAMu5uVuzupQ7fFp8LqWmeFtF+a93+PGygZxvosK5j5W4JE041u2MXOQW8S14Rc2WgZFhshg2SkU=
X-Received: from pjx12.prod.google.com ([2002:a17:90b:568c:b0:329:ccdd:e725])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b:b0:32b:d8ae:46f9
 with SMTP id 98e67ed59e1d1-32de4fb245emr4244466a91.35.1757706095375; Fri, 12
 Sep 2025 12:41:35 -0700 (PDT)
Date: Fri, 12 Sep 2025 12:41:33 -0700
In-Reply-To: <df357d87-3b4b-41a4-acdf-31289590b233@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1757543774.git.ashish.kalra@amd.com> <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
 <aMRnnNVYBrasJnZF@google.com> <df357d87-3b4b-41a4-acdf-31289590b233@amd.com>
Message-ID: <aMR3bRYEoR0eI6x7@google.com>
Subject: Re: [PATCH v4 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, herbert@gondor.apana.org.au, nikunj@amd.com, 
	davem@davemloft.net, aik@amd.com, ardb@kernel.org, john.allen@amd.com, 
	michael.roth@amd.com, Neeraj.Upadhyay@amd.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2025, Tom Lendacky wrote:
> On 9/12/25 13:34, Sean Christopherson wrote:
> > But the below build failures show that they aren't dead code, which mea=
ns that
> > kernels with CONFIG_KVM_AMD_SEV=3Dn will silently (until something expl=
odes) do the
> > wrong thing, because the stubs are hiding the missing dependencies.
> >=20
> > arch/x86/boot/startup/sev-shared.c: In function =E2=80=98pvalidate_4k_p=
age=E2=80=99:
> > arch/x86/boot/startup/sev-shared.c:820:17: error: implicit declaration =
of function =E2=80=98sev_evict_cache=E2=80=99 [-Wimplicit-function-declarat=
ion]
> >   820 |                 sev_evict_cache((void *)vaddr, 1);
>=20
> Yeah, this one is on me. sev_evict_cache() is guest code and should be
> under the CONFIG_AMD_MEM_ENCRYPT #ifdef.
>=20
> >       |                 ^~~~~~~~~~~~~~~
> >   AR      arch/x86/realmode/built-in.a
> > arch/x86/coco/sev/core.c: In function =E2=80=98pvalidate_pages=E2=80=99=
:
> > arch/x86/coco/sev/core.c:386:25: error: implicit declaration of functio=
n =E2=80=98sev_evict_cache=E2=80=99 [-Wimplicit-function-declaration]
> >   386 |                         sev_evict_cache(pfn_to_kaddr(e->gfn), e=
->pagesize ? 512 : 1);
> >       |                         ^~~~~~~~~~~~~~~
> > arch/x86/mm/mem_encrypt.c: In function =E2=80=98mem_encrypt_setup_arch=
=E2=80=99:
> > arch/x86/mm/mem_encrypt.c:112:17: error: implicit declaration of functi=
on =E2=80=98snp_fixup_e820_tables=E2=80=99 [-Wimplicit-function-declaration=
]
> >   112 |                 snp_fixup_e820_tables();
>=20
> This function is only meant to be used if we're going to run SEV guests,
> so being guarded by CONFIG_KVM_AMD_SEV was on purpose. I'm just not sure
> why the stub didn't get used...  or did you remove them?

I removed all the stubs to see what would break (I was expecting nothing si=
nce
all of KVM's accesses are gated by CONFIG_KVM_AMD_SEV).
