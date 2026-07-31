Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17491A3AB0;
	Fri, 31 Jul 2026 00:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785456809; cv=none; b=tk7R44LoU1L2/VRTCIWJhl9i5IhnzPvjea2On6kkuCI260F5HDq/B58xWazrEuY3iWzNY0j65w/25EKsNOONDqhW51IENEeOne82TX023KyCRaIv1L24ASxHw/VVcuEYQBmuDlsH2fnyZwpmG0MFkINYgC/hKVdWsHQEuoe6hp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785456809; c=relaxed/simple;
	bh=bHoKjpRPsU20OfpCgpLdzmTUQpQ734HXDcgDHAbvAdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FMnS7TfA42VPjyNuBXJxwi6KHfe8HxEmV85SZKOEVdRCz7FT/y54hYbJYJU1H5LpKfEEvoejqTAals+8GtP80SI2Q559FG7IJn+batBN9bnWTqyG5kJaECUN15jXWJ3LqveV092huuYn65ShRYKTIuKgctZBQ4RN6Gwnem/ZMPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=SDM7RnX1 reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="SDM7RnX1"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 92FAD40E02B7;
	Fri, 31 Jul 2026 00:13:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 7pPvPuiLtB9e; Fri, 31 Jul 2026 00:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785456795; bh=C/SHV9jDMzcbkRlE8+MAQIErFrfbzUMau76TNYPkhG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SDM7RnX1rp3zqyTBpJnOkspdPTzmAjNzhvgGYuGeaA/yrl650G6/tjb1uKeh+5ESl
	 GYkJ4/qmjD5twBhUmKOvfxR6wOdTxfaCwnOSwwBVDtla5F5gMmqERvLSO2PQs6hUMZ
	 9TL1oxkRgqP1nrE65zhPQBq/QG7ep41g2ymrHlq/9W1Eih5DWiVRGiOhNB3yw7Pt4V
	 jd6Nd3eJa/XUZHTpNtO7DpHXOphYqmfdZCBpAlytmtbclxJXaL6CoM5jcYFZKUewV/
	 Cajd3SzfCHo4QNMgE+K5t5dgDt9haL9lwxliiPbKk/qFTi58XO454EVPXdKhZGEw3q
	 KtoEKNfvYFNegD4FPBAfhgnqTmBuwTXPckX5//B+3LSX49emxya+9ghlgqYnZCBIOS
	 rXRouIEQBRPWy1G4796WjY6zcruLljKQV1dURECZd4CykWDgcA6AbfeSq+a0QDsfMB
	 uJYGemCGryIM7WzxOcKMiPksnSOLln4eJ4C3EtFZbpDTCtoGCDIiCUdPhjl0eb1aE2
	 YGMT7c3xVDfhRUqlCvK8uoAPdMPHLhMgQkuTadp2NzIECzmPtaDpfjgyAiHVR/rqDu
	 Dw3ODzMI8Rnz9QyK49sSpMLKBBubgL/R4MoO88iDUhIS403D67WO6tCqunXb1Mqy+E
	 gp64ARw5Mas0wYqNRvmCaYg0=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8E59440E00B8;
	Fri, 31 Jul 2026 00:12:40 +0000 (UTC)
Date: Thu, 30 Jul 2026 17:12:38 -0700
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
Subject: Re: [PATCH v11 3/6] x86/sev: Initialize RMPOPT configuration MSRs
Message-ID: <20260731001238.GMamvodtFAY7Scdtha@fat_crate.local>
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <ff346ea1770cf996e1623270a085ac08d21888c6.1784844080.git.ashish.kalra@amd.com>
 <20260730020704.GGamqxyPy5oJAmC5Oy@fat_crate.local>
 <5a980015-c391-4019-8b44-48d1373eaea7@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5a980015-c391-4019-8b44-48d1373eaea7@amd.com>
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 03:00:55PM -0500, Kalra, Ashish wrote:
> No hard dependency =E2=80=94 it only needs SNP initialized (post
> SNP_INIT_EX/DF_FLUSH), and the initial pass is async anyway, so it's
> independent of the SEV-TIO block and the panic notifier. So i can move =
it to
> the end (after the TIO block so it runs last without touching TIO order=
ing),
> but is there a specific reason you want me to move it to the end, as it=
 can
> just stay here after SNP_INIT.

The usual reason is, you add new code at the end. I.e., you append it. Th=
at is
usually easier for backporting too.

When you put it *NOT* at the end, then the first question I have is, why =
is
this thing there? Is there a particular reason for it to be there? Is ord=
ering
important all of a sudden?

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
