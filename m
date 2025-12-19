Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DCD2749C5;
	Fri, 19 Dec 2025 06:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766125345; cv=none; b=WMWlgzNrPgYBhEqPOYg8uChmGj77KsHMQgvrKxceX7PHsLtFKOU4bbBUw6mqr+/vXQ3CkjZUYA3DLKEgaCh4rdLQ2P1KrvdOsvTuk/3TFZ11zPFRaR7koxsM8CgmzEU1figi3/CgPNK8JvW27fYv3LoHHLM6NeRtHY++RcxJeGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766125345; c=relaxed/simple;
	bh=KjPAmDyxut7IXcApPB6WRZxT0G7td6sf7nanu8aDTsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=En/+uDQ04mf3ZHdBn4bOF/8YIqDa34ShAoDVKmgEXmIdOBrahbUSgbT02/VB6SHPeQ4x6JfW3V/hYs+y1OaZIoACp2lfzw9x82pyGJd5sdQZOoxmL91oa4XVDrTQhNm/K12IQEAtFfI7wp7Mw0QcJT+7ZBJVakYps3KgpKKGs5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ENnGgPvQ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ENnGgPvQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=W0MN6pUFNVtsOI+Zv3JYyUrXeCxmmFLgM9vFQUhlADw=; 
	b=ENnGgPvQ6zoEsTz+ORcYvVV/fbBV5FLiqhmPNMgE2V0f/D4u2DOBkWlKFmhfd8K2uapISLk09NL
	HaRfGs5tR5BcSlZQ+0iJFsOT9vcSxjGzv/6FeX/kNo/dWfuuKXQ4OseBb473WCX4mAW8Ba3vY6cdX
	4L3oX01y4AZB2XZWNNadrnWPY2nofZS4HeAyY0Pv+ItiKgoLIY+WADjVrW7L65yCh9pgq+fKmIbL3
	s8IIqEjU6MM2LV58t7lL4Xl9CpmTsm4gGKnJdv2S8Lbt/mcTD3fAtCe8BFdGj2wn2BQXRySzgHKrT
	jriX6jztWYmMGBFKr4FVu2nOXFswnRYiAtaw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWTsO-00BEDw-0W;
	Fri, 19 Dec 2025 14:22:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 14:22:08 +0800
Date: Fri, 19 Dec 2025 14:22:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: Jens Wiklander <jens.wiklander@linaro.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	op-tee@lists.trustedfirmware.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: Re: [PATCH v2 04/17] hwrng: optee - Make use of
 module_tee_client_driver()
Message-ID: <aUTvENaCfiURNyFg@gondor.apana.org.au>
References: <cover.1765791463.git.u.kleine-koenig@baylibre.com>
 <d0074b2e05cfb78ce5e95c875731e784bef52411.1765791463.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d0074b2e05cfb78ce5e95c875731e784bef52411.1765791463.git.u.kleine-koenig@baylibre.com>

On Mon, Dec 15, 2025 at 03:16:34PM +0100, Uwe Kleine-König wrote:
> Reduce boilerplate by using the newly introduced module_tee_client_driver().
> That takes care of assigning the driver's bus, so the explicit assigning
> in this driver can be dropped.
> 
> Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> ---
>  drivers/char/hw_random/optee-rng.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
