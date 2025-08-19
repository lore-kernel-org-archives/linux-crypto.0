Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E718F31B13C;
	Tue, 19 Aug 2025 09:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755597156; cv=none; b=CVXWJVvRTK1r5RbrFxZ+OSMyOzssg8Kf3BmjO9IX3u8BQk3+zIIR2qYJUNR2SbHiZdHeMIZBsk1un9q/xkIiYw1sF3UkW96qt6szuvhXgMMyG9WWARJBsZcScwRv300agJYgaxB1Ya4bcci5QA93oigw/XmgT2qsi5VWPT10Z8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755597156; c=relaxed/simple;
	bh=sk9SEQ1XauiFRExOYvEAvpEZAzKG7b/Byw4EoS48Z7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LUA1Jdx6d5ICPEpxNf6zVIasd4rwIeW/LPRUTQ9EMZ4gEFohG45ygB/EFOqRc3xZqRw1XVeQM3Wiys6DMgUgrWZoFPgt//fwknn5iTQnAAvoprBpomu9ldJY+QmUy6ZH0CM65ZRkx7B6qpqrcqN7Jka3EfsS0lr2C4XHhgx05DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SuMZ7fjD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SuMZ7fjD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=O60jgYN8/rCyrE1ImyUigu9cNTm7wM/14yyd1zF0yDY=; b=SuMZ7fjD2iQvJTLLepP7qTWQ95
	VLTdEfEElL+ojm7Ib4MO1yWJUuQdTGvts35x2DpPZmQOh91oMdSJn3bM5/krdlUQsw0zU26eZtD4x
	Pt3DQtOhuVUBIkf+5bwHt4OnHuEB2zoEmv4COQ+1AqGBomTbXoFGVsmU26olIWWdDOOGh+2n64dz1
	oMXNznRWDIcKtlyBWKrVnoYOzLJ2w/gRTl9VQ24I/2tsa1fy+Ix3sakTFjmFSsPCUqb1ZmdlG8/Yk
	ZzdcxhbhnZMLoooDiFdFSmP9Feim0h54/OBOJcgO70otOLrpuG0SC0wKDD5E3/x+bKgw4Vp0HTGWr
	5tQnDjOw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uoIld-00FTfw-1e;
	Tue, 19 Aug 2025 17:52:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 19 Aug 2025 17:52:29 +0800
Date: Tue, 19 Aug 2025 17:52:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/4] crypto:x86 - Remove CONFIG_AS_VPCLMULQDQ
Message-ID: <aKRJXVSg_fp5TYwu@gondor.apana.org.au>
References: <20250819085855.333380-1-ubizjak@gmail.com>
 <20250819085855.333380-3-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819085855.333380-3-ubizjak@gmail.com>

On Tue, Aug 19, 2025 at 10:57:51AM +0200, Uros Bizjak wrote:
> Current minimum required version of binutils is 2.30,
> which supports VPCLMULQDQ instruction mnemonics.
> 
> Remove check for assembler support of VPCLMULQDQ instructions
> and all relevant macros for conditional compilation.
> 
> No functional change intended.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/Kconfig.assembler           |  5 -----
>  arch/x86/crypto/Makefile             |  6 ++----
>  arch/x86/crypto/aes-ctr-avx-x86_64.S |  2 --
>  arch/x86/crypto/aes-xts-avx-x86_64.S |  2 --
>  arch/x86/crypto/aesni-intel_glue.c   | 22 +++-------------------
>  5 files changed, 5 insertions(+), 32 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
