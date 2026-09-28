Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B483345EC0;
	Mon, 28 Sep 2026 05:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572500; cv=none; b=ZcCirMlcNhQNmY0AeugMw8jUUUS0UjgSZ4VgRxb3F2Xa0WYBgkjOKPg5NLwmkRXiqDQGzgE63gHllJyVgmjfYAaRpBLHwwYiL+ImGAkOIIJWKXiTCD0GJbTQk3rYmKg4mO/EdKKQ0bI2nsOVgLoOWOdn5k0mhpG4mvuoMWxX1qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572500; c=relaxed/simple;
	bh=o5nCG+OAwTIWJJPZaeWtamUM9DOkcEIPimjNrkVeSz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MxRPyn/q+L8uGx2S5BlAztButAw3tbewSCGFA2Kb2W16OKj9UYWkgYR0vtv0UIqVVH+ZsLlFeP0wMPes+GA4hL/wKPiMrJHFPyVDES9tReT5oUB1GVQCuM1dgNG8hRh9/lGYeO1ektV1HKNV8/Gam0Sqb6OVoanhHq/caHZ6Lgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=a20t/Mty; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="a20t/Mty"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1r4RZI43iJp/ce+MihAT+y8KPQ68pt5edry6a9L0d70=; 
	b=a20t/MtycGIrR5HKKg5UBXgywuNKVasX168meCmqtFPxIk1T5s4jSWQq1azveufNS+2FkozLm4u
	8uTu9Rop8yTC+COA46mDD6fuGPcw/D7R+UmtyZ+gi0/8G99HithqUJs8fBlJ1RgNumpypMaqDHXLL
	HIlCuauePkPPMR/oWnDWhASO2jsDM6oklpB0LJwMiGSP1+8SR5jwGION5S0/qF+zryVpWMQmiChDw
	y4a523nxy2TFYWF4DRDZcQuqujoYc1uhJ7vx9HVFLITmdoENVHgxQ7Hex+rptJ7SJAn/+EFW4f33r
	/ObBvR9eAuJCpFQu/59pPeptgLWj5l0tyHxw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xB3hT-00000000w6e-0KqC;
	Mon, 28 Sep 2026 13:14:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Sep 2026 15:14:51 +1000
Date: Mon, 28 Sep 2026 15:14:51 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: huangchenghai <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	qianweili@huawei.com, wangzhou1@hisilicon.com,
	linwenkai6@hisilicon.com
Subject: Re: [PATCH 2/4] crypto: hisilicon/sec2 - fix scheduling while atomic
 in aead soft fallback
Message-ID: <arn3y4kT0izjENFR@gondor.apana.org.au>
References: <20260911102942.387778-1-huangchenghai2@huawei.com>
 <20260911102942.387778-3-huangchenghai2@huawei.com>
 <aq0AtfUHUw1qOD2Y@gondor.apana.org.au>
 <c19bbae6-e1f1-4ca4-8156-8b1fb6746319@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c19bbae6-e1f1-4ca4-8156-8b1fb6746319@huawei.com>

On Wed, Sep 23, 2026 at 05:55:43PM +0800, huangchenghai wrote:
>
> I try to use SYNC_AEAD_REQUEST_ON_STACK instead, but it does not
> work here: crypto_alloc_sync_aead() enforces a MAX_SYNC_AEAD_REQSIZE
> limit of 384 bytes, and several composite AEAD algorithms supported
> by sec2 (e.g. ccm(sm4), authenc(hmac(sha512),cbc(aes))) have a larger
> reqsize, so the sync tfm allocation fails with -EINVAL.

How big are these algorithms, is there any reason why we can't
increase MAX_SYNC_AEAD_REQSIZE to accommodate them?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
