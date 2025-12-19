Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8BB2D738F;
	Fri, 19 Dec 2025 06:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766125359; cv=none; b=Ys8+6doETLQ4EUbaKOSSzjjD7IWQVGup2vczU9Cva9AvaMcLh8JBY/+iDg1+YYOP1wtwyoFIYUE0AO5xZmhwwRYMaH56D8x01h5jl3ntF/WxciY3943spZ9jZjxaLVDiyJDfugP9LA+iBgqzGSPS+euzD0DvXLC3wlrsOiVGIDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766125359; c=relaxed/simple;
	bh=BF9qins3I9H30HLaesCMcDL4jQ4iH6E5wokq4D3rW7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D1L1Z6QpltTh51Ro88VhANyw3GOnVSXh2mTmErlf/5yScIuEMU7XRsO4fyx7AFla3jSoNMmTGCqJZwt2P+7i8IwGwzeRygoyI+Oy3rSsC/his3r9Q4JzDlv0iQrdr5ZquW1H2qhsqhCvq2wh03caop1F7Vpg27EMOXm+fN4Z3tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SR9XdtD8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SR9XdtD8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0r6gG8SlXmvlIIsbOSguFzX/oc68mghidC1DJol2F74=; 
	b=SR9XdtD8nT+RbMNH3/p/tZnARnJpWpWCJ5aqkzRtNzdKellAyUkeAy8qDTLVkvz6YM0wgIMtmGC
	lZ97SG1GL/cbhwqqujYH5LOmM+zTb7Gqpb5WM/hZJ27ykI640XLkeaG0Pd7SQXjiYXySruIw8/4MF
	1HthJ3VQL4TMVratXD1V4Z9eIrDiEkHdYRx8OEJ3gC1ly0OkEsvfsx/vVljVtb8xn2UohuglDQVsV
	KpRnQdCa46jQebLi+zNcrv4FCTdjV8BqAeYUrjLMmjhvPvbn9yPnsoHth7Waioflpqs7PU/eoJ3X3
	5eYdw0IN8/WoPMmOjI7EB/lKLBGTlTQciPNw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWTsd-00BEE6-03;
	Fri, 19 Dec 2025 14:22:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 14:22:23 +0800
Date: Fri, 19 Dec 2025 14:22:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: Jens Wiklander <jens.wiklander@linaro.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	op-tee@lists.trustedfirmware.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: Re: [PATCH v2 05/17] hwrng: optee - Make use of tee bus methods
Message-ID: <aUTvHwzw5-1vE6sv@gondor.apana.org.au>
References: <cover.1765791463.git.u.kleine-koenig@baylibre.com>
 <170dceec036ffe468a1f9f26fa08ac9e157ada29.1765791463.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <170dceec036ffe468a1f9f26fa08ac9e157ada29.1765791463.git.u.kleine-koenig@baylibre.com>

On Mon, Dec 15, 2025 at 03:16:35PM +0100, Uwe Kleine-König wrote:
> The tee bus got dedicated callbacks for probe and remove.
> Make use of these. This fixes a runtime warning about the driver needing
> to be converted to the bus methods.
> 
> Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> ---
>  drivers/char/hw_random/optee-rng.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
