Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BD2270575;
	Sat, 14 Mar 2026 04:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773463680; cv=none; b=W1DyH5h1ipyf15krChqBz+Tkwjgyvm2bvSrQJO2YhHCHxU8NoZ6n/cRwqdAS4emfpsDekKOpT1eFV2KLR2Axgq9fGZXkCpswWk6aibe7IjkRJ5M8O4HvzVKZq9MTxIh+ejpr5HHmBuRmcFcWVUz50CTmkOxfVWANzPFL9zwKcso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773463680; c=relaxed/simple;
	bh=aUsc39vY13fXZOzUH3cZ0ZGmLO9wzXXOtpTB0Q4k/dE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLJVFjopzPv4yo2zvpFetdy6nPMr1gjTK384F+zyV0vuRgNk4ytj0rofjhXzo5RmnwW9Fk3HWbmX5HkKxIhPXbpkjyT0PXGq2uuGxMLAHkmTl5ofiImmhHSeBSpO2tfqEqxAm9wM1wEshAm/aEjuVipOo0shcdSaf8NKn3z26Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sgGlgfu8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sgGlgfu8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=eoJtzYYgY9ROmVqLSa14oImeMikAFUZjBqozvLekkp4=; 
	b=sgGlgfu80E9Jj7lsC4CJQDWV6R+z7gOOFt15wVRHjbzGaPlWhhOJhflKvyPIFnondLh9UNaR7np
	E33oUujwnMIohz/fPKoozRCkUq/XcNGyEtacrTL/+f0GC2QFh1xw3rUgogEzzp4ytCJ5sMjzwGips
	0cJif27HDNgPcts+JxUfUNCvYGiUI9+GgDOYwo2MxZXyDnJzdkqSlM6Z1gV3DF4694lGrdESNnfTi
	kRkfabbiq5azJEY1qYRF9FElPAmcZtnz+v3O/4da7rLAf2wy9fewTu59Mo032BvJ3DRa289dExIgt
	BRO8QT+nRFuJInRKtMav/8KDR80An4M7RazQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1GuY-00EKsT-1L;
	Sat, 14 Mar 2026 12:47:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 13:47:38 +0900
Date: Sat, 14 Mar 2026 13:47:38 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] crypto: testmgr - Add test vectors for
 authenc(hmac(md5),cbc(aes))
Message-ID: <abToanZh-mkEjmJ-@gondor.apana.org.au>
References: <20260303184916.69132-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303184916.69132-1-olek2@wp.pl>

On Tue, Mar 03, 2026 at 07:48:44PM +0100, Aleksander Jan Bajkowski wrote:
> Test vectors were generated starting from existing CBC(AES) test vectors
> (RFC3602, NIST SP800-38A) and adding HMAC(MD5) computed with Python
> script. Then, the results were double-checked on Mediatek MT7981 (safexcel)
> and NXP P2020 (talitos). Both platforms pass self-tests.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
> v4:
> - rename aes-generic -> aes-lib
> v3:
> - correct sha384 -> md5 in description
> v2:
> - rebase and resolve conflicts
> ---
>  crypto/testmgr.c |   7 ++
>  crypto/testmgr.h | 255 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 262 insertions(+)

The previous patch has already been applied.  Please redo this
as an incremental patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
