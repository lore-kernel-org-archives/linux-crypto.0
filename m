Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E7F363C6B
	for <linux-crypto@vger.kernel.org>; Fri,  1 May 2026 19:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777662742; cv=pass; b=nh7kQJPmLj+/SeoZ3J0rrUR9onDqQYi4gOa4HO1nOOoJqOsYQ/SOBm/BzqDDniJKl4lAlF+h59GLgmjZhCe9HyRlTmkLVNYv2v6JfguYWHvp9xUqdj6UQ++wGG7Ah/59Ierp42R7iw2Q3SY3VwxTCVYLmMvHwAwbs9uD+y7c4As=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777662742; c=relaxed/simple;
	bh=hsgFMxSVpPKS2tYlhKBJWXt+iv4JfRbOTmCq+LCIYTE=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z0jYf26/Vjudtdn51wJMCp5b6YEWxDZlhnczdaLaQK5kzRXLA/xalqqwMPD2X61QV70MJPfqajKaxpPqXu+y4bXuJrzOL3ed45ApV0crFbb0+1c0SaVzmEwqow96xR0NhrypjLrL2zoFIMOD3kux6ody4gXGFfExJlXsV9Y55S8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ndZOySKx; arc=pass smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ndZOySKx"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-606045ef716so1427463137.0
        for <linux-crypto@vger.kernel.org>; Fri, 01 May 2026 12:12:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777662740; cv=none;
        d=google.com; s=arc-20240605;
        b=GCsP2IYU8sB0iQRPP2i0h8MLB/EAGdyY0iQw80pNOiVNQG7EgBP+DSEBQXNfV+GL9F
         3tFlcEZtMxsfK6vfiTcGRctjpXj9VzhpXlWL81+DimYcBmW04HINuww9RN9+XnmpSBIC
         XAPDjxEcOWB9mITguxdpcYr1SRfoOUuD5yCCGR3vfu7AEWHXQg7qPpqiHjrqIJse8GMt
         JJ5Ovc5tXsNQEVpGFDNJzWNy8TRdePhjra3mW+0wYEssT47+ijKl0B6BGoiHjGBHaNWX
         69zCr3XMRpXCoXPREWob3AJLSYCpE9qY6gHluPbSDdZ2UXAZClPN1q+vVfkF4qHfQgQS
         b60g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=nm6005Bs28bikl/uf0zpE9w9BeJo6zdbBUk2D1gSfD0=;
        fh=rdNzETgu3NUJwVihIwdTl5CM7A3e6dqltBunD3PFmpM=;
        b=GC6iLZhyqHRFCM65Q0x7efWL3zzH9t+4BauW0kEODhocYpBd707wuI4ZEJbUNupztM
         Mx8wo/s6nyuBxkf85d1C4D6RvZd25hbcQGF1+NR5joWkd2I8/8nWINqQJvgY3VvpNYK9
         /3Q17tBirQiXqnIJ7A1pWp9A15NloRWgisgrD9tMGVmBA2VFZ4hqyMnIWcYtrmEd1+zQ
         rAhLUJziaPFSxpSekvEDH9F1z7UCTfkeFIa20GJMuZFehd1U/c7U4GBEw7lDVnimElcD
         9FySbPwEGlKogin3gV9UGPvYqJQVHgqK7Jkv/uXPmgbVm82p9UqA29Lr431ZB8V1U6OU
         Q15Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777662740; x=1778267540; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=nm6005Bs28bikl/uf0zpE9w9BeJo6zdbBUk2D1gSfD0=;
        b=ndZOySKx4CFN4RTUl2aG7Y8f1wOJP1EEp+deLrF6SI7GbcpaVC+1kq31jUgyWIU8vZ
         lrRbgJYjVjJk2Pt+He3T/OPdU3AAXVNixGslVi1WJ/KZt6btbl5t26vfoTOeI8sK5AsW
         Be8+BtkjjB0KYu4lJUTqjbCDlswuW/JjitzeM8p+OcHkp8bmXiPcAeZuoTf1kHWE8sk6
         W0SJFm80URsB9EtGxUjGueNtmeupA69354K8DxVacyYI6WjzQHc7isJpOgVY/TsTvui+
         lw4XNajs5upZftABOkbwUSMHO2QPMvk53FNqCKV3Yh6gTp1zp6wOD2OMBX3KVl+eIEjX
         uQ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777662740; x=1778267540;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nm6005Bs28bikl/uf0zpE9w9BeJo6zdbBUk2D1gSfD0=;
        b=G8gK88JazBt0yFev86mOHGnoAwshcuHR1Vh96kadHzoalE9nEmNAahZZOb98g/AjkM
         evSwHZyAZnn8tcP8dp1hnQEhD1QPi40RDDeyO9K1EGCyCk+gu6w8k4V85jkqCyh14zHV
         V/zkwVdNauzJS3Rxaq+/7wn7tQP0sCJ+2WY9/oyLkkRcJRtQARhRPPQy49ARnpRRzOS+
         x5+PfXM8fmzLjIOy/ZGF4myWchH/0/r/GuzDmJ2+7yrVxM4H/nE2lKbka7XwVIgq7PvQ
         Wj/nPqnYhOQviSHz4w44xTlDUX6o1WVpuTXntg6fme6kuW7u0wSMll7MRY88JyQT8UAY
         y5hw==
