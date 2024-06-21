Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4D1152161;
	Fri, 21 Jun 2024 12:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973239; cv=none; b=MiIow7g0ydvHPzE5nGW74+QStsOa72nUtEPN3hykjO4bSt21R9kJemC1jR+tGOHsP/YX2Xzl8nUQmGgq9vWMPIQKRCAmUXCqEmQ3Lc/yEQW9lmeYKkbyKzsR4uoSzisAcD3Kkn0GgqEvhlojIZAykNZTVIbZvjoY4srWIcvzl+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973239; c=relaxed/simple;
	bh=3BJYGNkY5ljEsopichr1iPVm2bH5/omcygOmiN77/oY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YpX/3eSrGH1NwyZXtiYoJs28XTfFgVbYkITs71StB9yMo66vt/Oxa+xauqyf+i7P5LhX5I0k/D4mhbcHuvTRsm6f8xQiTpuGh8/aGrjkh1/FOynRsdfEJ1PLI9x3bcW05ME6vZn21PLWesZj2TUfUbvJBWK67IXyqEwEyk7E9z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sKdSD-002enT-36;
	Fri, 21 Jun 2024 22:33:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Jun 2024 22:33:22 +1000
Date: Fri, 21 Jun 2024 22:33:22 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: arm64 - add missing MODULE_DESCRIPTION() macros
Message-ID: <ZnVzEjYSfv4jZj/8@gondor.apana.org.au>
References: <20240612-md-arch-arm64-crypto-v1-1-7a0e83d83cda@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612-md-arch-arm64-crypto-v1-1-7a0e83d83cda@quicinc.com>

On Wed, Jun 12, 2024 at 01:11:57PM -0700, Jeff Johnson wrote:
> With ARCH=arm64, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm64/crypto/crct10dif-ce.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm64/crypto/poly1305-neon.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm64/crypto/aes-neon-bs.o
> 
> Add the missing invocations of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  arch/arm64/crypto/aes-neonbs-glue.c   | 1 +
>  arch/arm64/crypto/crct10dif-ce-glue.c | 1 +
>  arch/arm64/crypto/poly1305-glue.c     | 1 +
>  3 files changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
