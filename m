Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C5210A1E;
	Wed,  8 Oct 2025 08:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759911341; cv=none; b=hFQh8AJ9/nji12DyoQvcUXbh7YvCYGG7Su1+Dk91SD29YgjzrsCPLHC9LlbUe9tZScutNYtIzNcLd0Okb21GliBQqdPA64QrN1OMj3sMumb3soqbj5B12389w9/AM32cb5VMlNK++VMjFF/K0dj5wGla6zhJCRChETvquGXzIXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759911341; c=relaxed/simple;
	bh=P2GGlTUYTtBsyg/fxoUWVeOEvro8Z3cIvQlXbLOTlW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HscV+/w3pfWTSG9dbV32JKsWljioIXjYc+/Obuh325LKJu4xLhN1/8ooIEfX7Kkzq2oSMyVbRWom+XhCMg5D7f6LeZ4HMyoC0tLe7YESg3EcPoR87EQ+t50HxroGOT5ZuFHLmw/IzyVhgiM+UgvaXmy68j/R67882Qbdt3DwgHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YeZWkgAN; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YeZWkgAN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xTeD5TXMUUxOn6GRK8xe62w7qElKQSrw/VtIwhlCxEQ=; 
	b=YeZWkgAN9wEogSGEbJFyatCB6AqfHCkzh9XGFNVNO7x4yIvXCJZIgFkBsabUt1vZyTf6FtCFAX/
	gPzaZ6h4pKoGWrsHAtMaKH/E3gUBsMxCvV2tRHvJuXfHWnycyAq1G/m0KtJKoPGSjUtFwXE/eY1Dr
	tnB7kC7FpFULAH14I/hAogugUpioU4dkmA7DeIGvYoy6puSt0jrQB+Txf88FkxauHY/Br5OHCN8bn
	6yPrTJDZur9qll8cfMa9Bk3fZn3d5SsI03PUwq/F+NfkhhFF+flcxf0ykRJh5tnawEG9BDLUp2Hji
	H35WQ0/76YejgvWdECfOZH/02OveXRtiQfDw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v6PKb-00BBN8-2v;
	Wed, 08 Oct 2025 16:15:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 Oct 2025 16:15:29 +0800
Date: Wed, 8 Oct 2025 16:15:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: api - fix reqsize handling for skciphers and
 aeads
Message-ID: <aOYdodeILYU2_Pjq@gondor.apana.org.au>
References: <20251007141852.726540-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007141852.726540-1-t-pratham@ti.com>

On Tue, Oct 07, 2025 at 07:27:51PM +0530, T Pratham wrote:
> Commit afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
> introduced cra_reqsize field in crypto_alg struct to replace type
> specific reqsize fields. It looks like this was introduced specifically
> for ahash and acomp from the commit description as subsequent commits
> add necessary changes in these alg frameworks.
> 
> However, this is being recommended for use in all crypto algs [1]
> instead of setting reqsize using crypto_*_set_reqsize(). Using
> cra_reqsize in skcipher and aead algorithms, hence, causes memory
> corruptions and crashes as the underlying functions in the algorithm
> framework have not been updated to set the reqsize properly from
> cra_reqsize. [2]
> 
> Add proper set_reqsize calls in the skcipher and aead init functions to
> properly initialize reqsize for these algorithms in the framework.
> 
> [1]: https://lore.kernel.org/linux-crypto/aCL8BxpHr5OpT04k@gondor.apana.org.au/
> [2]: https://gist.github.com/Pratham-T/24247446f1faf4b7843e4014d5089f6b
> 
> Fixes: afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
> 
> Found this while developing TI DTHEv2 crypto driver. I narrowed that
> these crashes in [2] are due to some upstream change and not my code as
> the same driver is working fine in our internal 6.12 LTS version (with
> daily CI builds not showing any regression from crypto subsystem). The
> *only* change is replacing crypto_skcipher_set_reqsize() with
> cra_reqsize in algorithms as this patch was introduced after 6.12.
> 
> Now, these crashes were not caught earlier because [3] split the
> in-kernel self-tests into two configs (CRYPTO_SELFTESTS and
> CRYPTO_SELFTESTS_FULL) which went unnoticed in my local development flow
> and the CRYPTO_SELFTESTS_FULL config was not enabled till recently. [2]
> shows after applying this patch, the driver passes all selftests
> succssfully with CRYPTO_SELFTESTS_FULL=y.
> 
> [3]: https://lore.kernel.org/linux-crypto/20250612174709.26990-1-ebiggers@kernel.org/
> ---
>  crypto/aead.c     | 1 +
>  crypto/skcipher.c | 2 ++
>  2 files changed, 3 insertions(+)

Thanks.  I've applied the skcipher part of your patch.

Please repost the AEAD part as a separate patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
