Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91483905EB
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782237046; cv=pass; b=qh47bcIVfVSemC8YrFKP2togcGJtUgLGlOcwou/2SalKGdENNPkIL0ovuZZTJlqMpXsk6TT2gxCIfruZ4nB9GwL6qJtr46xpHCq6oeRa8+ytHwJeXU3ImxMPoz9WurXabG04CgpDKYK/yTF9sZaOLwZlXAYSAd7anO1GsIZF5Yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782237046; c=relaxed/simple;
	bh=ao/gjLtwrPN9EkIIj1OlYbo6h/r99kzcN9bKH22zQDQ=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JtviYOq7vZOFikDafpP/JiF8QU1rmsguxSD9XF5NbN6FWkan7S5lvxCUhkoIQlzPt8R5O/0+tE29IyQmE0UbSzWlvoi6K6QmTf2n794DhhkcSsP54rwCZDjI9mp8Do28UFfXEYZKPBUOHhDLdq+jVqaIkXBWqtemrjo75zNQk3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i6bLY+y4; arc=pass smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i6bLY+y4"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1390f75d8bbso283770c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 10:50:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782237044; cv=none;
        d=google.com; s=arc-20240605;
        b=N53CmWaZsdAFSqCVWMW8ZQAaN16mZV6NpZokijpgaYE5kDeEMI/rBXmAatYCVYzFnU
         SP/InSh7RZUhaxdr93LtObsRxogCmJVTgUYrTe/kR0FIFddpUDCJSbes40pcTVtgZ2DK
         vYm/CFkstNu/qggUT7rtOpKovuc0N6XF8p5RiciQfp+XC3ybn3VOEBHxgrCmP8zUxni2
         1aUd+hHnw89BO2DlpPZNtXZQNvfNFcfniXYUkcap5ZszHkXZOlA2CAtmwxq0mikOKIFJ
         VB4vG/Z7+WZVY6bBzsdMUdkO7mpB5siRMnkgXk/JpDyy8D6yWlrDrPWDaowGaTtb2tqw
         gJXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=iaH6OIuh4aHHZqieJze8syUo2Z1c4+x2P2tU6UVJVNo=;
        fh=F2WQIf8XRbY8p5xvjIPkJ7jhXZrYWZYC4GQROS65LVo=;
        b=edbz1NN6RzmFuDesV+pM2G9fkYDk6blTLSZUMzb4p4xdSAKlpyLywJbtND/47iei9f
         RtWX874sKuODJh4Jw1l9BFDahZPJZ05+1uxq6jp3PYct2Q1lQFQ3tTY1RWE6JUHTmY0l
         pHmTnydtpdNv7rJ73CDddvPmJTTbeyV7gLnqeNyIMW6FV8OxHpVeSxY3R+ZYuzud8U4F
         bu9R0MfBAdnDXPVjR60Yu8GriR4Sh/APN0tfwWE3p6M/wd4XXMmmryd6+cxuwXFGQ0va
         Z3GqZGCCEXFdcPpFqB/8F0UzppK3mfhucyp0AnSqDFKXLJ0OTB4HtvY3sqS0atyQaANX
         mQrg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782237044; x=1782841844; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iaH6OIuh4aHHZqieJze8syUo2Z1c4+x2P2tU6UVJVNo=;
        b=i6bLY+y4fheSs6q75OLzzsOqa9l01NWekCcBaj6vDWzRrNf73Wu4MLKQ8hmiwJfnGc
         T5L0BT/mAWOekSBW6iurWAgNjou+8CLxl62vfTA1iwQn+VsyLh6Vm69w9wJt8mFjNZHW
         65H9iGefXXfZta6mAi4Ir1iT4F0qMd34X59g/aHqqiMIWrnqLQxotAzq1Ca7wtIrfxjk
         kWfKyDQYzse3LFxaRXDz+JBSoLstq4q4ckKtWXUh/tJjNdjuMl7Ya4Cbv+WRHv0875rS
         j68iL8JOvYnKfj7/n8WU+gE4kxuu85V7FbV3MrWbOTdTNPlHy2w2lZ8d27Y1fhEf2D5b
         D9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782237044; x=1782841844;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iaH6OIuh4aHHZqieJze8syUo2Z1c4+x2P2tU6UVJVNo=;
        b=PRibolakCmlSflYbFmSfo3wZTKkECzvq6JOAohkbd8thBH7ARJkDOtzjGVQMwCkpbo
         2BmrD/0YFn8FISqyYK7rqqCBEvVibWsVu4fMhQyMZ7FMsQ58Vl6nyB0WmXrWoVbxRmct
         jhzrkHirivtKepryLUG8qrYEA4EGRKCOVQUJed/BAsNDf43dcnAtd9ZGOdg+vYWo/CnI
         6eFsaH2Ee/J2Y/Ee3diJX4XOhCEV73L9xLG/qDFU7WVgnHHOh8ANzGi7a9hPPLVVFloM
         LXc6lbkEK7R8XLJKt3BbJvX2C6fMNSxhDJqvqL1OjWbSmLmr/i29vRJPyf597hHMhUsM
         xhlg==
