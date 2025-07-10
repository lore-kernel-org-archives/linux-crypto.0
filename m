Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3234A28C01E
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 08:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752135504; cv=none; b=cxnkMc0aj6wjFPj4gmdJspNtkHc+jfUS9uLLnQ/XNRMYxCNxpOsjXjLe18VKeTva+Z+jwuAujnzlcFEetRmzq7Gkr8tGxZKU9Q1slmPc/mz5wGteNlV8iU9wu3kN+T9TbGRFctnQ+8vyPbgnmZOQb07+OS4vLxE4bOOMvoZpDZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752135504; c=relaxed/simple;
	bh=hbOzgPyE6YhsASf46NZFQvg6sVbTTV063HdgEjEqNEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m4PeDQlBNlbehEqWnTfLev0j9Fz8gNOoi6dax44RNRoG6iO/PGGWGL8KBAWqLsAAqKTUVEh5SLrAsbr+qPO+ZlouIb9srgl7ckd5Wc/QjryCAWmQ+yE4S65eRhSRqIx3Rk0HpTN+/NP0r4D3zcROo1QVqbErvn8FyCFXekPKyNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bNa2lphP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bNa2lphP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4r+jD0w7FNW14+fWqzE33zqsDBIQ1wnu4cDdjPEqU24=; b=bNa2lphPJntFbFZeApTgW3Jkxx
	ujvWJLC1cZmUHIXNPnZmAwLIq3sfaAYWO+SXDxuhzDnHGle77tvyJAmElrUdDNk5sjwSrDPBxxYTq
	lx+PRR7oTW0X8iR/xUnLa8teIju08qGZ62hqEXDKMx7yPLNoAz4n5SMo7sxyAdzerM1ys9TE5THiB
	AIQvHxO45SX3iuYxPnMwn5P8/R9q0jrQVHp5ysaqnabFy7CA1jwsPQccxU+lwb1oR3gugLz9zmjpz
	DWRxln5XYoMQ3qZnNXB0kHoI4oV5fbTDrFaIgcHR7dXqxmMy2ecja6r6sXDuMqhkkoY1cnEWhOY87
	gUIHv2LA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uZmEW-005Ov7-2V;
	Thu, 10 Jul 2025 16:18:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Jul 2025 20:18:17 +1200
Date: Thu, 10 Jul 2025 20:18:17 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH] crypto: zstd - fix duplicate check warning
Message-ID: <aG93SaPtZmgRhdXC@gondor.apana.org.au>
References: <20250630092418.918411-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630092418.918411-1-suman.kumar.chakraborty@intel.com>

On Mon, Jun 30, 2025 at 10:24:18AM +0100, Suman Kumar Chakraborty wrote:
> Fix the following warnings reported by the static analyzer Smatch:
>     crypto/zstd.c:273 zstd_decompress()
>     warn: duplicate check 'scur' (previous on line 235)
> 
> Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/linux-crypto/92929e50-5650-40be-8c0a-de81e77f0acf@sabinyo.mountain/
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  crypto/zstd.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
