Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBF23876CA;
	Fri, 23 Jan 2026 02:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769136768; cv=none; b=k2rIcvI6BSpzWartYSNCqnHfPkHdidrycd05fZXKTKDQCkN8MJlxFvWxKsT+JILPRd1FTNRHAL0Svr6SvEEJ3ApRUAOGt5ukijikhvR+Sa2lx7joAsMD39EiT4vutvcZbjQkafbTzK7bsCyG0y5JxYeC7Ik3BNHTOxb93u80If0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769136768; c=relaxed/simple;
	bh=rKk57+D1T3OLqDJOkI0wsJUgXxgmIky4NafnvfrZpV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDaIufknJX4FHqJtRPpywgmVA+U+50IAluvWEum9pyFyYWYPX/tARF0KBImWAIM2xk+q78F6M9Kv2CrDqpcPl80jFDuUeAyNt9rv8wXSKg5P4T3yU0/Dws2bExXm85AAehUkHiUIlHljIfZ14sRlwmW4IOgO6l0/qXNJXiLyEtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=L1gz2i/f; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="L1gz2i/f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=tObez+5s71Z2gxNgv1mMH01LClCRKZJiAJOxZNbpZ2Q=; 
	b=L1gz2i/fu4NupHBb4GMv+FTER9r6+Q3wgckF88JpV+kqzOzIv3wMyw1Rp3AmqqS//6q81LV48UX
	lVGr1uyWlFUas7DAhH+vosZA2YC9hq/RsQ6q/IxlmZkqaZiytAEGjy7P45/hjbTZ6+NVFg+TY1wOY
	/HqqTt3Z3yAotqMyJJAPl5zadj/9oaqLJyuj5KUmPqHhhhIQLBLndHqCFKbhZOs2N0exJCXxt+eeX
	BcUcIrV9TN9tZiLMj01SieqWKVAmehvclAmGJw1pVh1LyQgqKK5tMMMk/d01fdzh9h3QQZJvRnvJU
	Tza6T4G9pPHDsTW91XTup8H+TtNo54b41YSg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vj7HV-001Tgs-2H;
	Fri, 23 Jan 2026 10:52:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jan 2026 10:52:17 +0800
Date: Fri, 23 Jan 2026 10:52:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lianjie Wang <karin0.zst@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: core - fix racing condition when stopping
 hwrng_fill
Message-ID: <aXLiYQuXehWtvRrx@gondor.apana.org.au>
References: <20251221122448.246531-1-karin0.zst@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251221122448.246531-1-karin0.zst@gmail.com>

On Sun, Dec 21, 2025 at 09:24:48PM +0900, Lianjie Wang wrote:
> 
> Besides, if the hwrng_unregister() call happens immediately after a
> hwrng_register() before, the stopped thread may have never been running,

How can this happen? Surely that would mean that the kthread_* API is
broken?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
