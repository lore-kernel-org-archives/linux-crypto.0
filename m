Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156AA1FBC90;
	Fri, 18 Jul 2025 10:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836210; cv=none; b=uBFfXRTspHUbU+mTesftr7+jd1vrkfZLU4pZnFPKpZdFVoYnXKn7YHi9sCAc7R/1qiAa3Q/vmXMYip7nn3w1BT2oTGpZmyZeoE8MSOzDFifxiZhauiNxXoBBRrRo5Bt49ET9vci4ouUj0wrDTcAaVLZvit3PGktVbwtUggurzSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836210; c=relaxed/simple;
	bh=u2LkEn/zgqYWKn7C7KpEoFVn3tk+eA58HFlpv/IFMAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GM30iMRl79KSoxZP0UvsXpNYvJKQedQ3q3rWGiajivq6v9bJdDHSWoK8L1hH1rsK5gcul3jOujQufkS96SCHdDxjX/8JLmKL67CkTmJ51hny7/8XskSaSyh9vUdTT4yK4M8ne9UeYv0HPsdDa4iKL6MHnd0EE4Mo7CoUxV7ly8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=h0l66cJH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="h0l66cJH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LKt1g1sbqm2Wa+cY6013CXKJkO9ElxUaR2cwW6UTsTs=; b=h0l66cJHCxUZ4HZkJWbR2X3L5e
	2WrouEoTN8RIdJTof8MhfiQ5CN0awUPYxZdDcQsza1QTUb+ED0GxTLkRyWttNN12nG5CKiRZehnY+
	xpIfEYCuF8ePFfoNDF/DJQ7VdLuMHVa6RqlgTSA7bYEyDoRjg2D7iLKhLdtScs86rl/eHPj9BjWj/
	untkdfQGAs3ze+BrQtbZcwYl3Bv+IivIJgzR15nKF5zp2WtHhOjD99sy+dHMYsiHAAJAFLU/7NsJ2
	MseX9yipWowNzqzjk0fyCxMuf0FxgrYXQjI9RbwnyQkb24OQiiHadQZDrqBChUNcXCw6j9/1BDwpo
	ryeDgJbg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciW7-007yWV-1S;
	Fri, 18 Jul 2025 18:56:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 20:56:35 +1000
Date: Fri, 18 Jul 2025 20:56:35 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
	Declan Murphy <declan.murphy@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Mark Gross <mgross@linux.intel.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: keembay: Fix dma_unmap_sg() nents value
Message-ID: <aHooY2oi26hiB0TS@gondor.apana.org.au>
References: <20250630085707.62981-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630085707.62981-2-fourier.thomas@gmail.com>

On Mon, Jun 30, 2025 at 10:57:06AM +0200, Thomas Fourier wrote:
> The dma_unmap_sg() functions should be called with the same nents as the
> dma_map_sg(), not the value the map function returned.
> 
> Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
>  drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
