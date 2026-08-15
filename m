Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4571E32D6;
	Sat, 15 Aug 2026 01:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786755642; cv=none; b=YgqhJeDW4/kvafM0G4lUC0iAqCsSPqSn05vWFtnK2dj0isYFl0FMeCo2370x5pTrkuf2eLLabAm03viI7sFaT6nYhmmTtV1ctcvdnUwRDyZpdtHok/yP6+AdFgysArSsvZGxBnXZxUMx8lmIyZYl2dM/a0eteK9yuQGAdvt20vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786755642; c=relaxed/simple;
	bh=slMVkuEJUarhUvKB1tzJDHrIeeMSm9WvViRVqlA8dR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B1DeEDkqikg+5SjtwXm0dn7LabAdN8pbZ/bY9OwAUN3FYNPnJedRQUA5V9Fhod4aHCHoc/MJJ9jUnh2bDyU+Qnbql4LClZlpuTKTSlwFhGkw4wNxQrQJmo1cwzL+v0bOP04+ek6L+wYZRU1UasgaZodWx21ilmnYeVyD130ql34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=riukcU5z; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="riukcU5z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=NWsCwLnOedBTnwu/1/s+gX02uDKXPy09mJW5MfjBgIw=; 
	b=riukcU5znXglxjlRXRbf9zKChfdsqwsVqFD4tghF5LrOF5ribV302OqSrX2Bt/h2ichy5VDpuUe
	f5VJH5eSG2ANl4yFMaEjPYdlLGvKRHG1Ri+AqQK/A7wil7sWvsdozBEMq9+6urm3Hiu2Y/v0bOf93
	qLsyYOfB2l2IvVqQEDiWuIJkJsMmZKNyoQcrZJ7ZSLj20v1uPzNZtt6CnAUauhLSqholsGLngRg4v
	G3SNMU1VEzXb5irgV7ug65N6fQ1r0jgCgnoDUzAK5qbkBmD4u4q7CQ0lEuGr/+j4YBXxRBRziHTpY
	NYZDd8X/6T/r8Vt7UmcmUM6qRk7lk+KePG+w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv2lF-000000054h6-2uqA;
	Sat, 15 Aug 2026 09:00:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:00:33 +1000
Date: Sat, 15 Aug 2026 11:00:33 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Changwei Zou <changwei.zou@canonical.com>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, lukas@wunner.de
Subject: Re: [PATCH] crypto: caam - Use bounce buffer for unaligned RSA
 destination buffers
Message-ID: <an-6Mew-8fQaf5sb@gondor.apana.org.au>
References: <20260805041902.1575170-1-changwei.zou@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805041902.1575170-1-changwei.zou@canonical.com>

On Wed, Aug 05, 2026 at 02:19:02PM +1000, Changwei Zou wrote:
> The CAAM RSA driver directly DMA-maps the destination buffer supplied by
> the caller via req->dst without checking whether it meets the cacheline
> alignment requirements of DMA-incoherent hardware such as i.MX8.
> 
> On CPUs with non-coherent DMA caches, if the destination buffer shares a
> cacheline with other data (i.e. it is not cacheline-aligned), cache
> writeback/invalidation during DMA can corrupt adjacent memory or cause
> stale data to be read back. This manifests as intermittent -EKEYREJECTED
> errors when loading signed kernel modules.
> 
> When any segment of req->dst is not cacheline-aligned, allocate a
> single contiguous aligned bounce buffer covering the full dst_len,
> redirect the operation to it, and scatter-copy the result back to the
> original destination once the hardware has completed the operation.
> 
> The intermittent error 'Key was rejected by service' on i.MX8 with CAAM
> can be triggered when loading signed kernel modules:
> 
>     for i in $(seq 1 100); do
>         sudo modprobe xfs 2>&1 && echo "SUCCESS on attempt $i" \
>         && sudo rmmod xfs || echo "FAILED on attempt $i"
>     done
> 
> Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
> Assisted-by: OpenCode:claude-sonnet-4.6
> ---
>  drivers/crypto/caam/caampkc.c | 66 ++++++++++++++++++++++++++++++++++-
>  drivers/crypto/caam/caampkc.h |  6 ++++
>  2 files changed, 71 insertions(+), 1 deletion(-)

Please take a look at the Sashiko reviews:

https://sashiko.dev/#/patchset/20260805041902.1575170-1-changwei.zou%40canonical.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
