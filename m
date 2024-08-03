Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173AB4687;
	Sat,  3 Aug 2024 00:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722645609; cv=none; b=VLNHcWF9972ZXKmBWMSJO+z9es6OJj/1FJ3EntnWLZak+MUxAGkFGv4Kz5uU+zkktHcBEbEvxjcWZtW94Xva1+2lCOUp9/h0thDBncpPsYDshOWzNQrOLQtpBM6VAMrxB+IUcV2G/nSj8yqm5cVUUp2jLkEOeUvlbUwaDz7DgsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722645609; c=relaxed/simple;
	bh=PzMk2p3zdOZIqJkFUDWKpvnPX7N32f5w6EXQpIrRcJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bwb42F/0wivAKrJCtGCwAjaBF19r6X+pKY0xq4R714xOMPbC8eAuPi+PSPdybenX76fkY/ewjJhoOC2RPb9CfPemR497kwi9hBQADBK7znznkH6bQCACibQImP3ZdleApBUwmTtZ6LOwuWlcf7rxNdlBzD0zf/seRDGrTEJWNGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sa2fq-00276O-1O;
	Sat, 03 Aug 2024 08:39:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 03 Aug 2024 08:39:51 +0800
Date: Sat, 3 Aug 2024 08:39:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: herbertx/cryptodev <reply+AAIFISMST74UQEQBJUWW7J6EXDLZNEVBMPHARJBRSY@reply.github.com>
Cc: herbertx/cryptodev <cryptodev@noreply.github.com>,
	Author <author@noreply.github.com>, Jia He <justin.he@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-crypto@vger.kernel.org, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Andy Polyakov <appro@cryptogams.org>
Subject: Re: [herbertx/cryptodev] crypto: arm64/poly1305 - move data to
 rodata section (47d9625)
Message-ID: <Zq18V66ufraB_1-T@gondor.apana.org.au>
References: <herbertx/cryptodev/commit/47d96252099a7184b4bad852fcfa3c233c1d2f71@github.com>
 <herbertx/cryptodev/commit/47d96252099a7184b4bad852fcfa3c233c1d2f71/144978326@github.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <herbertx/cryptodev/commit/47d96252099a7184b4bad852fcfa3c233c1d2f71/144978326@github.com>

On Fri, Aug 02, 2024 at 08:09:10AM -0700, Andy Polyakov wrote:
> Formally speaking this is error prone, because there is no guarantee that linker will be able to resolve it as argument to `adr` instruction above. I mean since the address is resolved with `adr` instruction alone, there is a limit on how far the label can be from the instruction in question. On a practical level, if/since it's compiled as part of a kernel module, it won't be a problem, because the module won't be large enough to break the limit, but it **is** a problem in general case.
> 
> But why would objtool attempt to disassemble it? Does it actually attempt to disassemble unreferenced spaces between functions? Note that the .Lzeros label doesn't make it into .o file, so there won't be anything in the symbol table to discover as potential entry point...
> 
> -- 
> Reply to this email directly or view it on GitHub:
> https://github.com/herbertx/cryptodev/commit/47d96252099a7184b4bad852fcfa3c233c1d2f71#r144978326
> You are receiving this because you authored the thread.
> 
> Message ID: <herbertx/cryptodev/commit/47d96252099a7184b4bad852fcfa3c233c1d2f71/144978326@github.com>

Adding the original Cc list.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
