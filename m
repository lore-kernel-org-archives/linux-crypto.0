Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D247832571D;
	Fri, 23 Jan 2026 06:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769148034; cv=none; b=CRtunAgSNf7x4L4B3qDAslDWllKoMKbJPU+YEdz3PVZKGlV/BSIyE406rvPnW7rX0ugvvTP8Tpu4q1jujM00qKFF0tt3k4OQRFt3gSvSSt8ZY12MJkuOxmuNkDpoOi+xTZRtpZrG+aebAAglUqyM7IT1CI8zIv8/DPQsgSuNKRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769148034; c=relaxed/simple;
	bh=2gwzXHED1cxqfsZd58g7WQbRsBkRPmwgy/EXY314xqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CuqRtIpPS78Juz4JDDaBr+OxowWbK2zVcQRgEBElGPc1w+igM7xPrIRNdCjvdAn6eTULd/2ofMoCP1ZuhiE+oKsd5lZUClnfs07k71DhO1W1yMsB8fvtfoGZc5fIC0bqYdHlxXsErVkYK4GmFs9GfFpNZiazpl6InPGN3BrtOrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SM/p64lV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SM/p64lV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=RtzXpZGCFHahrFkdIvoMtF+cksQkU5NJKlrOBq+TlvI=; 
	b=SM/p64lV1r/oqDXv6IiKK+J+XhrASzraHpgIi5pDQ8V+XHbYMdZ9ZU7rZJU6G6mMsv8ox+ZvTNE
	9uf5yTwA5/dzRsaEA1ROptPyNCebVGYQE5uSfNJlPIj58cun+mh5McCf5ZX9HhJ3jGem2ZvaHPnpX
	2TyYqrj3UKeOCnsy61B2kr+CMP8piBPzJNNLqvD6qRHgFdXYwxW8WmMitaqsIhmbrN+NsE2fdk8tm
	xg4GJ0LM2I8+3Qpq2igVkleWawnkfrKw7mKawHOfaXrSJzPUQcpu2UF/6qUqeT1sSI3yeUCY8KDlG
	VmWYHe0YxMSuaPlKK34OdCzL+mAl4Hsi2k3A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vjADG-001VPV-21;
	Fri, 23 Jan 2026 14:00:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jan 2026 14:00:06 +0800
Date: Fri, 23 Jan 2026 14:00:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: nx - Simplify with scoped for each OF child loop
Message-ID: <aXMOZvjqHcAfWaEz@gondor.apana.org.au>
References: <20260102125011.65046-2-krzysztof.kozlowski@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260102125011.65046-2-krzysztof.kozlowski@oss.qualcomm.com>

On Fri, Jan 02, 2026 at 01:50:12PM +0100, Krzysztof Kozlowski wrote:
> Use scoped for-each loop when iterating over device nodes to make code a
> bit simpler.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> ---
>  drivers/crypto/nx/nx-common-powernv.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
