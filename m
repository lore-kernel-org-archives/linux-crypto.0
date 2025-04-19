Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750A153AC;
	Sat, 19 Apr 2025 03:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745032917; cv=none; b=mKCVAOciK9wBw6AI+VMGTxtLwsotERgApW45oDvJnMS7u8cpChi3KZljr2ovDG+AE8voMLKItMQIFFxQizgHqTX8MqLZ9BBFzLwh5nRZQU+d3RUje16lG85bvzg9Xje3ejH9mT5rjSrj2IPWuaPxCcpeZN5dof8DljPeVEsd/yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745032917; c=relaxed/simple;
	bh=RobllJVSVcEPvpw3eHIb2maEo3haaCJEdvx0z+gWyR8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=p7/34zDaKjZo4RAT6libh8A5t+i8A6XCrVy1oXTr9FpAJ9S/0l3mr/I7wa4GxZBquNPpvikSEkgvKOx3vclFJ6eno+wCk9JbhqXsLRSTtECbMVyTXeaaLZW/cxUibnJoxKI4zJwazVJjFOpd37roEyuEY7wmFyZVd6ea9gJ7TxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ngx6uI8k; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ngx6uI8k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wZ1lnHF/CzliUb7GzPY1eCrDK3d2yWHsU5Q/0caeY1I=; b=ngx6uI8k81i+9Jjvuvjhkm/vhT
	lanFVL7UAJTS+gMPgMTqJTCZvFmwX1fyE8IoIGwprlAC1kLEfmbX6JanhIi4zc6EjKCl/22NeqyD8
	nqL81zARYUJidkH8deibJXgYoytOb5mfelVAIwe9UDx0PHMlJy0aa+pOoGkmWZWmbgfHZ8/E/iRfe
	g9hfi3OqlQ5jvCqvyePv3XpLQV72W5okWzNAm76APNIAhnp4ibe3R7jpWLli14hKgclyxsbN3mzOu
	4Bh9G5rYxtcR1bjKasPSJceq0uNuN8OZ9BaehZaOklJpHnPJOgqUGzOSEenYMp/ziEF39xfMbDQYk
	blK5t15w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5ym0-00GuPu-33;
	Sat, 19 Apr 2025 11:21:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Apr 2025 11:21:44 +0800
Date: Sat, 19 Apr 2025 11:21:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/chacha - restore ability to remove modules
Message-ID: <aAMWyCjoFZJf9tOQ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418035909.64902-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Though the module_exit functions are now no-ops, they should still be
> defined, since otherwise the modules become unremovable.
> 
> Fixes: 08820553f33a ("crypto: arm/chacha - remove the redundant skcipher algorithms")
> Fixes: 8c28abede16c ("crypto: arm64/chacha - remove the skcipher algorithms")
> Fixes: f7915484c020 ("crypto: powerpc/chacha - remove the skcipher algorithms")
> Fixes: ceba0eda8313 ("crypto: riscv/chacha - implement library instead of skcipher")
> Fixes: 632ab0978f08 ("crypto: x86/chacha - remove the skcipher algorithms")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/arm/crypto/chacha-glue.c           | 5 +++++
> arch/arm64/crypto/chacha-neon-glue.c    | 5 +++++
> arch/powerpc/crypto/chacha-p10-glue.c   | 5 +++++
> arch/riscv/crypto/chacha-riscv64-glue.c | 5 +++++
> arch/x86/crypto/chacha_glue.c           | 5 +++++
> 5 files changed, 25 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
