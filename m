Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC673E5EC2;
	Fri,  2 Oct 2026 10:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790936116; cv=none; b=cGLwIv0CkytmSRQJgOYlfY04wDiieG2xLQMlP4U0lgd2D8xnNG++cvdC0m+HJUZIf6DAO/lbcSsrFbEqGDquB01JusXF4177jUY6T2dANl13JgSm1DGc2gsIMFt3CUDq+7kji0dVss8myQVmDONmbCQNb266aeKbzMi4+lVfZNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790936116; c=relaxed/simple;
	bh=DT12GOksE7GjrDIXoh5OAQzYhyg0q2vwBe7lXyavLxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFamJxpZPnzK0+5kr+uk1er/9IgqA00K+iQGG2FSNXwLSnMSI2+iPKDN20Ai4Nq5eEwfO86zh6o2jMC9qATaFK75bzHL5wvQxhrnDO0Ksp4TzupGEgN0pnhT9hZqxKneR/ydRtANKRkHJpWrCTCeTUXUldJETcw+cn9lkE5uP94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RvSfYxaU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RvSfYxaU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=t3GNyx8h99NgX8niXh1MHUwUotPPytVSieieLf3lD7U=; 
	b=RvSfYxaUdGVKdMlEuppKcdyuK6vENj1eGAtiO/X3C0uW5c/rftfbcDNkt4t4GtRYT702ry0LXe+
	AW94QkykorcS120T8sUREMrsPK7OfTAi4WKeRC/wajchi98iFo9WgaNtRGT0VMEcCHMONejsNqXcX
	r1dvPZDuPEfXVQ3ZRRl7/hZ0GUOtsqY6QCIUjkU3DaS6CNjACGTAaIC1x33+GgUwAdFmYeKPKuHw6
	y8WnAQEAAyq9IByQqi95uOtzy7tTCUFCJ9pMWybEcX1tqut8bTQefI/EDRNRXFYK26oQyJm2dLwm/
	slSRGhqB8pJ32NYnx21ukWV5YimCdvwFk5ew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCaIH-000000001iE-2uxD;
	Fri, 02 Oct 2026 18:15:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 20:15:09 +1000
Date: Fri, 2 Oct 2026 20:15:09 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Cc: haren@us.ibm.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: nx - validate 'ignore' before subtracting in
 decompress
Message-ID: <ar-ELZFhjUuXlZdl@gondor.apana.org.au>
References: <20260925175839.3704942-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925175839.3704942-1-qwe.aldo@gmail.com>

On Fri, Sep 25, 2026 at 02:58:39PM -0300, Aldo Ariel Panzardo wrote:
> The decompress() function subtracts the header-supplied `ignore` value
> (a u16 from the compressed stream) from `dlen` (the number of bytes
> produced by the decompressor) without checking that ignore <= dlen.
> 
> If a caller decompresses a crafted buffer where `hdr->ignore` exceeds
> the actual decompressed length, the subtraction wraps around to a
> near-UINT_MAX value.  The subsequent memcpy() then copies gigabytes of
> data past the destination buffer, causing an out-of-bounds kernel write.
> 
> Add a bounds check before the subtraction and return -EINVAL if the
> value is inconsistent.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> ---
>  drivers/crypto/nx/nx-842.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
