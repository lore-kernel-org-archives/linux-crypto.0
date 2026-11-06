Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964560;
	b=HT6Bntwzek9EHjrFCHrB+jTVCU6tIpNDI90EVCbXoraiDrnf+iIsXtCHdn8bFIFBZXgH
	 EVdDR6N7ZtdYMGJx3vETiUv5kY60J4mdzZS4r6bHz0X4Z9rMnJxJFvJEWu3V7E0fAZl4O
	 MNlXyF/IXTgdj0Vnt+1AdNuyQl7lzEh6v3Xxfd18OS+IILc/ZRtkpBbOqJnrzBdeS7SvS
	 wCBIEo+8To+ZesAETr7smbhHsiYHqlSlDsSKE/2PkjdWXqBvcrkSVch/+Kjl6MDZlT6N2
	 6n1z3FQkwm1A6O8NWOdFOUhCTzXWkq2cCLc/JwnsNCbh/pGmds5aRkMVHROMyOEYSeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964560;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=iM+SfBejBmbmga6UyfeGy4tcXe+ACgtNFM+WMKjMw2k=;
	b=lnVI3BiCxHMDwQnhCeVGesNrHjQMdwIfCceA2muF5GLzw16R8DuX3S8vyuB/1IjInE7X
	 cXYWFb7qeR3u/HQ2W209DqxzT2tiiYesHfCeFg0I9vZqNXRGh+jdWHd0/CCHx3CPpFLzj
	 E2ecvpxfIM6fKDEVYJ0jMbBdu5n+0xfxXMg2905Im9tGg/zwA43IlWqMi7uO35g8goywL
	 FG+dGKcTdZBNBkE4AfDw9KfI3QNro9WxbHAQbG8q3bNCvBEMxgO6V+1Uc3x9e2cMrWJCO
	 IF9J7w56LcosgJUzOUe9Ct8YGMKuU49gn1ZroXvjNA/LOD4nGZUw3T6QNITFfPh64aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=Kr2TdItY;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11AC606D835;
	Fri,  6 Nov 2026 11:29:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D11AC606D835
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=Kr2TdItY
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=iM+SfBejBmbmga6UyfeGy4tcXe+ACgtNFM+WMKjMw2k=; 
	b=Kr2TdItY9CYe1scElzL+I/RzNP3Gn+yn4X2emxWeNXDGBTLtIHso/MwGIoWdzlypgwmshXFJf0z
	9sBuPsFkkfNX3KpFgC/iH1iNdtWmMMo0yq7Xf45yOdzWEsQox2aiKz7DZ+f1CZ8HLa7HEiD7sUJvw
	wX5qFov1hcT2xayiTwRVJHqRqNCJJDkACXeuKslCB1EMPQPsgTvzTZZKKQRoWGCUk7VRnGc0yvHrO
	sZiHsHTzaE5dG02S/70BvAjCaz5C/9aa0a26/bAzhseBYHAK6k93tRmPZ37YF5TGmMvFvc+m17kal
	d82dasUSBCmtct1ne+7Kue3UWMtTbJMNC2MQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPI89-0000000Br7q-21aL;
	Fri, 06 Nov 2026 19:29:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:29:13 +0800
Date: Fri, 6 Nov 2026 19:29:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: ZhaoJinming <zhaojinming@uniontech.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	linux-kernel@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>,
	Thorsten Blum <blum@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - free dc_data with kfree() in the error path
Message-ID: <au26CQgxIh74UlJ2@gondor.apana.org.au>
References: <20261019-qat-dc-data-kfree-v1-1-b294cb951a77@uniontech.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019-qat-dc-data-kfree-v1-1-b294cb951a77@uniontech.com>

On Mon, Oct 19, 2026 at 01:51:32PM +0800, ZhaoJinming wrote:
> qat_compression_alloc_dc_data() allocates dc_data with kzalloc_node(), but
> its error path releases it with devm_kfree():
> 
> 	dc_data = kzalloc_node(sizeof(*dc_data), GFP_KERNEL,
> 			       dev_to_node(dev));
> 	...
> err:
> 	accel_dev->dc_data = NULL;
> 	kfree(obuff);
> 	devm_kfree(dev, dc_data);
> 
> devm_kfree() only frees memory that was allocated with devm_kmalloc() and
> registered with the device resource manager.  dc_data is a plain kmalloc
> allocation that was never registered, so devres_destroy() does not find it,
> returns -ENOENT and devm_kfree() ends up in WARN_ON() without freeing
> anything.  The dc_data structure is leaked.
> 
> Commit 4cc871ad0173 ("crypto: qat - use unmanaged allocation for dc_data")
> switched dc_data to unmanaged allocation and replaced the devm_kfree() in
> qat_free_dc_data(), but missed the identical call in the error path of
> qat_compression_alloc_dc_data().  That path is taken when the overflow
> buffer allocation or its DMA mapping fails.
> 
> Free dc_data with kfree() here as well, matching the allocation and the
> other release path.
> 
> Fixes: 4cc871ad0173 ("crypto: qat - use unmanaged allocation for dc_data")
> Cc: stable@vger.kernel.org
> Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_compression.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
