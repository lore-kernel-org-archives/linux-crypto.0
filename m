Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3513325B69F
	for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2025 19:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757532136; cv=none; b=XiCqdLGTeDxsekdfjtzlXRVzVSJSBdSUVL1t2k8SSt/+04p4LMl4jMwtZOkbm+LBm7FcK042U8G6zDinUhPzkOY4I6csLDaDw8zk13dhfl3OBkk2aCT+IBprzyNeNZ0nhuV8Vnyu18y5SeNxIESV2gajhL/hbDpLragbggTAXXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757532136; c=relaxed/simple;
	bh=WwPKx+F4nZMQQvbxZ+yQ8ep3mrkTsl/KPllHb3TKExM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u0NTVpwbeaud6cDa0UU5PRyOrVaXgugjZv+jTFYi00GWYPzj4Dz4xqlumKbkeb61T2TYlJwQTuDyYmhoueM+q7NvJle5f81AWC+9L+q2jl/ECSLLAKS9ZuhaGZX/7V2ApFcMWuaftFbYB8BeUzIYmAmTHl0QqVyh4CKPbIJxLok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qcRnjS9M; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qcRnjS9M"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e6e71f7c6so7413807b3a.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2025 12:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757532134; x=1758136934; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F4vLrrazh5OqKjK4hFSlEDxoFcTPUg28TR1gqdyw1Q0=;
        b=qcRnjS9MJqZEViulTai0j6vXBzSS0GrLbHGqMizQNiHxQSwrind1D0bCdB39sOEpgq
         k70KqIOer3dUHPDM5gXP0XG90WyxaNMZ+yMMLw2C1D9kdCzEsvZ7YGQk7TMmS76t7K9h
         72MfqjO1K3Nf4FIFcQPuKn8xvj/mEtNTzzb9FYm1nw4anMUMa9ldctsi5Sbw0fTrvdap
         550h6kff1tTOeXBcrU3mg4xZq99rfjYe8U0ANHSBVjYU6mDdseVL+JEz+oY/FtuGCGXe
         WTzmrpHUjcxAWPhY2ZNbdNTLFDAlwI44PCUPqYRdCb2N1aKIEEOcwnPfe/j50myvDwsa
         cLWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757532134; x=1758136934;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F4vLrrazh5OqKjK4hFSlEDxoFcTPUg28TR1gqdyw1Q0=;
        b=k0E6QjVZ4Endu7qyVpZOtbT8z44wD4Pl+KvWrPm1Z4ExdMUt7Krxanf4fm3faBEQDE
         NQpGLPyZTT8gZdOg3qXtFncYVgDBdSUJMCQLRfUTHPo9O8DdH5Icr+qgDYQLtmuXK5VE
         zcoNU2/gf4EXksjD7VB17hiCFqgRx+xJEGDha0fm+uWDguoBHctAnBEJ+htlhu6WHt8L
         C37QgxjkqA6vrAQ/HeFKdbGBrchJvmS/HirMdw+qzSQePlPggfql4AKCxup4ZASl73l4
         +Bej0HgyxECaeiuBx5goIl290fgWIcm+FGSMNc8v0xexuq4/0A02/O5K7I4DMjaCjlzd
         NX8g==
X-Forwarded-Encrypted: i=1; AJvYcCUqqmRz9b1wdzp2oMKtruamnKmTkzK7uoM6AlxnhRHgjYlSbt62QrNz8F+5Bjq70iW8wBXAWrmMRC9WBus=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA/jhRt9fvEz2cvBk5Mg+YjZv+/+vjKWygd0Latloksd50Jhuy
	RPO+ja6ytaupiA1k+gs2jEQNeqMaQa1outA3/5f4QMhkz3pmr0Uxjp044xdzz0TcWhMXl2GPpt4
	L0yx4Tw==
X-Google-Smtp-Source: AGHT+IGnPIfSXQ9s+kXYoHDkwl7tzKe5qzsmRWKh5g9jlXevcrlzn/w3fY5nOgrSlDdLhh33sh8KTyaeSf4=
X-Received: from pgcy10.prod.google.com ([2002:a63:7d0a:0:b0:b4c:7355:9e4b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f8f:b0:247:f6ab:69cc
 with SMTP id adf61e73a8af0-2534054a415mr21214365637.26.1757532134403; Wed, 10
 Sep 2025 12:22:14 -0700 (PDT)
Date: Wed, 10 Sep 2025 12:22:12 -0700
In-Reply-To: <e9014e7dfd7f7c040c5d0eefb1f6c20a3c35d9e5.1755897933.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755897933.git.thomas.lendacky@amd.com> <e9014e7dfd7f7c040c5d0eefb1f6c20a3c35d9e5.1755897933.git.thomas.lendacky@amd.com>
Message-ID: <aMHP5EO-ucJGdHXz@google.com>
Subject: Re: [RFC PATCH 3/4] crypto: ccp - Add an API to return the supported
 SEV-SNP policy bits
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-crypto@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 22, 2025, Tom Lendacky wrote:
> @@ -1014,6 +1031,7 @@ void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);
>  void sev_platform_shutdown(void);
>  bool sev_is_snp_ciphertext_hiding_supported(void);
> +u64 sev_get_snp_policy_bits(void);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -1052,6 +1070,8 @@ static inline void sev_platform_shutdown(void) { }
>  
>  static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
>  
> +static inline u64 sev_get_snp_policy_bits(void) { return 0; }

I don't think you need a stub (the ciphertext hiding one should have been omitted
too).  arch/x86/kvm/svm/sev.c depends on CONFIG_KVM_AMD_SEV=y, which in turn
depends on CRYPTO_DEV_SP_PSP=y, so nothing will ever actually need the stub.  I
bet the same holds true for the majority of these stubs.
