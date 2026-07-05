Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3237330C158;
	Sun,  5 Jul 2026 08:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240027; cv=none; b=oHuQfrREuFlHJWGSEQFilAVAFUUw4R/fR6xTcBgVCCBodVS1NsePLEsDtBdeSUOjMMHfc6bJfzXGrnbl/tqCIg+pIjyFjhO3kDl1huvZSH4PJ0RUgiGyWOZsAq5TxpRFROiiurHBu95541Clw87BZehocBWlKm4+geGKl5S8EHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240027; c=relaxed/simple;
	bh=EpKlMW5LveiYMuciMiXq64pDB1DX6k3eAxVfOX1YcKM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=WJb9vFva69HiMScS7MYvFXHl5IqYLZPWQmJ7LsFn7yLFuV43oMtgY1kloUVqfUNnSJbTYleFRPZJlKi+zihZBmKj6L8WT2DePqnFM+HW/8Eaewmzc0fLhtuCATr53jq2iuGTPR45xBW50w80ESGJpxp/kvSm8O+wKIwy8QRIUew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=IdE6efxt; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="IdE6efxt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=uOa1wMFrNOEdUyDKqta6glQyq4ySoPGgS/Mn8d2L3d4=; b=IdE6efxtbCK7cJNiuqrnOQfxlc
	5W1XYMbFN8Yq3RH/oSL2bjG9FtgjEjFJs/cckyV7SsMLIFWWuo9gARB3dcwoertEWMXm5m6qFBrPM
	Zz377ylFTUilGGFn+mBc9ckLtikGk92HqsGpPdoDNUU5B6i7WmP4YpCjEGxWdWdI7nsfusKlYk6g2
	RKVDqKmRBeVPGrNHIOBCuqHsm+JGcARXntMBbvapSL1v4J+oMEPERMtRIIXyfuuyHLdMULCY2soeF
	lfU+7kp7/rjZqMwwA4NhxSJj3ZxszybTydpP8RK8ndzEmjzDJxwK4cneukBRu9AjfGFmDpX4CZ/D8
	LPbZxVbQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIBj-0000000Akub-44HX;
	Sun, 05 Jul 2026 16:26:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:26:55 +0800
Date: Sun, 5 Jul 2026 16:26:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	quic_omprsing@quicinc.com, quic_bjorande@quicinc.com,
	neil.armstrong@linaro.org, linux-arm-msm@vger.kernel.org,
	olivia@selenic.com, ebiggers@kernel.org,
	neeraj.soni@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
	konrad.dybcio@oss.qualcomm.com
Subject: Re: [PATCH v2 0/4] qcom-rng fixes and cleanups
Message-ID: <akoVT0XHNhxy9-ej@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608175848.2045229-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> This series fixes several bugs in qcom-rng, including failure to enable
> the clock before accessing the hardware, generating biased random
> numbers, and generating duplicate or non-random numbers due to missing
> locking.  To fix the latter bug, it drops the support for the
> duplicative crypto_rng interface, which isn't used in practice, leaving
> just hwrng which is the one that actually matters.
> 
> This series is targeting cryptodev/master
> 
> Changed in v2:
>  - Changed patch 3 to make the driver continue to be bound even when
>    hwrng is unsupported.
>  - Added blank line in patch 2
>  - Added Reviewed-by
> 
> Eric Biggers (4):
>  crypto: qcom-rng - Enable clock in hwrng case
>  crypto: qcom-rng - Allow zero as a random number
>  crypto: qcom-rng - Remove crypto_rng interface
>  hwrng: qcom - Move qcom-rng.c into drivers/char/hw_random/
> 
> arch/arm/configs/multi_v7_defconfig           |   2 +-
> arch/arm/configs/qcom_defconfig               |   2 +-
> arch/arm64/configs/defconfig                  |   2 +-
> drivers/char/hw_random/Kconfig                |  11 ++
> drivers/char/hw_random/Makefile               |   1 +
> drivers/{crypto => char/hw_random}/qcom-rng.c | 156 +++---------------
> drivers/crypto/Kconfig                        |  12 --
> drivers/crypto/Makefile                       |   1 -
> drivers/gpu/drm/ci/arm64.config               |   2 +-
> 9 files changed, 41 insertions(+), 148 deletions(-)
> rename drivers/{crypto => char/hw_random}/qcom-rng.c (53%)
> 
> 
> base-commit: 79bbe453e5bfa6e1c6aa2e8329bfc8f152b81c9b

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
