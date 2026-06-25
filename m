Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A002236D503;
	Thu, 25 Jun 2026 15:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782399843; cv=none; b=ZQ56rJCGDRKa1CJWJaKORSmhWf5x7ZOl6TiARNpBWIGgt5gH/RuVeft8ob4iolMh5wFfKmjI5X4S56T+C9szeV0UfZXLnqWpDQsATODMVjDndmpS+amUnkynHHugnP+YkTeK49yDYMgywO6PDFELmbISBZtDRBjx3Vab+f9wYgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782399843; c=relaxed/simple;
	bh=Uac3s/FkLZu5nWQvtVOiyODe+/g5II1WqX00+hlx0Lo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmYqzZ/yKmWh7zMe0/LbDj7fk44yNEKI9uYAoLA1TFlHv22lXjriV1DHGgA66CGOovuRRG20k94WqZsXxccZTe1KpMxIt/HHQWuy3WtJ0pT8EsK+dSP9l2I/6A7aN8E2NSCnaV9M5xH3nzzrStT7vH+fxOr30X4PneGAR8toXeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=iQfR2mKs; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="iQfR2mKs"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7508D40E00BF;
	Thu, 25 Jun 2026 15:03:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id eHJzs-crGVFb; Thu, 25 Jun 2026 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1782399812; bh=gCbhzWJy0h7/sYHbIeCE/SlEs5Mm3OwXOOEFuRKFBz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iQfR2mKsH6/4iRn5OS5IvrsKEeoUmzF9LkUzPCcf7YVenE/soQ6PsAKMUoLDVJmuQ
	 PGoTr5pLrgnatv6RrMKZzf312NxvxFBvxScjLM61iIBKMEv8P9HoGvspyYgUM+/HHt
	 y+X3bj47cVwMYt048FuJNSDfan7NVCMsbD9iFfPkZ+PynDYAW1eTodbHLiGewZ+1Dg
	 qUT1g2fYK614+p33CJzDbzS+gwXL2U2rtK6VLdNezoOx8eJw2E/V4Svt+Lxhzv2S14
	 WFTAVilpeZDhBDGJlGdTm9LAvD3Ldzc4yHUcKqrG2CPLzZErjQxxfp4lJ/TC38SQIr
	 Phk0d+v8eFilPvOi0dIZn2VnMCYa89K65AlVD/PPRPGRwJMt7Pfg3J27Hx5Yl6Lr+3
	 XKuOptIbrsuC//PcpPASAgXTCi4g7nuAIO1guoOfMthJuoS5OizMD4HBdnwkEwnshr
	 A+5Vgi44j/qeOqOCGJwXzpJtESqthaXOv73g0NiLjpv5dylu8utndj1dYcpK2COGXw
	 6zV680j4z0QVFPAb8SPsIhJR1wMwAheYozw/e8ocW/m6TW4n/eft4FLJBuwljRRcZy
	 96h8e8qcPO7tNuPWVEayz2sH0NCuwINaiUUcvBu9nlJAYdhQ6CDUA6Ir26J9063ZCg
	 7nPKVdJSOhcqlYYnMDpTIIuM=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7C91540E0031;
	Thu, 25 Jun 2026 15:02:57 +0000 (UTC)
Date: Thu, 25 Jun 2026 08:02:53 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>
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
	john.allen@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v9 3/6] x86/sev: Disable CPU hotplug while SNP is active
Message-ID: <20260625150253.GAaj1DHZC8ULg6PzbI@fat_crate.local>
References: <cover.1782336473.git.ashish.kalra@amd.com>
 <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>

On Wed, Jun 24, 2026 at 09:56:49PM +0000, Ashish Kalra wrote:
> +/* Set while SNP has CPU hotplug disabled (kernel-lifetime; survives ccp reload). */
> +static bool snp_cpu_hotplug_disabled;

Do you really need this?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
