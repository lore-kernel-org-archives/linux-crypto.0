Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D27922FADE;
	Wed, 19 Feb 2025 19:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739993447; cv=none; b=MuodwzwTx1otLzxfGhkM6ZgOJy4CP9fG+FSu8pJDcKsBnG7i4qtMae9yD0mwnaAw+caaLgqfTWYJqy76MvnA6psCMG6YwSZSh2nXfFzIxSAWNPsXm/3bmUJtleEfUoNjeKXhb4xqSrwpLKkWXyTjFNgoIKgKQRJQTKf1Fcfp8zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739993447; c=relaxed/simple;
	bh=sksAyNByNx8NSbChA5OyZoKTsU644DZbakRE/oSvqeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MAZorF4cKw/SB6LotvUHh+TkEPLgGQOFBHAg1kzvTeJa6Cwfnp8PWrRvSd1DD3uwy1afokp04jLzhFEJ76L6rNcYdbYOvIfF/eNLmYyYaLdsGUvZ4ifRcMrp27cK4lDkobeFWBYV9xVHfqGLSuc/SQ4I1DZOuLsoB1juJ/uKeyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cd3e3eN+; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cd3e3eN+"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1A9DB40E015D;
	Wed, 19 Feb 2025 19:30:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id CiZ-zDsycV4B; Wed, 19 Feb 2025 19:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739993438; bh=iIz2uUSUDw1IG6CoLQi9jMA0nzb/XyRocZHfN1XR/B8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cd3e3eN+0/Un1Q65ttpGp0zhvbBD8sm48aGJ5khm9Ij5ZdaCHyEzNzqmjqtYjQro1
	 3jc1/RKtrD8/TBMA8RS8LLbuSkEc1DNxgEGnYthOFl66c15u6XKiu9i+4oH2TP7WUa
	 sDAyPLT9jsYBiCoDLOD2i6yzrEVerygg+hHHiPqLWoZpY0JpLj1pxVeeo16L02UcCf
	 ieWgIyDoTMEFMIumti7nJJJf95GAAKmwWhghktakEEJMM1KUaP+1RNvt6FZPqZLUt0
	 IBGcvBBDCJktWFEgRtesDqSauGSKMUyhNDIJfR+0IUcaKsv8Pvmi+cmbfnqIO90+oY
	 suV8/9wUsRt5tOwJPAvGb83M/JusjYPgSDFeTBeH3wlIcTbiOrMGW7NM8Hw1aWdaL5
	 Hv/nMHFM75ZNli2/ijzONDBF/+VErQoP+5Gzr/ZnOnPV74T/owUpL3IxH7h7DXxSgA
	 T+zDEuyJD8yJIO2ti7h7IUcC8DfR9LH0fSw/mw5uqWJEIloC5q5Jp+upBfDSZjnOk7
	 IAhbckEnlPkDBrIr5CkKrrInGkVOFxboM6+hT9XtbWs1iyMTVznlR0+VjXHU/ArX1Y
	 SibPu/PMQtZroNeMhUxAAvKbHhmhcxGpBPS54CMR8HHRba9sF8g8Sm0w7YyUF9JYV/
	 5ao4qJibuRTB5+msE2szY0uY=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CAD4F40E015F;
	Wed, 19 Feb 2025 19:30:13 +0000 (UTC)
Date: Wed, 19 Feb 2025 20:30:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, pawan.kumar.gupta@linux.intel.com,
	jpoimboe@kernel.org, daniel.sneddon@linux.intel.com,
	perry.yuan@amd.com, thomas.lendacky@amd.com, sandipan.das@amd.com,
	namhyung@kernel.org, acme@redhat.com, xin3.li@intel.com,
	brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, CobeChen@zhaoxin.com,
	TimGuo@zhaoxin.com, LeoLiu-oc@zhaoxin.com, GeorgeXue@zhaoxin.com
Subject: Re: [PATCH 1/2] x86/cpufeatures: Add CPU feature flags for Zhaoxin
 Hash Engine v2
Message-ID: <20250219193007.GPZ7YxP3aKjTV08yJo@fat_crate.local>
References: <20250114121301.156359-1-TonyWWang-oc@zhaoxin.com>
 <20250114121301.156359-2-TonyWWang-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250114121301.156359-2-TonyWWang-oc@zhaoxin.com>

On Tue, Jan 14, 2025 at 08:13:00PM +0800, Tony W Wang-oc wrote:
> Zhaoxin currently uses CPUID leaf 0xC0000001 instead of VIA/Cyrix/
> Centaur to represent the presence or absence of certain CPU features
> due to company changes. The previously occupied bits in CPUID leaf
> 0xC0000001 remain functional, and the unoccupied bits are used by
> Zhaoxin to represent some new CPU features.
> 
> Zhaoxin CPUs implements the PadLock Hash Engine v2 feature on the
> basis of features supported by CPUID leaf 0xC0000001, which indicates
> that Zhaoxin CPUs support SHA384/SHA512 algorithm hardware instructions.
> 
> Add two Padlock Hash Engine v2 feature flags support in cpufeatures.h
> 
> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
> ---
>  arch/x86/include/asm/cpufeatures.h       | 4 +++-
>  tools/arch/x86/include/asm/cpufeatures.h | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)

I'm assuming this is going through the crypto tree due to patch 2 so for this
one:

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
