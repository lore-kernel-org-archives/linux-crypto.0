Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793665372;
	b=ZNcGkkSzdpVy1ZOJwi/5TMBGN2Fa9XQpkmz8WBKgtJjoves/TKrJn+eFwngARyamAOBn
	 2m7ksVPvELBrTHdMjVXhTfRpi8t8cJHYs4Xfyshe53v87Pxq3hz579IwNjseJgNVRmNJC
	 t41RkbshBdDoNIXFLh4P2ba4QxcKaq7VX3hUOknlcivZthYDribbNIfJuGxgIA7giq6B/
	 7QXZv1jFuRb/5SLyJ+KAqbSaqvrCaW+O143XIFh9+PNt4YEl7EVw09qtGu4ANM2tg+eh8
	 K3t3E5t96FTJm2ysgQwpGvj7h8fmZrDm/5blZuQOQc7n0lBP88G77A4p/kGQhSW/USg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793665372;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:
	 Content-Transfer-Encoding;
	bh=oACA55A358PLl8qDFDFJKmB/gLplT2CMWDv2GqhT/eY=;
	b=KVYKWp8HQw5XKIdLUV0wX5/O6lLAT5Jl0k3jFIWpEDqYp2sKGwG4VtJLweGeDMNUF/53
	 464ArOA/36mAfYypNaOhdEdEiccQtlf1joZFpigm9aaLGLPw9JtwaUQ84UHdZk5C9JF7U
	 3dTX+F7t3qQnmoPMCwMyzR0SwFSEKhs0JaSjciysh7ogcKlUEI/U6OO+17iW9ZlRjs4rq
	 IISgWq+valiaOcCCRn82tD2VjyyU6r3A4w2gPYz60gFuLR3FDqHRTClhMtartPVqwZq0f
	 J9KUIS7tbxyt5iCGIXcOOZIYCUo55fH2dJmpMkNj9Q+k/3O+By3t7ax3GjI5gTmHPPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=fail reason="signature verification failed" header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=khc3QmfE;
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F259606A324;
	Tue,  3 Nov 2026 00:22:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F259606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key, unprotected) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=khc3QmfE
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A714E40E029C;
	Tue,  3 Nov 2026 00:22:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id fgWlcnxAZurx; Tue,  3 Nov 2026 00:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1793665365; bh=JKfbgc7Jq0iEjPmobbMO9Gv7X4ESK/4v8b1duX0LTVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=khc3QmfElXlheLotvCWAI3zTFZxggNYiI8c0QbGr/ZhraApU70VIU0RD/apCYh8Qy
	 RKsUpY7FGeXFlBhVNGMnh+V0VyGFqagOY1chikGWawfGtyiNePdto02fUUxkm/kidQ
	 PEtZdL7sBRCJqHg+uaXN1+7aJUX7D6ToSTARqbCAhlfy/c1zsXTZclc+ataZ9n+70y
	 bH8R55OSgsD3hT1NL0DbNu6tHC4vFpEI8vgUF4lkM69v4XUAl1KaQ2fvJXrUAVywfS
	 L1fhEv7KNDFv2UfW4ValUxbEjPbbUTZPnyf8lV+BQje+rj3ST3/l21n2fj3uq5lHsX
	 uM1U3yTgDxV8KHDXtAY1vUd48hn3dyr25KCzKVSJpUhgicC/SVGKxFj3dQ7g58pTqq
	 p/Rog2z+6BAQTUVjG0/nJhbCqLRT0R6wmvf20KxerU1rLLr3CEnLC+lxRkQ8vbAglI
	 LtZCGMaHKGr4Broyi6uQW/aOZX4q7w/QrCOpqm6jKVYjXOk+tMHr4GgrF/F9p0VvQN
	 IkMkffwBvog+rFxRMbzkTax6QX8RJuFhUvzSJHSY3D0QC8g8lxIDoaoAQ9RDia0zyd
	 CjleLDsyQCEJJfsibux4Diqe1sfVzkk+FaEr5VQK9jTwZatU9bl8J96oUVIMt7tame
	 v55t0JW2OVCOR6R1SNCgL8xY=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A20F140E03BE;
	Tue,  3 Nov 2026 00:22:11 +0000 (UTC)
Date: Mon, 2 Nov 2026 16:22:08 -0800
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
Message-ID: <20261103002208.GGaukpMICaKwIgoeRe@fat_crate.local>
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
 <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
 <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>
 <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
 <5c80e556-cdb8-46fd-9bee-c54732377236@amd.com>
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
In-Reply-To: <5c80e556-cdb8-46fd-9bee-c54732377236@amd.com>
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 02, 2026 at 02:21:28PM -0600, Kalra, Ashish wrote:
> As i mentioned above, the cpuid-dep only fires when the SEV_SNP CPUID
> bit is cleared though, and the IOMMU "can't enable SNP" path clears onl=
y
> CC_ATTR_HOST_SEV_SNP, not the CPUID bit.=20

I believe the IOMMU path is too late in the boot for the CPUID bit anyway=
.

> So we still need the rmpopt_init() (in patch 2 of this series) move int=
o
> snp_rmptable_init() to avoid announcing RMPOPT / allocating the workque=
ue on
> a host where the IOMMU turned SNP off =E2=80=94 this dep doesn't cover =
that case.

Sure.

Lemme put everything into a proper patch now.

Thx.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
