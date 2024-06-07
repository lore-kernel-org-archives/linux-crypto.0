Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654D4D53C;
	Fri,  7 Jun 2024 12:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761669; cv=none; b=rYMlMuMmnXTGLeDrYX0gaahETQqNHkqsyg/nu7vd/2na3ux5jN/UxrvBPm9uf/1Xn0hylH19CfFUve5QZODxsqqj6lPikie7ho6xmeG87x5d2zBRJeG/GJfqx54o4Hu25utQ65bfejHVWjKtxECrujH52BWHYSy16lz1D8Gy4Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761669; c=relaxed/simple;
	bh=8bM4TXmZF6Q3bEWKpxwk+dcuEiChrvC6AykME8hxFxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IzNFsbDdTWooe8d0oUsmZmtITttOKp7XJM26f7gFyXoMfcaKxmsL8DzI3ehaEUGA/5pGfQVyJqQmbSLpvZQwZHYOTsDUZEQSihY8Uv1151XqvI9Zvf5dNzKoeS0/UQ4Jq3Rct/eXdkLkGVc8TWBp+YthKyHtoyicAyVUoBxrbTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYHA-006pMU-3C;
	Fri, 07 Jun 2024 20:00:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 20:00:59 +0800
Date: Fri, 7 Jun 2024 20:00:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
	Declan Murphy <declan.murphy@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: keembay - add missing MODULE_DESCRIPTION() macro
Message-ID: <ZmL2e00gtB9K88iv@gondor.apana.org.au>
References: <20240602-md-keembay-ocs-hcu-v1-1-22741e1c3d13@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240602-md-keembay-ocs-hcu-v1-1-22741e1c3d13@quicinc.com>

On Sun, Jun 02, 2024 at 04:03:54PM -0700, Jeff Johnson wrote:
> make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/crypto/intel/keembay/keembay-ocs-hcu.o
> 
> Add the missing invocation of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  drivers/crypto/intel/keembay/ocs-hcu.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
