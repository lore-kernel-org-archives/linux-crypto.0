Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A33433F38A
	for <linux-crypto@vger.kernel.org>; Fri,  1 May 2026 18:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777659166; cv=pass; b=q6za0MCPgLg/IjAhBek5lpcOqYv+5NSr9yvfWBHyX47iUh/ZIbD24fh9KW5GvoOZgsUCPTHVSTecAl5sfuBnSqlZAgGKLbXlKCZhEHHYCic26gCBzU7eVvXaX0a+r0ea5PACVnsgMQlXVjCbgdssO9yNM4wJZmLNjPq8wYXD998=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777659166; c=relaxed/simple;
	bh=Evb7pUiFabj+kz7Z4hmGLA3FozrlLW7MTuvahXfdXYw=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bePyr3HPOveDfbYtDiFuyJMxP1/c24h8ZV8csmlpv7NVYhz5+UxN8P7Ua8Vk8l3bDctqxgKEFibNjfNIQhR4QO2y0ROSQ1eqGfReB0gkBpmsfCHm2rn9/G1frsgqOUFrnU4ERbrSr+9/NfFXFB6B4IltbBxchmsd5cP/evKjIbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fz2xMDPu; arc=pass smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fz2xMDPu"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-954997c9014so891758241.3
        for <linux-crypto@vger.kernel.org>; Fri, 01 May 2026 11:12:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777659162; cv=none;
        d=google.com; s=arc-20240605;
        b=XISYCPL8MQFUpfh8qHiVY7oM1QRGaVdabnMnocGGqa13fBU9eivSND8OqNBU4zFy6J
         DpP8qJrx/uBLNm0lQpV00H2tIsn7zVoFvH4UgpsINdhcVHSGlKoB+shjaz1O/hGyLKtW
         +OJdE5fm2NbI7dCXpEcVdBEGWfEIo4D1vOWQUm4cms4s5wupG3wOzqqXjDIDnpEKzzKB
         //tlOW+lzmaKv/mkedkNuT5Lz32wUN6SJKOgy3kxsyEi1nQzThuiM18wmi2VpgdAoeTD
         lpg/cg9YIQCgxRB6qi907fwagncLiy/c7PKGNUILVMryZlO6l4AGIMk2CQGLHwgy0xb/
         XvOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=A/Y83NyQH5pjjwFsH83zSujxJ4pp2R0dNDGRnTykyOk=;
        fh=pJabyFYxw39j056vWhI0g+SIasrcNgXWmVcpChnjCnQ=;
        b=Wyl7tihb1HKXH8Y1nw5rrk7FYQ7WySjSsM3biSZJ6kNk8fGg1epqxYG++sbBkolHe7
         JwxwZNlSe2OVpGMFdMFdE7ffO7wXlS2rJvWKITVq/RfYrHSNcyEVVO+9FHtBpplyAx+2
         NCKQjD4cgHhilgUc4lib1uX/dhARagHEsn/MSRxLL0JnokRDVT2hz/iYCMBKr/dPOO4F
         BGLdM/kYCfqHJkcaDWodmzwHTWEoZvVR1W3NOlkbbdyb277n5JXvu3VfGxzB2h3nSa1a
         8EJEEBnjGE/LgOiY8OJRWAVyAk1HvDzkn3NzomlX3neZtXQUAbASX4n/qEYEKw0NXMIX
         5TLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777659162; x=1778263962; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=A/Y83NyQH5pjjwFsH83zSujxJ4pp2R0dNDGRnTykyOk=;
        b=fz2xMDPuAiN1GvGYv00WHHCXNhkiUmU1fUxwtQD3Endev+5cLzROkK65gzFBFAu81E
         UaiRueZk7P1+cltushahJ3seUetnjSN4wPsIp4QNipIoAw+0ku0Q53ChumDm9zQOeJmu
         dPdNOAyhBfQUwkPdhUZvBayOoGnwIFGRmXuvHFe5W5ZsHFgQqGzS4BzK7SkvxIB7zhOF
         aHg07/unMM0YT1/yZumCc4Gph6cBYRDog5tN+qnq+vPAZjrOhMO2416ORxUoIsQwfpuq
         q/5nN0vLWv5cX8PFPy+QFGphX+1ngooLH0RcYxv2fpH3q5fGZNC6LdCl7h3M3HIUBRFz
         FJDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777659162; x=1778263962;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A/Y83NyQH5pjjwFsH83zSujxJ4pp2R0dNDGRnTykyOk=;
        b=CJSlD6Zy5w+J/W+wnkudt6e4VmTXlFTsll9RmSUc1NjMSxigLZ0YWlj7xcNFljBVUN
         Rd025u11wBp+JMMySRIbu5Q+sdgWXUCt9LGg9+h0BrH/N+kchZ6Rc86OtIuK0ZKJtQyf
         G564prvicjtKDejOx5NyF2pXVKIPHQHPS4B6lFvCKWYSPiW9qocv8PkAsUoDfbU0UQtN
         NYCiri7PIeC0CJDP7WLftt0MnaShkMz7ZGKbP2L44xgKDDd6r+DU9rpCAPDEj8xruzq7
         EpmZGoXQup5gm6SMvTWm/hLKx+AFJ3B9AEVhnYnvEIlM+lCWzP/3ngbhOBlr9lEWaFj8
         IR/A==
