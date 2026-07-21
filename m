Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360E4368D65;
	Tue, 21 Jul 2026 01:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784598574; cv=none; b=aM7HD/yhEGdnVF2pwvBtuApNzd1PJGNrwWYoXiZbguSCdUMVWINPm3y/YMARtIECXfLNZAvmJV00njwqtvJTsrj91QlgkmevOlahrP7nhKF1/HFD07E50Qxa8xfNlkwGfeTMvlmQy8dHmhbhoYC4ABPeNes6qDo9t0bcKENo5do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784598574; c=relaxed/simple;
	bh=mGesBaURCSkK73cNSPDNDbtvQ8PN0fZjtgrnpn68PVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCaMG6vpIn9qRQAf3Uy1daj6rEptEo8SVzrI4eTrairva0PoM7QUq8xMniLCOdW61ShRRd/yYAotL5jcxsOwQPV6jNTebgDhvXBoGtSzVAg9lPpfz+2hUxZU7ovAqt5jyJK4JdtsolaB6wfv64XVCO2SEFNoF6hVEUxAX9Zys4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Ooas6kTy reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Ooas6kTy"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C65E540E00C3;
	Tue, 21 Jul 2026 01:49:29 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 0jZWPBlYwiYe; Tue, 21 Jul 2026 01:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784598559; bh=6+CHJtCLMfBSzPUlrxDyYfscRk0QokkmTeoDqHNlJ7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ooas6kTyh5LyKRcWrAbdolUy7U7v1vKPBiMoHUcqAU7eZ2/q2SfrRhwkY2KfmpUsX
	 OcEM146v/5mP50zADtLNvfo2B3k5Ooilyj8rt7pq5JCU4i/f0PEMQFum4MhdlR5LmK
	 mOdPw2q4smgwIMv63D3mRPvZFVDJ4Rv/03Vecy0YlTyUXkq2gLsxSM57ppJHvK22DM
	 v1zG+G/NU7e6NsyVyV2Yy0yrRSL5TGIQ8+736zS3sMlj/OaW2SWG1OsC1UhXHDg4MS
	 1SkD3pYzhtYuVhb1DK53uD7xQyMetIp0T9t2+IRV0OXLhb9L802FcCaa3cMnww1k41
	 ZgI3x2bS2rqlpTHt7QanCTdCUJKQF6eC1YSxtl93wbF7FUqOfqKBKA3g9YZKF775t2
	 tHWKfsmV4LbltFACT4e0f975Jf4ban/yr5hJ4DdhfGU/d7QmX436P79hqGG+3YvLDz
	 puY3GBypDOOg65KY3WTyqCFSOyxPNMdVi3XzBxCS1h3iY9hUn2iMzoP9cU8KsAVls4
	 bZgafqPUrNJYtI2XzfztjLX+/OY+JNHfPWbM4gLkOQzUSSDIOnHiv50tAVRsY6lsoI
	 x1Q/s1A4EpVyDzZVX7rX9ecl95aQG/Fo63i3WlHzmTySpBXjKsT92OBEgk0LTb9D1h
	 hueEQl7j19pFzng6IZw67EdM=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B318840E00DC;
	Tue, 21 Jul 2026 01:48:44 +0000 (UTC)
Date: Mon, 20 Jul 2026 18:48:41 -0700
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
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
Message-ID: <20260721014841.GCal7P-f3ZBHQzR-0_@fat_crate.local>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260720221725.GDal6edYI3uHrDruHj@fat_crate.local>
 <5168d3d3-c31c-4f80-be91-c964a5cee674@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5168d3d3-c31c-4f80-be91-c964a5cee674@amd.com>
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2026 at 05:38:05PM -0500, Kalra, Ashish wrote:
> Agreed on dropping the bool =E2=80=94 I'll derive it in a local helper.
>=20
> One issue though: rmp_segment_table !=3D NULL isn't segmented-only. set=
up_contiguous_rmptable() also allocates rmp_segment_table
> (the contiguous RMP is stored as a single segment in the same table), s=
o it's non-NULL for the contiguous case too.
>=20
> To keep it segmented-only, I'll also need to gate on the segmented-RMP =
mode, something like:=20
>=20
>   static bool rmpopt_capable(void)
>   {
>         return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
>                cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
>                (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) &&
>                rmp_segment_table;
>   }
>=20
> The CC_ATTR_HOST_SEV_SNP check also handles SNP being disabled at runti=
me, so snp_clear_rmpopt_capable() and its caller go away as well.

Ok, you can simply do:

	setup_clear_cpu_cap(X86_FEATURE_RMPOPT)

and clear our internal representation of RMPOPT support and make it a lot
simpler.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
