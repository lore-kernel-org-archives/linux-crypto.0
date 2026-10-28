Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793224323;
	b=rB76092kn/3BCxgpPxqKurAMHe3dMlfEvaIu3zcSyFeKIN1CcHAuBJTxh2+IE6Sf5hqB
	 Jxe+BrNChGwMoBaZ6vb1lP49pJh9ZkdgiRiMMm6Q1Lv19E9osOuq/uiqAuEPvu6VjJL+K
	 7z75KOPcSz30bn3lc7gfq5Nw69IbqLWYp+e2sYBHvwb0Qr6rKpiuy9jc6UCOpsRN2vE9S
	 jh0NdwLB2zO2dqe/izyrEJ7rzbioBZrLTbrx0hBqYnAjBBs3EWlYsyZmYxAs4gotCMK9d
	 KBo/LboFz5kX6SCCYVUTZdLs1J3G3utFZpGy10vx0vzOYecDmaqYFRGxsg3gUpkyQZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793224323;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=mPtExrnKGOMQtspuIP7yF8Ip7fswDzEEpF0H728OVnI=;
	b=1kbEKFunGBcg+rpkeqwIKv9vByebv+GOr7Ap93PeRyEKLqC707s+tPghOPDxJH7XEF6e
	 KDNiQ3F19vnoBUHgUW518AONIGSQUkyp8SU05NNOWyi4VXv2byI/gCpUnQPxHcxF8ulBq
	 zEiaxVugucgFtBk/OPSlvaCu0UezRJXSjpeuzBDccN0vdykKm0qkE1ojcZ+oM3Nyq3pD/
	 ghUAEv7wdqd7UfVgxZiw7QWRln0LiQOAFqvpfbmu4afDXmru1qLv+yjGjv1yDON0obBMn
	 eO3NGPloHPtTX05k7kx47tGcYy7VbBu7CkqiWIt3rqjC6r6RRZ29uLtIOW+M1L/Qovg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0MVKsgzc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77792606A31F
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 21:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77792606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0MVKsgzc
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e9995ce866so13851605ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 14:52:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793224323; cv=none;
        d=google.com; s=arc-20260327;
        b=R8GDCbcUxv3B+votqTtSD5aMub/e8n1jtEjY+/z8EIqwztvEmyyilqeObVSxu+vqE8
         IDyv7rtpa9lHFEvyWesl5tX0MItBO9G/oMQdB+VMSeXUBFEH1uxDj6zfso/RtzLk1+JY
         WoQ9xb7HxwxcURYSjDhg/AAKSf893WwZ45tN6PkIZBdH8oTSMIXLwGPaKXUdEpbqrhRc
         Q+Yq1OdYqPSsOlavVjFobzfeDDuHZOenrBZb5QVFrNMhYZYXjnFZUhtbLEVu3azXLQPF
         4CraCnphfa+mgUpSD+G7avZq2MjIn3EOkJ5dDQY17eYzKLztlzd+KNICkgdyu96FRGYy
         GirA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mPtExrnKGOMQtspuIP7yF8Ip7fswDzEEpF0H728OVnI=;
        fh=FcTv8nlBBKWXrUS/HKCHNFCStQ+9VFtbPN8bWjvvwxw=;
        b=VfKiUsXazoNwU6qZhA5P1WSniQw6NTaVdYVYumwG7RRgCzu7ov+TH7FObwlV7srQRV
         SamBM5ci+SiAn8x08QExRWkyGu4tEjemkASXfZ1j2MmVucbvVN2gJLtqJWLUbeRI7qzC
         84/nWKnFsze2lTEiXu80ZuFx9zUKqEwphQamkxnqZXRg8Za7cxcNeC/hPi676GvxqX4Y
         PKeAoKv8NdNARj1p/Vhr6YvQCnnDyn5oOZ9PB+0wG+qk4I8lURYUGemkyQKRIIZrywxH
         yAJZlCgZaJnPKBS6AmbNOzVHDCvjcCQIjWQ4QEIXNe+UmhCIzHmofMuxKuluI5OrzrXx
         YTxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793224323; x=1793829123; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mPtExrnKGOMQtspuIP7yF8Ip7fswDzEEpF0H728OVnI=;
        b=0MVKsgzcw3XsZH5xCrtY10JGwrODxblZvE9fjvtxdDOfDlIewMlbTr/AUZBdZAdIRv
         0XG1+CGZb8xXRLmCTL6fiRGDyomJDYNr4QM/uqJT3iK5SsdywoNabbCFBqs20TpdPKHo
         in5si+Hxd/5IJI1ttPwmNlRbnyEf7ik3UqRrWwEDueLvq+WLrU5IvQztNMXNwEjvW6dZ
         lda1In9bhFdsinJ5V6NZsO3emcR9VATiODrcC+AuKtafi5TVHEkqYzpz991Ua0p3pwg0
         COypZaI+4OuJhTuNOwGZP6bn2ajsgpsRfQfS895cWAKcgB9eqUvxR0b+lK4tm8EuZVwp
         0RlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793224323; x=1793829123;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mPtExrnKGOMQtspuIP7yF8Ip7fswDzEEpF0H728OVnI=;
        b=fj3C7Jtcpci6APjz1k/AXC4d2xMA1ByCLL07owXb61yhl6iAvydBZq9kBrk4dWcc7s
         QKghGrnOrz+TylKB31xRsLhFdAm2CsXmZgpzMw/wtXIpsLIPi4Ct2to5Jb1X8ezPoYds
         b/HFjkZ1oEnIqJZNip1cYqVrG4kJu0r1TxfenipR4onUL4C/4K8aZT6/O/IAdO24jKNp
         md90RmdZts1X5Gx91NGOSpBf89CsKPGowhGt3sCY4DY1MPBQAcC6T8OU6UbxdrK/QQLb
         Rhc6RE33ZKy9PBGsaAznIinxaTsR3Ap93kEsYrI2gZ9E6BdFuUJtvtTxqmrB1D0Rre5n
         3S1g==
