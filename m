Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980A723B63E;
	Fri, 19 Jun 2026 22:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781907077; cv=none; b=n8fSF1QrcHUhZmCBkAgpqLmuSWYd93TuIR6nu4Pk8ZN9PRcT0ZlT9wgiaeZsc+Ooz5axQKXtk9CZBVtKHbb8YVxQ5DPvJhXG5FMlcEv7BTCYYRBdF0AxIehaAzzYIusAEmG+1b9DL6iiPSGSGtKpifiKHqHcOVdr9rz26zPfBh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781907077; c=relaxed/simple;
	bh=EFs5OqeRvJAckzzBCZW+hG87h9BgC3zyTM+ozZysbcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHxSc7xetIBfqrKi8vC0niQPAtQv3sTEKzeyaYyv1i4bEmOQ14CnFc4ME3kmfjkfIgFonC7yoMfX63PEBAc+/VSqCXO0h7VATmtlagh91pFELAfe69FJA6pPwbvaHmHWpVV16cfqC52NW3YtQTUI1vR1I5bvh+lg8oKd9yRC//k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=RPtXHwp9; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="RPtXHwp9"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3ADF340E00B8;
	Fri, 19 Jun 2026 22:11:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id zdLKd4u7-TuN; Fri, 19 Jun 2026 22:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1781907063; bh=nWOFZUaZ0sL4ccpLCHFOonE8OXwTmTeUdaaVudfhvv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RPtXHwp96f0gbBnV1mbO35hm92iTmDVuK5EHl9xoqXUMHOhbx0XD3q25yzdib5GIp
	 ea2pifFLOvGQm2ZLNFOwvQUBGayqVWehP1r3/B+7TO+clgaoYDk98xM8nYooAMfOQq
	 auw5182PRnk+IhWAx6cAbuRRfvxi09egXi5pSK6AP2gWYSgfZJX+ddEQbxIRq3Z0uy
	 CCVPesucX2QXWNFda1y5j3p/9K7oGl/B4ZirlAd02Ruz9I0wghbQk8LVLoXYaYnGCH
	 VDL6bmR8VxkADqT+DM/5UqBRdIWyfErJMdumk1pj0C3/KzBInK9IRSs3zsUN/zAws8
	 M+EWuPJlhHkzqNJw4Au47PPKElbzCitQx/T3vZUCJUTZlHVRdInmBgsecJTXIjqWCH
	 iPI5JmwiJDHS/ylpHS6vCKxFUKa7YELnLztjZOL6vUjCwA8hug1Wns+bn3n3ElsEqK
	 l5QLXBkwOAAwFAHzuZOVb8/rzcxzOcW81Y2JZKSZq8YL3eCoe6KqUWf49Poh26vwje
	 XMq0T5MSQXiOest7TN6ucM+um03HxTi5urEqMKOe/wpC+hFr0bpBh1LLN0YeqslR45
	 pDFMD3DVhMGwcZannTDf0Wpd6zDp9Gm2ffQHgLtFv97SYU6S0dOFwfJFuMGw79K72D
	 CF+dTDtWgU07ymJdByKxR3QE=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 18C8F40E00C0;
	Fri, 19 Jun 2026 22:10:27 +0000 (UTC)
Date: Fri, 19 Jun 2026 15:10:22 -0700
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
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
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is
 active
Message-ID: <20260619221022.GBajW-TvxyCuGo0FWX@fat_crate.local>
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
 <49380c3e-c275-4211-876a-c51f644aeb17@intel.com>
 <bd2dc2e0-e975-40a9-8e0a-4403db858316@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bd2dc2e0-e975-40a9-8e0a-4403db858316@amd.com>

On Fri, Jun 19, 2026 at 03:51:20PM -0500, Kalra, Ashish wrote:
> Based on Dave's feedback, i am going to drop this
> cpu_hotplug_disable()/cpu_hotplug_enable() and instead implementing and
> registering the CPU hotplug callback and then refusing to go offline if SNP
> is enabled, unless anyone else here has a different thought/suggestion.

What happened to using cpu_hotplug_disable_offlining() as I've been saying
a bunch of times now?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
