Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C257021FF2A;
	Tue, 15 Sep 2026 23:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789515496; cv=none; b=SSmlH8LVj37fXhCDG9QOmHYRUdGMGjdSCWECgC2qlBnXdx/O68sLRCBR78Lo24QrwuA7JJIb1owCn0Pa1yJog0Ajl3gDS32FCpkYkkJJ7kvQso0u8vopv7j2s4ybE0LtnpQBGC3YvChd8+WTsE9RaCTjuMx5h+mU6PITg0F9IMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789515496; c=relaxed/simple;
	bh=ITrPs/XtKb3JY3g+pYpg8pbKqiE+yGKnKoCJo6G04m0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P0Ut1YZ3sZ5H4EYlLpKU/bTu2Cs5osyXIGSfiObLdFJ0FqB3M+LBUVsGZA58bPmCSUAjpdwHpohSXaYlcTS5NHaLGhzYn7DgirTxZhSSrIpUx7CI40e1m1Hf9rcoTLtP1tW9gbVzHz2baj76QmelRlMS+GVCoeJGtJM3Jw7tD3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VVk7gQwZ reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VVk7gQwZ"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4465340E01F9;
	Tue, 15 Sep 2026 23:38:05 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id hitPcaDE_HpX; Tue, 15 Sep 2026 23:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789515475; bh=+2qwekjkCGVhq0fmaleVEn8OlbaUbQF+vy1w0eA5II8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VVk7gQwZVyqrK92lwr6ZafmRj3VZw0WWN4KrtfYS+ez9AC9ev/L9urRJyJPmhCouW
	 bKgPQM3PpOaU0oSodkcgpZCtK1QwC68pGRgUQIsf6QPIciPmcTiCD3WKiAw5SV3tHj
	 WYh+V02AEd4/cRzjCexPh60TTmJIJWAIqe+uO3w6zoh2zBHFGD6s/pjdHmHID3KcxR
	 rpLyd114qfJzM8yZ6BofpQJ1ckGDE1+JILSvoDZ+u0pz7IAziNnmz2l+87ofDHsyUs
	 XG/7tkOtAuVucTOFZP3wwDnONbVbFlUkQ/ImiQYH4d9rp3Lb8TbkN+0aKuV7N5YFMJ
	 CiRxp+BpyPYPPDHV/KKLD1S58/4lftq4PKLAxlXW/t21mveVLctBIJ/tkZ+mE/yF8t
	 c1IJg1Juum5I3qecbvHGW2fWi9GvFlEe+9t4VUFZc3bMTC988xhTINIbM2ycp144Jf
	 tAl4ra30dJIpT+8Zw4oXCs5WLC0OcDI2j1l1gyRxgAxfVrqqngNLuvDBya1+/+6kEW
	 DNuQTZm2Tnv4SZYvadZ7FCkVCvciTEQyDL3KnHDgpyE4mAyJMR0Ob9lukKR4T3GmiP
	 PbmpNb6QoZ1YywTSXzhSc1BDzbEkAxXX0awkCG9Mhzr28ylpLHDWVnxukB40gDGWGp
	 3so7sfW4zAUaOIAiCO8XxDbs=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4559440E00B9;
	Tue, 15 Sep 2026 23:37:21 +0000 (UTC)
Date: Tue, 15 Sep 2026 16:37:17 -0700
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
	darwi@linutronix.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH v14 4/5] x86/sev: Perform RMP optimizations asynchronously
Message-ID: <20260915233717.GCaqnWrefMu7fxv1TP@fat_crate.local>
References: <cover.1788984053.git.ashish.kalra@amd.com>
 <1e3d0edb6b275e33fa6f76b0c31db9e999d9a270.1788984053.git.ashish.kalra@amd.com>
 <20260912015336.GJaqSwoBGnp4Zl-jC4@fat_crate.local>
 <279595c8-30bb-4c01-8203-95619bab3d47@amd.com>
 <20260914231546.GAaqiAIsjGUdsK3MAq@fat_crate.local>
 <1c3d9841-eef8-4c94-9b2c-a7ed92a68260@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1c3d9841-eef8-4c94-9b2c-a7ed92a68260@amd.com>
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 04:04:31PM -0500, Kalra, Ashish wrote:
> One thing to sort out first, since you've already applied p1=E2=80=91p3=
: the setup/enable rework reshapes a few things that landed
> in p3 =E2=80=94 snp_setup_rmpopt() becomes the single snp_enable_rmpopt=
() export, rmpopt_capable() now uses the rmpopt_enabled
> guard, and the ccp caller in sev-dev.c changes with the rename. I can c=
arry all of that as deltas in the respun p4 (i.e.
> p3 adds snp_setup_rmpopt() and p4 renames/reworks it right after), but =
if you'd rather it land cleanly I can refresh p3
> too so it introduces the final shape. Which would you prefer =E2=80=94 =
p4 deltas over what's applied, or a refreshed p3 as well?

Nah, feel free to send a new set, if you have to touch 1-3.

Thx.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
