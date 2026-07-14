Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F47141A92C
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 18:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054521; cv=none; b=B6giA1dNdWjMp2CnIEpUsF+gvb75DwjWJz7Q3Jj3CCmshUK7ZN/zPPMfCillUL6L3HOt08lZJKQY9bPLoMZkYV8RZ00tVIBWFDTn11FvF+woen+o/Fn37DrLAe0GYK+suLWHtS5QfvHFrxMlJbi+bZWnWMB6RD6nIREyMtqhNqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054521; c=relaxed/simple;
	bh=PaQBkS90a4rPCv/dq+YRWwLuz5fATYts+TOoZzoPZj4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dp2o7FXtyNrG+Iif8kPIC5Ngt+qhIsdLxqezFYr5hQe27dpIfGDExNSiRxXcdHIcLROLEoWSXQBFoplpHBmwWt8eIsPTdCpPUWLGDKjwHGAuP7dLF81uUjfJVN3bzDV3bj4ZHw3Q90Z0GtEZvdYwSbHX5KK3XxhsTohse7+Vkog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rNCK1ue6; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rNCK1ue6"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-848860def2cso4842343b3a.2
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 11:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784054517; x=1784659317; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4QSNMOG9WUYsnTrdiXuaPBwAZEBhxka1gM9x6zaBmSM=;
        b=rNCK1ue6708Vv/JHVtlGRjDGmBg7q7721OgtbVuL7BIIm4HkNGVJG1vYzTGM9MDe5z
         1OUpxXC0cOGbLG+Jzn1WMctTPA+1IfA1i77sPtNKFgOEjmuSt06dIks3incEeubf428m
         zSITgaZnP86MMavZ181GykbtaURT2oBdYUpnDPxXERg/EWu+mul+RMoxZll7Pjf9AEfo
         Vm/SyCa5dOmFVfkZOWFptvYLO38cjr/ZZBMFQdzRv6KzEGbecMfb8ryqEBDI8RTMYfZS
         mZjgu9H3fKEOon8Rr9RbYgQaJAGn8urwRUCOqbTNxWJAs0meHhowCK3PmlfZYDb8nqci
         pYWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784054517; x=1784659317;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4QSNMOG9WUYsnTrdiXuaPBwAZEBhxka1gM9x6zaBmSM=;
        b=iHyerWcuEeSUsPE7bn1FXSsTs2gr83xM3uzj7Xs+mGAgHnZD0YHEw72+lG+2dRa/YZ
         nyi2i/vCkmeG8BaLtuBFmXLpynWCY1SbhZAmiuWtGckPM2mK7c9N/UHQKc1VNduOQBjN
         62GGSzdKmeRIBZnZz86BxLpMOefKuPX3TP9+MrS2pUtt1ubQ4RNX37Uee8hfYV4QIQTT
         YezLdF0IZQi/ZdvrGoVBLu2lnFuKzTuHcfzqg9ZEJ6IKjdaBPWSvPcUqrRbP3vmZMbrs
         w1CAq62G0M3bR3RUFTQspk2KvHz5AElrGyTw67L7BsbSv68NtV9ra3bKujeQb3S80g0b
         H2OA==
X-Forwarded-Encrypted: i=1; AHgh+RpvjP7Rd2jc8cCV2MGsoTT3MTFFhNnspgk+O0VbxKIEliffPekcotaYcUHWklBPVVLqkaFKbeRZY1ONCAk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX+21Id3pTmqzjN2BqETjNDljD7wvr3WJAU0TGGbRqSO7R1ggw
	dKmRvyTPlJPbZZZvqXufl49+5vxLkXKeu9FExJpoEJXEjhHZZpLCygfBivju8nV7y6BPLVmRrS6
	Ng8I38Q==
X-Received: from pfmy4.prod.google.com ([2002:aa7:8044:0:b0:848:56a2:f6a9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9289:b0:848:2ae4:d2ba
 with SMTP id d2e1a72fcca58-84889687b36mr12770821b3a.28.1784054516663; Tue, 14
 Jul 2026 11:41:56 -0700 (PDT)
Date: Tue, 14 Jul 2026 11:41:01 -0700
In-Reply-To: <20260602-sev_snp_fixes-v3-0-24bfd3ae047c@meta.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260602-sev_snp_fixes-v3-0-24bfd3ae047c@meta.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <178405419095.3137257.15966365152304045590.b4-ty@google.com>
Subject: Re: [PATCH v3 0/4] KVM: Miscellaneous SEV/SNP related fixes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, Peter Gonda <pgonda@google.com>, 
	Brijesh Singh <brijesh.singh@amd.com>, Youngjae Lee <youngjaelee@meta.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Atish Patra <atish.patra@linux.dev>
Cc: clm@meta.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, stable@vger.kernel.org, 
	Atish Patra <atishp@meta.com>, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Tue, 02 Jun 2026 15:36:31 -0700, Atish Patra wrote:
> This series addresses a few issues found during code audit of the
> KVM SEV/SNP and CCP driver code. The fixes include a incorrect lock state
> and incomplete state handling during intra-host migration for SNP VMs.
> 
> To: Sean Christopherson <seanjc@google.com>
> To: Paolo Bonzini <pbonzini@redhat.com>
> To: Borislav Petkov <bp@alien8.de>
> To: Dave Hansen <dave.hansen@linux.intel.com>
> To: x86@kernel.org
> To: H. Peter Anvin <hpa@zytor.com>
> To: Tom Lendacky <thomas.lendacky@amd.com>
> To: Peter Gonda <pgonda@google.com>
> To: Brijesh Singh <brijesh.singh@amd.com>
> To: Youngjae Lee <youngjaelee@meta.com>
> To: Ashish Kalra <ashish.kalra@amd.com>
> To: Michael Roth <michael.roth@amd.com>
> To: John Allen <john.allen@amd.com>
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: clm@meta.com
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: stable@vger.kernel.org
> 
> [...]

Applied patches 1 and 2 to kvm-x86 fixes, thanks!

[1/4] KVM: SEV: Do not allow intra-host migration/mirroring of SNP VMs
      https://github.com/kvm-x86/linux/commit/6ee414078823
[2/4] KVM: selftests: Verify SNP VMs are rejected from migration and mirroring
      https://github.com/kvm-x86/linux/commit/df371f2c6244

--
https://github.com/kvm-x86/linux/tree/next
