Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2D570818;
	Fri, 17 Apr 2026 00:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776386631; cv=none; b=JEx4wExbppd2IcgiRjzInl4C4xTmTlbZmgfK45v6H/sRhGaihDj5wS9sCjhFA1YfuPEkbByEB1PWYHd5GBCW5Uj8sk4iGBoVLI15bgrLnVvf9ep2vbDlw/zGdXgf2CcCGUC948Ji6lquiN6ooZuk9pGBXyAyNFaZkmIZJp3ADwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776386631; c=relaxed/simple;
	bh=v+wfAooU1Emvk6pVjZHqLQbnpWKbxUrHwikqbkiqf84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=snIDEI3SBtyxv6YzgWgguQX56GZ3dQoTquUa+ngF2KVz4uuvc155+4YBcXucRxZirhBww3Xuizsk6UnIbx06e0tGyiUqR4Grw9wxv0lgBGtYRUX+OtASATqolYbjKqZFATiJywJiFj0qp7gJINf03Bjmgu3c8xdJ6WJyVcNfMlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=eLB3z0xd; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="eLB3z0xd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=rb4zdcy7gU59NwdvxFW/DDCpXK4L3st6LO2Db2/M+pI=; 
	b=eLB3z0xdawd0dycFE6EKTkWmm+CCYkjWVvrFQdDBS+Tx5yByVEadgvQTV0GF5RTCK3UXglztIWe
	ycRzyBYbZh6ac2hpxEcjaIGzZ13/q6jZihWUkRF9KxScLRQZSZcQ3XxUknfzd/7HzMAxUbIy1cOJX
	P84+vD1E0pmM07ULanZ7MKkHp5sLp+H5u6iuRww56OzeTQ5u1y0717NVjhTBSmVKAhT53UOYBCylc
	iPpSBAvuzs8Q4498VfIEUQW4y9DLSBu9jk4OB+iIV1AmfLHgBgxzoM2nQkNi2h+5j+18zeoSmNH/r
	Iu4FMFdlUJ+bLw1h3gqWMh3n+Og9ItkdZHZg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wDXIw-006gam-0B;
	Fri, 17 Apr 2026 08:43:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Apr 2026 08:43:30 +0800
Date: Fri, 17 Apr 2026 08:43:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.1-fixes 1/2] rhashtable: add no_sync_grow option
Message-ID: <aeGCMkdg5Fgv8UMS@gondor.apana.org.au>
References: <20260417002449.2290577-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417002449.2290577-1-tj@kernel.org>

On Thu, Apr 16, 2026 at 02:24:48PM -1000, Tejun Heo wrote:
> The sync grow path on insert calls get_random_u32() and kvmalloc(), both of

Where does the sync grow path call kvmalloc? I think it's supposed
to use GFP_ATOMIC kmalloc only.  Only the normal growth path does
the kvmalloc for a linear hash table.  The emergency path is supposed
to do page-by-page allocations to minimise failures.

As to get_random_u32, we can probably avoid doing it for emergency
growing and continue to reuse the existing seed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
