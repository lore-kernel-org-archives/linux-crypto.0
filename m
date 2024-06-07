Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79277190685
	for <linux-crypto@vger.kernel.org>; Fri,  7 Jun 2024 11:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761440; cv=none; b=Ok6kj7O5EAQyoAUXDned1SS33RRpi899vP+UyBD6CWXy/3LVLgj80Y88INS7fEMDgGjBgQTVSuI72o3FI1CPyaZ2b6CblnmvmN6C97mm2i0Zru4AfQFEhE3jU3LOo4z9m/eeBx+2/K8Ovo/byIPRqgCD+5ulXdQe8J30fTiEUcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761440; c=relaxed/simple;
	bh=enubXKJTREljcGDnvPTySg+33OGJQdO3FVd7zNLevQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BxlQe18q2o8VsVCH0wwk29ZrATUPwQPnSZE1fdxF5bsJFOl/ZrlNtQh1kBO6iYwUCdNHkWpG9d0CX/Z3e9xLQA0awu8wMIZ/fId+gkHnqCVJFrbOBdNCsnsG/aR2xMa3cyc+RwTKgeWJunbe70zZjqTD4QsCthCTkc59JlMS+g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYDX-006pHr-0C;
	Fri, 07 Jun 2024 19:57:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 19:57:13 +0800
Date: Fri, 7 Jun 2024 19:57:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marek Vasut <marex@denx.de>
Cc: linux-crypto@vger.kernel.org,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	kernel@dh-electronics.com, linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v3 1/2] hwrng: stm32 - use pm_runtime_resume_and_get()
Message-ID: <ZmL1ma8yRkz625Nj@gondor.apana.org.au>
References: <20240531085414.42529-1-marex@denx.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240531085414.42529-1-marex@denx.de>

On Fri, May 31, 2024 at 10:53:22AM +0200, Marek Vasut wrote:
> include/linux/pm_runtime.h pm_runtime_get_sync() description suggests to
> ... consider using pm_runtime_resume_and_get() instead of it, especially
> if its return value is checked by the caller, as this is likely to result
> in cleaner code.
> 
> This is indeed better, switch to pm_runtime_resume_and_get() which
> correctly suspends the device again in case of failure. Also add error
> checking into the RNG driver in case pm_runtime_resume_and_get() does
> fail, which is currently not done, and it does detect sporadic -EACCES
> error return after resume, which would otherwise lead to a hang due to
> register access on un-resumed hardware. Now the read simply errors out
> and the system does not hang.
> 
> Acked-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
> Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Gatien Chevallier <gatien.chevallier@foss.st.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Marek Vasut <marex@denx.de>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Olivia Mackall <olivia@selenic.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Yang Yingliang <yangyingliang@huawei.com>
> Cc: kernel@dh-electronics.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> ---
> V2: Add AB from Gatien
> V3: No change
> ---
>  drivers/char/hw_random/stm32-rng.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
