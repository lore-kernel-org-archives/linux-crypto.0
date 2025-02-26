Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F81C1624C5;
	Wed, 26 Feb 2025 02:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740535839; cv=none; b=J2nlY7YN1GbsCvZHcJngvTUHIDRVbgTIz65NE4zzla98OYqTyC9Phki/ddctL9BKSuwvHH/s8ad5Ujd3/Htd/8CXgkv1JfC7Y96XlE1qNXRl67DdyCeb48KS/Hm/cI7fs3vaJGRMpcxHmUeR7t3+w/Z44zw1UTQJav40FkZryyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740535839; c=relaxed/simple;
	bh=i3ySs1ANzdL6E3wykPrZlYoNt4xpeP8fLcsBB2qT+WE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M/23k3/o4FfjV8Mw4psCTVP1EiDdkelUIf4IGZakXptUFXul+dMqLrACsMzpRPEgpf3MoBkL0q6BpK+UdZScAk6WouXPnn45X4pdjG2gvaR+5zRRi2e/jhqNCMnijpX5CzULgegzAp9AGnp7nd3AlqVLJJIuaRmZ2l8+BeYDTr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MWGoz4fW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MWGoz4fW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4UaxEhn+opD9ww6UUfnZ4q2QQDf5316tUr+NMRLN7X0=; b=MWGoz4fWs/xAd/6OgBVijOW0J6
	x4GBtTchVEg9eyE1QCxHr3M3CjdqBFN/7YsYKXT1+hkgEHHE7VMApuJEZPEi2pIY3Dj/KXsnhNnuw
	eYfF5PCag3sh5cmhCUYpqLp4r4js4gQTxlC1LQM3Q6qZFectjymws2D8JtLgpNGysfWnwpH8qd7rY
	Y2J3p1A++n54v7m/ocdVHRodQoXCQOfKi/7xuk9Hu5mOJERq9HUPM3jQtXisRmywVtYI0IVM50tQ5
	LGUd1Qc6XPgYtOZ6laRA5dtcFJ/YpQnqt61i4KpioZ/KFNtAFMmDDe0G2idiXKjovRfEAyPmbBByR
	kjMBfBWg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tn6sQ-001o3g-0l;
	Wed, 26 Feb 2025 10:10:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Feb 2025 10:10:22 +0800
Date: Wed, 26 Feb 2025 10:10:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: syzbot <syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com>,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: mm: zswap: fix crypto_free_acomp deadlock in zswap_cpu_comp_dead
Message-ID: <Z754DloF4TpoRr7P@gondor.apana.org.au>
References: <67bcea51.050a0220.bbfd1.0096.GAE@google.com>
 <Z72FJnbA39zWh4zS@gondor.apana.org.au>
 <3482501981b13aedda3c1c6b54d83d496bd05922@linux.dev>
 <Z75tg3wXoDnGtLis@gondor.apana.org.au>
 <Z753jsValuBdcvnv@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z753jsValuBdcvnv@google.com>

On Wed, Feb 26, 2025 at 02:08:14AM +0000, Yosry Ahmed wrote:
>
> Could you please:
> 
> (1) Explain the exact scenario in the commit log, I did not understand
> it at first, only after looking at the syzbot dashboard for a while (and
> I am not sure how long this persists).
> 
> (2) Move all the freeing operations outside the mutex? Right now
> crypto_free_acomp() was the problematic call but it could be 
> acomp_request_free() next.
> 
> Something like:

Looks good to me.  Feel free to send this patch since it is your
system after all :)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
