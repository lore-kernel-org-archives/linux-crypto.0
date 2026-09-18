Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E8536683B;
	Fri, 18 Sep 2026 04:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789706570; cv=none; b=XExLUjRA0H7pzPG+kEDQMbNhFbj6LCy/R4dM9jKZK18cqeXac6aWIERfl1lbgIHt6NnGlys+pGCcM62c/mf/nxqrhQylBrm5ngyvZ+JvdcAh3zO6X3vZ+hz8TTLuR7sbity36QsgCp/+Fbr//NHkIDrlA8cU9WBZJVgtJ3R58v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789706570; c=relaxed/simple;
	bh=D4upwOpfbyrRpYXuHH8jrQqsfj7I6iDeJpXMxZ/4lBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WHJ6j1deaFm6QVe0hTw0yeCOZSqlEvBqfauRdkwzjcNo6zFvmsthgT7najaVCudyrfMYIypceHWwKZCB+9D+S5h1FD2MGzacDa1xrMjESc3uqZVRVHQQIiCGs5oSDARCj8YNahbm6f3H/OAVHoDjY+wLYarvNk+gwon6cf0pspk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=QE+xiJh8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="QE+xiJh8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=MDWxXMOAn28ufDEjnxDRQRbRnBgPwhCMg+M+IS6dN5w=; 
	b=QE+xiJh8/ZERmL6lxHJE59n3ea4ANyDWC9dWxmgxyzfSR0zQZ0Lj05kIlogOsuPPaSw+ASgy1JO
	Y4tFVdLDmLCKV71U8W9aD3jag8HCW+V1zm1/PkPcWF0ZxEsvNXIGk76uhhrDCVA7RpGuwj1kt/ElA
	Xo56DNKfJOOkpU+QgsPcMPARW+QaeAG8BIyZ28Ri/nuJ13X/qliAYK+7SDoq22nyj4QFGqqRQA7ac
	X85ILznCda9+cl8BfijZDUJjVX48m48J3lqMRNNNA0eKMh6E3j4n7UMEE9Klcj6qBklMy6OiXxspz
	ncf98K+c5ft4YYmDwMUJBZYAXlwQkO0xuq3A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7QQa-0000000FH7W-3efI;
	Fri, 18 Sep 2026 12:42:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 14:42:24 +1000
Date: Fri, 18 Sep 2026 14:42:24 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
Cc: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/2] hwrng: starfive: rework clk/reset teardown order
 for JHB100
Message-ID: <aqzBMBaXnIZZMX70@gondor.apana.org.au>
References: <20260907031603.188483-1-lianfeng.ouyang@starfivetech.com>
 <20260907031603.188483-3-lianfeng.ouyang@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907031603.188483-3-lianfeng.ouyang@starfivetech.com>

On Mon, Sep 07, 2026 at 11:16:03AM +0800, lianfeng.ouyang wrote:
> From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
> 
> Rework the StarFive TRNG driver to address hardware-specific requirements
>   for JHB100 SoC. To avoid reset-domain crossing glitches, the driver now
>   ensures clocks are gated before asserting reset during teardown for
>   JHB100, while JH7110 retains the original reset-first sequence.
> 
> Add per-compatible match data (struct starfive_trng_data) describing the
>   clock/reset teardown order, a new "starfive,jhb100-trng" compatible, and
>   select the ordering from it.
> 
> Fix the runtime-PM get/put balancing across the init/read/reseed/cleanup
>   paths, manage PM and the clk/reset teardown via devm so all error paths
>   unwind correctly, run the SEU-triggered reseed from a workqueue instead
>   of hard IRQ, and serialise the command sequences with a mutex.
> 
> Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
> ---
>  MAINTAINERS                          |   2 +-
>  drivers/char/hw_random/jh7110-trng.c | 297 +++++++++++++++++++++------
>  2 files changed, 239 insertions(+), 60 deletions(-)

Please take a look at

https://sashiko.dev/#/patchset/20260907031603.188483-1-lianfeng.ouyang%40starfivetech.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
