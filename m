Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B706E2BEC45;
	Fri, 17 Apr 2026 21:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776463065; cv=none; b=GoX+YeHeC1CjP+JBKKRnml8F9wCryAW74G2uOpZCjwNIsTdqnSDH6P9BarJ0+6Gb/XErTg8M6FtC+aNcs80Iwd4uvaV92kgr5TpFWxzYwGLTIIHTmklU2NWxB+jmtn95i5bfcYauMKo4kCM3SWfPwV5QCMeoBP1LkO/Wx+StpxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776463065; c=relaxed/simple;
	bh=AuFz1748A7BScnX82VhuTiWnx+nSfzjEvokC+CuqdH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TNR9P0MPGPSRpklbfDr2OpPrPLycUEwRC0KUO2GiR8dLbmsRaoYWCMLh2UvN0ATRnnikEeYVhO/rDlZMnBa53jjl9fFvzosXjRFn1WVWF1w1gwqkAW//9moxPf1CoikWVqTWt9F/XeKORPaCw4RMWtzpTUIM9wnmuQN4BrrFfdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cjFtkJXU; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cjFtkJXU"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0E3E940E00BA;
	Fri, 17 Apr 2026 21:57:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4jj1gDogLEFz; Fri, 17 Apr 2026 21:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1776463053; bh=YH4HFe7qz3Cjc+v09895BgV6+rr5ybw6RJWaul6NQJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cjFtkJXUUioBJ1FDoLEspXoXAfKV6AM+z8fj7ZNDPl+9E/S3tlDiSiUQAjwYCYiDK
	 4m55htx6UTtihju5SkutNg7GwZ6XhitSXdWk4vQZahBGPbkO5aujHBSTszf9c6k4tI
	 s/mSfs8xl0A0U+F/rvufuY+UIDi+r5/y2V/EawXQZ6/Ss/pjodZS7ROeQKJampIChr
	 jEJzYX5epw6pYvO10NggZGeV6RW/dBAbPb/EOGz8RhVBldhtW5MjMFRgxyghKV/hP3
	 mBJ679cGSfOXG/qEXaqYfE8Ito8B4gY8ZkkuC4X3QjECfY6PG408BOy2JcMIRTcIBG
	 Uvqwah2MQo8WbGlmaHZF7zFhWOamkEdcSfbBQ6ennWqpOlcahZ8uGEB05EWNuc4eRL
	 Q8oUbXEZacY5DxkG+93BkW5b1Yhfb0bRDWNwaQ1hUcH2JXULNkKxaEphmZafqxowql
	 TsQJXj7TEtMJBgM6jIkvwMmqvo/0UiR3Cm0x72nzBh5w/4HHiqrtgpwCnJXKUDSKoi
	 xcEXi61Foa5yQKnrUQ+ZLAz1sj2V3T5jw3B0OAmYJuxArMSBWJzq7IXJEoC5x6nBYp
	 dVIl9mqngIjIXA1ScwqNorhTvBv6liRklj9qriGY6iCC+bg7rdkysOSxYL3/J+ZiRi
	 Z13e9WabuMLNah90DDd0H3K4=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 570D540E00BF;
	Fri, 17 Apr 2026 21:57:11 +0000 (UTC)
Date: Fri, 17 Apr 2026 23:57:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tycho Andersen <tycho@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@gmail.com>
Subject: Re: [PATCH v3 1/2] x86/sev: Do not initialize SNP if missing CPUs
Message-ID: <20260417215703.GAaeKsry3MG2ussVvg@fat_crate.local>
References: <20260409195602.851513-1-tycho@kernel.org>
 <20260409195602.851513-2-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260409195602.851513-2-tycho@kernel.org>

On Thu, Apr 09, 2026 at 01:56:01PM -0600, Tycho Andersen wrote:
> @@ -521,12 +522,20 @@ void snp_prepare(void)
>  	 */
>  	rdmsrq(MSR_AMD64_SYSCFG, val);
>  	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> -		return;
> +		return 0;
>  
>  	clear_rmp();
>  
>  	cpus_read_lock();
>  
> +	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
> +		ret = -EOPNOTSUPP;
> +		pr_warn("Skipping SNP initialization. CPUs online %*pbl, present %*pbl\n",

You need to say why exactly you're aborting here:

			"SNP init failed: not all CPUs online: (%*pbl online <-> %*pbl present masks)."

or something along those lines.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
