Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C6330FC31;
	Fri, 14 Nov 2025 10:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115871; cv=none; b=Cjp/hJXZabpUZaqzNVWmfjOtgZOIxQeBFK1PJHiCmCNomrC+IwOh9Udd7tFH8iPP18A9ipQqQy4LzXi/8eTN4TVPc/pnE1GV5W3R6oijjJGRvtK/wYuwBUMeKBvIxg9i92wd78JKB2HsQ7tKX++x1e+8fxRqdEk+TAop9hdyb3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115871; c=relaxed/simple;
	bh=L2znFfLlo19Ya/Q4qyF5INzpQfXSumiV/vZ9w6Jdumo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDhScZBGmYsa2kS2ForPL6+YS4707QoMLvzKb72FIdNZHK1p7X08LhAJovFlXNOViN5Efj1q2q4AWSaeA6933U0WRAT1f6byvmhNY0tXk27ur6zeoooOeO9iGX+mUWjVKM67GlsPYz52BQTjBvhzxDQBBPRMJPI7bnjeab8rKxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=jixnp9Dj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="jixnp9Dj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=8EAg98BYyKHe7EgrE3l9zD3sK3piwHgmRR9FV9NI7Ds=; 
	b=jixnp9DjvvE/bDwBzVdplP9o9ik25RgeLZl/iStoDkR5NBffS8wAmsPUaUClX+XjiDGJ8SP1oeM
	5CeQWcmdaRdKFtduSytHmc9qhQZB/19MGSBAatC5SqTp5bHusIKFT9f5lHpvnd3n1F2cHmCOCk0E0
	9a60IbYSmJPocqqrOzhhhj5GJuiJ8jyk+fAIzEPXRAMr5RiINzCtXTLbdfaqP+wc8IDDYtribnkE5
	LAcqkeh0Y3x3kPGZsnSwpAFrqlh+wnbT5nAiYgFQVbeeBZDrBNBMDXTDbQfjYsOy0nOI7ekwvuzCb
	UhjkZUyBXkRCAmZ7rw6l3P23PjgrIjc7igyg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJqyN-002yRC-0c;
	Fri, 14 Nov 2025 18:24:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 18:24:07 +0800
Date: Fri, 14 Nov 2025 18:24:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: zstd - Annotate struct zstd_ctx with __counted_by
Message-ID: <aRcDR1OdNL293aem@gondor.apana.org.au>
References: <20251108120740.149799-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251108120740.149799-2-thorsten.blum@linux.dev>

On Sat, Nov 08, 2025 at 01:07:40PM +0100, Thorsten Blum wrote:
> Add the __counted_by() compiler attribute to the flexible array member
> 'wksp' to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
> 
> Use struct_size(), which provides additional compile-time checks for
> structures with flexible array members (e.g., __must_be_array()), for
> the allocation size for a new 'zstd_ctx' while we're at it.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/zstd.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
