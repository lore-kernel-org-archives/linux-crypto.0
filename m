Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDA32EEE8D;
	Sun,  5 Jul 2026 08:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240872; cv=none; b=gJJw5TL8GUBJCF8XlsG2lwHFscFT0GC/4tBqIQn4ZA266j8Yr7cr/aKAYG+kybv2+jzRJDOnnFm2vUu3pjbeunnbnXeRqz2/8NRSoSbnnjSI8bUbKzL/7UChKBjgXnmfBN7ZcwTRujjgt0V9LILtmOadhmosVNe7olXeFoKKpmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240872; c=relaxed/simple;
	bh=iy08QOwcCzLs113RyX9wF+UfS0JGIG256F2louG6/R8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y+6ZWdxdonGRAW8uXiJfQKn3CLnH8Ypx08rIsMnJGhpHsswQ7mQXPA7zI+njjbDRO99ZJTQfdnt7M0uYnnhvh4Qb7Zv1jPS9rfypNruhWv5dMySs79d7Me4MFk/LeoUb4G4pQBr4DMl4l5BWrzPjvwE8At6fQlkHG7953wimHNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=k4/5qTcZ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="k4/5qTcZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qA3gP4os8McJ+OFNt7VdQApYAsXAbBxNhE6FHogmy7s=; 
	b=k4/5qTcZKzBCWtbviciE1tIhaLlmL7Mll6xFO6a0fvAz1wVm4nlf4bqF6/kuaM9DlCzvIcOEz0x
	uwcBxf+o8kXBv/l8b8od4idqOKzcNiohTboAgsxNpF7db6Ts/w8qv+lNj18V1w2GAVryJD5/50yvq
	qk5ehtgF+Wmx9bjdS1D26lnscVwXdjdVrb3IqvbpECw346OzIHNxQamsYjlTHpQyJXqRzoe541dwI
	dWjV4P6PMcWgLa4wqVlMd0W+mRYn72KaVym02Odn0YaPlYpEX2l250T9CDv4gHzgiFJq4bz7Cpc0W
	vtCb+9vdBqTFpMRwxzl328Czo8Php1FSDr5g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIPO-0000000Al8V-1mDb;
	Sun, 05 Jul 2026 16:41:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:41:02 +0800
Date: Sun, 5 Jul 2026 16:41:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Corentin Labbe <clabbe@baylibre.com>,
	"David S. Miller" <davem@davemloft.net>,
	Heiko Stuebner <heiko@sntech.de>, John Keeping <john@keeping.me.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: rockchip: fail ahash requests on HASH idle
 timeout
Message-ID: <akoYnu7cfveRDmKc@gondor.apana.org.au>
References: <20260623135528.46115-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623135528.46115-1-pengpeng@iscas.ac.cn>

On Tue, Jun 23, 2026 at 09:55:28PM +0800, Pengpeng Hou wrote:
> rk_hash_run() waits for RK_CRYPTO_HASH_STS to become idle after the
> final DMA transfer, but ignores the poll result. If the hash engine
> never becomes idle, the driver still reads the digest registers and
> finalizes the request with the previous success value.
> 
> Store the poll result and finalize the request with the timeout error
> before reading the digest registers.
> 
> Fixes: 37bc22159c45 ("crypto: rockchip - use read_poll_timeout")
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/crypto/rockchip/rk3288_crypto_ahash.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