X-Forwarded-Encrypted: i=1; AFNElJ8fd23682h14VBxioG1KB2JhowRuUToRM6J4MyfB7uqFF8ItI1v3vgc489nSWaD8DBhRAuTb58BrByMj50=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+IZ+tmuNJoXy2AhpflNGHPhpNsoess7t9huj6ZpBFnmUyy+/7
	GeJBH+ga7W9LQrJ/dsdWuVo09jWM0DHU750goXIz/gnA99V6gZD21DwBkNjXGrA1RQAvaHUDy5X
	F2+fyqbpxQKhWXvHRSBTQXDpF7f2/jqq+2q4QmD1C
X-Gm-Gg: AeBDietuyJOHQIhmQqUio9xbWY/gGNVTjgcFzn2gcnZVv2U/I965ulTPztHhwfb9vq2
	IoD/tbBz4ZlC2IoxLh0bURk3ZM6ku5aA3J/rJdI1kTMCMaSu138LXDIfWbS8QtbX47SLr91Zcl8
	eyrP/VUJFMN14F3YI00fEvdB6coXgpZ9JLKY0S+PxriHcPLG05y4Fpq3D/EC4/UyWufd/OFQPwp
	UduzK9JxjmnFBJ2P4EESXqc2hOzQZHhT/u0rJMD9m2RoIyzDS9BqjKateHduP0xQ++fL/KE2rAB
	ZEfzi8M3fA+i8QQprpCTADHJi5NUXUf+HulW0QEXJm3jzEKhZmNd1Ml9VTHQrWrKm8JUw8EqG20
	3015xF1UQV7FGBUw=
X-Received: by 2002:a67:e116:0:b0:605:5d09:8631 with SMTP id
 ada2fe7eead31-62d87c925d5mr189727137.29.1777659161523; Fri, 01 May 2026
 11:12:41 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 1 May 2026 11:12:40 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 1 May 2026 11:12:40 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <846263383f9b6a08fc87ce6edb931c912f68c60d.1775874970.git.ashish.kalra@amd.com>
References: <cover.1775874970.git.ashish.kalra@amd.com> <846263383f9b6a08fc87ce6edb931c912f68c60d.1775874970.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 1 May 2026 11:12:40 -0700
X-Gm-Features: AVHnY4JCk1U3ofCsegg3s5i-0XLTqrNFTyFRrFp-Tgnyf0yeEIzSs60Geh1Ze08
Message-ID: <CAEvNRgEC2NSROZWz8uxnOSD6t8s1KmmFrr92=e8s30PJzYhQ1g@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] x86/sev: Initialize RMPOPT configuration MSRs
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
> +void snp_setup_rmpopt(void)
> +{
> +	u64 rmpopt_base;
> +	int cpu;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
> +		return;
> +
> +	/*
> +	 * RMPOPT_BASE MSR is per-core, so only one thread per core needs to
> +	 * setup RMPOPT_BASE MSR.
> +	 */
> +
> +	for_each_online_cpu(cpu) {

Dave mentioned hotplug in v3 [1], which led me to check. From this
series, it looks like RMPOPT won't ever be performed for newly-plugged
cpus, is that okay?

> +		if (!topology_is_primary_thread(cpu))
> +			continue;
> +
> +		cpumask_set_cpu(cpu, &rmpopt_cpumask);

nit: perhaps flipping the condition is easier to read:

    if (topology_is_primary_thread(cpu))
    	cpumask_set_cpu()

> +	}
> +
> +	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
> +	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
> +
> +	/*
> +	 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory
> +	 * for RMP optimizations. Initialize the per-CPU RMPOPT table base
> +	 * to the starting physical address to enable RMP optimizations for
> +	 * up to 2 TB of system RAM on all CPUs.
> +	 */
> +	wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
> +}

[1] https://lore.kernel.org/all/ab41b1d8-e464-4ad6-ac07-7318686db10e@intel.com/

>
> [...snip...]
>
