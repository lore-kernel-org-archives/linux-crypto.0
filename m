Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E050312827
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 12:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764852494; cv=none; b=aIwBvVsZMqpAmf7UBmK2iSfRu0QJ+pEH7SeauJgwIxa3uDYeq2t0FRbTXRX56aOZoMtJBq35z2KfsTnWbI2qfZk9i5mh1DDin8d6/LTvOrO9rkE6AV9ynTXt45m7qmo6AVS0DUCLZzA5wNiRORSdlP1kY3fLqzPK4xzES9dib+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764852494; c=relaxed/simple;
	bh=B0hEugrCXqGGN4ALbIJPeG3+AtscP9Y0qNOYxWjUgkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQ8Ztzc4pYGcbXoBNgQiBWRxmbXM7SmYxOYQ34Dp3UXbaLGbavfZGo9ZTDJ5rzlDsvu2iNuKf3JbOPDwotw1UdPl06o5+syzCDsgOcbHBG1NEAdo4gsBw0mA+CATFx3zDoZd/DkrweyU7er9lxuWY8x/Kx7At4vuQhg3Ef7wj/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aAaol5on; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jh+J6o7l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aAaol5on";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jh+J6o7l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764852492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pX7y99mmj0giZ9y5FDPCfhmCiPPHpiTX9nP/IatHpZ4=;
	b=aAaol5ongJVTEoBxlmcIJhCjtgaLjXTZnCElNMuzTo5xZvDxoKRlSIrMoDUSe5MFzN5jng
	PweUSvL6lWj0W3KGyo4tj29RLx5xk6FGnwdDuFmowEyPD9zLvWmIdWB2hm9RXSH0TaDnkJ
	DDWwtU4GeRogy6Elk85G+eEev+lNSe0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-8yPJtYb-PliDA6jpQqL_RQ-1; Thu, 04 Dec 2025 07:48:09 -0500
X-MC-Unique: 8yPJtYb-PliDA6jpQqL_RQ-1
X-Mimecast-MFC-AGG-ID: 8yPJtYb-PliDA6jpQqL_RQ_1764852488
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477bf8c1413so5605345e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 04:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764852488; x=1765457288; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pX7y99mmj0giZ9y5FDPCfhmCiPPHpiTX9nP/IatHpZ4=;
        b=jh+J6o7l3HyXwXCVgm5G5BgkZzX2Pvj2nob3D/LWlPEnXlzaCFSxdN8vJqAbl9mug+
         qm421bxM50Zyla9eZYaJu+262EyEb71z4c+FNFgPwtR33jWjEFenuuo3LPhLE2bRFy61
         hzpfO2KhnolIQcrCXkWGUZe6EhIchY/9NyME20VkZZB/aMATkKbLJWGQn4hvZ22r6J4U
         s9+8D/ZRPNhww7MrRuLFAtW42/CtRj3yw2rLjeGAvH/Rl4bm9KkCmBPWi8Sp0ivFId6i
         gCAq8nqH6MV/gdQMPmTegpED4xokeKso0eX12IL70RknTI2AktmiBeSOstkfW89h7d3n
         3yWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764852488; x=1765457288;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pX7y99mmj0giZ9y5FDPCfhmCiPPHpiTX9nP/IatHpZ4=;
        b=cqGd3NHU42578kLAmT8D632yfjh1DBRXFeB1TekyDMob3x6dE3ua5IXRiz+R4mukVl
         CCMj5f+BA7y9WRXHgpJvltYVmU5Z37bsZHhsACOeY/55ubKiMZN1T2tKMidCiKHX+l7j
         f8l6OUpW6Z2IYpE3K/47mBkfb0B4h1lMbjiSXU507dwBHCJ0EQmL3zlyhGqC4j8yEbbh
         NZ3QUYq5TfVUirwulQW0yJPMJ203CjZvpDNSpBW74CivFbzLe2ILeSV1dljtLDl3JMeb
         KrAMS8YQlBkx2LvoW8clyT/JV+xS7kpKHY/S/Tm1jR+1TT5CKUyBVjek6XIDLw6QP5ul
         WWTg==
X-Forwarded-Encrypted: i=1; AJvYcCVvx3LHLe98L7uQePuToSiU4MRg2mxeUoTsSBgQwfPCKL7KmhPVf6BRYM8bK12AYgENEOz93eISd1auGbA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJRcED+8Kl4OyvDE/skQHucdc+BGb8N00g5pTZ1kOXx3i+WWBZ
	nTqLu9qZaK3h+v0Vq4Zy0dtGcBLbOV/P7wzmOWfGZZv1WWDbW+v1yoSoHpXaB+Jg+dOcmO0zBg3
	ML7rE+YDfM7mBBVzJBMgJ5shtJh3Ed8JCBH5j2GBsUTBdzpceW1TcthyS+bwiMyDEHw==
