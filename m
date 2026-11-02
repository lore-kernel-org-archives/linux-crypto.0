Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793602918;
	b=GXSeDBAwuZLCKzBAfOKtJEpbXMKgsSg5FCUIGr/8f6g0xuheEw9RMR0FzFLxtLUP5gy7
	 9La0f0KI+uQua+PCS58wSCjnfAUuivEdCUAa7XWWC5Ur0+tG982/OiUdtcsZcQHD3sf9a
	 bsSr6DhNTat8w8UbX56c/6XYn+wAJMKMETvYeCvC6Urpu+LnSmnuJn7MUgApnKT+DQzCg
	 Wv8AW5iZFerUsQ965SlSHHbA69i+mfYOasIAqkV3YC5v5+r5sP32bGVqtbl1E2hXo14ib
	 iTKtKqp8h1/ElkTDwIdTbzZkNsw010038beB+u+2in12mNYFA/h77HeIsqeCRP4g7Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793602918;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=iAPIOenTPqHP2Ny+OdMrV89UeIqmPs8LpJjh/tMjUZM=;
	b=so4Ap1Y+7tCEbKXMPyAzAO3j489H2feb3dS5TU+9/rVL5mrPx3EKLVypRh2zKPELahSd
	 4OAPwEXAlM+FlPXrMmFAJwVF9GIpnDlA5UF1MRz+KRluhmpQ0I9LTGpN1x4Keo1MaW24J
	 +44Hb6c+NN2GZzXTHa35QH9wNfwZZwChS0NqQk4XzgStFncwvIbKh9mMg6qtBR6e9QNK3
	 QFY/10bD0rcKohU+TswP2yUN4txVYM+rDJhzyHyucmq7BK5+bcH/gYeUPuNAv7reNJMf3
	 8AuPP2yVjtpE/SArYZWHHwetHrrUNavDtyEVLpNkgY8K4SsjNiEH/15kdX+GbaACYaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=pass header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=Wexv6Zcp;
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C058C606A324;
	Mon,  2 Nov 2026 07:01:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C058C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=Wexv6Zcp
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 154E440E0184;
	Mon,  2 Nov 2026 07:01:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id li8LNwrtJSLE; Mon,  2 Nov 2026 07:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1793602911; bh=iAPIOenTPqHP2Ny+OdMrV89UeIqmPs8LpJjh/tMjUZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wexv6ZcpPCkMgapkX25daR0HLzS4JjMaTW7WeUJHBqiV5ICvEI8g91SgoYrvua2Sr
	 9pKYMHI6uZbaPI6iSjsx44gYHdBX77tMrVZ5W4Lr6wz5+SNzb8JJV5OkIQRcRGaxxC
	 kqd0sDcKb9BiuQU6VYoZSS6WIzfSUOcShQQ1fHyHFHOAJy2LQW9tCZgvulrToHB3NI
	 7npGOXZmhRr3OI/wmcoio5yRmX0ViNEscoexkVTt8NaPGuBP828U7D2yErHMOGl6eq
	 0tDZHYxnEW0eaJ566Uc/LyNdLStyuJQBNbRC01TYnwSMFGbfAEDAxQhVHij2gK17I3
	 c4xjc5KRsKejIgu+PD5gO0gr/8GlAJXWhCxdQfiFm03VkMvN3wQPybt+RrBrIemkfT
	 /YtHah0kT9yJioZNPcUWFLpLkmwNuOcOgzZI6c5JUfeFOQR8s+gdvR2OXWoNX8vkKK
	 RKHllfVnj2ohmITfTcH6TXylFhZyxkIaOqovstHy/x9oW/KukP5MWA3GNctvZOEfh+
	 +R+PsTWZ5UWwy/rF1KyNzdkumT4zbDQA+gZsYGck5Gb9yOW6mq+e/QT4FDDANKZHGB
	 GdeNrKVAOw4HGLPuVEUY357UvkcL8nvmRF8fEJ+BWPcpnwluX+kLnQc22jzt1o87az
	 5Lbe4taVzs+H/RmTT7ecBYpw=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6358240E016C;
	Mon,  2 Nov 2026 07:01:17 +0000 (UTC)
Date: Sun, 1 Nov 2026 23:01:13 -0800
From: Borislav Petkov <bp@alien8.de>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
	ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
	rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
	pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
	dyoung@redhat.com, nikunj@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
Message-ID: <20261102070113.GEaug1OQN7oEYDk9aD@fat_crate.local>
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>

On Mon, Nov 02, 2026 at 11:42:05AM +0530, K Prateek Nayak wrote:
> On 11/2/2026 10:58 AM, Borislav Petkov wrote:
> > Segmented RMP support is advertised via X86_FEATURE_SEGMENTED_RMP, and the
> > firmware enables it via MSR_AMD64_RMP_CFG[SEG_RMP_ENABLED]. The latter can be
> > cleared in platform BIOS by the user, in which case the system runs in
> > contiguous RMP setting.
> 
> nit. In the latter case, SNP is disabled entirely in bsp_determine_snp and
> the system won't continue with contiguous RMP.

Ah, true, good catch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
