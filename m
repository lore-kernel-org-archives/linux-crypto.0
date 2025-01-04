Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F501E871;
	Sat,  4 Jan 2025 00:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735950834; cv=none; b=iFd2XjPZsTtfRSHN+5Y5N0yuLRCQmMdFyQF+iM9POgOhCBpySQhVPq4g25OZULcyg0oELayGqV8vF4yJMD83sm0qAjVK422m24u4nna+B64j/KL1DV0A8PS6fNzbtSWJQhNoQt6v7FT5wWvtkDO/0hbMpRqBbIfw1LFdSS0lTdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735950834; c=relaxed/simple;
	bh=jwWK0Y0j4edN/rU6CycxNEdiDbxMsY7i+eM/6Pf4NT8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=FEHJ0j39mSV/hLf42Cg1JM9yW6Ae489oPvmrkRsL5scXZfk839eSFatOonK5VSGbIiBlz7r6oCnA9Rs9Ay/woQPAW7ckZea+W7oHBqLvum6CxDl6YQW+9hqCimWyq2kfSzmu9vdecjiRxKLmI7eiHNl8Tdog+fqaLTO/rLSzfpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=RDe49Mvb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="RDe49Mvb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ds8LAeMrAqjKoN7303lALn4NxYynix7l+uVLHIZhwMo=; b=RDe49MvbzGFA+4JpQEmDba8ArT
	fwArDuybT3E+HIHVvIB2YQL/Iumg7Lu2ia1R3z0Wh4NmP5HWBfRv1V5jncrvOGBGJWYHQh7BLvRfW
	wO63rMDb4koi9ft6a9ERz0HGq/V6vWBu7m+e6mER96fRIeF++kI2tdsqL8skN/YmfTysgXbUGhKC8
	26sawFgAEKaUyiTwq/jVL2J9NLOjXkrTHBgM193SOQezUEfjkzwjrXPrASkMfNk7VtBT6r+TftR1n
	yyVeCpulT5JDQmCEn36BooMwYN+iEC6OCFE71I+KZHGTHLJBkpSwobwDIxtHp2uIvjDWNY299FGyc
	1wBF4HDg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tTrtp-005fKc-00;
	Sat, 04 Jan 2025 08:33:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 04 Jan 2025 08:33:37 +0800
Date: Sat, 4 Jan 2025 08:33:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yury Norov <yury.norov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk
Subject: Re: [PATCH 08/14] padata: switch padata_find_next() to using
 cpumask_next_wrap()
Message-ID: <Z3iB4YsIPdD28cvn@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241228184949.31582-9-yury.norov@gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Yury Norov <yury.norov@gmail.com> wrote:
> Calling cpumask_next_wrap_old() with starting CPU == -1 effectively means
> the request to find next CPU, wrapping around if needed.
> 
> cpumask_next_wrap() is the proper replacement for that.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
> kernel/padata.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
