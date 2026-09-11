Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B3130568B
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 05:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789104476; cv=none; b=ZaD/WY8ZHATR5LN/uh8KXbHuTHy9CLYfOnYStuR3p6p1W2GUAEHmAFe8wq69HlqifJRFaOs8tkMWNiE3mwYMDyiD9tTT8EuThtNI14N9PP/Borxlr+/aVj4pw49vn9Y0vyz2J6D45wrB/iTKyMNHnHgMuGKmBaRa+7/DNj4urCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789104476; c=relaxed/simple;
	bh=TW1Mzf2vXrHfPopBCMVtJ3eYP9LoLZwEO3nOMakstVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PpCU73/LYf3uloA1i1aRfVec/A7Ie/HHBJm9Mgxft9TufvIxpOQw7E6rPQJa8SFDTi6yXaRGZ+SjTOa2IFMPQHAvO61dvwQr5Ula6vtvr1JjyA99+KNk1U7qopu8bqoTzyUcHNSsqeGhGxskccC9FtvW1Fau9/73YeZtokRunT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cCQ2UDV5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cCQ2UDV5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=zgXTtlhaWmR7MTFB6z5T9qK0uzjKNG/+8PYmzgTHf4I=; 
	b=cCQ2UDV5YMlq5c2SuO5KYHutgvrVCdjOeY/n1DyuxposmjghUoQrvjWZbQO9jyYVh4HI7oDSGjY
	nSOuQRsNwb093EmTf9jzB1byXyh1+Gv7iJh67/yQYA2ZxPBDx5ku51sbcC9dy3gWxXdkfdC0h/G+6
	4/45VhvjstE89ucPDQL9n1FEycVczK8NNsUTRVX/RuOZYSmUf6njoW2bmIuYWmkvSgCBwVKGUPigG
	EP5n4Z6xvDMtZuWupLXA6ndy5TtZmvZT7bs6hcgaPCgB8fvldTWSjws2QiqxAXj39v5fYwaJ6Jlyt
	dek/BYgtVpAVwBvWcDuiZlCLBEGeuuv8+baA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tni-0000000Cu6U-0JuS;
	Fri, 11 Sep 2026 13:27:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:27:50 +1000
Date: Fri, 11 Sep 2026 15:27:50 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - release instance on DH fallback allocation
 failure
Message-ID: <aqORVtTan5hWbbhS@gondor.apana.org.au>
References: <20260826093931.445639-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826093931.445639-1-ahsan.atta@intel.com>

On Wed, Aug 26, 2026 at 10:39:31AM +0100, Ahsan Atta wrote:
> qat_dh_init_tfm() acquires a QAT crypto instance before allocating the
> software fallback transform. If fallback allocation fails, the instance
> reference is leaked and the device remains permanently in use.
> 
> Release the instance before returning the allocation error.
> 
> Fixes: 5d5bd24f4155 ("crypto: qat - implement dh fallback for primes > 4K")
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
