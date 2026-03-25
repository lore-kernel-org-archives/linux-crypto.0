Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45033382E7;
	Wed, 25 Mar 2026 09:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774432189; cv=none; b=M99Xjn3/TskzDpQ8D0uwaCrhLA1iA6tb6p/seinBfVUQP79Fhk5pQaUyG7/Gew7MtyGFdECKJrcLwTuk3cxxqROTLAUdxFGk3G6Nfp4qhNlnyZMhMKMP3hsFSILEHwqKbJkIzjYOFO6quhhFN+UiU7Boi3ODKNi/EfnbCBRYq3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774432189; c=relaxed/simple;
	bh=cjUh84v06t+5duH/JkRGgIHlc5Nd7VmjKA1DabpKZzM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Vkp59NFtqi0UcSkRZfTQoJTVqKLFgZNRG5yxpLuLZ4EBjaJPHN5b4rN4k57fiAvPDZIaUYJp10yF42zyXrEdj3A7UXIMzzoVWyRykd3F/X4NISY4NrLbB0HJ9y/8zmUhVwRF/lQpGlkkvY7xi9U+J39qyKMdbNmWWrVvePcU+1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Jx8UEjkl; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Jx8UEjkl"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E5FD140E0222;
	Wed, 25 Mar 2026 09:49:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id DL2YnFTbJOvb; Wed, 25 Mar 2026 09:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1774432177; bh=opSuZ+nsbfDVXSO0zZ3CqmEhBPTMnFclYwOe7hnJzjY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Jx8UEjklj2eZQBaIFoxv0oTQssN5+uDjycqG6lg6j2qTmKI01oydPP+BbH3kPy9YF
	 CBATsQm0atYNOg/K2+2IXpDWwVSHea/L3tPkE9FMo9sn/jZrKhZdYdPisTYiwNGO1w
	 kJE/47MKnQG7KCQwO4Bt1O18cLlB0Kc2BTeDWawXRuVBA0egkJhiS05HEKij4H3JFD
	 KN56s+4nVsmzaTJYin6jVv9HS2TFrvLYXFkQw+aXMI24sIu0Q5OCp7QsSP9Kb+ijr3
	 65SGP5KV/DlGCL3fuczM3ZDYflyPutQecyln65ZIF+yCdOzDRW7itaePNqASGoT1t5
	 +fwWZQKucvoFjh2ZyTokSqxQMxDsNvJXtQmjuLCkzI5q9e8GxhN3WmQMu9AITqQZEv
	 xjo7YGTu3h2CfLVVsBxVCtZrGMbAN/90ojZnUAsVyRx5dyqS4tjPcOoCr9balSSBO1
	 8CI0+MAZc9pJYOXeBNQv0OjL6Ped1mjhmdt2D+MNov7mRW0+4ZqfNLK1LkBqn26qFp
	 2Lc2uE6QQ9Mfizy4QlryMZQdzDL2cjkkEZV1cfmpI85JBEGejxpSMTkiJvtL2SRplc
	 3AGdXHNx5CNWEvlu4yhmEp5vJ2dFsFNtuLkwFpQ9IrYI+wwwVrX64zSXtqd1cNXT+F
	 NXsKXfQjIaE5VTumCo1xmVkM=
Received: from ehlo.thunderbird.net (unknown [IPv6:2a02:3033:266:68d6:b127:ed1d:b692:3857])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 07DBA40E015B;
	Wed, 25 Mar 2026 09:49:15 +0000 (UTC)
Date: Wed, 25 Mar 2026 09:07:42 +0000
From: Borislav Petkov <bp@alien8.de>
To: Tycho Andersen <tycho@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Kishon Vijay Abraham I <kvijayab@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Kim Phillips <kim.phillips@amd.com>, Sean Christopherson <seanjc@google.com>
CC: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 "Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: Re: [PATCH v4 0/7] Move SNP initialization to the CCP driver
User-Agent: K-9 Mail for Android
In-Reply-To: <20260324161301.1353976-1-tycho@kernel.org>
References: <20260324161301.1353976-1-tycho@kernel.org>
Message-ID: <6A6AA56D-6B4C-4C32-A639-18C14BC0C358@alien8.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On March 24, 2026 4:12:54 PM UTC, Tycho Andersen <tycho@kernel=2Eorg> wrote=
:
>From: "Tycho Andersen (AMD)" <tycho@kernel=2Eorg>
>
>Changes are:
>* commit message fixes: snp -> sev, add arch/x86/ to path, capitalize thi=
ngs
>* rename snp_set_hsave_pa() -> clear_hsave_pa(), since it's clearing the =
register
>* snp_prepare_for_snp_init() -> snp_prepare()
>* snp_x86_shutdown() -> snp_shutdown()
>* 0 -> NULL, drop a newline in snp_shutdown()
>* carry Herbert's acks as appropriate
>
>v3 is here: https://lore=2Ekernel=2Eorg/all/20260317162157=2E150842-1-tyc=
ho@kernel=2Eorg/
>
>Tom Lendacky (2):
>  x86/sev: Create a function to clear/zero the RMP
>  crypto/ccp: Update HV_FIXED page states to allow freeing of memory
>
>Tycho Andersen (AMD) (5):
>  x86/sev: Create snp_prepare()
>  x86/sev: Create snp_shutdown()
>  x86/sev, crypto/ccp: Move SNP init to ccp driver
>  x86/sev, crypto/ccp: Move HSAVE_PA setup to arch/x86/
>  crypto/ccp: Implement SNP x86 shutdown
>
> arch/x86/include/asm/sev=2Eh   |   4 ++
> arch/x86/virt/svm/sev=2Ec      | 111 ++++++++++++++++++++++++-----------
> drivers/crypto/ccp/sev-dev=2Ec |  62 ++++++++++---------
> include/linux/psp-sev=2Eh      |   5 +-
> 4 files changed, 120 insertions(+), 62 deletions(-)
>
>
>base-commit: 2ca26dad836fb4cd18694ef85af7a71d2878b239

Sachiko has some questions:

https://sashiko=2Edev/#/patchset/20260324161301=2E1353976-1-tycho%40kernel=
=2Eorg
--=20
Small device=2E Typos and formatting crap
