Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3194218A4;
	Thu,  4 Jun 2026 09:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780567198; cv=none; b=cqKZBik7LoxEk3pYN428rUocHQy3ammy8hqfFJxZivUCxwXf3HP3FJDygx2zi3aJR6RPVw74oRiFaqz7OWU+OUzGFvBxi89403V/E8W9lO1KCGjoGZZ0bfODeVJsOWXwbX96F0grHtd+RQGvkQoi7yjg7w/7dXYk3C22w0oucOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780567198; c=relaxed/simple;
	bh=eqlNHF+q3cEDddc+wxNKDVAWG6EiGIssayDG7y5vbuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gMzipciGRJgtunWMl9KhoL/5YjAKYnaZSenrCGZmu8WieYd7HShiF77Zye/KTZOmnOOPAMw7KWCOJ9rZlImxVK63GZWTWDOpDV7ZjyEWxE+2RkO7eUeaOqH/bUZJvdP4OSKm7CXLlRRrek4kA1ggZPegDGVwrGrs+dWEhiFB9bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cAZXwkux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cAZXwkux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E9E1F00893;
	Thu,  4 Jun 2026 09:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780567196;
	bh=RE3y58cfN3emON7okbPg00mrh+PG0AR+SDYN8nlyFj0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cAZXwkuxDP3V24BuhjSHh05PCPeqN9CbVh1GWI8UJMbBsTCqoVP/K4HFUSe69fXeD
	 aQnbBSlDfS4BfQ2t2YK0FdOAlQmkWj49flSCZuNvEfJ0wqxtzEv0yP/st2XtfF6whB
	 yj/RJKyKsvKyx5qqv4h6LT9eT94yeJliIUJ0Ss9/Bq6u0hVgL5Wpq05U0Z6QXskBfi
	 t2EGCV5c7V8xPmamVd04tBqGb/nErP4NchXSVTrRF+METQ8BrYrqQlCBCCzWYBalLy
	 jXrPIVgABZKeuvxPJvezUDIm2oa/CzcMsAQCcUNwGk/5aXE18qwgi2RmJFm4PpcuiK
	 rnjUJjct2tFvA==
Message-ID: <4202c304-4a4e-4b1a-8d40-d96a1ef143fb@kernel.org>
Date: Thu, 4 Jun 2026 11:59:52 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 29/29] crypto: talitos - Remove TALITOS_DESC_SIZE macro
To: Paul Louvel <paul.louvel@bootlin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-29-cb1ad6cdea49@bootlin.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-29-cb1ad6cdea49@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 28/05/2026 à 11:08, Paul Louvel a écrit :
> Now that struct talitos_desc no longer has the SEC1-only next_desc field
> (it was moved into sec1_talitos_desc), TALITOS_DESC_SIZE is identical to
> sizeof(struct talitos_desc) and no longer serves any purpose. Remove it
> and use sizeof directly at each macro invocation.

It is still there ...

$ git grep TALITOS_DESC_SIZE drivers
drivers/crypto/talitos/talitos.h:#define TALITOS_DESC_SIZE 
sizeof(struct talitos_desc)


> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
>   drivers/crypto/talitos/talitos-sec1.c | 10 +++++-----
>   drivers/crypto/talitos/talitos-sec2.c |  6 +++---
>   2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/talitos/talitos-sec1.c b/drivers/crypto/talitos/talitos-sec1.c
> index e4f482520372..504ce9e23e59 100644
> --- a/drivers/crypto/talitos/talitos-sec1.c
> +++ b/drivers/crypto/talitos/talitos-sec1.c
> @@ -190,7 +190,7 @@ static void sec1_dma_map_request(struct device *dev,
>   	while (edesc) {
>   
>   		dma_desc = dma_map_single(dev, &edesc->desc.sec1.hdr,
> -					  TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
> +					  sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
>   
>   		if (!prev_edesc) {
>   			request->dma_desc = dma_desc;
> @@ -202,7 +202,7 @@ static void sec1_dma_map_request(struct device *dev,
>   		prev_edesc->desc.sec1.next_desc = cpu_to_be32(dma_desc);
>   
>   		dma_sync_single_for_device(dev, prev_dma_desc,
> -					   TALITOS_DESC_SIZE, DMA_TO_DEVICE);
> +					   sizeof(struct talitos_desc), DMA_TO_DEVICE);
>   
>   next:
>   		prev_edesc = edesc;
> @@ -216,12 +216,12 @@ static void sec1_dma_unmap_request(struct device *dev,
>   {
>   	struct talitos_edesc *edesc;
>   
> -	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
> +	dma_unmap_single(dev, request->dma_desc, sizeof(struct talitos_desc),
>   			 DMA_BIDIRECTIONAL);
>   	edesc = container_of(request->desc, struct talitos_edesc, desc);
>   	while (edesc->next_desc) {
>   		dma_unmap_single(dev, be32_to_cpu(edesc->desc.sec1.next_desc),
> -				 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
> +				 sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
>   		edesc = edesc->next_desc;
>   	}
>   }
> @@ -239,7 +239,7 @@ static __be32 sec1_get_request_hdr(struct device *dev,
>   		edesc = edesc->next_desc;
>   	}
>   
> -	dma_sync_single_for_cpu(dev, dma_desc, TALITOS_DESC_SIZE,
> +	dma_sync_single_for_cpu(dev, dma_desc, sizeof(struct talitos_desc),
>   				DMA_BIDIRECTIONAL);
>   
>   	return edesc->desc.sec1.hdr;
> diff --git a/drivers/crypto/talitos/talitos-sec2.c b/drivers/crypto/talitos/talitos-sec2.c
> index 52f783ddc8b6..0df3b22510c7 100644
> --- a/drivers/crypto/talitos/talitos-sec2.c
> +++ b/drivers/crypto/talitos/talitos-sec2.c
> @@ -205,7 +205,7 @@ static void sec2_dma_map_request(struct device *dev,
>   				 struct talitos_desc *desc)
>   {
>   	request->dma_desc =
> -		dma_map_single(dev, desc, TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
> +		dma_map_single(dev, desc, sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
>   }
>   
>   static int sec2_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
> @@ -346,14 +346,14 @@ static void sec2_init_task(struct device *dev)
>   static void sec2_dma_unmap_request(struct device *dev,
>   				   struct talitos_request *request)
>   {
> -	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
> +	dma_unmap_single(dev, request->dma_desc, sizeof(struct talitos_desc),
>   			 DMA_BIDIRECTIONAL);
>   }
>   
>   static __be32 sec2_get_request_hdr(struct device *dev,
>   				   struct talitos_request *request)
>   {
> -	dma_sync_single_for_cpu(dev, request->dma_desc, TALITOS_DESC_SIZE,
> +	dma_sync_single_for_cpu(dev, request->dma_desc, sizeof(struct talitos_desc),
>   				DMA_BIDIRECTIONAL);
>   
>   	return request->desc->sec2.hdr;
> 