X-Forwarded-Encrypted: i=1; AKwUvBx0aNOsuy32MxTumxqP4G5FFPeFKGKoy1rQ/HK3Bp6S5iO5M3q2QIeICTtMYgChWuzEvA1Fj84CrD+h1d0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJfOHuOz3cWkjU+AOds1c2xqjkB8mB9dG8ZXyF/dvZcsb9AlD3k
	2f4+uaU9DX87b/ioZpuXEqiH2kuIJQdZsf4cfH7tG0mEVnOqYum0T13MolwX8/1NETWqf+DSq/F
	u5lgknYDBApLHEko38/a5QymSj0ugkc0=
X-Gm-Gg: AYBFou3fLj9mZzGnjCKypYCWWIO9PokO3cgI9hhstsGsFQGsj/wcVXY57+vmlGr9xto
	cWqaMsCMfr2bLvdXwQiTlNWKPbJXOmpGZqmeB8Om5jaR2pg2QIkjXaRwPRCSnuwVwlF4ryYrleO
	vOXuJ6HRwFtxob9bSwkPUh+AyGMka1vPDk54pkeXOIv4gv4QSojV97RF8QxYNoXEQj7Iipm5elw
	THWfAG0YsiM6WNfeLFwztK0TbosiOAM9FK5MWJVGDl4G564pPOOyMwkdTPrhF651T6XInv3IneY
	HxcgH/stEA3/mDUThYBjjvVhFuJxo70UcD6tQl4dJZAg5m/oxZkakYGcyaj7F+VjJWp3MV1b+m9
	Z2PuMDAxFp2QNqIrkEPKpFG6fzQ6YEkl7lwBKrps=
X-Received: by 2002:a17:903:94d:b0:2e8:1d5c:f6f2 with SMTP id
 d9443c01a7336-2eb003bd5f2mr34821655ad.24.1793224322720; Wed, 28 Oct 2026
 14:52:02 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1793216372.git.ashish.kalra@amd.com> <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
In-Reply-To: <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Wed, 28 Oct 2026 22:51:51 +0100
X-Gm-Features: AclHuK-lLMUGo00CsLuRjBYLJYO8QfoO65WYw2V8BbtyozSJ3LTmNXJa2V5HQzw
Message-ID: <CAM9Jb+gBzgwvtOkV32bNudAqb4sU5+40zuj54py+JoLVvV+naA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	peterz@infradead.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, 
	Michael.Roth@amd.com, KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, 
	Nathan.Fontenot@amd.com, ackerleytng@google.com, jackyli@google.com, 
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com, xin@zytor.com, 
	pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com, 
	nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Segmented RMP has two independent states: the CPU *advertises* support via
> the X86_FEATURE_SEGMENTED_RMP CPUID bit, and the firmware *enables* it via
> MSR_AMD64_RMP_CFG[SEG_RMP_ENABLED].  A platform can advertise segmented RMP
> (CPUID bit set) while the firmware leaves it disabled (SEG_RMP_ENABLED
> clear) -- e.g. through a BIOS option to disable Segmented RMP -- in which
> case the system runs with a contiguous RMP.
>
> snp_probe_rmptable_info() clears X86_FEATURE_RMPOPT only when the CPU does
> not advertise segmented RMP, or when the segmented RMP table probe fails.
> It misses the advertised-but-firmware-disabled case: that path falls
> through to the contiguous probe with X86_FEATURE_RMPOPT still set.
>
> X86_FEATURE_RMPOPT is a CPUID bit advertised independently of whether
> segmented RMP is enabled, but RMPOPT requires an enabled segmented RMP.
> With the capability left set, RMPOPT_BASE is programmed and the RMPOPT
> instruction issued, both of which #GP on a contiguous RMP:
>
>   unchecked MSR access error: WRMSR to 0xc0010139 ...
>   general protection fault ... snp_enable_rmpopt
>
> Clear X86_FEATURE_RMPOPT on the common contiguous fall-through so it covers
> both "segmented RMP not supported" and "segmented RMP supported but
> disabled by firmware".
>
> Fixes: 15d974be0a3b ("x86/sev: Initialize RMPOPT configuration MSRs")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Tested-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>  arch/x86/virt/svm/sev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index bd70c4d0b774..cd0412b9d251 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -827,10 +827,10 @@ bool snp_probe_rmptable_info(void)
>                         setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>                         return false;
>                 }
> -       } else {
> -               setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>         }
>
> +       setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
> +
>         return probe_contiguous_rmptable_info();
>  }
>
> --
> 2.43.0
>
>
