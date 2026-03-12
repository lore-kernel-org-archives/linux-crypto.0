Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672353890E6
	for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2026 19:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345331; cv=none; b=tcETM0O3MvTT/tYAXNJAgxjvsVNKBBpCgUCKpE/DjB+7JnkAbmQcMZg1WgPzW0YiBEO+gb+xeAwF8P2ZIydev9qaXx38nLeA31OXEExb7GWgmPZakjbfjU/MYiidr5I8lcLfGhUdyDYg7KEQPJNzPmwQrKhcKNJXHMBuDctiOos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345331; c=relaxed/simple;
	bh=xJZ5W+Tlnl5u86g7EdYowItOjUuecQm5CqUYrR7edVE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vevyf55d2sR7LRJnFaGK8sXkfLWkXBCtLxFXedJTLgs+6KJAANwPuhGaLHejSidQ1jOKiwXgmfAdn5YOeSdu9rO5cVqCupgRFfpAplCj+53CEHIWxKlTjbxkdv82IYOjWBl55Blg/+sIYaYGg7pUElEZFMtsiC+BxOIK5SfjLl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mKpp9UA+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mKpp9UA+"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35a032cdd78so5875465a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2026 12:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773345330; x=1773950130; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hrjSa5sH7XQL3da3DJB6S0oC3QqGZXkp52qJDNxbE6Q=;
        b=mKpp9UA+Z1WXRQEo2fLz3qXIg4GodO/HbjY0Rb6yrj1p/IelbGr2NgECZSljFhNU9P
         r+e9+ik9FBRWTnxbQX3hr5qQCIAPcZnTMxhfxD8pnBXtx/e9NZuv32FTezb5Ypx7DdVS
         aXNcJDpFqVvIUyANBS26IPmMHNg9Omds3VbFxj//J2oT45MOM2wmOXsCRS0ig3nCLA9b
         aHK8pk3GrcXYD8pnsv/TX32mzEi9Z8O3h1rg2tZfBTWaMNQwcmqvx+NxtwSiloLdD+Vv
         vQRHYeCrhnyhEs9pWvGcvWnWczMcoNaJXJVo1FJSm11iuVfzqmrVLklPuqmuVhHwdnxD
         8v0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773345330; x=1773950130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hrjSa5sH7XQL3da3DJB6S0oC3QqGZXkp52qJDNxbE6Q=;
        b=sTPK9CsQo4OfoF43h9kQ/kv1JFES70bKLSQnHkSuU8OZd1sGHNPoZakSvD9KBzYYEX
         QcTHVLO8ppoirttRWj/pNJYfe2bChUMoJM0U/CGatFJXH8Ib8O90D5HBpDybS07fUwWE
         kMt1hRC8PHg0JEEjWzO9T6i8ZS5OA3DNj7bLG5PMFUF3bSuO81kgX1mY4J5rs6bXiYpW
         siwRfrS+vMFor6kQEFmnU3EfZ3AKwsQUxxkNNVyGqS+bx7dhLwSoDhk+Zru6EoQmF221
         FnPz5CTt49d7mHV7TLawG3yDLXQOxrt5PYxSQ3NZrTZNbV9ZAohJ3+1OlTIUwQpiZvb8
         ffhw==
X-Forwarded-Encrypted: i=1; AJvYcCWHqaGDRSbBWw5gTxkkJTWn7tr9pnQFmCOVaYbrBzPMEEXBfdmfD63mIrEzHp0nq0EAatTc6ND1FFs9wjk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1ixxKWX1yzfoVVEy9jfPpd3LhJgwh/VPIRk98oT44HK9aoV7N
	QH/gcofRnr6sO3o6Z+18pIAkLN3F9rx0XBA6/HlAfmKRZWceB30dBqaiHxsUXu5uqtsXtX+kZ9y
	m7DI8GA==
X-Received: from pgbcr11.prod.google.com ([2002:a05:6a02:410b:b0:c73:9c8b:4186])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:914c:b0:398:8a92:78aa
 with SMTP id adf61e73a8af0-398eca38eecmr460017637.22.1773345329610; Thu, 12
 Mar 2026 12:55:29 -0700 (PDT)
Date: Thu, 12 Mar 2026 12:55:28 -0700
In-Reply-To: <20260303191509.1565629-2-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303191509.1565629-1-tycho@kernel.org> <20260303191509.1565629-2-tycho@kernel.org>
Message-ID: <abMaMECwiJPvEXss@google.com>
Subject: Re: [PATCH 1/5] kvm/sev: don't expose unusable VM types
From: Sean Christopherson <seanjc@google.com>
To: Tycho Andersen <tycho@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Shuah Khan <shuah@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

KVM: SEV:

On Tue, Mar 03, 2026, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> Commit 0aa6b90ef9d7 ("KVM: SVM: Add support for allowing zero SEV ASIDs")
> made it possible to make it impossible to use SEV VMs by not allocating
> them any ASIDs.
> 
> Commit 6c7c620585c6 ("KVM: SEV: Add SEV-SNP CipherTextHiding support") did
> the same thing for SEV-ES.
> 
> Do not export KVM_X86_SEV(_ES)_VM as exported types if in either of these
                                       ^^^^^^^^
                                       supported

> situations, so that userspace can use them to determine what is actually
> supported by the current kernel configuration.
> 
> Also move the buildup to a local variable so it is easier to add additional
> masking in future patches.
> 
> Link: https://lore.kernel.org/all/aZyLIWtffvEnmtYh@google.com/
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  arch/x86/kvm/svm/sev.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3f9c1aa39a0a..f941d48626d3 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2957,18 +2957,26 @@ void sev_vm_destroy(struct kvm *kvm)
>  
>  void __init sev_set_cpu_caps(void)
>  {
> +	int supported_vm_types = 0;

This should be a u32.

> +
>  	if (sev_enabled) {
>  		kvm_cpu_cap_set(X86_FEATURE_SEV);
> -		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_VM);
> +
> +		if (min_sev_asid <= max_sev_asid)
> +			supported_vm_types |= BIT(KVM_X86_SEV_VM);
>  	}
>  	if (sev_es_enabled) {
>  		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
> -		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
> +
> +		if (min_sev_es_asid <= max_sev_es_asid)
> +			supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
>  	}
>  	if (sev_snp_enabled) {
>  		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
> -		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
> +		supported_vm_types |= BIT(KVM_X86_SNP_VM);
>  	}
> +
> +	kvm_caps.supported_vm_types |= supported_vm_types;
>  }
>  
>  static bool is_sev_snp_initialized(void)
> -- 
> 2.53.0
> 
