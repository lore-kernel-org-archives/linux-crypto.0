Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0773803EB;
	Fri, 22 May 2026 12:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779452830; cv=none; b=cmOTMuQjW+MO+utb1e3kluDGTqMbA5QyynBMKkYM3gE0HfXDFNnFZgiU8pzjoKhitVd/H0lV8avLClq0ls8WSp2ouOSSpNiJJJKJ8qAlAfsSM6ViA4DVQf2+VHnMv2tZvI0xGJhzNDJOuv47qmpPtscQDf+VcQYVELgIPfwzKA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779452830; c=relaxed/simple;
	bh=T1YzM3IEwY/v1ytU1VpQpGKPL7/DSer5x9y26/BK9qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s73CZxX+N+fNFCiS5bduiZj1KO2Wbe9zZgtmic+QxywGaGtsPJipaegeLIGnoaRMmzjqhVGbWYTJjdfbmEzf3dFmPLN6SnbeAqwK3zcokYVDcdiYin+jeEkDu5hW93TpyHyK0wUPW+okApkeab0N8jfsKiH3ohGF6yn1iMcp2gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=bOzDv0e0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="bOzDv0e0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=k2jbkeiMmwat2y8clFhE7OWa9KzdYnSVUD+YeB6gaiM=; 
	b=bOzDv0e0Zzg3DVBoYc3f3Rc0zCpZ4600p919G3FaiMXZGUnNDGsUTCBYIgX1PaFDvNxSedCrFWt
	xuU2uNIQpjx/31UbSHoZqloPzGo+duUQcaBbrPhsRoQ5USDQ13yDw5QDR5s/aBxpoLpXu/+/IY0s3
	dmPuDNh3qNcFP3QvfTHVY3nmvE+OKTlMMIjKXBcvtS+TDbOElAD67hApoM8Kp+brSoBpdtOoFA7Q+
	NvEIy7Zlwt4S4j7a2BBGOASnBwr3v25TMsxjDKD+AWWSVtgrVkKZklnHBIV9GEhbvSLTMFrk02dHO
	B0s2J63p3FYE4efY2k/j37iA1sY0lKXxVhEQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQOxw-00GSJD-0e;
	Fri, 22 May 2026 20:27:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:27:00 +0800
Date: Fri, 22 May 2026 20:27:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/sec2 - lower priority for hisilicon
 crypto implementations
Message-ID: <ahBLlCR8qxYOH1zR@gondor.apana.org.au>
References: <20260511004927.3469951-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511004927.3469951-1-huangchenghai2@huawei.com>

On Mon, May 11, 2026 at 08:49:27AM +0800, Chenghai Huang wrote:
> From: lizhi <lizhi206@huawei.com>
> 
> Lower the priority of HiSilicon's crypto implementations to allow more
> suitable alternatives to be selected. For example, certain kernel
> use-cases do not benefit from HiSilicon's symmetric crypto algorithms.
> This change ensures that more appropriate options are chosen first while
> retaining HiSilicon's implementations as alternatives.
> 
> Signed-off-by: lizhi <lizhi206@huawei.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
