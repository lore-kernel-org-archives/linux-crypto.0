Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9506088F
	for <linux-crypto@vger.kernel.org>; Wed, 12 Feb 2025 02:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739327506; cv=none; b=VP6j79SUOHYmOy1WIUw96obDXdGF+DKEE8b8+0SdhbKTpp8mpP00u+AkEZvz+1O+IRxdF4b2ttm1TMACnbPZA15SNYFaOh8bI4sVYyfueKn2WI14ce0Bqg9lIs/71NVLxwzzAwEdgE6e0bnJ5qL8QBKQMbrAEombAnz7y7WIs8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739327506; c=relaxed/simple;
	bh=/xVLIbnBID19pVlqnJua6JU9LCMU9qjYDj0RqS1xVgc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S/3FfUoIO34mmz/BlL3KUhsPOZBlNtJGLAnM0098v33xCrNrUiaS2+HqTUlimUsedKo1LmLNv0/PLOx6Om/YiBQRzhzrbnJBcsh87yjaBOZZjdEAfLXHGPQ+lH7dGkcVTjA5zAZg65Bs3eb8Dqr+D9qVZuzsvOOAzmJ8DbHer4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XMCQ5w2a; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XMCQ5w2a"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa440e16ddso8300237a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 18:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739327504; x=1739932304; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vPRb0IsRdvCLk95iJ9DvUJH0LJh/0xdqXsVtoHsQUsQ=;
        b=XMCQ5w2agmlYv1s0pdi7t182NBsKWVRQWC2FKVwRvkwm3y/AL3HSvSfBaosrMIIivI
         3rZSbBi93tSybljuoxp+P6VId+R47ZiRcmthPecAGnxXijT6ENxJRJt1KpspZE1skV5x
         rapOU6yl/LlVmyAXlH+y/DG+5f823a3U5WTDkONfvU35oZeWOU7Czuxl/36dYnMleOAA
         oe4QbvocdqVYS3quW7FEAE8ukVdj7ULI3J2AXq6jwAuuwj8HiuopMe4W4S1Mqaf5QsO9
         Chix6cRJfc6shn+KepOWopI0bpfY4+WnH3Ovt6ehIbbPgd5rw/FSOiQ0nzcy3XdhhEPb
         k2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739327504; x=1739932304;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vPRb0IsRdvCLk95iJ9DvUJH0LJh/0xdqXsVtoHsQUsQ=;
        b=CkRsS/Hp61o5Zl+KSj7pXVwT/SvxcA+FyDP5QHA57shxftxhkgOGuxsOZrm+2tssaQ
         9AJXgvAj7UtjaKAT4N6WqsX3SvOY2WSh55kNLZfXM3PgYY5GIQoBk8eEd+CPzH3aeffk
         QggRrrSo4d3EMtr03h5Fb3bzXNafeQP7OTTjdPXvMVgwSwaLkS5QmiDwOxd8rwCkRPgE
         Gs6N0sCotHchbtJ38mvAxJsgTFxqVRPLLNg4so3cM+mTa+2lxiZ5Hstl2pAAk1YpNy2p
         /xVxyNWBS6DzZ62kXwyXLhnOIn2rnCuJsEurMtyhp5aOE0w63MlMqjqjNvtaf9FR8A8Y
         L9zg==
X-Forwarded-Encrypted: i=1; AJvYcCVy/gTXbHw6VfmST+IJ7/H26VIlS6YErT0TLDz4iW2yzxHp/5lG9EEG2QV3pbQyG5IDANuYSEis+/cFQoU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9dzGO62JZI86Vw47ZuW55qpcDE6XI6ExhIIcv1AyUQQLHMpWZ
	/JK7bvKRoaRSiQ/AP/wKxAhdzJUuOhfiejjnl2//VjxnPyBBHXE1Kg6Uu+SOC//FFF/AZMC1JwE
	uxw==
X-Google-Smtp-Source: AGHT+IGMX9u7M35FXglCi8he7YjOChUI+hVwPKDefN8wt50qF3YlUo1gLTN02dl5lpemjD008hcqqNreu6U=
X-Received: from pjbpw18.prod.google.com ([2002:a17:90b:2792:b0:2ee:4b69:50e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfcd:b0:2ee:863e:9ffc
 with SMTP id 98e67ed59e1d1-2fbf5c237demr2067501a91.21.1739327504064; Tue, 11
 Feb 2025 18:31:44 -0800 (PST)
Date: Tue, 11 Feb 2025 18:31:42 -0800
In-Reply-To: <20250203223205.36121-10-prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250203223205.36121-1-prsampat@amd.com> <20250203223205.36121-10-prsampat@amd.com>
Message-ID: <Z6wIDsbjt2ZaiX0I@google.com>
Subject: Re: [PATCH v6 9/9] KVM: selftests: Add a basic SEV-SNP smoke test
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, shuah@kernel.org, 
	pgonda@google.com, ashish.kalra@amd.com, nikunj@amd.com, pankaj.gupta@amd.com, 
	michael.roth@amd.com, sraithal@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 03, 2025, Pratik R. Sampat wrote:
> @@ -217,5 +244,20 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> +	if (kvm_cpu_has(X86_FEATURE_SEV_SNP)) {
> +		uint64_t snp_policy = snp_default_policy();
> +
> +		test_snp(snp_policy);
> +		/* Test minimum firmware level */
> +		test_snp(snp_policy | SNP_FW_VER_MAJOR(SNP_MIN_API_MAJOR) |
> +			SNP_FW_VER_MINOR(SNP_MIN_API_MINOR));

Ah, this is where the firmware policy stuff is used.  Refresh me, can userspace
request _any_ major/minor as the min, and expect failure if the version isn't
supported?  If so, the test should iterate over the major/minor combinations that
are guaranteed to fail.  And if userspace can query the supported minor/major,
the test should iterate over all the happy versions too. 

Unless there's nothing interesting to test, I would move the major/minor stuff to
a separate patch.

> +
> +		test_snp_shutdown(snp_policy);
> +
> +		if (kvm_has_cap(KVM_CAP_XCRS) &&
> +		    (xgetbv(0) & kvm_cpu_supported_xcr0() & xf_mask) == xf_mask)
> +			test_sync_vmsa_snp(snp_policy);

This is all copy+paste from SEV-ES tests, minus SEV_POLICY_NO_DBG.  There's gotta
be a way to dedup this code.

Something like this?

static void needs_a_better_name(uint32_t type, uint64_t policy)
{
	const u64 xf_mask = XFEATURE_MASK_X87_AVX;

	test_sev(guest_sev_code, policy | SEV_POLICY_NO_DBG);
	test_sev(guest_sev_code, policy);

	if (type == KVM_X86_SEV_VM)
		return;

	test_sev_shutdown(policy);

	if (kvm_has_cap(KVM_CAP_XCRS) &&
	    (xgetbv(0) & kvm_cpu_supported_xcr0() & xf_mask) == xf_mask) {
		test_sync_vmsa(policy);
		test_sync_vmsa(policy | SEV_POLICY_NO_DBG);
	}
}

int main(int argc, char *argv[])
{
	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));

	needs_a_better_name(KVM_X86_SEV_VM, 0);

	if (kvm_cpu_has(X86_FEATURE_SEV_ES))
		needs_a_better_name(KVM_X86_SEV_ES_VM, 0);

	if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
		needs_a_better_name(KVM_X86_SEV_SNP_VM, 0);

	return 0;
}
