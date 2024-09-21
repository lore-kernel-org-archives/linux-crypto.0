Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81676D1B9;
	Sat, 21 Sep 2024 09:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726911122; cv=none; b=Akn1h9oBxhAlzJDaoYgpWCwegpDsIx2sl1kAklDsM2XD1y7qiembnK+iy+FDgomKkQBv4Z7yCqsQWTlh5f+66OjgrJTT4bn49Yk8w9J/3jAg5hYVv9SSbEGWiunzTxSoZJT7ugkUDn88tZg7rFibSJrLmGnE+MDde9rPDTXO8b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726911122; c=relaxed/simple;
	bh=WNoZYh7Aa5ofSeqYmpxILxX7PF2FWl6gdpEVXaqy+jE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RF5uBU7YKJTR/wmAVHusGPrHK9lTdhf8YDZgByxh6v0iyycaGxLtNOwhLfOXnlV5yqEhbp+oIFdwEdyqaAF89AmsCnu3UJVn4MznO0T0RYXVJ2jJnPq8o28tU0WYVLLsC8drUhk6E6l+0yFgFsrxVjFnPnBIXjxpTbBWwwCWQj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=B4jB1mQr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="B4jB1mQr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vjE19+EA/AopPzWy7APV3m/MroOy6WxqyOwkBypTXlE=; b=B4jB1mQrvycPEIxXWp9oKEB6FE
	r3PmgGys6yEuDajmiBGW6LtMY9h2RINQSDIZe5a50C5vU/l1ThmC1rKJsa/sxHndsUrvDX8dPYfiO
	DnV9ajAgYzXpvurCVzoEABSoI5u7Do5cSEEy8w8vz8O8FeO9XNQ/C2HZsWAgvU24lF/EyqRG2TqHO
	DtHvXciIerbMn59YDFRhHzLCzrID9vudyrppiUT5/EL7jRZJwIDPkOheD1Vp4dcKASoA8AEHdBbac
	m0hWL6MU3YC96dTpKxLuGVsabCACOrC+X/iA4Gd8Vtsyo0rdcL/uKBZ6GN+fPbRh1EY8VNbybvh43
	1n8cWfSg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1srwIu-003kPm-0D;
	Sat, 21 Sep 2024 17:31:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Sep 2024 17:31:37 +0800
Date: Sat, 21 Sep 2024 17:31:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Danny Tsen <dtsen@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org, leitao@debian.org,
	nayna@linux.ibm.com, appro@cryptogams.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	mpe@ellerman.id.au, ltcgcw@linux.vnet.ibm.com, dtsen@us.ibm.com
Subject: Re: [PATCH v3] crypto: Removing CRYPTO_AES_GCM_P10.
Message-ID: <Zu6SeXGNAqzVJuPS@gondor.apana.org.au>
References: <20240919113637.144343-1-dtsen@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240919113637.144343-1-dtsen@linux.ibm.com>

On Thu, Sep 19, 2024 at 07:36:37AM -0400, Danny Tsen wrote:
> Data mismatch found when testing ipsec tunnel with AES/GCM crypto.
> Disabling CRYPTO_AES_GCM_P10 in Kconfig for this feature.
> 
> Fixes: fd0e9b3e2ee6 ("crypto: p10-aes-gcm - An accelerated AES/GCM stitched implementation")
> Fixes: cdcecfd9991f ("crypto: p10-aes-gcm - Glue code for AES/GCM stitched implementation")
> Fixes: 45a4672b9a6e2 ("crypto: p10-aes-gcm - Update Kconfig and Makefile")
> 
> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
> ---
>  arch/powerpc/crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
