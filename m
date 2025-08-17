Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBB13176FD;
	Sun, 17 Aug 2025 11:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755430834; cv=none; b=BO7cs2CUDRGFiS8XsQEF4khmw83M+vLaw5quPkFM87JP5zREslvJwqkI5rtNq75s9oNc/AyIfLsSKVr7SMb2whT7AsbwvNmmC4kkIQ675IDrlK4X4kwGY+jTBuBvq9KEjwopcz5TQgZgppF7g2y71Rw+Vqc/H50dIBhShPlASlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755430834; c=relaxed/simple;
	bh=wSKGngVMiU6SpjdKxTXG1q+SE13GTgAOMD26yhQZlwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KrclhnlHDYp56a7zxtfI/xwPVyTzGwMIxy5Ht1su1onIyXF0KZNt7b//LeaxlacbeWvyLlgX25zhWwx5z4CvtTdylSz/f4sNv8TtBCr5U5R207p/eT4FkaESPB5z4+YAZ61EI0apM1+b6eHMS7IU/FBSolf8XPFi9u4BDV9/ukw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dD6/3GLx; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dD6/3GLx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QCcwWZtPpfCOfSJRlJ3ifzODTcu4UNcUTX/FCaRv9j8=; b=dD6/3GLxEuz7hps+mxNbboTcfQ
	99BTaVnuzdyt0bibflc+Er827RADVFDVPt3x2BKssRxYoCst6Y/tKnbWvjiBr6kcUaZX1klPcYwPF
	fScrbJOy0h7Vy8B9AMQM/n4Zf00dDGJXxSFAdCDwf/S2OjtpQZkprt0UI4hI9uTNlkRPk0MyBYhNk
	LRUq0Alqhws14w5sYBcCBrieou6z3Ub+G2bfct/mAB6YGIKsexnGGNVZCDdz+IcyfnFYypSpM/w9N
	sp5/eCPa3LtGUFrSHnjxODYB5iE6LKMeJrwYZ116oaLizTGZhXrKRrvHzVHKIZUSAe0SxT1rqEesM
	Lqd29hkA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unbUy-00Ez5Z-0I;
	Sun, 17 Aug 2025 19:40:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 17 Aug 2025 19:40:24 +0800
Date: Sun, 17 Aug 2025 19:40:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <h.jain@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, mounika.botcha@amd.com,
	sarat.chand.savitala@amd.com, mohan.dhanawade@amd.com,
	michal.simek@amd.com, smueller@chronox.de, robh@kernel.org,
	krzk+dt@kernel.org, conor+dt@kernel.org
Subject: Re: [PATCH V5 3/3] crypto: drbg: Export CTR DRBG DF functions
Message-ID: <aKG_qHTkmvQynXQ8@gondor.apana.org.au>
References: <20250817105349.1113807-1-h.jain@amd.com>
 <20250817105349.1113807-4-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250817105349.1113807-4-h.jain@amd.com>

On Sun, Aug 17, 2025 at 04:23:49PM +0530, Harsh Jain wrote:
>
> diff --git a/crypto/df_sp80090a.c b/crypto/df_sp80090a.c
> new file mode 100644
> index 000000000000..bde5139ba163
> --- /dev/null
> +++ b/crypto/df_sp80090a.c
> @@ -0,0 +1,243 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * NIST SP800-90A DRBG derivation function
> + *
> + * Copyright (C) 2014, Stephan Mueller <smueller@chronox.de>
> + */
> +
> +#include <crypto/df_sp80090a.h>
> +#include <crypto/drbg.h>

The header files are still missing.

> diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
> index af5ad51d3eef..4234f15d74be 100644
> --- a/include/crypto/drbg.h
> +++ b/include/crypto/drbg.h
> @@ -144,6 +144,24 @@ struct drbg_state {
>  	struct drbg_string test_data;
>  };
>  
> +/*
> + * Convert an integer into a byte representation of this integer.
> + * The byte representation is big-endian
> + *
> + * @val value to be converted
> + * @buf buffer holding the converted integer -- caller must ensure that
> + *      buffer size is at least 32 bit
> + */
> +static inline void drbg_cpu_to_be32(__u32 val, unsigned char *buf)
> +{
> +        struct s {
> +                __be32 conv;
> +        };
> +        struct s *conversion = (struct s *) buf;
> +
> +        conversion->conv = cpu_to_be32(val);
> +}
> +

Part of the problem is that this header file includes an insane
amount of stuff that it doesn't even need.  How about moving this
function into a new header file crypto/internal/drbg.h that includes
just the bare minimum?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
