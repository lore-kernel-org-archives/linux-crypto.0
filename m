Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750E8130A58;
	Tue, 21 May 2024 17:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716312148; cv=none; b=D0SDdFzjXm2sGYRxBeCjf8R9Z8YNCStnAhGIBigIJSOn1+DPLgikCI2iP8ECsIEeC0pqjhpMJeYAyM4E+vxuTuutFoQ4u0sNkVYprFjGTWqivVzs5T/k5HEO5Md74K8plZTdfzXE2DLM2jP5pBrmkzB6gUYVIG9Lr20WFSYoVL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716312148; c=relaxed/simple;
	bh=nuf4X0/T3JI5TC7+6qp+QSCJY0CBYQyeinR2VpKA0eQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rUjSRNFPpLDXeePzRheBL+EVZrLylJt/exyRLrGOY5O4D1oYlMWqGo5y01pQW6lCGHBsvtWJTij1lgk+31bAmW2pwL+qUeI6Vjtjp1M7Ew8IKctZVtu6jZxWsNfukYcTKiAzIN+WP9DeBaFVmyRKep77t7RSoyGHGzmxYkiclYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=DaI8y++R; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DaI8y++R"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3F20B40E023A;
	Tue, 21 May 2024 17:22:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id GnRxoitaSh5b; Tue, 21 May 2024 17:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1716312140; bh=4Mss1yr6Qw3EOpqWcdehvLeh6+TroHvA3YHEcHI6qQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DaI8y++RGYMnUF+kG0imSKJvAhFK6hArgFTrorl9pZb4PZVSTbx6yJppiuQ8/TPUI
	 5Ilc+vJn3EK66Dln+7E8mQvn68uQGG7QilLaKBtL4twmOdPe/Gw3EBxOFj2/9r2ONw
	 /b95hqjT+8C2fq5ugbwSKnmoV0JQ8kb3ZXci7FF7LN+fSy1H45dDFwLLtl1TSSkXEq
	 r4SbXN4Afq5vURl2QGM5g9PwSNKpnFRLko6ZD+neffnDdAXmxTOhqSR9lhLjM8sRL0
	 UNrtXkFHk3VXXDazbFjkjJ/cvUckX10StsWN4XyAuTFJUe9TCrPfjtvnBoA/lM53mH
	 UfRQiagyp6vLFrHWGzFklMbIgltUpl2xgUnFRnTFAtBLcoaJR17BV9d8JRJ/BF0lNa
	 hp6/6uGXTSuJK0blOK2XvrpIscCUp104d0DGfWEoAsfoX7Dk5B76PJXAZVawQNPOo7
	 138LUb2calgfQsLnkJdPxT7Ao4K27WAx3hwZu9habwrgYbPemjnu/14egJ8qWHQ3ig
	 JqcpDpktWK9CbizEmyHz7qRCWUpaXrPmkU81JahtnirdQdC3r6AQ0cDA+PCdtkUmeW
	 SNSjCrH7kpaC7Ff0oBHLX7k+WHw9GN4y4hPcqN2ucjEL7PsR7F7kGl0H8vt7tMjahX
	 G78qhsLfsvsCu3DO75x7Egj0=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2531B40E02A7;
	Tue, 21 May 2024 17:22:03 +0000 (UTC)
Date: Tue, 21 May 2024 19:22:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v6 01/49] crypto: x86/aes-xts - Switch to new Intel CPU
 model defines
Message-ID: <20240521172202.GFZkzYOh0pET7B1SFW@fat_crate.local>
References: <20240520224620.9480-1-tony.luck@intel.com>
 <20240520224620.9480-2-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240520224620.9480-2-tony.luck@intel.com>

+ Herbert as an FYI that I'll pick up this one and the next for 6.10 as
it is a fix for a regression that got discovered.

Thx.

On Mon, May 20, 2024 at 03:45:32PM -0700, Tony Luck wrote:
> New CPU #defines encode vendor and family as well as model.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index 5b25d2a58aeb..ef031655b2d3 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -1223,14 +1223,14 @@ DEFINE_XTS_ALG(vaes_avx10_512, "xts-aes-vaes-avx10_512", 800);
>   * implementation with ymm registers (256-bit vectors) will be used instead.
>   */
>  static const struct x86_cpu_id zmm_exclusion_list[] = {
> -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_SKYLAKE_X },
> -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_ICELAKE_X },
> -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_ICELAKE_D },
> -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_ICELAKE },
> -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_ICELAKE_L },
> -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_ICELAKE_NNPI },
> -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_TIGERLAKE_L },
> -	{ .vendor = X86_VENDOR_INTEL, .family = 6, .model = INTEL_FAM6_TIGERLAKE },
> +	X86_MATCH_VFM(INTEL_SKYLAKE_X,		0),
> +	X86_MATCH_VFM(INTEL_ICELAKE_X,		0),
> +	X86_MATCH_VFM(INTEL_ICELAKE_D,		0),
> +	X86_MATCH_VFM(INTEL_ICELAKE,		0),
> +	X86_MATCH_VFM(INTEL_ICELAKE_L,		0),
> +	X86_MATCH_VFM(INTEL_ICELAKE_NNPI,	0),
> +	X86_MATCH_VFM(INTEL_TIGERLAKE_L,	0),
> +	X86_MATCH_VFM(INTEL_TIGERLAKE,		0),
>  	/* Allow Rocket Lake and later, and Sapphire Rapids and later. */
>  	/* Also allow AMD CPUs (starting with Zen 4, the first with AVX-512). */
>  	{},
> -- 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
