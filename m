Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168863;
	b=oYEvyDkbagu5/J/t3nDVuAUN8LyqbbPtxCImqJQxetym3Mk0kSIdV5CwSu/jPlkKy9LG
	 w/M10MhQrSEafvz64USnjW2vyByqQsCL1dJFgkYakcQB3dBZbr4K7pjI2Itms5tV0bD/Y
	 Pug2HjyVe4RORNxdYkyPbjXBcSvOALzy7TeEhH+e4VWKzq0YksYSrza7KMEbHSr87uGad
	 OyvOB6RNSlFBB8VdTsVvNzRfqMeTfPrUodpJunbaJ5bpTw8OZywzTIN2dz85WK0/o/BVH
	 /uFsu9whDaN7WDnHaDdiLhgQX8pD7Yd/v5jdtMtFPPvLqLL8W1hESBb8bO3DZOcspfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168863;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=1U7Hy2sMhArBZCxu2GDyjmJzGlD4GYMvvTvb31K5AEo=;
	b=jUwWWlti5GX5jrCfeAZNbl3n2R+E4/ST1295W9sATO1r++xLZi9+jeXcNetMyewayeHK
	 Ew/3Sz9qWdkSzwO3CsvGnYvDx26CH68ujmJcrzicuZ8qw7ovgLfH3qYUUkwVFylPVu/rw
	 mQH6IbXOZndvJKBCRdGBz47+DTsjAzko1PzCRkfU6mRKxGp3tl2rbfz53MRFOuMDRJOLG
	 m+sL8hNYa6kxVhlgJ3J6YgZLyttrgsZGSOYx3c3AhRy0QM/7rwsyO1DtzR1eOKgIJSyP3
	 mcbbr8a0dTQ/vML6kU1vo3QC5Oo0U1DSsBW3hGlUyCD3pprGf2h7nhNg1ZBxbLZI36A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=oVD8bui9;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5C160A2600;
	Fri, 20 Nov 2026 10:01:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A5C160A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=oVD8bui9
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1U7Hy2sMhArBZCxu2GDyjmJzGlD4GYMvvTvb31K5AEo=; 
	b=oVD8bui9cOYU8Q/+DzeLXlCvZ/ZII2UZLIEquGhoNyM5Du29Dx1ksoxcAohJ4ftH0zd+NEEnBy+
	AzCKyFf2G2xKEqteH9ps/1vbZV1aRM4vUll6+TN3zr9DhpG2Eo7uLyIo0gUrU2menCaCTZh5fKU14
	tSDIIY/QdW5/UMX3AhUldwJS8u3hUjue9r/nNJtuL0QGEhg8h0qJ4kt+B2WGFKxWGuxP8aJ7f6JYK
	iptZLClLJWBzFBNrNQMMr8LIT+/4SzPq4ZkI/oTnv/VRLUFsSVs6bQAh37PTK+BJrMv2KXZk2kyQs
	PZnOMATag4DRbrHxC+z24wgpkjccqACDojFQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULQR-0000000HYvw-3bIW;
	Fri, 20 Nov 2026 18:01:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 18:00:59 +0800
Date: Fri, 20 Nov 2026 18:00:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Huth <thuth@redhat.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - Don't use -EFAULT as error code during
 setkey()
Message-ID: <awAaW4PhJxllUutD@gondor.apana.org.au>
References: <20260824122403.630026-1-thuth@redhat.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824122403.630026-1-thuth@redhat.com>

On Mon, Aug 24, 2026 at 02:24:02PM +0200, Thomas Huth wrote:
> EFAULT means "Bad Address", it's the error code that is meant to
> be returned when userspace provided the kerknel with a pointer to
> memory that is not part of its address space. However, the QAT driver
> abuses this error code during its setkey() function to signal that
> there was something wrong with the selected algorithm, which is just
> confusing.
> 
> The best choice for an error code would likely have been EINVAL here,
> but qat_alg_aead_init_sessions() seems to make an effort to use this
> for another error case already, so there is likely the desire to
> distinguish the different errors here. Thus use EOPNOTSUPP as a
> replacement now, so qat_alg_aead_init_sessions() continues to return
> two different error codes depending on what went wrong.
> 
> Anyway, instead of hard-coding the error codes in the function
> qat_alg_aead_init_sessions() again, let's also simply rather pass
> the error code from the called functions up to the caller instead,
> this way we can also get rid of the need to call memzero_explicit()
> here three times.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .../crypto/intel/qat/qat_common/qat_algs.c    | 31 +++++++++----------
>  1 file changed, 14 insertions(+), 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
