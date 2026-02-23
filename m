Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907AA1FF1AD
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 16:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864595; cv=none; b=rU5I7AQVFVfvAh1E8AhuGyf8lbYJBPOnC2PR1ho7sF78M9cd2Fucm/IbqEP6GnGdwq0p/Tjz7ydgZLNht+/6wCcEygu6ZnG0aeZNtyw1ORKVXScaIAxvvqw4XEgkfKJLMl8CBVch1KtGSLC6oiedCmDVc48dA9KF9pHxFxNOTdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864595; c=relaxed/simple;
	bh=mvK24oTTBqZrxHHEFPq3cG7IWQTbAHw8+UO0+UuviSM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VWL84ETc68dPUOQrIbLbXfXz1L1kG36eX4rutS57SsYEW7n7leRQvgSvyF06yjWhATJupYdkJl7jJDrgbdIyH4hPjZXP6tWwELftpb05U7ydTy1PiTcGmQDo0Te5lCTwkO4o4AKWflUQ0oGQT2tJgUms1mc2TWGXNIVE4uwPlu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tSV7Rhb+; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tSV7Rhb+"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aad3f8367bso53457035ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 08:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771864594; x=1772469394; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yJpQri3B7GVcHe+2iM9Lc81Jg6gKvTThd70NiS5YIcI=;
        b=tSV7Rhb+7trl5vs8l4TFzfSJye7k4hyc0gCT1pm0iQ7KfsqwWQVcAn1resESG+u9js
         4SWk9sZZv+zAZWYD49R4rHPjWPldh+5Vv5Z0EepVHLQzKWhYXiXnmRDNrXyGLl+Qgtz3
         tYxiC/4J/tSTlccy2cHefCI4oAnl36mRyACR32WTnOwc6htQwg3WgTYHXsJO+lNG0Cgl
         272osN5UDbJKzI3zhl9Y9izUNbqA9bgr7QW2aLVPmDNdccPlRvSXuSQeth8jPnQNqfch
         4zbIqpMpBd/29LcnfiBQkNrdj2ngGOX79myuOoBcDbHYafNbMsAAwR8Rr75Gk+1IW/ai
         baEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771864594; x=1772469394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yJpQri3B7GVcHe+2iM9Lc81Jg6gKvTThd70NiS5YIcI=;
        b=QysKK9k2r7uFB/2NxV9rQSc10xEreMXGDrE55xrjPVDpc2IOJYzuFP7xToxl/bhyyV
         fa2ia2dXVc6bfLCFC172VpUhigT/4hbubOAk3xuqRDxb0J7ED2/rzF4NeWmMvPAPeXgz
         O2ZLXsyOgZpvgFNa4iggQ7W1LFu2vHmhdXc5qdvcpGUIIpJEDcIF2g50NFWitkZgllGT
         aXV/wZjsgaW/EPC++wVWu68ZLDgTDgrj9p4DI9Rgxfgn9qbnr9x8cI/fECtuE9zzwQXP
         ogrM+241hopKLB5CbBehObQmF8nDF//+/xxa4KLWxXg6zV2z3GHclsOEutZI5YuFgosr
         ksIA==
X-Forwarded-Encrypted: i=1; AJvYcCXwxtpbKUu6FT6p4vCq44n28mnRNmU0PKdgl0soyuOXH6v57ntmObBR0bRw8LCdFtqzbNsXaL/Z1dL+HYs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKbBkVgcf4CQv2AocFiC07Dlyr/H5PRzVP7klyPW30xoJcJHx5
	Ucbwp1k59dOmZLCvuFrqhiPs5ekT09iE3SOV8vR1TFFG0E1u0yRU77z5W0B0BnMOfjfbyPdraCY
	3D2cuPg==
X-Received: from plrs10.prod.google.com ([2002:a17:902:b18a:b0:2a8:ea98:5b88])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef0f:b0:2aa:d506:d189
 with SMTP id d9443c01a7336-2ad74515d1dmr84078595ad.34.1771864593795; Mon, 23
 Feb 2026 08:36:33 -0800 (PST)
Date: Mon, 23 Feb 2026 08:36:32 -0800
In-Reply-To: <20260223162900.772669-3-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223162900.772669-1-tycho@kernel.org> <20260223162900.772669-3-tycho@kernel.org>
Message-ID: <aZyCEBo07EHw2Prk@google.com>
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

On Mon, Feb 23, 2026, Tycho Andersen wrote:
> diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
> index 86ad1c7d068f..c7fda9fc324b 100644
> --- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
> +++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
> @@ -213,13 +213,48 @@ static void test_sev_smoke(void *guest, uint32_t type, uint64_t policy)
>  	}
>  }
>  
> +static bool sev_es_allowed(void)
> +{
> +	struct kvm_sev_launch_start launch_start = {
> +		.policy = SEV_POLICY_ES,
> +	};
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int firmware_error, ret;
> +	bool supported = true;
> +
> +	if (!kvm_cpu_has(X86_FEATURE_SEV_ES))
> +		return false;
> +
> +	if (!kvm_cpu_has(X86_FEATURE_SEV_SNP))
> +		return true;
> +
> +	/*
> +	 * In some cases when SEV-SNP is enabled, firmware disallows starting
> +	 * an SEV-ES VM. When SEV-SNP is enabled try to launch an SEV-ES, and
> +	 * check the underlying firmware error for this case.
> +	 */
> +	vm = vm_sev_create_with_one_vcpu(KVM_X86_SEV_ES_VM, guest_sev_es_code,
> +					 &vcpu);

If there's a legimate reason why an SEV-ES VM can't be created, then that needs
to be explicitly enumerated in some way by the kernel.  E.g. is this due to lack
of ASIDs due to CipherTextHiding or something?  Throwing a noodle to see if it
sticks is not an option.

> +
> +	ret = __vm_sev_ioctl(vm, KVM_SEV_LAUNCH_START, &launch_start,
> +			     &firmware_error);
> +	if (ret == -1 && firmware_error == SEV_RET_UNSUPPORTED) {
> +		pr_info("SEV-ES not supported with SNP\n");
> +		supported = false;
> +	}
> +
> +	kvm_vm_free(vm);
> +	return supported;
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
>  
>  	test_sev_smoke(guest_sev_code, KVM_X86_SEV_VM, 0);
>  
> -	if (kvm_cpu_has(X86_FEATURE_SEV_ES))
> +	if (sev_es_allowed())
>  		test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
>  
>  	if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
> -- 
> 2.53.0
> 
