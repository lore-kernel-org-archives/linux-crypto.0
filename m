Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C77B244665;
	Sat, 30 Aug 2025 08:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756543958; cv=none; b=IPWcpwxw8oQviCyNQO9HSLbShNk+he4G9QTKFaEB7mJC6lxogmpxQWzVq58nBsDEzfnQER14DmUAPUT4qbqQlNMWNtNYQFKWjWeMlvUUxVBUuPf5HTsDv5w4uwED2Mb3ZSgQIPhCKlxvq+b9JIzUGtqNIZ3h7j+izKC0RJI0AgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756543958; c=relaxed/simple;
	bh=H2p52wYG6qcMo/fVdJnbMcAN+v8ydjIi31uAsnjOuFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c1ujI6QSNsmF8Xc8PndubqB+X3ieIcRY77mzE9pIyXtiieato6z24MXudtlnxldzoJdn4llbjVOFhARar0ll5GAwqDC/TenMaRoJgM0sUqsHcXz4uHQ+5EfTlUaDqIpAxm5O2sibrloNbxb79YW1ILCSQw4l25iCfliqRrgX9qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=KIw6G8lf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="KIw6G8lf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lLDdrlfYHpWpZ+dTMk4icfQ0y05B7CO8YPhGFUoL7JE=; b=KIw6G8lfBBZw+ODe/Xci8Cl8y/
	OZ9isOuRIvE8vHloqwyzD8zEvXbYJ/E5etuk7f45c8Swk/lQGhAACrs4oRpi70CS/IlWpD7BnV4NP
	4ITYQydTnpAZD6mIVrBTGXKxCfvwHZCVOIspOJ7KWWBTw8wL2pnzbuvmunO8iv5Fw7TocUlR4Q7xg
	Fm60GlMgFD5+7/OmNX66Wq/84uONy+Hanir1Ihh7dzJJLt3iW8sngi6AR6KS10ngi3oEx+uB+lCSL
	cksFyfIkM5lWKZm7biBFNDIORB056SACYog5q7Jci2Dgj7Z3tZktUeuoDufNBKybgTrawR28NtZzi
	aQJyobJg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usH4Z-0017CM-2D;
	Sat, 30 Aug 2025 16:52:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:52:28 +0800
Date: Sat, 30 Aug 2025 16:52:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Liao Yuanhong <liaoyuanhong@vivo.com>
Cc: Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	"David S. Miller" <davem@davemloft.net>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: jh7110 - Remove the use of dev_err_probe()
Message-ID: <aLK7zClfjwWKE3zJ@gondor.apana.org.au>
References: <20250820123703.473004-1-liaoyuanhong@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820123703.473004-1-liaoyuanhong@vivo.com>

On Wed, Aug 20, 2025 at 08:37:02PM +0800, Liao Yuanhong wrote:
> Logging messages that show some type of "out of memory" error are generally
> unnecessary as there is a generic message and a stack dump done by the
> memory subsystem. These messages generally increase kernel size without
> much added value[1].
> 
> The dev_err_probe() doesn't do anything when error is '-ENOMEM'. Therefore,
> remove the useless call to dev_err_probe(), and just return the value
> instead.
> 
> [1]: https://lore.kernel.org/lkml/1402419340.30479.18.camel@joe-AO725/
> 
> Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
> ---
>  drivers/crypto/starfive/jh7110-aes.c  | 12 ++++--------
>  drivers/crypto/starfive/jh7110-hash.c |  3 +--
>  2 files changed, 5 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
