Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53FC2E62A9;
	Fri, 18 Sep 2026 23:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789774806; cv=none; b=sVFo23JhbNJXTngbuZWJm/aP4lTfloupvTzi5Y+ZKiyd7/5kBKnQ9tJak2dPBJzaqqshjj9bmmFoxRrqEmx4rAwx+9WSerHI7HBYawSRay37P/pK4P7a9xN0rQW1DMKV0FdgrOl4JVTInZspUlgOduA6GQE7jyBl/Z8WuvvnIX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789774806; c=relaxed/simple;
	bh=f1i4j4wFPGQ3PlrQcFZCJSySXFx3gJOSaObAZfFD6z0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N/wl6toIan2uICisvzGCiHv1QISA94SczZ5lZuS5X7jlXg/G2pG6bHTqcHwuxr3xxDcgHqw9ew+Tl3vyzQRdhckO7BfFDAvdLKDGx2zSXxXq596Xvaueiw7+4FO1FkCKGPcyp5QbQFwetBnc74gvD76l9ModbVO84M3WGT9fkvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Gq4dvspR; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Gq4dvspR"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2D3DF40E00E5;
	Fri, 18 Sep 2026 23:40:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ovnvQ4Bb8XjR; Fri, 18 Sep 2026 23:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789774791; bh=RQiq7JrJpJYJbr52IzNuLiSYVxDM/UptMCGU7a7i5fI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gq4dvspRN59lENIAsfQtHq+auv+Uk/ZscQveXp8by9nxGcRecIRwDdRbEyol/dZgX
	 hUHXy1Cg9yIr1L4Ii2LaZy1SYABQKqaIbyo9oHT9PAiM20cWA+vmtYOkfSO3YT3wb1
	 5qcstlueMNOTnmKkaegf2SvsYb2vBHzJliYVluTwOt+s98jv9+7bdiVICegS5ShC1S
	 i8rjvMP+kJcFG7ZF3dVeXwOKaua38VVNizTT+ODBoZsRD1uCV4327+tD3g2fN55sb9
	 VIR5JvBA0pgCNww/RURMBs7mZj+a0GFo6+Yk/8WfQZM/HECdxbDEdeFwcaF+iBQ/fQ
	 C5gdT3dKcoeicY1sqRSdoqmx4KPuEoiHrbhywJBb8tyQpQqglLiRJn3BcNGuvnqIGA
	 lA8xEtKI1csSaYto6txGYrQOp8Tw6mbiPUj9MBoGqQYy2GgDge0pVFWLK7H8laCyNg
	 ns92X6Z4eHotnTtNbS/+eub0mLq+wzzZVVGGDeQrb2EFobQ16hMaDbCJ70nUdLR6Qn
	 TN/w/k6sKU9t5rWwk1i6zkZrh46JRwMMCfFSqD3FuVFSJprotcJfwKmaUsBDjjb796
	 wuSELJsjr8/cqq+AoTcDLFYe/jrgqEFLCCZqNhB/W5PCmmrfsp2moIxV5EM0zxDBG5
	 mTXQPtfP5PMftuYEoKo3feko=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4D36D40E00B9;
	Fri, 18 Sep 2026 23:39:17 +0000 (UTC)
Date: Fri, 18 Sep 2026 16:39:13 -0700
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, ackerleytng@google.com, jackyli@google.com,
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com,
	xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com,
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v16 4/5] x86/sev: Perform RMP optimizations asynchronously
Message-ID: <20260918233913.GBaq3LoXAJHIHv5abI@fat_crate.local>
References: <cover.1789594774.git.ashish.kalra@amd.com>
 <daa513fbe8f0672b00bc5e026e4399244be6dc72.1789594774.git.ashish.kalra@amd.com>
 <20260918222326.GBaq253l7rsV04EUpy@fat_crate.local>
 <49aa3713-d8af-4c9d-a67e-81c1f776a876@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49aa3713-d8af-4c9d-a67e-81c1f776a876@amd.com>

On Fri, Sep 18, 2026 at 05:46:00PM -0500, Kalra, Ashish wrote:
> Looks good.

Thx.

> One comment here, i originally had pr_info_once() for printing this once during SNP init, 
> if you change it to pr_info(), it will get printed again at every SNP guest teardown too,
> i am fine with it and actually it keeps the user aware that RMPOPT optimizations are
> being re-applied/re-enabled, but there may be just too many kernel messages dumped.

Yeah, I had the exact same internal conflict :)

I guess we should do the below instead. This tells us that all the necessary
stuff needed for RMP optimizations has been set up and we can assume that
those optimizations will happen from now on.

We can later add some more non-screaming reporting to user - ratelimited or
whatnot - which gives more info.

But let's do that when we cross that bridge and we decide that they're
actually necessary.

Thx.

--

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index afa5f78808fe..bd70c4d0b774 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -656,6 +656,8 @@ static int __init rmpopt_init(void)
 	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
 		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
 
+	pr_info("RMPOPT optimizations enabled\n");
+
 	rmpopt_soft_init = true;
 
 	return 0;
@@ -688,8 +690,6 @@ void snp_enable_rmpopt(void)
 
 	mod_delayed_work(rmpopt_wq, &rmpopt_delayed_work,
 			 msecs_to_jiffies(RMPOPT_WORK_TIMEOUT));
-
-	pr_info("RMPOPT optimizations enabled\n");
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_enable_rmpopt, "ccp,kvm-amd");
 
-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
