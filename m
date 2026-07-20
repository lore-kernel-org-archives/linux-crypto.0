Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A023AC0EF;
	Mon, 20 Jul 2026 20:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784579379; cv=none; b=EQ5VItJ49Rp5kmKtXVndMXiPzklHaCuKeLORerSjcA9+opleXr9l/YPBBxCHRv1zuykZ/S9b5vDFuTjjlAp+YqlaDuDPUjBtnLBYpN1S3ExXde1oENbF1jqvV2BpV46TowFDVoG98YTV4vgWu0gKALI+YAkYrBNa1x2xhQAm9KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784579379; c=relaxed/simple;
	bh=x6MeNQnEjKD7xpMjnvzEcZoxOHc+q5ARJTzvsnPtJmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfEeP6eOp4PVt1Uc9+mq2KJkOnPkYCKAriI6unB0riLOkB0/ocr1Q6hijc3SzKBNge02t1qlhP6WfZDV/KYkT8H/jT/qQ7W6tglHeina2tz7XORNcIBa0su2iVoUqhLTK87Zy6G3hUjq4yCcdxB7k/UqML2IK8LpNf5wJmHuUp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=FuMmVgqd; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="FuMmVgqd"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 20F9740E00C3;
	Mon, 20 Jul 2026 20:29:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id uZXkSqPZT5mY; Mon, 20 Jul 2026 20:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784579363; bh=+o4OZw4hG2PNtz31wowqgpCiSVORj6qyCbXupzQwBtA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FuMmVgqdTWgxJt4jtWT1A57pVE9j0obRMEpABea0U9OgHQNJ6+1CapF+3OjqSlt6Q
	 6nAcswr1kaLl/isdNZomYdpr7HVnfqOtKjnGRRY3ppQ1YBA8UxmXNzAHEwITQ4jSOO
	 HQ5JxrXvuIT1PB3Bywx7a8Kfut74/Byva2Q/755Wf0Feq63LgGTKmpMk/4xu0w4uVM
	 2rC/rjXRlYnQ29r+Gfmx8fY5cbZkdCrHt8LzrSGngJRhyOycsott7ibcuA4OBmqeur
	 xe/GIZrFBxQUuMHe9zUu6zew/xk2a8HWn/G0AsNwHjuvxEnAMBREd+XorHYDlpVLUf
	 tqQw+VUWuJNCnuo66PXu5c65TZQoT/ugLJCNa+lnETvn/ZQnZ70Jm6ZRWk5FUAmZDp
	 kWpcOKYEKyjxshGmQtfKFVF1gTAlOLD3avkofN1ks9LtO5NH3JUZdn+5MZwcADTpNL
	 KbQFb4xrMl3Lj/m6UxgMTcokbL9PaBeEFcbZEyQxQpaqD2KsdbN8hXQoD581B228Sc
	 GxPXSnHA/7PibVFhwcFgcsKTFNsKZLHm3F6SnARdvAJh319TcUG9uvW5FSG9FqPUan
	 l+2ALFKL5k4um8Q9637UWjlZDaEsKw4DtJFFR1VKwelEUCvYaiE/4NJLzoTUYjpK7k
	 lnRWiJHKVtGh1umDUCQ57mJc=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 666EA40E00DC;
	Mon, 20 Jul 2026 20:28:48 +0000 (UTC)
Date: Mon, 20 Jul 2026 13:28:45 -0700
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
Subject: Re: [PATCH v10 0/6] Add RMPOPT support.
Message-ID: <20260720202845.GAal6E_dQjTa_vEO3y@fat_crate.local>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <aad54bd5-8a5e-418d-8cb2-2cec6527993b@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aad54bd5-8a5e-418d-8cb2-2cec6527993b@amd.com>

On Mon, Jul 20, 2026 at 03:17:23PM -0500, Kalra, Ashish wrote:
> Just a gentle ping on this series. I believe v10 addresses the feedback from the earlier rounds. 
> Please let me know if it looks good to merge, or if there's anything else you'd like me to change.

What about those Sashiko comments to it:

https://sashiko.dev/#/patchset/cover.1782841284.git.ashish.kalra%40amd.com

?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
