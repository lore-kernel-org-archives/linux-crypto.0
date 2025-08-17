Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B2D1991C9;
	Sun, 17 Aug 2025 08:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755420725; cv=none; b=YbY11hx4C7wcgm+P0aClfbLgeLQ4HUfPk+P1TmiY04YwBssZqhdIf6M+vLJXuNJA2cPW0vGSH2kEs0cJph0rLcS7sUKYvA8UiiEJs/E+2IjjX7l6hEUWbQT+Dr2Enee+TpKrQqC9rZBtssnj9eV5aLr4pdM3h2/CICA2q++IMpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755420725; c=relaxed/simple;
	bh=i72uNQ60IspHwSU4CFmSpIeEOXO2aaAsRUmU2eA3Qpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWn6yWeNup8dOliuMpXIvUH/pN4llP0tPwLWiYZi1VdZsRu/Bku+Dkiy/rToD0FVVIj09EaIjZwcy9wHVPjwdeGYPSw//mu6f+sPNAAlaLfsZ0jMN2xKvUlNbJHEByV/cpB3pLKl11rQtc+2IWDXQolhGziZopZlkfFK2gzkzj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gxp74j9X; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gxp74j9X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ucjuMVr22C0HzjXRvmtLnsZY82iQWU4h8AL1Wo79MjI=; b=gxp74j9XkZvQUcL17iFD4Ge/pi
	drF9JAlsIlPhsjrQo04Ua3ghv/0Q9CiFZWrMKKvodx8bLzEP13xN/W2bKzMin6oNPHXDfHPl4XFcq
	optBxJtSU0wuoJ0ngyc5q30OjzhoVd17UvUpvYyCP7t9j5OE7s5hzQOV2lo+uCa9Dmg0IeuYP9LPQ
	m4EMmnEqxKQKOcIAudAw+ZjoDAhOY6dLHj7Tb+Ldn3FnHQ2GFwqRIjt7qIlC9tUU3yt2ImGKOxAnu
	RhYcbXgQ15usYs93Ixop91cYXEV5ciC/VdOdr6bNB3MFugU2F2gxOHCm2eseoiVoRrhzNxCsZOCqu
	4vZ+4GLw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unYrj-00ExbK-11;
	Sun, 17 Aug 2025 16:51:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 17 Aug 2025 16:51:43 +0800
Date: Sun, 17 Aug 2025 16:51:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] crypto: Prevent kernel-infoleak in rng_recvmsg
Message-ID: <aKGYHwT31OaGzc5Z@gondor.apana.org.au>
References: <6895b041.050a0220.7f033.0058.GAE@google.com>
 <tencent_B406618996EEF22ED6CC8EA7DF46FD92D206@qq.com>
 <aKBMjQpA9P70EA0z@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKBMjQpA9P70EA0z@gondor.apana.org.au>

On Sat, Aug 16, 2025 at 05:17:01PM +0800, Herbert Xu wrote:
> On Sat, Aug 09, 2025 at 05:59:43PM +0800, Edward Adam Davis wrote:
>
> > diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> > index c24d4ff2b4a8..9e9e069f55af 100644
> > --- a/crypto/jitterentropy-kcapi.c
> > +++ b/crypto/jitterentropy-kcapi.c
> > @@ -107,7 +107,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
> >  {
> >  	struct shash_desc *hash_state_desc = (struct shash_desc *)hash_state;
> >  	SHASH_DESC_ON_STACK(desc, hash_state_desc->tfm);
> > -	u8 intermediary[SHA3_256_DIGEST_SIZE];
> > +	u8 intermediary[SHA3_256_DIGEST_SIZE] = { 0 };
> 
> This is not a leak! The stack memroy is hashed and fed into the
> entropy pool.  If you can recover the original kernel memory from
> the result, then we have much bigger problems :)
> 
> Please find a way to mark this as a false positive.

I think kmsan_unpoison_memory is the function that you should call.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
