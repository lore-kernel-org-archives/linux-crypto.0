Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9C423EAAD;
	Sat, 17 Oct 2026 04:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792210363; cv=none; b=tFxLlo4dvVF28iRJZ7r2GLvsyC5+wH/EIBbNVVBGMFftu76TnO0KFL9Qn0gBnIwAYxrx2pq65opmlyUFalOGVU2celGBSMAoTQkDJCW4IGozLMC0s+azzakE1AlAKYuIXMrejbtJvkWB405MNs/2jXFnDudY0LsiMlUoy0vRBh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792210363; c=relaxed/simple;
	bh=eswVyMdGhiPhLMHs35ifg0wQ6r29KihLct2u6yKHwcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdNmSTRxTcDnCh1KnS8u1rOgHkCnEs70aLSuv4r7k85wAJ9UIH69P3cqK4UGmjfD3km1V+RtM5QIu+/GZJZ/4uLgxBkijzVN4javWYlDefxwF8NStxUt2vCN/Z1+tg08PK1H47m1+7rMlSALeBSkaFmMkec97incx/udoxWgFd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AKAwiVPA; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AKAwiVPA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=5S3nqzH7nV8QrVGtHVrTGOi4+HwJ/Mlo6RAYYB4naZA=; 
	b=AKAwiVPAeyCRzMo1jbBEYWbcgi1nQZ11Fo9O8DFd+t64ZwueOITZYYZoHQ9IaiJtvZVS/1b2N4c
	7ynyb/zeAwr6JXRi5RVn/npdykazsiPYSZwGFZ3i1NZBAyTcmu7HoD8PuPExQ5J2UfnFC7FCXUGkA
	y1q4yfstfvcniYpNRl1lgxIh3sVRiRhGFV9PQXBQDHLHfAZfO2RFr3sMskMqz/x2NXBs/IeYjmtX6
	5Wp71LrcREBfTNNgbUHh5+gXwdmk7JuM8V6Ou7XDvDhU60kqqxKR8hoHfrGT3JHbQHqSKpsSPQZ6g
	6gCNf3jTFvcpi4+U6gTrjuX4oxfuTRn2uhfA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHvmM-00000004mbD-3wqW;
	Sat, 17 Oct 2026 12:12:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Oct 2026 12:12:18 +0800
Date: Sat, 17 Oct 2026 12:12:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <atL1ok1YkHbA4AaI@gondor.apana.org.au>
References: <as-jZopKRfuYAiTE@google.com>
 <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au>
 <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>

On Fri, Oct 16, 2026 at 08:03:07PM -0700, Kanchana P. Sridhar wrote:
>
> The Average throughput of 10 iterations usemem is 19,058 KB/s. IOW, I
> don't get the same performance boost as making the localized change in
> crypto_acomp_compress(), likely because of added computes per compress
> call (one function call, two conditionals).

What are we comparing against?

The thing is that the conditional will have to be there at some
point as otherwise this becomes pointless.

What if you just do the conditional and short-circuit in
crypto_acomp_compress?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
