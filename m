Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5DC269D18;
	Fri,  3 Apr 2026 01:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178428; cv=none; b=iMciR7MXgnrdfxX5ssOw44y/6PKBhyYyncsRvsg1hqh4XgIFbCVstYjPUN0VLZh2WBmqXnF9LAmVlW+7G9lGqz4NZGOx/DzLcUEbAfDSp3LH2eT+jkARWTifiTJp78uO1VKCw6JaS4djllwmu2JsC5Dv2UYhMS6AjO7fWpu0/30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178428; c=relaxed/simple;
	bh=sqxDIV0RF8nIZelYgUioKN3XTPgk894VUZlwMHlpUb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BTz6BOF6Rc6ieUst29mUArrxBSlQg03EQxuEsk1wxV/rzXtNSz4wiIxD8C7ajXe0FxTf5hv9e0Uqi/lgBfgxiAxByyFGCfE2rLaMKVccbkJDngMJ1DnSQxfFfd4cfDY3PcRARqLBYRexFZeYHIMT7pWfalpmehhgiJKqHEc/CFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gVbSUnj7; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gVbSUnj7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=rODPce7ygzLPFsB/u/35h/aUCre/IZsi6I1r9lopMT8=; 
	b=gVbSUnj7ev4HXs/cFCFLInoPbbuBFKVc3lP8iDVo+2pDSSQtk9z3IgVGvuqJOsZS9TJWrTsq30W
	X817sv5iCAIErqpYsxBJ4DixSUaPxYRrzhDPV/490yKf54dT9/SsT4UBp1K8KUGWulK0wNkg+3kuv
	CraL1525Rix9a8CEjqNdtBA85J9BclVsFVl7/bHXDUqJnz1JEBzop5TArxSSyY0Zety3Ew2SfkOUE
	jSjYzqfUvDVheu/IN5I232jCH1ifEk9whI+yWQFg/De35sMRqe7suYWPB+f2EKqp3a94hAuLgVxjQ
	XQAH4QBVSOhXggojtOzZpe8qxXonFbaPQk3A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8Saa-003R28-2T;
	Fri, 03 Apr 2026 09:07:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 09:07:03 +0800
Date: Fri, 3 Apr 2026 09:07:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
	x86@kernel.org, Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: Re: [PATCH 0/3] crypto: Remove arch-optimized des and des3_ede code
Message-ID: <ac8St5Ggesgl-bp4@gondor.apana.org.au>
References: <20260326201246.57544-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326201246.57544-1-ebiggers@kernel.org>

On Thu, Mar 26, 2026 at 01:12:42PM -0700, Eric Biggers wrote:
> DES and 3DES are cryptographically obsolete and insecure by modern
> standards.  Continuing to maintain highly specific, complex assembly and
> glue code for them, especially when the code isn't testable in QEMU
> (s390 and sparc), is unnecessary and risky.
> 
> Thus, this series removes the architecture-optimized DES and 3DES code
> for the three architectures that had it: s390, sparc, and x86.
> 
> This series is targeting cryptodev/master.
> 
> Eric Biggers (3):
>   crypto: s390 - Remove des and des3_ede code
>   crypto: sparc - Remove des and des3_ede code
>   crypto: x86 - Remove des and des3_ede code
> 
>  arch/s390/configs/debug_defconfig |   1 -
>  arch/s390/configs/defconfig       |   1 -
>  arch/s390/crypto/Kconfig          |  16 -
>  arch/s390/crypto/Makefile         |   1 -
>  arch/s390/crypto/des_s390.c       | 502 ------------------
>  arch/sparc/crypto/Kconfig         |  14 -
>  arch/sparc/crypto/Makefile        |   2 -
>  arch/sparc/crypto/des_asm.S       | 419 ---------------
>  arch/sparc/crypto/des_glue.c      | 482 -----------------
>  arch/x86/crypto/Kconfig           |  14 -
>  arch/x86/crypto/Makefile          |   3 -
>  arch/x86/crypto/des3_ede-asm_64.S | 831 ------------------------------
>  arch/x86/crypto/des3_ede_glue.c   | 391 --------------
>  13 files changed, 2677 deletions(-)
>  delete mode 100644 arch/s390/crypto/des_s390.c
>  delete mode 100644 arch/sparc/crypto/des_asm.S
>  delete mode 100644 arch/sparc/crypto/des_glue.c
>  delete mode 100644 arch/x86/crypto/des3_ede-asm_64.S
>  delete mode 100644 arch/x86/crypto/des3_ede_glue.c
> 
> 
> base-commit: f9bbd547cfb98b1c5e535aab9b0671a2ff22453a
> -- 
> 2.53.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
