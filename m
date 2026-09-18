Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A3E38947F;
	Fri, 18 Sep 2026 09:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789725456; cv=none; b=qRb3XJztV0XD+8QXvOXYpOjLSu/G8hdzAJEZ0JJIv6dJdP+9t9RHhsAipNBH3u6Sld8DNygJzXAc8h6e50rkHnMrbDkkay9uMRu5egRpsGd8YYKEU1Bzc9zxPWrwyorEotGVuyji7gehZYFeHTVqMozhs6fl5zuYM/qgoDshuyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789725456; c=relaxed/simple;
	bh=PPmcgWAtzaNGk2cQAWCxyeyiI8hiUzFM5yKVc4tKWg0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=S22nppZaRZ0iydY8pXR3kp+qeuCiUBHWxGFnlbcm4aSr18EdfGktk95tFvz5u4fVLsvnNvd0l4tgGgcfLPlniN3UsxTaHq1HkZWoZ8qXepJ/UtZGTHZXtfgtVr/CDNABRy433mmYrPLzqzU0ZqF5Jf8WH2A/bwxcBMx2SRq8j4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=je90bFkv; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="je90bFkv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=vSVyhelhFsfegw4hVxsjPHJm1Yo/7biii+IJ3uJLRNo=; b=je90bFkvhOQrvZxbwrZZrlVKBo
	/6CZ2ngkSPuohY6QFxZ3/GbKelfat54bngKn8uAmjXkSldlyMKu+E8xYtFjgKhLTzxu1IselZuShw
	dCIBxavcRp4LfrhHaI/kfvfkWUjTmef8gjium8ydW6oxp1qZocfdYonoaaZfkcQGLcMe2orj55ugE
	VyLzokIkTgjKsTEQZp4yWOGI/OrSI+ZKCLVte2hIvEa76emPoQKgx1aunyvWE7zUT9wZUpPQKOiGj
	rFXG8ST4naS73wbJkbJ+8XwvBBL8YNy63RdjKWGSD/zIPE8DHQnM/RK+i5OHZzhVk6jjTQ42eYDrQ
	5jfottaQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7VLQ-0000000FM4K-3Gpm;
	Fri, 18 Sep 2026 17:57:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:57:24 +1000
Date: Fri, 18 Sep 2026 19:57:24 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Slavin Liu <bolin.liu@seu.edu.cn>
Cc: davem@davemloft.net, nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, bolin.liu@seu.edu.cn
Subject: Re: [PATCH] crypto: atmel-sha: reject initialization without a device
Message-ID: <aq0LBO6C20OuPVdE@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913125143.109897-1-bolin.liu@seu.edu.cn>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Slavin Liu <bolin.liu@seu.edu.cn> wrote:
> A transform may be initialized for the first time after the last
> device has been removed from the driver list. Return -ENODEV when the
> lookup is empty, before the debug message reads dd->dev.
> 
> Detected by static analysis and reviewed with AI-assisted source auditing.
> 
> Fixes: ebc82efa1cd6 ("crypto: atmel - add Atmel SHA1/SHA256 driver")
> Assisted-by: LLM
> Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
> ---
> drivers/crypto/atmel-sha.c | 3 +++
> 1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
