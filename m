Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74D8FBF6
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 10:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747650826; cv=none; b=L8xq9KuXmoh/gwWz18vdb/Cg5JC2l/PXKim7aeKGC50sDSqd8UJCcmO8f2BCAqxUnrnK5/tUFs8OxlDW8z/ipJYqXu4G9mtcHxM26zxpLhTqprg0IsTsLOvG9DVOxgStvdF1k+Cur8Fdme5vOA3B7PWQ1GPw4rh4GNevAS+r+QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747650826; c=relaxed/simple;
	bh=4icjFxtN40cUnVekd76sw5yLf5myBZnGEONPs1nDaCA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=JZevW8MeQo54cD9TUbAbJ5Kd7qGWi5jwl9ZXAeDJvbuX5MHmpqeD8ontcx3T84JGAUp8oPs+dInIvi9FOCLaHX5EeYS9Ya8rO1aQULUak9vK7NqEePzZHpnyhlNYEJKI56Md4p06EkeVhRn5KDpOVF/Xxi03EYLScxAVox0dG0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=X3P5KPE6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="X3P5KPE6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bMlrOLY9G6iTuRU3jSwC5Jp5USaHXq7diA4NtE2ezLs=; b=X3P5KPE6dGcxSBCbPDJPqwu3Cr
	tPDXPbAlb5jPHkONs1JmqkwCO37ZNIUh2LZKxagV3lmBeFGXBchvt+xVgL85YMWM2StYvSct40cJ4
	ICa0KPFdDO+9hPwYnEFW8JAGHSFXNGITi8VhCPBYaKpPvZFyMD01pzqXn2vZ/bIK1Nt/RfpvF1Vsz
	PmaSsXyvCHc0w0MxXuCjP201vcGhGJP2P3Eqz79b9PU+hk88ujEcA7/JGkPUjW7vhLyPTMscBY4ej
	NnDwg1CcwegQwmoVeU43dghyfiMMyEu8nXFGri4w5hn1U3NRqd4Kjdp5XIX7hhsposZ2rBKq1spLl
	9VBuwJFg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGxoN-007DZ2-2r;
	Mon, 19 May 2025 18:33:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 18:33:35 +0800
Date: Mon, 19 May 2025 18:33:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Scott Guo <scott.guo@outlook.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: Add a null check in crypto_free_sync_skcipher
Message-ID: <aCsI_0PR2snafNTR@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCPR01MB75770ECA9EB78E6A58A7E553F09CA@TYCPR01MB7577.jpnprd01.prod.outlook.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Scott Guo <scott.guo@outlook.com> wrote:
>
>  static inline void crypto_free_sync_skcipher(struct 
> crypto_sync_skcipher *tfm)
>  {
> -       crypto_free_skcipher(&tfm->base);
> +       if (tfm)
> +               crypto_free_skcipher(&tfm->base);

struct crypto_sync_skcipher is identical to struct skcipher and
crypto_free_skcipher already has a NULL check.

Please fix your static checker.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
