Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058343A4521;
	Mon, 10 Aug 2026 08:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350693; cv=none; b=Hjx5YXq6Xv+EvwMkezEjjjrRJoKcg9B2ZhyDgvcshjj69CjP4YrNBIDvJhVwCXa2fKnjNoCAD8sl42fnUeX+mrvL2SuhRx3xf7B3wRu9Q9XUpOEGLX4aEhgZg0UEXHPpxH8/zy4/faRxXQsdhkRhKsiXAN81t1C0Jtva4XxAfiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350693; c=relaxed/simple;
	bh=1khHu3bXy8VfyeJSekNO2EMpQo9/a7eInl55FIFCb0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LiOZSrQX7Y17CrcplAjVhM8hCtxbjTzx4FtSsl6bcBmpiCXPfy0e0Fots0zmO1dpzUw2YmyMYSCB9WtipSvXgNr04ztjJcv/Uz8j1Pzyko64iw17NnP6uEuDUd884L/qtR+7M/aourddOFcaetirXgigzwgKx/qcRc0o0JJhhD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Ajr9bPT3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Ajr9bPT3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Ax73i209+w/6+Z2Rl+qU/zcxTYq595PGjHWmbjXYsSk=; 
	b=Ajr9bPT3Hh3mcQrjw0HSWkNROriF7afwe1yGYiBBQQxTwMZKyjaAJlOkJUmM1RpofM5q/imi8Hn
	5syWebJyUvf9y/XiQEtsC7nvZCp3XrfKLu8WbKSZYt6hkmG2BcZvIbfKLwG9b59hv/5n4C1wvVFdR
	YI3g/I+uIAFcWy8pdpLbGGTU/nkclzCDRD2WwPYMJncuFw/aws38+0nqgZzr5VshSrFy9chUYsL+M
	drcbTh+svI1gIIEX/1xuTOfb/Ba/6vfcBXWhJNASlb9qDW3d0/nglRYRtuShZP8IcjPV/haTYTHB2
	AbYd82pXxwp/PP7kzK8HmiBVz8VOVgeB/1Nw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLPr-00000003Wl4-3QB8;
	Mon, 10 Aug 2026 16:31:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:31:27 +1000
Date: Mon, 10 Aug 2026 18:31:27 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] crypto: cesa: clear cesa_dev on _remove
Message-ID: <anmMX8O2xkp_-pBA@gondor.apana.org.au>
References: <20260730190029.1038946-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730190029.1038946-1-rosenp@gmail.com>

On Thu, Jul 30, 2026 at 12:00:29PM -0700, Rosen Penev wrote:
> This is already done on probe failure.
> 
> cesa_dev should be set to NULL as the driver checks that it is not and
> errors saying that only one device is authorized.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  v2: set after mv_cesa_remove_algs
>  drivers/crypto/marvell/cesa/cesa.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
