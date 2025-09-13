Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9B51F419B;
	Sat, 13 Sep 2025 04:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737713; cv=none; b=MHedl9FtTmDAjGk4TDGp/XD7L/ECJNA2Je67zIZHI28SeAsMqmUXFT8BxxofHK2Y7qJozNWHQao4nggwz6PlkkFHyXFa6mcJWZeor7yQ7aIvnzLJW94wMtaOYK70CNQbl9fidq26mrB7UCi/rXyQsXveYrWaEGxnx1C3ySxero4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737713; c=relaxed/simple;
	bh=cvjtbxHb81GqY1nr7CNjoolOYkcmrFi+G3Uk7AQCBhY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ckrTcueudwJU2x8T5E7/bEJGee2ReGT45Ch7YmI1Lajvk5bswXC0ZutrWkjLf8cDbP78ns6oDhVAL6ryV/+FXqQYKTMxpggJIPQACKtmMqj0eQ1v6LZhx63uNGaDfN6tGO9gui2Pq/OTbwYLwbGNsvHBTGRBOU7Xw5PRzKetB7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NUd6U9IA; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NUd6U9IA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3Vdz4KdJepaWOWVazMBUxWQ9UZEnxrMMUqkkEJTGiR8=; b=NUd6U9IAWri7sensjZIsO9RDWR
	a/kksWonZK9zKJTHbEb6ObvejtLkfAC4lttas63jw8Xl6PoH8NV1jchg7VwI1vBAl/VWCnnBxdszH
	fQ7036MxIaYubXB9zn+vNl3sMpxcn1sqTXinSTKprXUalfkSVC2m4GSL/Yie2sZ264rJ/5EM2LDFO
	YUhUadCWJZAYHzhb0NzcMNo8bsxRmGgEmUbIBzz1y2vXjZ1m29gUUwPzhchTkl1Qd6TrHntoiQoAi
	yEDF2tkGeFf4nIoOVBsnrV2+xrikKn4Uxk7YXA9uspHjC5wa/aCXBU94aXe/aGGhCTBbUBGehca+t
	oaCG7MzQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHcl-0053uK-0t;
	Sat, 13 Sep 2025 12:28:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:28:27 +0800
Date: Sat, 13 Sep 2025 12:28:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, Jason@zx2c4.com, qat-linux@intel.com,
	giovanni.cabiddu@intel.com, ovidiu.panait.oss@gmail.com,
	ebiggers@kernel.org
Subject: Re: [PATCH v2] crypto: qat - Use library to prepare HMAC keys
Message-ID: <aMTy60Ty6P8vNUW2@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905030153.11892-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> To prepare HMAC keys, just use the library functions instead of
> crypto_shash.  This is much simpler, avoids depending on the fragile
> export_core and import_core methods, and is faster too.
> 
> Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This is the same diff as v1, but with an updated commit message and now
> targeting cryptodev/master instead of libcrypto-fixes.  Since I'm going
> with
> https://lore.kernel.org/r/20250901165013.48649-1-ebiggers@kernel.org/ to
> fix the reported regression instead, this patch is now "just" a library
> conversion and not a fix per se.  If needed I'd be glad to take this
> through libcrypto-next instead, but usually these conversions have been
> going through subsystem trees (which is Herbert's in this case).
> 
> drivers/crypto/intel/qat/Kconfig              |   7 +-
> .../crypto/intel/qat/qat_common/qat_algs.c    | 191 ++++++------------
> 2 files changed, 61 insertions(+), 137 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
