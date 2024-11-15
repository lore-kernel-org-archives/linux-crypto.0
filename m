Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42193BB22;
	Fri, 15 Nov 2024 11:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731671925; cv=none; b=epLQ1E6W8UtcJrx9JLE7PLwp8A4V3T1iFTCYD9PPJBfF9Glz0JwrM08ci+J0O+t/rV0PlWy7j3bhc8eAL7DXzt3pAhmrU1wtdq6CbWI0r6/ovBhzXbkJNUhfSyVcwLwzKWBJ1EZto/QQnvom+TvM5NJUELq3bz3V0HFEKDh+YSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731671925; c=relaxed/simple;
	bh=BCIW7Eqtkd/JoC4ZXWZqmDWtYnGayq/LlJ9Oqz3xXe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jcSnqDfmvsreWWy9dqt0Oa2K6EBD06jppSCn7yt06CLVOcYnK++YtGVf1Y5ymRATpXYfv8F19Z0UeZMc13ma64V6mZo0vTkJZIc87t3PI+PU4lb8CdkEvbV2APk+jQF9Yrz+1CQ2EBAZZPMjfxzUOcFX73wn5AxdCQ3pJX0BiqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AdJQJaBA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AdJQJaBA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ln6NUFo2qRXRfJFl/RulvjbR0lolf2yFHeb6Il/5kl8=; b=AdJQJaBAWwAXJEsrsvth3BJ0xd
	EShv8PQUIgwXqdbV4VJhtB8N1V8PZAGLCjMratcIou5WEASpf+20CbKdi9LHIdct9/Vov9k8+2x+O
	SprrVl4US0j9Ev+PWllTbiSVOAIxYuZYgVtjh25w6LUAzASJMNxDuGu8hepsR0r77Fzh2eaafrYoW
	QOi8CkMk40kALSP73u5a8De7MWeYKdhs/CTmXXcJRQaW0qSOOp+H5crJ5QZ7FS532uiGSeBKE/xqi
	hdt16PBVKfsptTaa8c8RIRdPwpsHNnyIDppRwXqEpLxQ2CkUTAXQ0Vr5ztjojXE5FAwCBfgxruoaf
	ViEv09pg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBuy5-00H20E-1l;
	Fri, 15 Nov 2024 19:58:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Nov 2024 19:58:29 +0800
Date: Fri, 15 Nov 2024 19:58:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Bulwahn <lbulwahn@redhat.com>
Cc: Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev@lists.ozlabs.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: Re: [PATCH] hwrng: amd - remove reference to removed PPC_MAPLE config
Message-ID: <Zzc3ZUgMVFAd8xN6@gondor.apana.org.au>
References: <20241106081343.66479-1-lukas.bulwahn@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241106081343.66479-1-lukas.bulwahn@redhat.com>

On Wed, Nov 06, 2024 at 09:13:43AM +0100, Lukas Bulwahn wrote:
> From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
> 
> Commit 62f8f307c80e ("powerpc/64: Remove maple platform") removes the
> PPC_MAPLE config as a consequence of the platform’s removal.
> 
> The config definition of HW_RANDOM_AMD refers to this removed config option
> in its dependencies.
> 
> Remove the reference to the removed config option.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
> ---
>  drivers/char/hw_random/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
