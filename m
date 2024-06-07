Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7444A187329;
	Fri,  7 Jun 2024 11:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761286; cv=none; b=UKrlBGRbLWJLpcoyO2CNmj2qRPACQJrbbihl0+1ZzJmWrnKuTcGh6RMvZz4EPAcNTfFAN2CWXrGiluBrO0s4GVmEa46CDf4Dx1v5/nZhCpxQgbhyvwNvt9nH4ccAd7abqwg8fxtW2miE3zAKuWp4B0l9GZuRLQf3fc2/RUQ7XTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761286; c=relaxed/simple;
	bh=hFkaWyI3OZP29wsFF9Fo3AkBrRlml8QhkZFGp0/L0Xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxs+Uzumv1xT9cTInBGDbbnq8Ssq8xrjW78Wv09W/RdBTP+5UIFR5CWKD23h0uVbk/P5z5bXjRJ60BAqFwDfTCwf9hGCnMgMtAqYbGDYnLMGLLlJ1yFXDHoHZQ6vWFX9US70f5Y6IrEAFaTjwAYLGaO/TFcjZ+YqsoQh8d5Hwl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYB1-006pCg-23;
	Fri, 07 Jun 2024 19:54:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 19:54:38 +0800
Date: Fri, 7 Jun 2024 19:54:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] lib: crypto: add missing MODULE_DESCRIPTION() macros
Message-ID: <ZmL0_gAr5oySSbPe@gondor.apana.org.au>
References: <20240528-md-lib-crypto-v1-1-840e468d118b@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240528-md-lib-crypto-v1-1-840e468d118b@quicinc.com>

On Tue, May 28, 2024 at 04:49:23PM -0700, Jeff Johnson wrote:
> Fix the allmodconfig 'make W=1' warnings:
> WARNING: modpost: missing MODULE_DESCRIPTION() in lib/crypto/libchacha.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in lib/crypto/libarc4.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in lib/crypto/libdes.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in lib/crypto/libpoly1305.o
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  lib/crypto/arc4.c      | 1 +
>  lib/crypto/des.c       | 1 +
>  lib/crypto/libchacha.c | 1 +
>  lib/crypto/poly1305.c  | 1 +
>  4 files changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
