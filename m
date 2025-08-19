Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD1E311977;
	Tue, 19 Aug 2025 09:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755597148; cv=none; b=hEV1KG987Jb727+LeOaCJ1NUR28MQovUA3nTMX2yXaocyFR+ix/2R/WTMcj73rbLK6z+qA4y5ntzZAMo0BFwvam/RYcFa/66yI797+a3WHU8iksIP54qn0pVHAxUlQNgqAn0isy4pFoHYHbTStc+omAWR2x1rVwyKilKEYf4iRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755597148; c=relaxed/simple;
	bh=Oe09uXjCrVJXPasJBDooO/cYDoS21WDAFEw1Xd0gzHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpE2maLiCPhiwOyPxfZw5cXhPUkaBPvIi2IAJaACaLFukFBOFOwrswfzdDYbO8lT6ck7HJE4Yi3nJ+ggwbdGux9Jb3VTAVBllGDsE4A8m6cduy3EaV6wpTePEW9W051QHL37jJOSdjf62pu+vTpkgkwzJtxLa1nW4dFOnT8WbY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QFfBJtVa; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QFfBJtVa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6Ka0ZIkU24Zmqvm9tbsjRwVEJ/EjpIJy/NsunVNq46w=; b=QFfBJtVaQ/xejmkemv216O+1m1
	jXq75v62hnmXQntbwhphOpYVuOQxolG5lizHx9tr2nODFnqp60dSPibSqpAh1iqemmQRhxSQUQD69
	mIj4Koa0aY1HjQWVKa5bf7KRDi7gRkrVAOpQhS/84MFE8+icfCuJQZC2WPY1Nx5Q1ydQ8eK9X7+f0
	47eCEExcEfO3NtF/ylme9UYxf3RtUxpL0lezI5IXnwW5AcPC8C0dPJieG9jUiryztv5EMUYSRKdR4
	VE1ILtlyJ+sTtQGdXSvZZv/UhUOrw5yatixqfVmY99/mytdDsdwglB7qyzenUFgq5Db9CDi46az8l
	Ogs4B0KQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uoIlV-00FTfS-1W;
	Tue, 19 Aug 2025 17:52:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 19 Aug 2025 17:52:21 +0800
Date: Tue, 19 Aug 2025 17:52:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/4] crypto:x86 - Remove CONFIG_AS_VAES
Message-ID: <aKRJVTuSc_oIHfmL@gondor.apana.org.au>
References: <20250819085855.333380-1-ubizjak@gmail.com>
 <20250819085855.333380-2-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819085855.333380-2-ubizjak@gmail.com>

On Tue, Aug 19, 2025 at 10:57:50AM +0200, Uros Bizjak wrote:
> Current minimum required version of binutils is 2.30,
> which supports VAES instruction mnemonics.
> 
> Remove check for assembler support of VAES instructions
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
>  arch/x86/crypto/Makefile             |  2 +-
>  arch/x86/crypto/aes-ctr-avx-x86_64.S |  4 ++--
>  arch/x86/crypto/aes-xts-avx-x86_64.S |  4 ++--
>  arch/x86/crypto/aesni-intel_glue.c   | 14 +++++++-------
>  5 files changed, 12 insertions(+), 17 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
