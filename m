Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A6B346AE3
	for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2026 23:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789255667; cv=none; b=HxUZMYkHEOpl2pojjI73/W/DziRucfPBTI+6il9ezCxsEuR4XXWq99c1CGVdn7HWWv7z8X4/JjP46co5MiEfwGQJH+sf9tjqSB/b5+eGPqNic6DQ4kKWMLsKsv4zh3BaJsSN0h7//K1UKFlUnW3sb2UWs7TnSqvp3Xze77jqemk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789255667; c=relaxed/simple;
	bh=8YJTlE6IhQgqjDywt2N04MGW8EWwPd1rPdt5eaJtM4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GIKoSJHxgKB5pVL3IchmI1GfrjWb7alEgwPcDRbg4F5C+RGnUlqepW27th7PT1jwx/fvla8KpMMQHLyaaR7tGGLC3/IxUqbTtcppQxfGuY/It61qOg0ELAdKOHxIg5GPGA/yr0nvvT5Us0aX40KFaG3elTNCPapqKILIyiEX7iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iTnr/wE+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iTnr/wE+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=glC9/HEDmoh1+wwdWnLEvC2Vp7ZpsQizI/B+a0GJMJg=; 
	b=iTnr/wE+dy/L/N+tHZzYecB4R1jWEpQkcLd327BBQy6ZcYEkElvxfyzteiZwBsirABePYjBPRK3
	m7FRKFpJS/G1WwAkocyihxsK5esnaK/a9nsCYbsYIJdbK/Ooi3oW76aXvNakTFU3T56+nre/Kyo3O
	K1UbF3OIZd4MZJh2ev8uxqMhOtN+XBYcxWPysNgu0pvH+LBl79GwU3u0x5r/COqixxY3/Nc8MnDJN
	e7dfBkbGOo7SYMke+u5dw9RPEhcivgPvILICrD5+Zaua3TeDR1WVqwIZn7IBUIklKYq4cuefUUNsW
	KytUr/M8IbntsTOhwXBfYNuKyReyTYDOEwVQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x5X87-0000000DQMf-03y3;
	Sun, 13 Sep 2026 07:27:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 13 Sep 2026 09:27:31 +1000
Date: Sun, 13 Sep 2026 09:27:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: kadlec@netfilter.org, linux-crypto@vger.kernel.org
Subject: Re: [v2 PATCH] rhashtable: Add rhashtable_flush_and_free helper
Message-ID: <aqXf46iXp4BhuPud@gondor.apana.org.au>
References: <aqUmlWEzhR3pKYuP@gondor.apana.org.au>
 <aqWazNYddvTO5Sjn@strlen.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqWazNYddvTO5Sjn@strlen.de>

On Sat, Sep 12, 2026 at 08:32:44PM +0200, Florian Westphal wrote:
>
> When you send next version, could you elaborate a bit why this is
> required?  rht_deferred_worker grabs the ht mutex, so I don't understand
> this problem.  Worst case is a single,
> "useless" rehash of a most likely empty (or at least mostly empty) table.

You're right.  I mistakenly thought that a scheduled rehash may
cause a rehash without resizing the table, but that's not how it
works since only insertions can trigger a direct rehash, and that
doesn't even happen in the delayed worker.

Let me see if I can simplify this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
