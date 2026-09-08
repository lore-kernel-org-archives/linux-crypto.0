Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC5E4AD7E6;
	Tue,  8 Sep 2026 09:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859259; cv=none; b=byvMXBOnHn/XtPk42YwenvxUOsUMzCwewe//6L29RxI/BSOIRSvgNcfcAKuSfvCo6ySYYa111/f1jSaM+lQrCc63Z1Aq8eziZfdQSidsFPt4xXOtFQkfjaAjAb2kBRfXJWVaoRl9xLsrKLFL9QlHZtASQBeMYvIOIZKS8VYaA/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859259; c=relaxed/simple;
	bh=VGdgfu8FflBUe1F0QvCfe+YXb0jjB4KTsG1VdxloQ1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jsNy1QahzZHh6yVTwzMD050u5QqizEVDcely56uJdJ9ex/WJ+OBTl32xwPCf1yhjqj08cjm8xhrcmGe4mRbv6hMtAUmb5m7yu09Oa5AGM4C+HU3tKtn5aKEkoBMffMKJW+ePErXSn88HvNjq3652ywM9i5bT0vQM1vzfUnQ6NTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iqCEkxAq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iqCEkxAq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=C407YdSwLyJjiUUnrA36d5Mbdvt5XnU6O23tFgKHeQw=; 
	b=iqCEkxAqCo7XVL7E97GFXAOhpV6JPho2st8lQtUfP4A41jAbO2CbgHhoNg0315hmmQpAyqqBI/w
	Wl7SK+hGFcjEsk8P6sVSBAByY+u2ZDGpc+H8jgXHwT9aZsKmUZFm3ld4UCVXOpdpXHHfeWM1LQchL
	HX9TYGZ9xDp2D/dAQnJvJVpq/8ZItBgNel6RYGv/9zqFeG+DSf6ECIQWpWwA+Wp/vinHqyU3QCGV3
	5acQzPEoj+bNw+AiqnMFe/T9yKzicMqhptHC2hb7MiemYFnOK6v+JsdKABkA1s8lKLoJ9vRmMIBKr
	GDjD5WouYQ8KFFWfC4enyI2srdjLjCqKObYA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x3s0Q-0000000Bncv-0UA9;
	Tue, 08 Sep 2026 17:20:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Sep 2026 19:20:42 +1000
Date: Tue, 8 Sep 2026 19:20:42 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: arei.gonglei@huawei.com, mst@redhat.com, davem@davemloft.net,
	jasowangio@gmail.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	Bryam Vargas <hexlabsecurity@proton.me>
Subject: Re: [PATCH] crypto: virtio: validate akcipher completion length
Message-ID: <ap_TatiabFuXiiad@gondor.apana.org.au>
References: <20260821095511.3600564-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260821095511.3600564-2-Jeremy.Jean@oss.cyber.gouv.fr>

On Fri, Aug 21, 2026 at 09:55:12AM +0000, Jérémy Jean wrote:
> The device controls the used length returned for an akcipher request.
> Subtracting the status byte without validating that length can underflow
> dst_len, while accepting a payload larger than the submitted destination
> can make sg_copy_from_buffer() read past the response buffer.
> 
> Reject malformed completion lengths before updating dst_len or copying the
> response.
> 
> Fixes: a36bd0ad9fbf ("virtio-crypto: adjust dst_len at ops callback")
> Assisted-by: Codex:gpt-5
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> index d8d452cac391..886032abae80 100644
> --- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> @@ -69,6 +69,7 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
>  	struct akcipher_request *akcipher_req =
>  		container_of((void *)vc_akcipher_req, struct akcipher_request,
>  			     __ctx);
> +	unsigned int dst_len;
>  	int error;
>  
>  	switch (vc_req->status) {
> @@ -88,9 +89,19 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
>  	}
>  
>  	/* actual length may be less than dst buffer */
> -	akcipher_req->dst_len = len - sizeof(vc_req->status);

This appears to have already been fixed by

commit f77a956f6a19f9463ef1527c9d0cda50dded6b92
Author: Bryam Vargas <hexlabsecurity@proton.me>
Date:   Mon Jun 22 01:52:15 2026 -0500

    crypto: virtio - bound the akcipher result length

Please check that commit and see if it's sufficient or not.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
