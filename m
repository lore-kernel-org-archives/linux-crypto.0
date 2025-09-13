Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C654E1F4C98;
	Sat, 13 Sep 2025 04:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737623; cv=none; b=GizRZBNcArqjei/yQMjXsCS6hIuE6fIkWfU7nw9vrDgdNiuVSJH0sJin3LcaWdeXpmjf49E/yz3+9QZ6GtCy5KftcWSRJCXLP9l2rfnJ4svczfU0vfQpLtJOg8cp6ysigX+pI4jcLEwazr0dW0/xk46SdcKDA4fXb5zEUsuQ3Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737623; c=relaxed/simple;
	bh=y6+sqrLibtwb9qCu9fU8DRNV5ZEp9wBw6P3uxlOEpSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4dy33XK6BfmSVDdD/JgjZz5yrATI5BfV6MolxyQjrt1t2uMXAk874PFC5Us6VcUhqHB3ClwvRURhiB4TNVl+a/7HGHM6Js2hIx5MvwJ1Q9LHW542ESvs/2n/0sQHlCe4c+Z2WRltqysJR2BtBoEzJtRXcQGeqBHHocmMmOSZ5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=S3UByejv; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="S3UByejv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OHPC47bISBOTJD21QN1sdK3DKka3QWCE6WCqPFZ1m/A=; b=S3UByejvjAfvXXVsrAIY1jyvT+
	ZyLm8ROgSUL9qnlJkH/LCC6/Yvwcp4FByNeqfExyAbfDL0WM4L8UJtKM9k8jCbdh5QcytsOTe6UEW
	68NtLuvrFjftByp5AKXDJgJ23lG+gWK2Ba8wOfB2uXUQ9BGhrpUo5YsgVW90EygnjJ0Wdz9GBrri1
	Avzlxlj/DZxM/N9Ak+P0ODLxkw4UHihmwpzIcDcJg5JyBpelM1hOnUE8/ebVn+zf/a5QpHRkuohii
	dRd3VgTXf5lnlq0fMbn9Ewcrz5B4WWPEgF+Q6XMT+8qlHRbTAKdTBJM4Ft/5Id9Tbg3HbimhMyAHb
	janisymg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHb1-0053pp-1d;
	Sat, 13 Sep 2025 12:26:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:26:39 +0800
Date: Sat, 13 Sep 2025 12:26:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Nicolas Royer <nicolas@eukrea.com>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel - Fix dma_unmap_sg() direction
Message-ID: <aMTyfxBfbYgFqQC4@gondor.apana.org.au>
References: <20250903083448.621694-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903083448.621694-2-fourier.thomas@gmail.com>

On Wed, Sep 03, 2025 at 10:34:46AM +0200, Thomas Fourier wrote:
> It seems like everywhere in this file, dd->in_sg is mapped with
> DMA_TO_DEVICE and dd->out_sg is mapped with DMA_FROM_DEVICE.
> 
> Fixes: 13802005d8f2 ("crypto: atmel - add Atmel DES/TDES driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
>  drivers/crypto/atmel-tdes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
