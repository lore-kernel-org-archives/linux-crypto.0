Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5EBE56A;
	Wed, 26 Feb 2025 01:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740533144; cv=none; b=MxOR2QgY1YHQDa+BS8JYk77uIEvL0H2NW2TTWhx7h9er4QQobL99VUQyx7NWwwxghxoOMkQ3RNqEtz3ccXINUJXbAyZ7TnLShtC3GakAjIPu/atBT1901xmRTrshvbMuvAmrDc9ui4nglFJjssiLHnakKTMB/689ZGwjKjmQimw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740533144; c=relaxed/simple;
	bh=vnzgAuai+PqDRJ448BD5D7BjFjsFitxstzThcRWOnvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iHvf+LpGEKSwrH2/jWc0xzUK6aiGE2lSpDVaHQ56fe8+s0J5VeqLjPATem01i1O8Jtqwg+sOiFqYhhibcGWVXnSphyM8PamCLQxS818TIbLp7yux+q/tOEeSLzEgZ0tWpYWhbYl2iURljIKp7srWjk5jz/ZW1fZZkOlwXLXJqEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hzo57jvN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hzo57jvN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=u6gjY0GvWz0cVjCLNjZik1ey32U4+7GO7hXOEyOYVlI=; b=hzo57jvN/49WD2nfGGCFbgsRSk
	PcrzaiZeZXiOoog5+EFpmrRY0gstm1NYesYMJ4jTRGgENptDSllijGjPabXAD2eBHun6oPKgbBvz6
	QywVuZQazdwChoay34Esf8tHHLNyXoA3fnmzX6CjajsMg4KV+C+bSVP/jT2Wxw6y/yp/UforDTRSh
	inclI03KaMGAehbCCBMC62wNDc8xPJRIsfiNSTQJb52P9hpfKsnIMDDUjAnIImnyKGTckNOhRgiOZ
	Z7TOSrTPl/7Wt2YfMm2O9crOXW0FYCpeCoCxkbbz8SxqKzczJZKO37lfu7V8ovGKTirTRx0xx9OC5
	psgW+/Xg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tn6At-001n78-0X;
	Wed, 26 Feb 2025 09:25:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Feb 2025 09:25:23 +0800
Date: Wed, 26 Feb 2025 09:25:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: syzbot <syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com>,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: mm: zswap: fix crypto_free_acomp deadlock in zswap_cpu_comp_dead
Message-ID: <Z75tg3wXoDnGtLis@gondor.apana.org.au>
References: <67bcea51.050a0220.bbfd1.0096.GAE@google.com>
 <Z72FJnbA39zWh4zS@gondor.apana.org.au>
 <3482501981b13aedda3c1c6b54d83d496bd05922@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3482501981b13aedda3c1c6b54d83d496bd05922@linux.dev>

On Tue, Feb 25, 2025 at 01:43:41PM +0000, Yosry Ahmed wrote:
>
> Interesting, it's weird that crypto_free_acomp() allocates memory. Do you have the specific call path?

crypto_free_acomp does not allocate memory.  However, it takes
the same mutex that is also taken on the allocation path.

The specific call path can be seen in the original report:

https://syzkaller.appspot.com/bug?extid=1a517ccfcbc6a7ab0f82

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
