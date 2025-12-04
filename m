Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABFE19E839
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 12:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764852380; cv=none; b=RUabf+ppcOsB2YM5u2MYs0H54hHGOIiHVTIj4wNl0KNXH/lokQkJWvjpKgd9Oa9fXtE0PcbeV6QAZGSXfTiuumj/L9AmkELM87E5HRUkzLIcklUIYZ9TWUd5khSJIp+KwMI59gspAZx+tKxfVjMPcWy8mKs5WBVvaC4PAvjmPGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764852380; c=relaxed/simple;
	bh=k2d6AKIbxjDNvI+iSHhx9EKEQwXZyEmjVW0faFK8DDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q05sjqh+nWpd7H+b0Oa37cMq4DKgH8V4c2XpLVF1aSSp7kFFghQJEANMeBSo1vgBlzSiJBJbIfNvnsE3Y9PNMkFFCbA9kotOAHOdpC7GPk3wakUFKnpJNKerUYgbDr2N2Z0V4nRrwmiTfnWpQGp0/xAfn0Q20RLKrboC7gHOxgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FNSQV8/X; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LbLMUcER; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FNSQV8/X";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LbLMUcER"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764852377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CeTXlItwEjkfILL3F/GDxGRgx6cCYk34DZi75wL0heE=;
	b=FNSQV8/X1OGjMC52XOhLrTjNDJY1E2ZNMcQY8gNtjY70lEY9IBPDhVJJC5FeZNMaRbAGFu
	lc7gobhdHi5StKhIkPj4FCpsXtilXWphLNUeXgPxs9bKvHk+GBy0h+vkWCxTe8FiR1Aai2
	5o93i2JWz0D8wchT3cNAO7gGW/wbZ+Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-ZGvWL3YiPWO3WY5sBx91Dg-1; Thu, 04 Dec 2025 07:46:16 -0500
X-MC-Unique: ZGvWL3YiPWO3WY5sBx91Dg-1
X-Mimecast-MFC-AGG-ID: ZGvWL3YiPWO3WY5sBx91Dg_1764852376
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4776079ada3so7437805e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 04:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764852375; x=1765457175; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CeTXlItwEjkfILL3F/GDxGRgx6cCYk34DZi75wL0heE=;
        b=LbLMUcERsZLPqCq98VaOBYwQSAJVGkptJpsfDPzsQm+mzPxRA66LRDbXMl8CsMu0ur
         Qz4yW5daZ4pbtr+gVs9W1Lo0FOdkHa95mYo0CoPcXBhJpjqeH8FYFVsUVbpSWfLFG43j
         +wW/DTWhkqb0v8Bz+n7fejuMYxakV72LquJHc12Lb+AXZt8d6eoPMDSG+4j0n8RLQYAg
         udS9knLfSo70Lv2f4gbRvsmBhMl3rAjk5uYkfGKBO0XdZW6LeAc1foqZCESqCSfBfUgc
         Xhgftz/EyWIs2hRABVFruDprPwMQ4t/wq78IyT94eoo3YQYNmXk5tjp5V0w3jPXmeI1V
         ZUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764852375; x=1765457175;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CeTXlItwEjkfILL3F/GDxGRgx6cCYk34DZi75wL0heE=;
        b=tvIgn8cEBmmisFxSJHCJsikE32cm+RYLJoR75PSQ7YCGOk3AODxpQBW8nkyuohEg98
         8OpIZOcg1x2jVdakRsJjKho5jkfRAGtzsF4Jjl1KJ8Ce/KiSYnXyGfymr8oTuyoVNKYZ
         UvfDaeFUYcoQjWrK40IQh02dPW4aVFevAlNPbq+2XBvhfsC7YBpADE2d3jTfTzemR98r
         1odJEgnQNTeshkk/sC/YRW3C5FjK1/R79oRJDxWlrRZOkqSoNX3OdIrTP1jxiTFJXpDu
         qRMCqQ44ISL5mJVUhwnvW2BK6rYGl5iyyXQL6Q9AeryatI/co+l+yosmYDt7ebmCCThl
         jKMg==
X-Forwarded-Encrypted: i=1; AJvYcCWaAcaGhE3Ri/Mi3OKkqy5dES1hBv4p+cIEF5RdbPZyPjVJBi7H6CRfNHQGzGpOBB2rgTBQbZSYp9ywHYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtH74RuDjA+TbUJ03iUEZp4hJlmiWlWJyfmFmA5K7z9y/4OC1g
	c4JhanLasQKFAC0XzOk4XwTI+3+PhoY2HjUCCKZ5p3CMTSFlrZ8UqjJhIHkk3C+6EXe8Oe7nPmN
	Ggy/QvnaLPhrGRn5VHHJUuIp3m/EoYg2A/Fj9X+XcEU9J6dfXChdOSYEVlaTVHNzPNQ==
