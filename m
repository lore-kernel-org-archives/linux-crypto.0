Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FF821B191;
	Wed, 22 Oct 2025 05:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761110313; cv=none; b=JWcMEw1Z6nWYigPEs1B4L0dc1pawzIRT1+/PwAO2ct1Z5N/7s++R7CqKTixvA6ca5L/XDCAITbx/ti36b8ZInhEjCkmGLwRHVcebkj0j1hgTWbOqy6njZNEMGtINVueH5t1/TW6FS9wj/hyNv13txD6G4qtDvrBBriNqLGk3RXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761110313; c=relaxed/simple;
	bh=z0lb6s966H2PCJSHptpf9JDasu3e30IiiI/eKi8yY9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NWjP/Vkc75NqtIbq1WV58FQEpWZ2Riw37wnTegRPMUyy6dJ6CaS4SQnbJdmCop/roVNn7uZtGy8j64XqQm26m2i6Iloncz1+eRk3p99aBlO/kh88Pmb8J6ibjKPe8AuQPUpPmNmYYBRPducJNrAl8/5irzX+BN/NI7YZ/390lUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RV870c22; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RV870c22"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=teAud6Qwz333bGc0PlLBgP477zERkOpdS5svpKstPXc=; 
	b=RV870c22xWI6DFospbqA4RVRtdgkSEHUB66rwzVxh1Cfc1sI+tPinmLxrriKO5sm7DkWPvpxCo8
	9ni6ZE4zfFEWDsDWmw5mqQuS4kGbfQ5GR35b2EMi0WTyl2ec8uHgC8HV/ljsotwCQIzhG5dP9ORU1
	rivMuii4PfZum4OnODRcq1xxaEl9ykaEgiqPq/G8oQ8ZlaUhVw0yK+m4J7aBP322jc4OmwsB5um7h
	FBogF8hysqml/AbbqM/5J7CZroniiZEuZkEan/HDAa01PLJ37e2SYuZlb81seDVpMbpZMAmKoxGTn
	DJPFhNVriLG7pSd1JzmqAC9p067Jk6PK7/FQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vBREW-00EaFJ-2z;
	Wed, 22 Oct 2025 13:18:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 22 Oct 2025 13:18:00 +0800
Date: Wed, 22 Oct 2025 13:18:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v12 23/23] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <aPhpCGz1dWoZsMeH@gondor.apana.org.au>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-24-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926033502.7486-24-kanchana.p.sridhar@intel.com>

On Thu, Sep 25, 2025 at 08:35:02PM -0700, Kanchana P Sridhar wrote:
>
> Another initialization level optimization that happens in
> zswap_cpu_comp_prepare() is, only for batching compressors, we allocate
> extra memory for "batch-size" int pointers in the
> @acomp_ctx->req->__ctx[] that are statically set to track the output SG
> lists' lengths. This optimization was necessary to avoid the latency

There is no need for this allocation.  Just store the output lengths
in each destination scatterlist entry.

Before the call to acomp, the destination SG list should contain as
many elements as the number of units.  On return, the dst lengths
should be stored in each destination SG entry.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
