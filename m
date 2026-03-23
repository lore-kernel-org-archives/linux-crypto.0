Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91462517AF;
	Mon, 23 Mar 2026 15:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774280853; cv=none; b=DAP9yxjSHnIxIZkx5vB4t6KJIVBOkd4Rj1qrmNy2zwPJqMhjhPww4Elm74Nx75w8C5Yyou3J3RqV2eydXkN7cEq0nmgPz7Gz+giXFhS1WalXdFQV4+S3EzS13ONYBRaQE2mXeyd1qO58IvHwbWsnqNpy9lc1pz/9IF300AW6d30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774280853; c=relaxed/simple;
	bh=joCNnMqjilSmKJyyYetjOdhS9xLaXMkKBhscCp3nPBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbhzeWKK1X4iLgFqseLb0iv/a9b++UnXGFc+chrOYe4DYJMa+UtPJdSoskV78B317Ym8s+O1mb+3suqggMTh6P5JfF49dPb2k5/kcX52k/E0KW9+YTZypQoVcgWwZ7YFW7W//nFk44mlcUI2r6Na1R/QVIIX8ER6+6geli+z+KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=LYRHHvwS; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="LYRHHvwS"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 22CE440E01B5;
	Mon, 23 Mar 2026 15:47:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id AshPm7v0_NYd; Mon, 23 Mar 2026 15:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1774280843; bh=zqulSAdpxOM1UEu9rcgn1fNvE9odXJe6bRV4qgcBX2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LYRHHvwS6y2ouOqN8YiLhORGgkG3wP+PtBdskvxHkcfJne1mXhGj/wEWUHvisI+1O
	 cZfhv/S/2AKYvG6kVmF9XmgVvUZNXcKowpUw1AmYA4beEaqrciIeZoYVMDTy/qeIFd
	 ab1roOya6UI/igFOjgVQ0ljckVfqUhJ/MmKjHBLih5ugWHxXfb9hc2vjvImwd7wQR2
	 Fn6HXcV59KIBphrDav1CIONqPog/KQUkrqhyzw0574T9TZYLZzOxFplEc48QRfjlwV
	 8XMIHx6xOsoK2KahIHKMoebTF0V8FUhbf54HLTmLRleZ9QSApv3lUnPpDChK4yoNX0
	 IW5CEzEzAj1m2oZ67tTxi2CD23/hh0pzRn4ZnLaF+v+9RwbOKPFQrrvnjXbINvtjkB
	 Lzrn0IfXm5lNOuboQtKaDQ0AwftXJ7lomXvzIJav9vKiU3GeM7eKUnH+/Ja7LoqcWz
	 GrcAMp5jl0Ev0TIpVr+ktMrYzjczavKONAXMT1LHWskM9F5wnkOVVJPWri/LZq2bdn
	 Z6UsIeVHCUL/IR6/sNCwCeq75V7HetlTysckDNMa/eF6PWpsJyDc+wHbHVyqqL9qPR
	 eF1BIxcUqJyy1ZKEizAys1cv7WhgDfIxEYc6ig1Oo78AgIDbHwXLuy4blzEFPJCwyl
	 QYEaY7YnpmXP8uzRwCAZJ2Ag=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 8D31640E019D;
	Mon, 23 Mar 2026 15:47:02 +0000 (UTC)
Date: Mon, 23 Mar 2026 16:47:01 +0100
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
Subject: Re: [PATCH v3 5/7] x86/snp, crypto: move HSAVE_PA setup to arch/
Message-ID: <20260323154701.GDacFgdcf_3HRsmGAQ@fat_crate.local>
References: <20260317162157.150842-1-tycho@kernel.org>
 <20260317162157.150842-6-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260317162157.150842-6-tycho@kernel.org>

On Tue, Mar 17, 2026 at 10:21:55AM -0600, Tycho Andersen wrote:
> Subject: Re: [PATCH v3 5/7] x86/snp, crypto: move HSAVE_PA setup to arch/

		... arch/x86/

There are other arches, you know. :)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
