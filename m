Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B87393DC0;
	Fri,  6 Mar 2026 15:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772812577; cv=none; b=TrJGvxERrkitGy++GmtrodfbgMnyXVUvGTSWOizSa+32fu4zoqXPoJssTjJUeCjAWj6ndyl9km90tNh8cSpu66s7ecfdxvmLsh0QcZdeWh66Up0ZWOymfutCpaQvttXelKq7L0jJvKGRMPiLZgI6CqD4GWcgRwX7Qbj1uA98/Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772812577; c=relaxed/simple;
	bh=6UcHndQr7ANL4MwOY2++n2867cjk1mbERzOry8yxiZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nj2ESWBHhmP3iCO5YVN13ZcSBaJKBae+Z7hJCWOVkON5sHBahk0Ag27Zsh8pURaud75s3toZM4X5tKXdY+TTM+5DiXWk7BciOWJDku7P3QtXobsKogNR278HcMxiSrpL/Wi11I2wTIGeoedzpcewWj2ApbngJ3dxcEGEB8izRIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=HCbGxb63; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="HCbGxb63"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9B68B40E01D5;
	Fri,  6 Mar 2026 15:56:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id DYBwOhK8saUQ; Fri,  6 Mar 2026 15:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1772812565; bh=ugYGZxma4kbhd3qtVb3diDEM6yaKrOOf2ZblkidBgWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HCbGxb63QhOfNq5r9yd2ScuBE+9sKe65ARRWQppvMgeIQV+ge2IAZi1aDq4x1tx35
	 JBAancWifDta6oWqzw4nEqnoNHWFHbE2o2na6RIZoTdS0kRaHVXrpWyylseVU8EAuh
	 tQFMS284GjGeJgPFjaw0Ej5BHKdKC/tkyR/hT97/v48Rbkf3WGWKTMSNojolzu+L7y
	 Pm/5I9rQSzMdFNHnvBn5hQ+CHsudCZuCF92MLXBx9TC0ErnZbZAH4fx/bU8tVhkW7L
	 0U9seO5f1XLkIY0byJXcgf24AM5sV559Y+mUxFomHNuzpeoM9JKwbsbpmLlsj8+b2f
	 PYzDDGDRwMIpFLJ3lYr4SgUHeGDxXdzgvYjvk7dfwLk3O0g9j2P1djPZj/j7cRbIjs
	 iCoeioaOh9nhZDVDGR3yX+eNIl3FZJV0T5YS+RHL1mxNnxZygdO958EU4XoDEzqj5J
	 FuNSowfy4pKF5FWLIRDVKMPl4+2Rp7un1zzJYot9GlgKAHG4D3YNqiPCwvWtkP0o3E
	 CkyUFykLd7hVmA8uRdqe0UoCtCmQUMONTdPFLoXUAD6cEOM7Zr/Ts53dt8U4/t+75c
	 gp0uul/3h6ZDSTUYiuCDMQh51dP3+yL5KcENzDdsTAkW1v6akKfKMpfHb842kexM+s
	 ZewOeRi5CQuDaYXv7sd+Disk=
Received: from zn.tnic (pd9530d5e.dip0.t-ipconnect.de [217.83.13.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 9FF3040E00DE;
	Fri,  6 Mar 2026 15:55:44 +0000 (UTC)
Date: Fri, 6 Mar 2026 16:55:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tycho Andersen <tycho@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 02/11] x86/snp: Keep the RMP table bookkeeping area mapped
Message-ID: <20260306155543.GLaar4_9VHzLKL6fYZ@fat_crate.local>
References: <20260302191334.937981-1-tycho@kernel.org>
 <20260302191334.937981-3-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260302191334.937981-3-tycho@kernel.org>

On Mon, Mar 02, 2026 at 12:13:25PM -0700, Tycho Andersen wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> In prep for delayed SNP initialization and disablement on shutdown, the
     ^^^^

Yeah, write it out, you can do it... :-P

And yes, this sounds like Tom to me. :-P

> RMP will need to be cleared each time SNP is disabled. Maintain the

s/the //

> the mapping to the RMP bookkeeping area to avoid mapping and unmapping it
> each time and any possible errors that may arise from that.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  arch/x86/virt/svm/sev.c | 40 +++++++++++++++++-----------------------
>  1 file changed, 17 insertions(+), 23 deletions(-)

Otherwise LGTM.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
