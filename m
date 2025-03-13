Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3F12E3391
	for <linux-crypto@vger.kernel.org>; Thu, 13 Mar 2025 01:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741830236; cv=none; b=OsBTHcuIbqh0q2qR7iDWvjPB8hpF2aAsF15B1akQfE0BSUZvtmrHguKNc0erhnO8x579M//Uli8zMuZ2Qrvu2/Wr6rypu1pcATyYAPYYRXGH4FJSRkwxynMXFWQwBb5OCnx9RQHu7D+KFmbem7QE8/F/dot63rp1c6VD+NpBhIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741830236; c=relaxed/simple;
	bh=lWG7J9vK2HxrjL1CmZjC+FWFDdKEWQGWz0+cx2eRkjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fPJS8A7R5MENhHnXmjYz7AJnw0RttF3hnvTa0AFNkfLu+3dnJSyGbMeVojPFHIXlmIvFDOunQZlIjawRMydg8q15yg/fmzIoMKY4VeZN07cpmnlwmF0K7gfoweWJ3jExnxBMf33/+otGPZzFQS1UMeXg6jbrYb5K5ExwHvouJBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pbJ1ggay; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pbJ1ggay"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=K4/9zzjningwxLb6SXB30NkFoG/TaJvZX5aGrl1qJ6c=; b=pbJ1ggayXMNMvb1Sby8cfrB5BG
	EZH2cXbz8+eDwdqkNujpL1bhk4j7DtksTGyMdAMH0dXs6aQWditKl4TBXsN0LdM9Kb8HWO9t2BTwI
	RuFFSJwQySUMvk/qxpB69Zlpa/x3ShwhrxuJgLHEhHkdUI/giVlLM2hf5vGLbWuptiyH3mFUrz4D8
	0aTbR+tt6ard+4IxE2MlPrKEjGgmbO896TY57jMv9PbAEtOie3ONQz89r6UEGpKt5ybFIyB4OmHkj
	Dxzo4JJqq3UH6rhniw3KkoxZcXJtlsFbfflaR0fSZ6zCbubExBt7PIvhU1YnveNdS6J/csEYPLBhg
	RwghlvUg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsXbw-0066lJ-2Q;
	Thu, 13 Mar 2025 09:43:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Mar 2025 09:43:48 +0800
Date: Thu, 13 Mar 2025 09:43:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 1/2] crypto: scatterwalk - Use nth_page instead of
 doing it by hand
Message-ID: <Z9I4VBZ4hTWJYFw2@gondor.apana.org.au>
References: <cover.1741753576.git.herbert@gondor.apana.org.au>
 <03f40ecd970de816686b233bd79406768dc66bbc.1741753576.git.herbert@gondor.apana.org.au>
 <20250312195622.GA1621@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312195622.GA1621@sol.localdomain>

On Wed, Mar 12, 2025 at 12:56:22PM -0700, Eric Biggers wrote:
>
> This change is unrelated and seems incorrect.  lowmem_page_address() is a mm
> implementation detail.  page_address() is the right one to use.

lowmem_page_address is obviously linear, while page_address is not.
For example, arch/loongarch does something funky with kfence and
page->virtual so that page_address is non-linear even on 64-bit
without HIGHMEM.

Sigh, it seems that they've overridden page_to_virt too so even
lowmem_page_address is non-linear.  But that's probably just a
result of people abusing page_to_virt.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
