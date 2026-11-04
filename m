Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793752196;
	b=fggss8PSMNRbkt3cSR2W0K4xD5VhY68fgXXa+KFMCTWzz/2vLc7IWJr048SPkdL78DeR
	 SO8Ze5SbqUpjtiBGAQ0bVhiosoCoYt9iLm3FxUB7qfP5l96SakerQqmipbZsuVTAEWpdS
	 6Onl3jDy7TH7yH7+WIfOI70XXBh5cNdBdgzqYg5J/o8bn7mdo5tSaJbodsTS3B2x/801x
	 4p/BkfaQvtZd3Gz0/dokK0FELW8txFI7RgIMIGsg0aayhoYkwbOyPTJH7A+0N9OUPLgyF
	 IFdP+Bommse+kqwdYlC3czHbDQ75Y77DWuf3Z4SNtWKK20jTg4ePKw8mPwoQm1QHszw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793752196;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=11TWoilnUAwwnoICHn0Pai020F/1fd8oGymeOrpOeUQ=;
	b=wNwiyqCvZ3ARXpz7HKsM1rT6HuCSQVjmmnvvRb59df3knx0IOBWSS3Sxsrwtmnpy2Jpd
	 TY886Bnr3G0QMWWR/tAw68SHpt57lg+lKuCmaK/TBFotcwlpGx8vx2PYskuJBIvnjdq76
	 nG0TKFUHrKD2P+5CVXDg7JypA4rxmp4B8RU2nDiIuQZ0cOxE6qqNP+CU112PV0gBmB7Zl
	 hHB5iCWhZYT3BKkv0Wmrz03O0wk+Q6oQUffKzYmvOZBMCmy8L0vgc85XT5BSCoofY94TT
	 w6vzwRgHQuTtKcG+oFiZ9EV7jPX6SLdh75TgNJWklX/momXnc+nr+Vr0YXOQP4RC8ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=pass header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=ki5WhSSh;
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF240606A324;
	Wed,  4 Nov 2026 00:29:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF240606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=ki5WhSSh
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 44C3840E0184;
	Wed,  4 Nov 2026 00:29:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id iB2fZmh7Popd; Wed,  4 Nov 2026 00:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1793752187; bh=11TWoilnUAwwnoICHn0Pai020F/1fd8oGymeOrpOeUQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ki5WhSShKDv4SSh/WVvj6Ps057PBNuwTeIHHfZwQKvjCz1XDPyxwqd4vZCBF1CtgI
	 eDpNG1yvMuYpeY1N+zOwGKOBSA5TMbnOGkqjaUMnEDFzta0uLFnLmsda34GmWWtQj8
	 WJW0WFnhil+MSiJvPUJE4jtlyTdUg9C/60D1ePrTFRlRByy0rsrtiztAwXLJx3LhEr
	 rwIkSwWGOGwP0VuAgppgzPKCKmamdYUSZNxhwy8DyBlZ6ls8W9BJbp1fIkNgPSC1JQ
	 cD4/Z6lNA061XFuhy3dQtRDJpvRieelBG3HklnvXvk7C9HX8LNq9dK/ENfikeaX/gd
	 z6jqTfUjmuej06FMry2CRPF/5AlLNIjCJR4DWmbg0HlluOZMJJIZDC5j6Z+wJ3vnV2
	 StJa5Ioizu2tV3QfPJ/35HmbYUWe8/Ow2hWaQOEUR+D45tqCLlMaMcQs7/JBxRlkD7
	 25k2DAcuJWjL/nA9R21Rxn8UAxO+KvU+SEkcAw52WS34hwy/7c8pczcHmdwSzSDnZk
	 nH26GaLBvFhQMLyq+2ntFmNDwDEuzVOCYKH+CBEfahwpvs+2ouU+UVeoO+NzXh9HVv
	 aIotPGF+vhkKMsCrobsQZ5pz88m8tFhXc2kM7XHeU2eZmjIcxMps8kMzPp/3OYiZmt
	 y4Zw2rjd38bac6S8vgJdbs4E=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C684440E0299;
	Wed,  4 Nov 2026 00:29:13 +0000 (UTC)
Date: Tue, 3 Nov 2026 16:29:10 -0800
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
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
Message-ID: <20261104002910.GBaup8VlLyafsjSbth@fat_crate.local>
References: <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
 <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
 <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>
 <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
 <9ebcb83a-1c0e-423a-8730-eff6b710634b@amd.com>
 <20261102214343.GFaukED8ep3EMmQxfx@fat_crate.local>
 <30947e17-bffc-4c70-b19c-56504771c9fa@amd.com>
 <20261103004531.GEaukuq9sXbCs_PjfL@fat_crate.local>
 <78bc08d8-211c-4de0-b99a-2932d5612282@amd.com>
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
In-Reply-To: <78bc08d8-211c-4de0-b99a-2932d5612282@amd.com>

On Tue, Nov 03, 2026 at 08:59:25AM -0600, Kalra, Ashish wrote:
> I'll wait for you to push to tip:x86/urgent and re-test there.

With patch 2 ontop:

https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/log/?h=rc1%2brmp

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
