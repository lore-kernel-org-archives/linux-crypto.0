Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301B62D7394
	for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2025 19:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757531987; cv=none; b=d4iX0RK8rhyZ8oW5elYtpLXvPX+itvBzinptD8C/HUG2rkCEqLZ5LvOa6DKO+ImEU7JgAANoMsyK36gcKnI5NeIr/4XB8gggcDCGhowmm+6YiaYMS3mLv8D71xvoRKLxyCwux1nthUgPHDvXYkskGzpwxKRuiLA5GS4Ml8pCtdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757531987; c=relaxed/simple;
	bh=qWueF42qwhO9/d4nulib23wqx9pkPXKoj4m8Enmbuag=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HzbbMa6+JBC2B5KuI1rc2FmY+MGP2OQIoLcu0RqCzW3TrgBN2l77P6FnfHfZzdAjFY8gjOr+06vo7e7+icZ2FQE+2h2MuU8en1rwCeHLoOtLOSCD7kq8XzxVk5hszFNIN8skkkT3cAEq1VvYjVDz2wbkLBSfgnCgB+690/rBlY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RfNgrym+; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RfNgrym+"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4fbb90b453so11285248a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2025 12:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757531985; x=1758136785; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VN/rggrH4digs9qBWZB1KbUoy16EnGUVMJIJH5xmr7E=;
        b=RfNgrym+tYbAWnYqtJTcZU17SPyOHkyDR4Q5WilKy+MgLEmjCxARjXZRNEeDw+nTOf
         XiRqj5L1LiJ6rHiYlXRxQfeo8paRSrLdnZWx848T7JO1535Dct1jL/7p6+jX+XpFmbxt
         pGgHzWt1iMMUOq/j5hSyN689xrDHYz/vMzvnnEhJZ7Dsu82dCCiVrGidifWSBC25Vr+O
         TBqUqz36L1+1uP9nRnWVP34biDAZdDmV27rEoWKOpRc1jNArTsL6X4FgriH3ZMDTuS1E
         pZnl3LOgiLhyIqFIOf+7OaSnvnVCvcPEVM7JS4LBoU/mvKWpgvgwJCR349lplWoE2/q9
         /WvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757531985; x=1758136785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VN/rggrH4digs9qBWZB1KbUoy16EnGUVMJIJH5xmr7E=;
        b=hkKF1c0kiipUzOFBWHfrMiCLgUf7pfvSYeTmkiRsPQ69oU6r6NAnFtzQv9JnuiiGgK
         3w6+GpyixmhlniYABfhkMJrYohT84wnw/PKaxeq2725MR+cYkMmefVkCemSoLKQOzbwX
         3/QKBZ/+U07vdfV/n9DLjmYuSfzKbgZUvWnTYXyv54KCra+jUbjALkImMvXe5k1wo/tB
         Z2BwZXMdspHr0QTjGicQYfpyXqi5+PDCxbb+ZT8MApqHOUPTwMtnvbbqSZ2VVUAYreWO
         nKIXVHSuAHGkCecrVwDz2NO/tZZEKGODtfFRDs81efPS54wL7bpaX42ywEqEpy4Rs9ft
         fjsg==
X-Forwarded-Encrypted: i=1; AJvYcCVymwemwAOq4pNd/j6G3T+lwwElM0DDZ67CRtIkQtkykLYBjymSb+6SjNMXkXNIUjSKw6mSYq6GpsBp7J0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIW/OjiD7YHu/Rg2TDcOulu7J5MJiU/SifZeAyptkXN+sSffbG
	4hZbUQfD71jXy8yMosuUbU0Gu75bdyMzPDO4CnWWPm2aoCkOuPaWxp8UsI8m7JXLdrEP0gU4aHV
	H2WdlbQ==
X-Google-Smtp-Source: AGHT+IHX7UynOVRpi3If/F9N5K/tO9bGneP/KTRE0HxApIqGpBDwKgUOwjvsvvWc3ktK/GVAM4OFjpZif2s=
X-Received: from pfqr14.prod.google.com ([2002:aa7:9ece:0:b0:772:750f:4e23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d9c:b0:245:fdeb:d264
 with SMTP id adf61e73a8af0-2533e576707mr26771465637.12.1757531985441; Wed, 10
 Sep 2025 12:19:45 -0700 (PDT)
Date: Wed, 10 Sep 2025 12:19:43 -0700
In-Reply-To: <ad3dfe758bdd63256a32d9c626b8fbcb2390f26e.1755897933.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755897933.git.thomas.lendacky@amd.com> <ad3dfe758bdd63256a32d9c626b8fbcb2390f26e.1755897933.git.thomas.lendacky@amd.com>
Message-ID: <aMHPT4AbJrGRNv05@google.com>
Subject: Re: [RFC PATCH 1/4] KVM: SEV: Publish supported SEV-SNP policy bits
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
> Define the set of policy bits that KVM currently knows as not requiring
> any implementation support within KVM. Provide this value to userspace
> via the KVM_GET_DEVICE_ATTR ioctl.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/svm/sev.c          | 11 ++++++++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 0f15d683817d..90e9c4551fa6 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -468,6 +468,7 @@ struct kvm_sync_regs {
>  /* vendor-specific groups and attributes for system fd */
>  #define KVM_X86_GRP_SEV			1
>  #  define KVM_X86_SEV_VMSA_FEATURES	0
> +#  define KVM_X86_SNP_POLICY_BITS	1
>  
>  struct kvm_vmx_nested_state_data {
>  	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2fbdebf79fbb..7e6ce092628a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -78,6 +78,8 @@ static u64 sev_supported_vmsa_features;
>  					 SNP_POLICY_MASK_DEBUG		| \
>  					 SNP_POLICY_MASK_SINGLE_SOCKET)
>  
> +static u64 snp_supported_policy_bits;

This can be __ro_after_init.  Hmm, off topic, but I bet we can give most of the
variables confifugred by sev_hardware_setup() the same treatment.  And really
off topic, I have a patch somewhere to convert a bunch of KVM variables from
__read_mostly to __ro_after_init...
