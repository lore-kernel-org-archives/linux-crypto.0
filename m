Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4431552ED;
	Fri, 21 Jun 2024 12:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973321; cv=none; b=aVZWVxetIsC46jou09/XapHF0f98luvQdMj7SjK26kJNLjb8D15FwJrt6d9q4YNgyffWQtRGellNOQ1ik8rLxqY2aq7IZ/31myAaiuZcjjWxNiD9jHYI50htfL3R6Q5HhQOIgnCIoddhTQTvFmzZ+m/5EPjtnavnaqwXde+U0lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973321; c=relaxed/simple;
	bh=jYTDt0Blf0IGRCLiR9Gi7to30UUBqgffpSUNmha3AOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D7CfszFJROF1zyuLGujfPmUpWS9TM+dDWKo/5KTWHXx5qg5QDCOh6AzRUC2Bv6CElzS1Zi6An6Epec1T5riuKPX5iePBJLsdcYPzhVWrDBacVN8XFuE9V2JFqjoPLuu10v9F/WW723ROQHj20hZ+cENMaU9GNdUkFh6l7qvRxro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sKdTj-002epi-1v;
	Fri, 21 Jun 2024 22:34:56 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Jun 2024 22:34:56 +1000
Date: Fri, 21 Jun 2024 22:34:56 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Russell King <linux@armlinux.org.uk>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: arm: add missing MODULE_DESCRIPTION() macros
Message-ID: <ZnVzcCMSCI+ERiOB@gondor.apana.org.au>
References: <20240615-md-arm-arch-arm-crypto-cont-v1-1-f15541b5db02@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240615-md-arm-arch-arm-crypto-cont-v1-1-f15541b5db02@quicinc.com>

On Sat, Jun 15, 2024 at 10:32:37PM -0700, Jeff Johnson wrote:
> With ARCH=arm, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm/crypto/aes-arm-bs.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm/crypto/crc32-arm-ce.o
> 
> Add the missing invocation of the MODULE_DESCRIPTION() macro to all
> files which have a MODULE_LICENSE().
> 
> This includes crct10dif-ce-glue.c and curve25519-glue.c which,
> although they did not produce a warning with the arm allmodconfig
> configuration, may cause this warning with other configurations.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  arch/arm/crypto/aes-neonbs-glue.c   | 1 +
>  arch/arm/crypto/crc32-ce-glue.c     | 1 +
>  arch/arm/crypto/crct10dif-ce-glue.c | 1 +
>  arch/arm/crypto/curve25519-glue.c   | 1 +
>  4 files changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
