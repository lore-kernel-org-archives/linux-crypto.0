Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB2B1534E8;
	Fri, 21 Jun 2024 12:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973259; cv=none; b=iyt9waVXvqX/K/rItUbIwnUIQAm9FneNTk1nhK/B+udmTmEsj4OiIjU9qIvJvFA0BSVvUO4cM0kk99G2HGFsg4L003IjZVQrGxzX340pRbGujLPfNYuflCHBkiJezVAMxnlcfeQ7NnS8/WdFMtMqhrKmByMzSx/G1bBDy1zfJ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973259; c=relaxed/simple;
	bh=HoQjIAwoupAiFgsGAC1OXVXb3HoopVh+bPPNvH9Vtbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NRXzM1iRCj7R1egyR2IqLJ8V+2zeST7qWZ+0EEEl5rK198+1ibvM9gJV9xXlrY3J0nF5pPB9bG5oMOt6kDTrYzY/PJqreYIE1rq73wLLuu9RVfZX4mkUBrg8O5bckgcI5UCZird5n4uFu+OONzkjPEImaVPK60pU9w4oFbcNKrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sKdSk-002enf-05;
	Fri, 21 Jun 2024 22:33:55 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Jun 2024 22:33:54 +1000
Date: Fri, 21 Jun 2024 22:33:54 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] hwrng: add missing Arm & Cavium MODULE_DESCRIPTION()
 macros
Message-ID: <ZnVzMn0i2iNBR2Fc@gondor.apana.org.au>
References: <20240613-md-arm64-drivers-char-hw_random-v1-1-8bc3cc208333@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613-md-arm64-drivers-char-hw_random-v1-1-8bc3cc208333@quicinc.com>

On Thu, Jun 13, 2024 at 01:47:49PM -0700, Jeff Johnson wrote:
> With ARCH=arm64, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/cavium-rng.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/cavium-rng-vf.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/arm_smccc_trng.o
> 
> Add the missing invocations of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  drivers/char/hw_random/arm_smccc_trng.c | 1 +
>  drivers/char/hw_random/cavium-rng-vf.c  | 1 +
>  drivers/char/hw_random/cavium-rng.c     | 1 +
>  3 files changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