X-Gm-Gg: ASbGncsR7vSsW0ojFezAjDH+tSP0D9zgHmALfEd6Srn6vKg9iTRRCIfFuezoQpjNixm
	KtJKFcmFksrUDklviRZ5s5ASvtiF8lhYl3lcjbO6RmdSlmAZHUoNbwhy05BbyV1hEye6QkdeD/1
	gHKOX4BjzxAQft/KxhvYiranzVyGz6Q2Kz7O3BhKYroybdVwFbjlub4q3cxSxn0k+eArO1aArou
	1LWC52mUSPa2OFWRywph/f6pVlZSVovlvs1rhXZf0t8xEXJLlQxo7/eScy0thgLgjabW88TxiFk
	HFr7HvKJThTHxodAOnEInv+BdiK3V1tQNtebZcavl45myEwAZTfKWHkY9522mK2G6x5SlcBpcjZ
	7LBf88LmAbYRlPxb+WYi4EBAhILTEja4Kjw==
X-Received: by 2002:a05:600c:1f0d:b0:477:952d:fc00 with SMTP id 5b1f17b1804b1-4792aef32d7mr60372085e9.12.1764852487630;
        Thu, 04 Dec 2025 04:48:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFbNFqgJDX5+7XQi3p9LS6ZXlKNMGmlWKhpbg0dum6lKVbLtjuX2TB10rq5OVbED8RR0dMGsw==
X-Received: by 2002:a05:600c:1f0d:b0:477:952d:fc00 with SMTP id 5b1f17b1804b1-4792aef32d7mr60371715e9.12.1764852487110;
        Thu, 04 Dec 2025 04:48:07 -0800 (PST)
Received: from redhat.com (IGLD-80-230-38-228.inter.net.il. [80.230.38.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b178959sm43289225e9.8.2025.12.04.04.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 04:48:06 -0800 (PST)
Date: Thu, 4 Dec 2025 07:48:04 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bibo Mao <maobibo@loongson.cn>
Cc: Gonglei <arei.gonglei@huawei.com>, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/9] crypto: virtio: Add IV buffer in structure
 virtio_crypto_sym_request
Message-ID: <20251204074712-mutt-send-email-mst@kernel.org>
References: <20250701030842.1136519-1-maobibo@loongson.cn=20251204112227.2659404-1-maobibo@loongson.cn>
 <20251204112502.2659544-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204112502.2659544-1-maobibo@loongson.cn>

On Thu, Dec 04, 2025 at 07:25:02PM +0800, Bibo Mao wrote:
> Add IV buffer in structure virtio_crypto_sym_request to avoid unnecessary
> IV buffer allocation in encrypt/decrypt process. And IV buffer is cleared
> when encrypt/decrypt is finished.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  .../virtio/virtio_crypto_skcipher_algs.c      | 20 +++++++------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> index a7c7c726e6d9..c911b7ba8f13 100644
> --- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> @@ -30,9 +30,9 @@ struct virtio_crypto_sym_request {
>  
>  	/* Cipher or aead */
>  	uint32_t type;
> -	uint8_t *iv;
>  	/* Encryption? */
>  	bool encrypt;
> +	uint8_t iv[0];
>  };
>  
>  struct virtio_crypto_algo {
> @@ -402,12 +402,7 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
>  	 * Avoid to do DMA from the stack, switch to using
>  	 * dynamically-allocated for the IV
>  	 */
> -	iv = kzalloc_node(ivsize, GFP_ATOMIC,
> -				dev_to_node(&vcrypto->vdev->dev));
> -	if (!iv) {
> -		err = -ENOMEM;
> -		goto free;
> -	}
> +	iv = vc_sym_req->iv;
>  	memcpy(iv, req->iv, ivsize);
>  	if (!vc_sym_req->encrypt)
>  		scatterwalk_map_and_copy(req->iv, req->src,
> @@ -416,7 +411,6 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
>  
>  	sg_init_one(&iv_sg, iv, ivsize);
>  	sgs[num_out++] = &iv_sg;
> -	vc_sym_req->iv = iv;
>  
>  	/* Source data */
>  	for (sg = req->src; src_nents; sg = sg_next(sg), src_nents--)
> @@ -438,12 +432,10 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
>  	virtqueue_kick(data_vq->vq);
>  	spin_unlock_irqrestore(&data_vq->lock, flags);
>  	if (unlikely(err < 0))
> -		goto free_iv;
> +		goto free;
>  
>  	return 0;
>  
> -free_iv:
> -	kfree_sensitive(iv);

so iv is no longer cleared on error. problem?

>  free:
>  	kfree(sgs);
>  	return err;
> @@ -501,8 +493,10 @@ static int virtio_crypto_skcipher_init(struct crypto_skcipher *tfm)
>  {
>  	struct virtio_crypto_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
>  	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
> +	int size;
>  
> -	crypto_skcipher_set_reqsize(tfm, sizeof(struct virtio_crypto_sym_request));
> +	size = sizeof(struct virtio_crypto_sym_request) + crypto_skcipher_ivsize(tfm);
> +	crypto_skcipher_set_reqsize(tfm, size);
>  	ctx->alg = container_of(alg, struct virtio_crypto_algo, algo.base);
>  
>  	return 0;
> @@ -552,7 +546,7 @@ static void virtio_crypto_skcipher_finalize_req(
>  		scatterwalk_map_and_copy(req->iv, req->dst,
>  					 req->cryptlen - ivsize,
>  					 ivsize, 0);
> -	kfree_sensitive(vc_sym_req->iv);
> +	memzero_explicit(vc_sym_req->iv, ivsize);
>  	virtcrypto_clear_request(&vc_sym_req->base);
>  
>  	crypto_finalize_skcipher_request(vc_sym_req->base.dataq->engine,
> -- 
> 2.39.3

