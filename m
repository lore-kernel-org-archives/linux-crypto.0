Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA651BC41;
	Sat,  8 Mar 2025 13:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741440808; cv=none; b=L/ihbVKC1ezTRGDx3HaSAMp3WO5N5Tius7IftNhJKB/HWxjz9NIn/pksAJpXbAL7/0GbnHz+SjdPEiu/CBWsbXM7HP+dVujvYOtzBCYnfx1Ru2mbyrkf4jq6GfKVKcaw3GczsykUvyUbsI321ChynhzrA1/IIPLQKdgqMnCjelA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741440808; c=relaxed/simple;
	bh=115Ze+IxI3/vfEm4pnf9cpZTmUZlkDAqgkOYFm8bgM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLLPPUnZm9Z6KDpe6c+05SQnWP8sQ3EHuepSHQjng0wt72l+0l2kFTSqEF0KviE6rr9muUxvDlS1J53fOXnvYd/rSlzNvoLoYgqZP3uvDhNYD6u0328gOI4wt31Oac3anelbQyMx6WEF5Ke+fBjV+zNh72GbreG0I/HbwwSLSGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CAuEjA+o reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CAuEjA+o"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B3CF040E015E;
	Sat,  8 Mar 2025 13:33:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id fUOTjdyFzZYW; Sat,  8 Mar 2025 13:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1741440798; bh=mGUnWVGEljwRD/vFW5lzAbLtqCZsrT5Mor9RAoXgYyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CAuEjA+oufa4li9tDQ0w1Tt+g9NQ2+DCEOZiizHP92xumN76F16HsASw9+eAtvZ4D
	 ZzSxv0mg09iZzSTaTycYd7JYASUXK9G05+DQmRpC3AXHoaSIEmHBY9bfSzzuBkHyit
	 SA03K8Egc2lDY/c1OiPBemVPYZTX5z/XNRji4bWoAZhcstXdrN523dAZVtK0pEV9MB
	 aTlGOguhVs8N2mRdotkvuBYybKADKYpLGE6QSpTc92cJ9M0dRwXCfJ8lg7GzmlvPMK
	 wfuLdvFDWVRbuRWq3rU3xmPk4GK63QtoZDM3e0r1nhhuUR3KhT7/cPErryvt7kIWWM
	 OB0AJROTpv1oFRLdxPsmZaV6tVilTndruIzlv3lQyVfydgymZWdi7OwV1UQxJmmWEK
	 LLBP7taxoDK5WcaobNlt1TQyiNPJ3JA9jZmtN6iqf7nCX9YStC0TyyHxJhRmK/hPxm
	 59sFO6Q55TkKduj+/y0FwKNUC256t3K5aGxn0BsbcfoK4bAHhJlYD93JPbEOUa2DgD
	 lyxT4i3Il8cE2BtKLyH1T2Pn+8MW4YGHl7f33Y/PmWqcU0Sj/il3aqsjJ5OsHItkGK
	 toJnZrFTyqwqMGvB95oJzz2vtUiWycr3MCTTDds63z4cnAF90Q2xpohgqHfYW16mDL
	 7j5l97NE3JinsBfG0j9RDWYA=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8105740E015D;
	Sat,  8 Mar 2025 13:33:09 +0000 (UTC)
Date: Sat, 8 Mar 2025 14:33:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dionna Amalie Glaze <dionnaglaze@google.com>,
	Alexey Kardashevskiy <aik@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: Fix uAPI definitions of PSP errors
Message-ID: <20250308133308.GCZ8xHFOX4JKRG1Mpk@fat_crate.local>
References: <20250308011028.719002-1-aik@amd.com>
 <CAAH4kHaK3Z-_aYizZM0Kvmsjvs_RT88tKG5aefm2_9GTUsU4bg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAH4kHaK3Z-_aYizZM0Kvmsjvs_RT88tKG5aefm2_9GTUsU4bg@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2025 at 09:40:52PM -0800, Dionna Amalie Glaze wrote:
> On Fri, Mar 7, 2025 at 5:10=E2=80=AFPM Alexey Kardashevskiy <aik@amd.co=
m> wrote:
> >
> > Additions to the error enum after explicit 0x27 setting for
> > SEV_RET_INVALID_KEY leads to incorrect value assignments.
> >
> > Use explicit values to match the manufacturer specifications more
> > clearly.
> >
> > Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
> > CC: stable@vger.kernel.org
> > Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> > Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> > Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> > ---
> >
> > Reposting as requested in
> > https://lore.kernel.org/r/Z7f2S3MigLEY80P2@gondor.apana.org.au
> >
> > I wrote it in the first place but since then it travelled a lot,
> > feel free to correct the chain of SOBs and RB :)
>=20
> It's all good. Thanks for seeing this through to the end.

It should be corrected because the current SOB chain says that Dionna is =
the
author but From is yours, making you the author when it gets applied.

All is documented here and in the following sections:

https://kernel.org/doc/html/latest/process/submitting-patches.html#sign-y=
our-work-the-developer-s-certificate-of-origin

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
