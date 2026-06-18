Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFBA30675D;
	Thu, 18 Jun 2026 20:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781813497; cv=none; b=Szah8+vuzk2+DZbYWlBqIAs2sU3vEkhWNY1wBvWnohDhQbLO3s0gazkvpNlWJXKoE+bjragVsG+y5L1hBtBBjiFd3nPMvQAj668YQuGI8ktUOFZoKoXdgvqyVmap+waSbE66w63ZtBKK9rndA+pJi3jZCkicvFdUk7jaarlylKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781813497; c=relaxed/simple;
	bh=bR6CgrTL8L9kbMWcBO10mVoLhF34gJMLuouRnWjZ564=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ju001wtmIAEnfZXL1Cv7DdpEG0QxAvIZlwd0KPWmNGPTCgaHjywo0LYMvzid1ID8XOhABAhg/MTAzDEX7ocibhhrHIUKp6AV4yW5ZsmneRvfDx6cs1J6iNLZIhXvQakVWePJEYG5OAx6qEYMRsOQ0s+QSod1yDBUS3ziRYNRjEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=DFsDXOVY; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DFsDXOVY"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4F09840E02A2;
	Thu, 18 Jun 2026 20:11:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6gZYi2X4M_Mh; Thu, 18 Jun 2026 20:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1781813484; bh=WymufkYy9irEHcYu9yFQ9mnRS4Zsr6ANxKVWzHI9Ae4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DFsDXOVY9N3yVMWpXubiXdLevyL3JPmotJBGGhpNsaC3jyA4SiPH0g1EW3gUfE2hn
	 IjShW55ybqtjgL8Rt3kIj0PnlLyl9bhKz97huLZdhO6aZMdmtQxqk5HnSb6eqEdi/c
	 QjG5XnRckfd4NFxJBWitnlSq7uoIEwwOFLJEJSgCwIX1uCIMtb5pfS8WANErCdEyb+
	 zHnvHx2Zhyuhi+xv2qW+h40lNdWbTJpE9iBw5tdA4cOJEzrLyPMKlEajNQmVP3iWHK
	 +KFh892XDMCWZUEt0bgjutD3zh63DNo8h7jdDnq3AELf4u3bcBugJ6O2IdXWeA7vU+
	 pq0ctKvkUsUrldfpE5DAhtmHmPYfjENLI6ZYR4/JHVVP0CR55s7K2lL1YEtYMMlfom
	 2oC4tu88AjywYSrQPwbauBQtRjWR+rgni6VbbGITBXMEkTbdHZr0rugOJW3V8tcofx
	 fBlluw+onGgQs8v4Ql8ABw4FVxmRqmnsNR/EdFt4xZtdqhV+gWF6GsxHzPaweNEo8I
	 YHVKhgEh2ADBsXTHi6IekekoW/+MdYMcyHDwposvnTTvt0WXdqA3K93tGaZhQe3rTL
	 loX06M5tT1rwL1EIwRU8i5TerLv3Q5lBaXKUCjRPrKpvl+Br2wLVcQpG9Baxk9f68i
	 6P3sRLxn7rbNldxPhQidBazw=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6E77540E01D8;
	Thu, 18 Jun 2026 20:10:49 +0000 (UTC)
Date: Thu, 18 Jun 2026 13:10:46 -0700
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
	john.allen@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v8 7/7] x86/sev: Add debugfs support for RMPOPT
Message-ID: <20260618201046.GGajRQxrh8ekVMeyJS@fat_crate.local>
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <cc9aa9b6cfa2ce826f2ad53f8a13d3b7bf0790b6.1781419998.git.ashish.kalra@amd.com>
 <20260618180814.GCajQ0Dv0CoRMJxbP0@fat_crate.local>
 <5849645c-f701-4768-8cdf-1f9032e3226f@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5849645c-f701-4768-8cdf-1f9032e3226f@amd.com>

On Thu, Jun 18, 2026 at 02:57:45PM -0500, Kalra, Ashish wrote:
> Maybe i can add a line to this patch's commit message stating it's a debug-only interface
> with no stability guarantee.

Sounds to me like you didn't really read that article.

> We have to provide some method/interface for users to verify if RMP optimizations
> are enabled for a GB range of memory.

Sounds to me like this wants to be a facility which is present in the kernel
and it is going to be an ABI.

I am unclear on the real use case but I'm open to being persuaded otherwise.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
