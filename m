Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AB43368AE;
	Wed, 22 Jul 2026 06:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.241.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784700387; cv=none; b=H4Y29krhPb/cSEXTjSmbK2dIOkQtBwB1vh6763HFEpM9JrfCR2Rp8Ro5adQvepseOAj/TOOW1Xhp1MWHwfkjIpVQlXoQz0KEBcliosuBBhcZPgQgJRXyQY2SUvnDRyufA4KydDDkgHsD6y/0QuwU5FInyKARM1Pnl379VT99hg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784700387; c=relaxed/simple;
	bh=LN5bdwWceuskaNKmyJkWqtdrVJQGUEM8o5+xyiQlKUE=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VgDOGnKB7b/jl4snQOxlu3Fl1JJitSC7Q6FW1SF35ZDmb3I/njZSQNw6q+oraZ9B7/Cnq1KhxCfrDwV640rlBY1aeDR5RZvt/Tmo7vRtYvxWx1uZWHxj2z7A+QUZp8CEZZLsOMKQPnTvKlyKLWhtHFfqyqIIBKs+Yv+2SQ2LtME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codeconstruct.com.au; spf=pass smtp.mailfrom=codeconstruct.com.au; dkim=pass (2048-bit key) header.d=codeconstruct.com.au header.i=@codeconstruct.com.au header.b=RH3Pfm2f; arc=none smtp.client-ip=203.29.241.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codeconstruct.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeconstruct.com.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codeconstruct.com.au header.i=@codeconstruct.com.au header.b="RH3Pfm2f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=codeconstruct.com.au; s=2022a; t=1784700383;
	bh=LN5bdwWceuskaNKmyJkWqtdrVJQGUEM8o5+xyiQlKUE=;
	h=Subject:From:To:Date:In-Reply-To:References;
	b=RH3Pfm2fKMvYCi7wJbahzfRlko43ftqoQEk7VlGj5uI97BRLC7omAXn6tYMryEH1z
	 +9YxADvc3Rw8JoKyX6PHnFhZGNg/zLqvcOmZKFigkDRfd5MlKdCwQirswoMq7TRGg8
	 CkyDXwobBElM6JqKynoJfIaCE6r1S2l5MPHuAb/BNn3zMnbHoG22tNyKvr3sh2cQLW
	 oiUnVSU5aJWVGWPFZ5Xa9OQzddsFDThBMzJVqjlYFI3U7xEzJbq/LxZV+kZ4Z2wSWe
	 zuaP0Ed/qliw0w1XxQWSpHGQPNaebEPgQ7aNG4oVhwJND7Ud6o8pRAOqY/eE73f3JV
	 Lxkqt/cdqL+lw==
Received: from [192.168.68.117] (unknown [180.150.112.11])
	by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 954F265B37;
	Wed, 22 Jul 2026 14:06:22 +0800 (AWST)
Message-ID: <7ce703b95521b11a2ddf978d23466a5acc65ce9d.camel@codeconstruct.com.au>
Subject: Re: [PATCH 03/12] crypto: aspeed - Remove redundant dev_err()
From: Andrew Jeffery <andrew@codeconstruct.com.au>
To: Pan Chuang <panchuang@vivo.com>, Neal Liu <neal_liu@aspeedtech.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, Joel Stanley	 <joel@jms.id.au>, "moderated
 list:ASPEED CRYPTO DRIVER"	 <linux-aspeed@lists.ozlabs.org>, "open
 list:CRYPTO API"	 <linux-crypto@vger.kernel.org>, "moderated
 list:ARM/ASPEED MACHINE SUPPORT"	 <linux-arm-kernel@lists.infradead.org>,
 open list <linux-kernel@vger.kernel.org>
Date: Wed, 22 Jul 2026 15:36:22 +0930
In-Reply-To: <20260717080045.191538-4-panchuang@vivo.com>
References: <20260717080045.191538-1-panchuang@vivo.com>
	 <20260717080045.191538-4-panchuang@vivo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-07-17 at 16:00 +0800, Pan Chuang wrote:
> Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
> devm_request_*_irq()"), devm_request_irq() automatically logs
> detailed error messages on failure. Remove the now-redundant
> driver-specific dev_err() calls.
>=20
> Signed-off-by: Pan Chuang <panchuang@vivo.com>

Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
