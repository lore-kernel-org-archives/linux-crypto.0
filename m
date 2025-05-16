Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5FE23CB;
	Fri, 16 May 2025 04:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747368751; cv=none; b=S7C6OH9UVlZWHc6bFKv2xWkobqeoR5W7DLFyWxvmKzNiuwjMWU0Sa64DGtSqkXP/xAG6V1KFium3htcWgjQQFpXUR4lVmwE/75PG0wZXCdaj5MDCyaQTg05s8Ys2hk6LXc+zKdJw/TlmbledOcOjYzlGvC+jE+8y+qQpvXWKlMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747368751; c=relaxed/simple;
	bh=4lJqPgfJUWp+HKWCAIK5S+/LJNGV4XVQ/wpjh81OLDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dU6saHSmanviIHuqpC0GK28B0d5Gs8H4wwK3KQspTzEM2s3hLQ08/IjFEUt5xTFBXgpXupx27fjbBnHxLhPaqESAijEf2uLAh8KRwbABXayQiKqSIBeMJ3JKXmgBZ9vIkuw+Qqu5rHjNM+UQFrTo8kiVf3T8DqJmEbEODzYLhRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rCSA3j4I; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rCSA3j4I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MuPz1OrQvYor3ybkROjPO24gbYqc8RiiNEPJSCKMoJ8=; b=rCSA3j4Iln5dDEb2We66Ksz9TK
	hYlX7WD8oragJ20hdXZRGNlkJXH6z1691BOss9W9joI0l+KUBDeZ2reBDoR96ecx90j+68aadJA04
	lGg9eQSxVzovhkx4JLHM7Sk6SpApYcoRiBH7Z7Y8T8kiKjRf/B9mDzlOEMkLCbPo5BlYHQ01L7H4b
	jk8O+YqHsW0ypBFP6trthB93g10j1/09BWwPYnY44cnsXmOvMUR961LP3taZ0HIfWQE0H+sxDM1X4
	DjDrf529rpP014LGpsAHCTXVJa5Mt6RF3adE6ETeGJX3Pku62ZFIWCV677IrOgIsGVfgNXGoEgomY
	jQSaKMhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFmQp-006V3d-1a;
	Fri, 16 May 2025 12:12:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 May 2025 12:12:23 +0800
Date: Fri, 16 May 2025 12:12:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aCa7J3I8DyRs7pP_@gondor.apana.org.au>
References: <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
 <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
 <dcb0b04e479d6f3cfed87795d100ea09e4fbcf53.camel@gmail.com>
 <aCAX8rj2ie4QMnTo@gondor.apana.org.au>
 <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>
 <aCMOyWVte4tw85_F@gondor.apana.org.au>
 <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
 <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>

On Thu, May 15, 2025 at 07:53:03PM +0200, Klaus Kudielka wrote:
> 
> Okay, so now I have two printk patches on top of the current cryptodev tree.
> 
> I have enabled CRYPTO_SELFTESTS
> 
> - Three successful reboot / modprobe marvell-cesa. All self-tests passed.
> - But the whole self-tests sequence now take approx. 2 minutes, instead of 15 seconds with plain v6.15-rc5
> - And the journal gets huge. 24k lines. I am attaching a gzipped version, hope this works.

Something doesn't look right.  There are zero ahash lines in your
dmesg.  IOW all the output was from skcipher tests alone.

That could explain why ahash appears to be working.

What does /proc/crypto show after boot-up? Do the cesa ahash
algorithms show up as tested in there?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
