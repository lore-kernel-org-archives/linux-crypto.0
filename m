Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A014239C657;
	Thu, 23 Jul 2026 20:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784836855; cv=none; b=OUJwcmw14dgbO1EwYzMr1FaUnfQ4ZAl+xYIasS/nSY3DX+VVNjGAOWoglFXHAJDPFkyHs6aCY8eM6LPn/iYoPpVrO2N9TWhpEISa5PVvwOiYfMZPTMHTiDLDkD/DBLCDu+//sL3CK6xUFLd0OjaLZzJcfdTDoc0h0/jNUzB704c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784836855; c=relaxed/simple;
	bh=5WiNnBZv1bPiBoOtpCmuhxQ77Pd5nAEKktR7I531XB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fe0lEWGesUUzHCe+ywTk2nXpvWwrXtAcfYZEFBKn94O3X9lJ59PeQlfCocUJJ2NgHMOVC+ulSDHfNmbriYLe9/wXVFYuV8Hr20c4v+4gBbpY6X4BbHSLMtorwvX0cKYid8CUipM64ZGLh/tQ2Z/XZo2vGck5g2y1770K0ICZ8gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=WFDfGci/; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="WFDfGci/"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5D6AC40E014C;
	Thu, 23 Jul 2026 20:00:51 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 2V9d21iM5GBS; Thu, 23 Jul 2026 20:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784836841; bh=+GBkzJeT/6irLf2HN5o90x/DBsvXycEcqjo5v+va92U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WFDfGci/43cmXnIiUNpnYg2v0s/3yH1bX/OZicsJsBKcDPfjjYz2gyQ3YnzVxM8W5
	 FUY43UUnz9Z1JAtlDC3xhYYDo2z4o2zN/8IfU0qj2lFWwBm4VZpxpKpdLz1VvxSu71
	 8wEyMzJuf+PjwMrqzhwp8l8OAfBnmgMhepNbi8PCa++XKBKC8ZbNX/x2TY6mKFT16r
	 lF0/DeEFYCkRGEmFl1E3hz0Odi7eqdpfom1Gp7TN7pS7+b298MUbs8r84WqWyd++bn
	 tCWuWTI/WuYdD0AfbryLKYjOIBBu6ICyZQ30oOXLPdHkMaStvZ1UcFHeiAe0uvoK/a
	 ilJRDaBU8u+mdadS6FozCZMgfknNa3su6Nwubv8qDWDXQvxwDEEpGDVGO+6lKc/5BA
	 xHbMitpBeX/2g30g2kiMtTTUdrRKhQ4TqdnO4zJOEkuCuAnnvbswjPVsI/QtZ+kOso
	 5AqXe/vgmtlW98nGa957sVIJbCk0H65BLLQmN1H/l6kWUji1XlDInNLzAhnD9XTRlx
	 Q6DggFTHo9ovu/JSUnpvp2OhAnfapU3AKVGJuTwqTJ6p6u1KV/N2wWP4MvypNqOKzg
	 DOCADrS8s8cowOknNB4arv+OE8K8oHhkQLUna4KQTw24DLMhh9ff1x7Ur2hUZjM5Ug
	 PGOztsgLgYHAJ1Z9Ng06WeE4=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9D01640E00DC;
	Thu, 23 Jul 2026 20:00:06 +0000 (UTC)
Date: Thu, 23 Jul 2026 13:00:03 -0700
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
Subject: Re: [PATCH v10 3/6] x86/sev: Disable CPU hotplug while SNP is active
Message-ID: <20260723200003.GEamJyw2W1nMPAUdHc@fat_crate.local>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <205a5259f9fd353dc0ca6b00565c8175a96768c7.1782841284.git.ashish.kalra@amd.com>
 <20260723185323.GAamJjI2HoM1gZmExw@fat_crate.local>
 <404433af-b908-4849-a8b6-1c1ee9d33d8e@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <404433af-b908-4849-a8b6-1c1ee9d33d8e@amd.com>

On Thu, Jul 23, 2026 at 02:44:47PM -0500, Kalra, Ashish wrote:
> Actually, i will have to remove cpus_read_lock()/unlock() across the whole
> patch series and also in the original code.

You need to do that in the same patch which adds the hotplug disable so that
there's no hole in hotplug handling when bisecting.

Make sure to explain why you're doing that in the commit message.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
