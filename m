Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CCF1F19A
	for <linux-crypto@vger.kernel.org>; Tue, 16 Apr 2024 08:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713257957; cv=none; b=faiI+ouS2UZbM7ejrrbnCdB2N5af1KHwm1HCASb4tT7BOgQkUhsgRHyrRqRu+qMMLt/xo05TSAs9WAPwBqLY8SU81qa9vVxRzoAAceoSFN97avj9lRQCCfxBImCZn9eOycOs3cuPZyPGDSsM6bsi3h0I6ts+9VP0/TKO2u6Fl5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713257957; c=relaxed/simple;
	bh=IUeVz3BA/76P3socaWqYfQLfGmlPt9N5h6hgm7V2DV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kc3nSIRdTEU4+c30Kawg865lgJU6C8+q8Je56l5fuCjG/h0WpjirNj8X7ZkqT6Qb2td/aXHleh0t+JMh6Z5a7eSZK8ff9u09E9iwoOv6HUUODxcqg1KAkZDc9bNQOQMrqRQnv+2x0l3mi3st8xb0hRXR46m92+TV8k+FeKudqyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rweeW-002I4o-TW; Tue, 16 Apr 2024 16:58:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Apr 2024 16:59:14 +0800
Date: Tue, 16 Apr 2024 16:59:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Simo Sorce <simo@redhat.com>, Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/2] certs: Guard RSA signature verification self-test
Message-ID: <Zh494tFvPQhxJ8j4@gondor.apana.org.au>
References: <20240416032347.72663-1-git@jvdsn.com>
 <20240416032347.72663-2-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416032347.72663-2-git@jvdsn.com>

On Mon, Apr 15, 2024 at 10:23:47PM -0500, Joachim Vandersmissen wrote:
> Currently it is possible to configure the kernel (albeit in a very
> contrived manner) such that CRYPTO_RSA is not set, yet
> FIPS_SIGNATURE_SELFTEST is set. This would cause a false kernel panic
> when executing the RSA PKCS#7 self-test. Guard against this by
> introducing a compile-time check.
> 
> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>

The usual way to handle this is to add a select to the Kconfig file.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
