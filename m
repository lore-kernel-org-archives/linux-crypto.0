Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6174E397E64;
	Wed,  5 Aug 2026 19:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785958177; cv=none; b=K/CyIX2PKhIbRD41JHq2dlnzzxFoUFrImaoQdo/tYl6eFY3JKRyNq8eSLAqMbtZwcF5n/lULyrNpL2A4bzu7oi6xUnS7CijvM06AvLaQ/rzn/U7pKZ6T18nwA0KuPtsejW9djKAD809T2E11k70P4Iib66cZ4g+wSZjYLy/FM3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785958177; c=relaxed/simple;
	bh=cX2eQD1esFsEsgIcg2HJwleFbF+Z7MfZEa+31I7mwq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2GQhbWyfIUa1gXpi250kGC9ID7BDpt9jSf1og3G1nBUYTtDVpyj9oA5sfMZX99niUlpL2d1MDqrnOJeoBlZtaTMHXIsSTcvdgR9PBPNt4y8SSD/FkZIv3d1KlDDx7f7NRP9VH2AwlgM6v6zfy48gyMnJ+sJ0+qwjUKOgLDWzM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=hjXIUoMK reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="hjXIUoMK"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5051940E00C3;
	Wed,  5 Aug 2026 19:29:26 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id oViidsjl9PKq; Wed,  5 Aug 2026 19:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785958156; bh=hEouxIsC4Je+jV925zCURKIYMNOO0ioFdfYsQd5pUSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hjXIUoMKfFxquwnhUuFDR9nrRJlVNoc7/dPpG++TYMCi5IHFj8vFrc+wIzar9tVD7
	 H+RtKvWdJMNISb9oyDJk/XRKR2zMRZvTH57A/yXjdWvq/DZnSkyj9257DsubNTeD8f
	 aYjYa4avZSsoAoqYS82i74zvlv36dQvPBRZcvDgAYNpG5psJ9+Zta9ME2338WY0gB9
	 NBklYCp1F0Zt1DovGuFAIYAxGkxZRBWl58IESua3z+s6JJhIsM9SlKYW7LaXCi39EA
	 8Tu2Sa35wa2mCT/EKRMMC1a1s14Fsa6+kLhzt8vX1izZWoFOX372P4brrh5lZXuPmM
	 RWZMhGp9llNc3rtA64HlWYmNa8i19+LJDnXxcX7zkHge1B/1Vwh767psY8ySN5FoNe
	 PjFoYoSzP6fXnvnLcOQdY5iq6oTWoXabwAchfcmq8qLeSmMUb/4nlH+ueLyRYerWoY
	 AM4lErXuqfoNHNiPSoGLyy0aHL6E88z1mwME81NYKeQU5lhfYHpxdRaH5hhCud2c/w
	 lqJF3g6Ki/o+l2AKNm2qy/PkyhjMJdNwONyWdla0q51JdnH6PgunG0iR7N+Jnf1lC5
	 es0A39lkDdd04CF15wdyYyBxspckvx3BDJhKUPy8vA3nrsDo+/p2oaSvufQAxgYWRY
	 kSTMEQxiSTviOAhCL6DeAUSg=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3F1DD40E0031;
	Wed,  5 Aug 2026 19:28:41 +0000 (UTC)
Date: Wed, 5 Aug 2026 12:28:37 -0700
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
Message-ID: <20260805192837.GAanOO5SU78CzNgblB@fat_crate.local>
References: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com>
 <178578506318.2377606.14791252769672870038@Ubuntu-2204-jammy-amd64-base>
 <df5f5f6f-7278-42e7-bc7d-8e56187d1438@amd.com>
 <8DAAEA48-F2FA-4D52-8E56-4B7213155F12@alien8.de>
 <d7a17bde-4af0-45ad-96bc-4717a1fa1545@amd.com>
 <60B4B369-19E7-44DF-BCCF-FC8DD851B2E7@alien8.de>
 <59e8b0cf-0ab0-4b7a-9e05-4de6f83c9a10@amd.com>
 <20260805004913.GBanKIiW-O3pDjIqjH@fat_crate.local>
 <63867f3f-a7a3-4d6e-83b4-0683688512e9@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <63867f3f-a7a3-4d6e-83b4-0683688512e9@amd.com>
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 04, 2026 at 09:38:05PM -0500, Kalra, Ashish wrote:
> - Under churn (many SNP guests terminating and respawning), an hourly s=
can
> is too coarse =E2=80=94 freed regions would sit un-optimized for up to =
an hour. The
> teardown trigger re-optimizes right after each burst of terminations
> (batched by the timeout), so it's more responsive than a periodic scan
> exactly when there's the most optimization work to do.

Yes.

> - When no SNP guests run, a periodic scan achieves nothing: the initial=
 pass
> already optimized all of memory and nothing has changed, so it just re-=
scans
> physmem for zero benefit.

Well, no. You won't even run that when there are no SNP guests present.

> So the event-driven approach self-scales with real work =E2=80=94 it ru=
ns as often
> as memory is actually freed and not at all when the system is idle =E2=80=
=94 whereas
> a fixed timer is both too slow under load and pure overhead when idle. =
The
> mid-life contiguous-1 GB case is then caught precisely by the 1 GB-huge=
tlb
> page-cleanup hook when that lands, rather than by a coarse sweep.

I wanted to have this in case pages do get freed up from time to time and=
 you
get some sort of a fragmentation. But I'm being told that we don't suppor=
t
balooning yet, neither memory hotplug and when the pages get freed, they
remain guest-owned. So yes, the points in time where those page become
HV-owned and potentially freed, then we should optimize.

Please hold down that in the commit message so that it is clear for futur=
e
readers why we did it this way.

Thx.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
