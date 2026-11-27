Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756658;
	b=DkVuL1i5q+tY+fsIrozytyF0GPayKtBreNAZ6VbH0nzxvU8NDxkWEuLHFYTY3fQ+q+VZ
	 tFWScI+wU/JO6ukEfx9hjdjWTeB/8BdKJTJ4cRR0U/Jj/jzeujreS3XpciO9HPWU/LJGk
	 qd0LWa8AXytXfJnNIexqK7/5YYa9Wd+1zFqaUvAO4WavgD80UGOHL3/za6D3A5K/PcFro
	 enRljMo6Vqp9zv0ap/gU8WlFFXgvJ+8WJN3Q+HWNoP9kM8J47WUTTEj5jd0jckvaV0OJ5
	 QYfdrQTJ9mURyfykbWAj0/An8C53merpz8K0f9G/lVw57Yv/nBDVNzVeJDHbERbqmEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756658;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=p34+E36hlMLMURBldXXi/frkJoE/rDtT0dfPvmlongc=;
	b=rCg3xQG9II23JmcBPO8QMBkbIKIblG06vxV93UBAkkYNg3yVBq+dS7PrZFYckrd/ORRb
	 Us5TfnosRjXpgRTV6jHL8BQTAosCkLDDiT3ntDqjudDAKNDc3x+YRqYfividM2c1HMzg4
	 V9qa/Ph4l8XrIq9szhy2A59iCy2CBAlLFSI+Fr4wUh12h+7KAdbK87puEBoAwAUXYW0uj
	 GZXPzU+cAeu6iTAXUiZT/vsgMuKzK7bWv6XGU/iRrIPewvI2Oh00L0H0tlWjZnKvOwCoy
	 sYsbyuvkvwKQl4HjPwLIXYuPWsWb7Dx+pcWa8Hu0+dzQQGcxRQ1RRcncbjNCkZu1ElQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=bAnQ8QkS;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0987606A31E
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 05:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0987606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=bAnQ8QkS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=p34+E36hlMLMURBldXXi/frkJoE/rDtT0dfPvmlongc=; 
	b=bAnQ8QkSlBghyDS4ZZ0Am6+yLXzofBMF6HKrTiLLXvPAV9cRJ7IoYrB1OyQcpGDPgHvugfch7dU
	H3PJxhAZPNLnFXWTTjYb/HP61c4XBBOz5z9kEcSFt9dOl+nzCFFgsbsxUBKrKgGMO0kgMD/+XU5hl
	QfQZA5RoPVjnf4WkJEYyfdxUSsOAB/1WLsM2NRrm4cids6Nz87S+PXDwID9ke5vd4mQlX7ozQaaHj
	Jg2HqmhjCXNy6PIzrHnYB2pv0JHhbgoVhyEE2WeVoL1CGVj7j1Urm+GX19ZCGUFwYQ0I6wHA7UoCG
	Gf3mNVshRZ5ImId45TBXcQFCBjw2dlUr/Wsw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoL0-00000002VbA-0E9v;
	Fri, 27 Nov 2026 13:17:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:17:34 +0800
Date: Fri, 27 Nov 2026 13:17:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Avi Weiss <thnkslprpt@gmail.com>
Cc: tgraf@suug.ch, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] rhashtable: Fix safe iterator cursor substitution
Message-ID: <awkSbjrutzGRgchw@gondor.apana.org.au>
References: <20261121072454.27804-2-thnkslprpt@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121072454.27804-2-thnkslprpt@gmail.com>

On Sat, Nov 21, 2026 at 09:24:55AM +0200, Avi Weiss wrote:
> rht_for_each_entry_safe() uses next as both a macro parameter and the
> rhash_head member name. Passing a cursor with another name substitutes
> that name into pos->next, producing a nonexistent struct member and a
> compilation failure.
> 
> Rename the cursor parameter to _next to preserve the pos->next member
> accesses regardless of the caller's variable name.
> 
> Fixes: 88d6ed15acff ("rhashtable: Convert bucket iterators to take table and index")
> Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
> ---
> 
> Alternative approaches considered:
> - Use a differently named cursor parameter such as next_node. This is
>   equivalent in behavior; _next keeps the change smaller.
> - Remove the unused macro. That avoids the broken expansion but also
>   removes an existing interface potentially used outside the tree.
> 
> Validation:
> - Original macro: next compiles; saved, tmp and next_entry fail.
> - Corrected macro: all four names compile in the isolated source probe.
> - The original next expansion is byte-identical after the correction.
> - No in-tree expanding consumer was found in the tested base revision.
> - Full kernel Kbuild, runtime and external consumers were not tested.
> 
>  include/linux/rhashtable.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