X-Gm-Gg: ASbGncsI1+tV8+VpI8wAO3CG4NvIDc89ABcmov5M+oC0OB6ZJawWNzvffBaQgFrh1NN
	Np1hizi5YGnOrHLS71DA+omf25EKDh+YT+HXkdYxeUpnb71CjoiGbyyr+2Ek5s1kY8CunvNCz0h
	/gejow3VKRVq6PuWIMgFHmGOE7hBgATFyiCubnTmSBX0Lh4Fkepupwb2N5a6aQq87P5DVQnej3t
	kcF73serIpgV67Q5Q2hs8HO2xJboglwRDxXVBhykzyUa/HM3/anpec7AUoOG+urdKquoI/QOl9g
	FIOZAc/zTYy+wEG/BrOxrA+j2hrC7JvTP4PTD97PnmVU6fFffmHa1FO6uKybFdDCC8Icqoiwsqh
	l23oAOxTvfyWLPDD60jxid/Epwei5+Zp5GA==
X-Received: by 2002:a05:600c:548a:b0:45d:d1a3:ba6a with SMTP id 5b1f17b1804b1-4792f39cb06mr27308965e9.33.1764852375518;
        Thu, 04 Dec 2025 04:46:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEeqahDkXcX70vDduTq7HLlftnPzdScbCOHAGJylBXRuVjbzCCIVcrHwCKumENhm/jymdPb+A==
X-Received: by 2002:a05:600c:548a:b0:45d:d1a3:ba6a with SMTP id 5b1f17b1804b1-4792f39cb06mr27308625e9.33.1764852375047;
        Thu, 04 Dec 2025 04:46:15 -0800 (PST)
Received: from redhat.com (IGLD-80-230-38-228.inter.net.il. [80.230.38.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b1522e6sm37484525e9.13.2025.12.04.04.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 04:46:14 -0800 (PST)
Date: Thu, 4 Dec 2025 07:46:11 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bibo Mao <maobibo@loongson.cn>
Cc: Gonglei <arei.gonglei@huawei.com>, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/9] crypto: virtio: Add req_data with structure
 virtio_crypto_sym_request
Message-ID: <20251204074310-mutt-send-email-mst@kernel.org>
References: <20251204112227.2659404-1-maobibo@loongson.cn>
 <20251204112227.2659404-7-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204112227.2659404-7-maobibo@loongson.cn>

On Thu, Dec 04, 2025 at 07:22:23PM +0800, Bibo Mao wrote:
> With normal encrypt/decrypt workflow, req_data with struct type
> virtio_crypto_op_data_req will be allocated. Here put req_data in
> virtio_crypto_sym_request, it is pre-allocated when encrypt/decrypt
> interface is called.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  drivers/crypto/virtio/virtio_crypto_core.c          |  3 ++-
>  drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 12 +++---------
>  2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
> index ccc6b5c1b24b..e60ad1d94e7f 100644
> --- a/drivers/crypto/virtio/virtio_crypto_core.c
> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> @@ -17,7 +17,8 @@ void
>  virtcrypto_clear_request(struct virtio_crypto_request *vc_req)
>  {
>  	if (vc_req) {
> -		kfree_sensitive(vc_req->req_data);
> +		if (vc_req->req_data)
> +			kfree_sensitive(vc_req->req_data);

kfree of NULL is a nop, why make this change?

>  		kfree(vc_req->sgs);
>  	}
>  }
> diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> index 7b3f21a40d78..a7c7c726e6d9 100644
> --- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> @@ -26,6 +26,7 @@ struct virtio_crypto_skcipher_ctx {
>  
>  struct virtio_crypto_sym_request {
>  	struct virtio_crypto_request base;
> +	struct virtio_crypto_op_data_req req_data;
>  
>  	/* Cipher or aead */
>  	uint32_t type;
> @@ -350,14 +351,8 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
>  	if (!sgs)
>  		return -ENOMEM;
>  
> -	req_data = kzalloc_node(sizeof(*req_data), GFP_KERNEL,
> -				dev_to_node(&vcrypto->vdev->dev));
> -	if (!req_data) {
> -		kfree(sgs);
> -		return -ENOMEM;
> -	}
> -
> -	vc_req->req_data = req_data;
> +	req_data = &vc_sym_req->req_data;
> +	vc_req->req_data = NULL;
>  	vc_sym_req->type = VIRTIO_CRYPTO_SYM_OP_CIPHER;
>  	/* Head of operation */
>  	if (vc_sym_req->encrypt) {
> @@ -450,7 +445,6 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
>  free_iv:
>  	kfree_sensitive(iv);
>  free:
> -	kfree_sensitive(req_data);


So the request is no longer erased with memset on error. Is that not
a problem?

>  	kfree(sgs);
>  	return err;
>  }
> -- 
> 2.39.3