X-Forwarded-Encrypted: i=1; AFNElJ+JgoMXuAWYev9uEZdgui3Lr0QqMOxDrBBr7+5jhQVBYxQlpBpCzwVPsP9Ufuf8H0FbaYlw+62XxNTWLFM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/mB3ClneSmdKYrfz/B8tiRLu6dnYaW583BxjiTtnSeef8J8Xw
	mXJkQNDJyzDqgRjqjucST1HB0kpY2tJ9Xrj2acyz2YiMQQByRqM3BlsokM4oiB2rbd2UwqGeWY+
	MW+QThpWioj2BdrniI3KFGxr+/aB+3SSfIdhEXqud
X-Gm-Gg: AeBDiev7V0OqrCpI32p+WKeWDgi8iDqZbb1a3QAfQqBBR8i+bXsEAZj1fJjGp1xzZeN
	z0arLrop1iZ2EcX24tRFIbqXaAJRQQ+4yIR1SVdMEXcdRLEZBIU8gqB2fNGtX8bKa4b4YvUyqJG
	p7EKRSFR93n8+mBGlgQzNh6l6ABLs/YGQcE/BLc3Ss9ISHMSbRXJfGhXAFnP1heygBV0omyVV5T
	RunRcq8ojXAq2AnzwgorscmOX1V1r3hYE3QSPF60+wV+53HgrysgIJunJRijCgflcKT9Su7xy5P
	UGzt7UOQ/8nVG9t2GxmbVgXaYb+oSoxIniDeo/1Uou+wh66fUMcuGaO/UXj5IxWAZdSWo/iqd/h
	63cxBQoLbTm7+fYc=
X-Received: by 2002:a05:6102:4489:b0:618:442a:9e76 with SMTP id
 ada2fe7eead31-62d8547deeemr417754137.10.1777662739743; Fri, 01 May 2026
 12:12:19 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 1 May 2026 12:12:18 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 1 May 2026 12:12:18 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <0c15142ecf6689ebe31a9c0f6f331398fc04f6d2.1775874970.git.ashish.kalra@amd.com>
References: <cover.1775874970.git.ashish.kalra@amd.com> <0c15142ecf6689ebe31a9c0f6f331398fc04f6d2.1775874970.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 1 May 2026 12:12:18 -0700
X-Gm-Features: AVHnY4IwCQzSJJS5oI5H0hf1wYJTfgd9UcwRH4ft9v8o5wccryGIDOCmRLQ2i0g
Message-ID: <CAEvNRgGP4ZHz9=MOGybGwe2A4XHkVF6nXnr_KdHavz1rR62U4w@mail.gmail.com>
Subject: Re: [PATCH v4 6/7] KVM: SEV: Perform RMP optimizations on SNP guest shutdown
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	peterz@infradead.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com, 
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, 
	jackyli@google.com, pgonda@google.com, rientjes@google.com, 
	jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com, 
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com, 
	darwi@linutronix.de, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Ashish Kalra <Ashish.Kalra@amd.com> writes:

>
> [...snip...]
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3f9c1aa39a0a..e0f4f8ebef68 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2942,6 +2942,8 @@ void sev_vm_destroy(struct kvm *kvm)
>  	if (sev_snp_guest(kvm)) {
>  		snp_guest_req_cleanup(kvm);
>
> +		snp_rmpopt_all_physmem();
> +

I see this is what you suggested in [1]. The time-based batching you
suggeested works because adding to the workqueue when there's already a
job just does nothing. Thanks!

I think optimizing when the VM is destroyed makes sense, in most cases
for SNP VMs, we don't expect large 1G blocks of memory to be shared
anyway, so even if we try to RMPOPT on every conversion to private, most
of those tries would be optimizing nothing.

I guess the remaining optimization would be to update based on only the
range of pfns where guest_memfd has private memory, but that could be
done in another patch series.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

[1] https://lore.kernel.org/all/31040bb7-653a-40f9-8899-40bc852f7e1f@amd.com/

>  		/*
>  		 * Decomission handles unbinding of the ASID. If it fails for
>  		 * some unexpected reason, just leak the ASID.
> --
> 2.43.0
