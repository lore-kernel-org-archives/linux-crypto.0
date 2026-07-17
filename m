Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E60A30568E;
	Fri, 17 Jul 2026 08:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784276283; cv=none; b=jHMPoVJxFLA0eS15DlH5aBhg8GbM8XdbM7mDfSZa2Uylap9VTTA/AK59XB0Y/HL9WCgwWy51nKNpQsY14PRzvHYR+4JzI6YRm61b/aKuol0s7x7Fks21pkSpXgQHVjAesoSvRUC3N8sPuXaKVnCWK57efhN55GxHATiVkGWQuoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784276283; c=relaxed/simple;
	bh=i+R4cHMdY9GH5EfVgQYUy5uoRNt988Y3bquysDJ6TqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpvNqWEnjyoJdb0+v2e0U169Y8bVNZPYnBM2NTA08C5qDFfYSic+K4QGlErb5RSf64dooHZSIZ4x4VHdXvmrZbIg03oor5/Nh3vpLmftVFVjv42dpdsvhg+fYiE7hVIkmq3IkJYLgNfVLAH4foNtP/EbBW4idPjhyRNUozFe2UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UogLas1I; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UogLas1I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/uwwzJv9rSUgDKy6TMSdODfdguuexpxWZhu6PXoHUC0=; 
	b=UogLas1I7hV6QI+awXiZecVbouUfwPKx2LO/IbiiAcerY3i7D5PmR0uqAhq1LH3n7tVInKhQ/5v
	r2vSeolfbvowZIALRDWeU6rE5bK9Y9zayMlvveL1i9a2N9w9EJS55Ntv3AMRvftt6Td/vXpfol9S/
	yqvVXun/e/d/UKfrojPXZJyqtkATC7TPh61uOFEVyzr3NQV8rr7QeiMRPAkayI0LkqUiXxCDkbCuW
	9RyHteRjc5YOonGVwsb7niBZjB9VK2c7n0Qx554qlGaWTN1HRYcg43xKIrb0imkcGFtrC7X+sgNFi
	/63O3aKHWdr6NLh10if7XFkEZ7vRX8havUhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdlX-0000000EOD5-01x2;
	Fri, 17 Jul 2026 16:17:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:17:50 +1000
Date: Fri, 17 Jul 2026 18:17:50 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
	Nayna Jain <nayna@linux.ibm.com>,
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: powerpc/aes - use bool for encryption/decryption
 flag
Message-ID: <alnlLg-LmvQwTDjU@gondor.apana.org.au>
References: <20260711145216.747128-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711145216.747128-3-thorsten.blum@linux.dev>

On Sat, Jul 11, 2026 at 04:52:17PM +0200, Thorsten Blum wrote:
> Use bool for the CBC encryption/decryption flag passed through
> p8_aes_cbc_crypt() to aes_p8_cbc_encrypt().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  arch/powerpc/crypto/aes_cbc.c | 6 +++---
>  include/crypto/aes.h          | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
