Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E731A681C;
	Wed,  5 Aug 2026 00:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785891005; cv=none; b=Y8cTVg2Jy9jSXKwRkwbHbaMwp+KIZ3To/eDFkbd7T74zKijwVa3KYM0WaOPJgMwsuw/m6jOzM+cfBYASntywl+Ry0pzivFL/lyoTwtbU4+Ir0r5hyhYMhZOiSI6JAh9jfYyLlDYbd8rYbReDfR+O5Waw6pFiskD/KhiLe/mv16o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785891005; c=relaxed/simple;
	bh=QlM00SFoLt3SgpwM5yns+MvvMSc3chlByAGXz9p99Sk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EN9VAmRi4hzhBeIVp1ocqzvIyPJ/PAKAUQYbe/iWVrXMnpERDhKPzP6HqOymLr7dLpqP8zcaaYof14MnI0gebl6SFgGV4W4c7MhOF/F6vNxpn8BLUkVn7Woau9l5DcQHPIY9z08bwN97Atp5rRT+U1lXcuzmwht3/VnC7aj4NRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VnS3br3T reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VnS3br3T"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CAC5540E0031;
	Wed,  5 Aug 2026 00:50:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id xQGTgCeBaw9Q; Wed,  5 Aug 2026 00:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785890990; bh=SwRMflM/G6Wl3HyHAlXjWRPLk8KQM08C1ikUPXNLpnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VnS3br3TMpVJeA1wPy6Tsy8Hb2w/olsQ56p+I9gLYVYNpHXlUTiIbE2JDG4e9HWci
	 FcrundY2KMgn3fy46OP+DInemzWUFmXEZhnDQ49h/hHxvqvF7J68VB+IU8gGP6cIOw
	 kAcP2pcZxD4TQYzu7UWp+foY3YUW2YqjgxwJWXlM7gq8zhquXSBqzI2v3yTXiBrjm8
	 dKsLg3AY5iIQg8GClCuTJoRNHe5WiTNefyBxZqXcsxJqgVZheYa5PT4JEr5GArToqI
	 Xn+No8zQaFRrTma140uGjJkYKtgYzsABoTN/prceMpe7fIuV7JZKzrtlty+gPZjDCb
	 ROL6FCBzUen7RQpyDlkPAM9t7b1o1EdJyyH8KBynsjwmGpokjPTLTKPoqGdykEnSyR
	 FAT35nrU706FLH0tL6OmqrOIRBHLriQR/LlZbrrlj/cETZv5/Rl5hzUuoW25fD0mUt
	 FgUojrMdhYBwtxM5yfE8h9TNBjdEMHeQC6LUSYPAdBEfpf7xgRzyri43NlpelIthfI
	 OR/NgFwdVpj20M8Hh5bvWZnyAlbKJDziWAsTQUytCt72wv32yhjmUYY25YU4HRDera
	 0JiDUUBbMZC/mQGVMrYLsvB3MtSsSvdLGB/MTP4qk7ecLN41u1SpCWU+CjWX1IO6LM
	 FEJp0/JoBEGO9z9I6fEA1NBQ=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C1A6440E00B8;
	Wed,  5 Aug 2026 00:49:15 +0000 (UTC)
Date: Tue, 4 Aug 2026 17:49:13 -0700
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
Subject: Re: [PATCH v11 4/6] x86/sev: Add support to perform RMP
 optimizations asynchronously
Message-ID: <20260805004913.GBanKIiW-O3pDjIqjH@fat_crate.local>
References: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com>
 <178578506318.2377606.14791252769672870038@Ubuntu-2204-jammy-amd64-base>
 <df5f5f6f-7278-42e7-bc7d-8e56187d1438@amd.com>
 <8DAAEA48-F2FA-4D52-8E56-4B7213155F12@alien8.de>
 <d7a17bde-4af0-45ad-96bc-4717a1fa1545@amd.com>
 <60B4B369-19E7-44DF-BCCF-FC8DD851B2E7@alien8.de>
 <59e8b0cf-0ab0-4b7a-9e05-4de6f83c9a10@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <59e8b0cf-0ab0-4b7a-9e05-4de6f83c9a10@amd.com>
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 03, 2026 at 05:22:17PM -0500, Kalra, Ashish wrote:
> Periodic re-optimization was already considered in an earlier RMPOPT se=
ries

Link?

> and dropped because of being too disruptive =E2=80=94 a timer-based sca=
n would run
> on all cores every time it fires, even when no memory has been freed.

What if it ran very seldomly, say once an hour?

> Running it at guest teardown (batched by the timeout) is a better fit:
> teardown is when large contiguous regions actually go back to the
> hypervisor, so the scan only runs when there's real work to do instead =
of on
> a fixed timer. The case of a guest freeing a 1 GB region mid-life is th=
en
> handled by the 1 GB-hugetlb page-cleanup follow-on, not by a periodic s=
can.

Are you saying a periodic scan won't handle anything?

Because if it catches something, it will handle that something.

> I will also like to avoid looping on this =E2=80=94 periodic vs teardow=
n was already
> worked through in an earlier revision, and this is where we landed. Hap=
py to
> revisit if there's a specific new concern, but otherwise I'd prefer to =
keep
> the current approach.

Sorry, this is not how upstream review works.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
