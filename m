Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7CC192590;
	Fri, 19 Dec 2025 06:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766127403; cv=none; b=KJPS5m9gm9Q8Gc6pM/fyzX0P1Zor3sdqkRJ6E6JtUa3U3iXGqI9I/jdC7m3Kb0aTkMcWAb9BV670n/U0hRUeYMuy/9Qkcwz95Ybn33EKxSPonfTQkTuNiDdpyvT1vlbvBZHWoCdKFCZrQHWPDm/8YXr2ZSzFTIKDxQKwxmPaEHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766127403; c=relaxed/simple;
	bh=wPPd269+CWG79QE4sf/QojEtm6mR/sIi9OXTy/cvvfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F972+C45VZp1BAeWmHP64kxlLDh6X/ogbABKgY5NKsymBVkBBoDm+GDz5jkbsdmhjVq9wrPEh/5mCAFeuGfrjbMCdjwfsC78mOPQ1egxGSbOxjT8WZ8RqzzbscAZxmOZtbLc1z7SX3El1amBjow4iX3HfcBc4Brtu+RLOvjmp6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=d/ljccvP; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="d/ljccvP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=gTALtd/BKITeLIhLBYSh7v2zg/ONbvzKEfYAEJsSlNE=; 
	b=d/ljccvPT06DV/LFt/sK5GyGSIJZt0lb+A2/KuFFcVEgvsFYt7+qpDbk0glmlYX+Lw8VujNWQdm
	QFCwyEnZj6qnddl1hii27DonBeOuTZJk/cri3qe8Q5lEBcBgC4JJ9NNkGdffetnrA77CEGmD8zAgn
	hQmFdMJnEZMjOFJgFx48tkV6LA0WpkOotCxI34MpDLPkqBmpvBE+EDHJBw3jnVNlhIQIK6tMjmFVC
	wK2NOtbLUeU12Bad/j7+0VSdmdd+AC4z7Qvx2QSePccdVvoU2ZGtRNSJC8g+ihMVEUjBHSldLPxKL
	/BGHmz8ZUuJHvULKm2DZ8NxsiJVfp3p/DQGw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUPh-00BEWe-37;
	Fri, 19 Dec 2025 14:56:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 14:56:33 +0800
Date: Fri, 19 Dec 2025 14:56:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linuxarm@openeuler.org,
	liulongfang@huawei.com, qianweili@huawei.com,
	linwenkai6@hisilicon.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/qm - fix incorrect judgment in
 qm_get_complete_eqe_num()
Message-ID: <aUT3IW8vlYKwWDt2@gondor.apana.org.au>
References: <20251120132124.1779549-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120132124.1779549-1-huangchenghai2@huawei.com>

On Thu, Nov 20, 2025 at 09:21:24PM +0800, Chenghai Huang wrote:
> In qm_get_complete_eqe_num(), the function entry has already
> checked whether the interrupt is valid, so the interrupt event
> can be processed directly. Currently, the interrupt valid bit is
> being checked again redundantly, and no interrupt processing is
> performed. Therefore, the loop condition should be modified to
> directly process the interrupt event, and use do while instead of
> the current while loop, because the condition is always satisfied
> on the first iteration.
> 
> Fixes: f5a332980a68 ("crypto: hisilicon/qm - add the save operation of eqe and aeqe")
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
