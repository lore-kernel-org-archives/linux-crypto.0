Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA4A54146A;
	Tue, 13 Oct 2026 22:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791930465; cv=none; b=JlgvSKnNwgHu4KnH4CjBNA1mqMondAN3Ot1lPQASOYFHG6VN7Zws+bKfnOf5wl1BpfjIYW2xZPLvNcCDM7EyV/r/ECjWG+D7dBmUz6C2kkI+HGLDbFgNEeaYzbKUqzBFYuJH9F9nu3iypABITQDbOygaluaUqkwIKmtN75Lmtxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791930465; c=relaxed/simple;
	bh=MYH/6BTWP4WBym5dOVKu8AGvlq8RGdvDGlhtonURdeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AM7eXiZcojZfWW7kxHHpP7FyOcDsDPhBwZH3k/5J24lmGkVk4FwrrJ9u9+92VHHW+5k8dHTCpjBLJUWeaEu5sEK2X4wyuAnJhc87eH95tp3rXTo59YEwIQgnIwPYhy0me1+gOCDhhcwgU+uEUeJ8qzRECI5YYy5H4LIFgQZMb/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=A8JKDyN7; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="A8JKDyN7"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CEFF540E015B;
	Tue, 13 Oct 2026 22:27:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id p5hBXKBQD4ff; Tue, 13 Oct 2026 22:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1791930450; bh=gWFz/4FQAxsI4drfvLMDt4B9p5wLm1FIioKwPsbSOQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A8JKDyN7x9fBLPybMZn4shIOOO6NXKB+T0e8QvbdPsV6MCXCJIqo9A0t4Lnj31Fdk
	 lPbEaCaW4ywn3TxcXM3t8hpTQ2otiF0n+oq4QlAEcAF88rHomI1GvyxT/1DkiXlzaJ
	 ZKNyYBpY4hQixZY8TGWNrh5ZniOwfEPTzDiRphMsxEgz0TNNEqpP8auAMcDfh1HeHY
	 FVSeNJYtqSQDcjsvT1vGKponTTAT/AI/ycl4/6cZtf37tqfIyEPdvrezJUhtvv4Gwb
	 uFekqi4fEXVgtpYC4mnN+oF45y8PPI66M3bm5ho8mugd+oLJGMIcYbh8ED3h2KLiwl
	 oqwFrHRMQhbA1oe2y8gIaBxrj+6iUVeqoxeXcLPXzO2Eq6Xw1eQPYtZrLd7bTUqVdH
	 F6v9AInZbb2jebIfyqJ2by+kAiUnWHBQ5ojdjlwCP/ksTL03+ZkRYRm9Q0r8EFZeFJ
	 96A/hKzt4n60p5BaticYommv2pWH6J5aq1Qj6AqiHx5ZNon8rk1AXbPdpexlCNNd4K
	 stpCFJ/ulWaz3HhETQ8xBbI+WeisLD/7SlKGElCJAAPZTlDzJpVMbHcQwKuHITonUv
	 jgSYLKbD43j3YLW0EOr/IxBMnf5MIFnGQV7HWbcPl/XZegGeOTWIri/7TmbO91nZXy
	 Qq+cLoKejsPSS9jqnauSFqZw=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8A89D40E02B0;
	Tue, 13 Oct 2026 22:26:56 +0000 (UTC)
Date: Tue, 13 Oct 2026 15:26:53 -0700
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
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH 1/2] x86/sev: Clear RMPOPT when segmented RMP is disabled
 by firmware
Message-ID: <20261013222653.GAas6wLTEwIw9Te240@fat_crate.local>
References: <cover.1791905953.git.ashish.kalra@amd.com>
 <24ec806222fb8cda660269d3360780687403d150.1791905953.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <24ec806222fb8cda660269d3360780687403d150.1791905953.git.ashish.kalra@amd.com>

On Tue, Oct 13, 2026 at 03:44:18PM +0000, Ashish Kalra wrote:
> snp_probe_rmptable_info() only clears X86_FEATURE_RMPOPT when the platform
> does not advertise X86_FEATURE_SEGMENTED_RMP, or when the segmented RMP
> table probe fails.  It misses the case where the platform advertises
> segmented RMP but the firmware has it disabled (MSR_AMD64_RMP_CFG's
> SEG_RMP_ENABLED bit is clear)

What does that mean: "the platform advertises segmented RMP"?

The CPUID bit is still set?

Or anything else?

How do you create this configuration?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