X-Forwarded-Encrypted: i=1; AFNElJ/WeCUxyP1gWQmkqgUB0u3zfqBMAYCr32DEk9CQCVCkszRG+WUhKb0lyqKHktNCwkZF66M+NrPvTNvciTE=@vger.kernel.org
X-Gm-Message-State: AOJu0YywjpzQwqaPq/ZA403+u7P6dOUp6uvCANOkMWJO9h2IzuGQlWyg
	uzJI01AJjA1NCTpatNngupuAM8DvJ+uLnn0mKmS1uKKvmxfEhDmbHQ2JNjYt0l+t9aNAxxtghlB
	3CItzGV6AFrQcWSG4AIfHvmTbJKTPDKxea0uHoZlF
X-Gm-Gg: AfdE7cnddWuMtbHssg243PY1To4gxHnJCUI8CsdtU1/aX3Xhi37Ot06XAgjSKAA0IUT
	Ppqc0IC8cmugPGSr5ze2SUBZ0pO7RSeBlYVBLtm87oB5mCDqAA0/YIFF1uX8Q92jMZaMQGtFyhx
	Ia7YCi+jJhTp3JBP8seV2pvQyG0oHC6ZWD9rYRPLPqA/eX0gbmxIf7u5Y18brKMwuoz9PGsP2mQ
	wsuhSKwItF09uBRHvvUibnycykpMAdePIx3hQ8cQAZiLyJHq4vLQC0/PBAoOV1lyqV4C5eSw44L
	yI+VMr+mv2osRKpaEUz8L54QGTE6hrD1SD7EPVq12g+7JyiTbN9FWPx4mEY=
X-Received: by 2002:a05:7023:b0d:b0:12d:ea4f:99de with SMTP id
 a92af1059eb24-139c5b9d56amr3139260c88.0.1782237043068; Tue, 23 Jun 2026
 10:50:43 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 10:50:42 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 10:50:42 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <8c5f4082-e3a5-4f65-b058-33938a7ee324@amd.com>
References: <cover.1781419998.git.ashish.kalra@amd.com> <de274c2fb3f794ff1f19f0c96184ee50d04d1282.1781419998.git.ashish.kalra@amd.com>
 <0fa0bc95-ff31-40c5-b083-3c885d09d0ab@amd.com> <8c5f4082-e3a5-4f65-b058-33938a7ee324@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 23 Jun 2026 10:50:42 -0700
X-Gm-Features: AVVi8CdyhQZDa5lioZ66r0smztGw-BoY8xCcu3T1y7FPhbFJD_2pARoB-P2VDng
Message-ID: <CAEvNRgHPbb0ARYS-E4N=fM1eG5fNshKHSwdWj74gZdzjgwm4Rg@mail.gmail.com>
Subject: Re: [PATCH v8 4/7] x86/sev: Add support to perform RMP optimizations asynchronously
To: "Kalra, Ashish" <ashish.kalra@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, seanjc@google.com, peterz@infradead.org, 
	thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com, 
	Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, jackyli@google.com, 
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com, xin@zytor.com, 
	pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com, 
	nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

"Kalra, Ashish" <ashish.kalra@amd.com> writes:

>
> [...snip...]
>
>
> Yes, a simpler implementation will be like this:
> ...
>
>  	if (!alloc_cpumask_var(&follower_mask, GFP_KERNEL))

Perhaps have a WARN_ON_ONCE() here so we know rmpopt was not performed?
Not a huge deal without though.

>                 return;
>
>  	cpumask_copy(follower_mask, &rmpopt_cpumask);
>
>         /*
>          * The current CPU's core always has RMPOPT_BASE programmed
>          * (snp_prepare() required all CPUs online at setup and CPU hotpl=
ug
>          * is disabled while SNP is active), so it can always be the lead=
er.
>          * RMPOPT_BASE is per-core; exclude this core from the followers.
>          */
>         migrate_disable();
>         cpumask_andnot(follower_mask, follower_mask,
>                        topology_sibling_cpumask(smp_processor_id()));
>
>         for (pa =3D rmpopt_pa_start; pa < rmpopt_pa_end; pa +=3D SZ_1G) {
>                 rmpopt(pa);
>                 cond_resched();
>         }
>         migrate_enable();
>
>         cpus_read_lock();
>         for (pa =3D rmpopt_pa_start; pa < rmpopt_pa_end; pa +=3D SZ_1G) {
>                 on_each_cpu_mask(follower_mask, rmpopt_smp, (void *)pa, t=
rue);
>                 cond_resched();
>         }
>         cpus_read_unlock();
>
>         free_cpumask_var(follower_mask);
>
>

Definitely better than the version in the original patch :) Thanks!

>  Here, the leader exclusion must use the sibling mask, not clear_cpu(this=
_cpu). That's why my collapsed version uses:
>
>         cpumask_andnot(follower_mask, follower_mask,
>                        topology_sibling_cpumask(smp_processor_id()));
>
>   - If this_cpu is a primary: its sibling mask contains itself (the prima=
ry) -> andnot removes this core's primary from the followers.
>
>   - If this_cpu is a secondary: it isn't in follower_mask at all, but its=
 sibling mask contains its primary, which is in
>   follower_mask -> andnot still removes this core's primary.
>
>   So either way the current core is dropped from the followers. (The old =
code needed two branches because case #1 used
>   clear_cpu(this_cpu) =E2=80=94 only correct when this_cpu is the primary=
 =E2=80=94 while case #2 used the sibling andnot. The single andnot works f=
or
>   both cases).
>
> Thanks,
> Ashish
>
>>> +		goto followers;
>>> +	}
>>> +
>>> +	migrate_enable();
>>> +
