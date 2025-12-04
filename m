Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B1530DD0C
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 11:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764848604; cv=none; b=QIrio59S+jozTIl5oEgN2QmOL8MXp3cnyAaoqX7ZRHhEfbIcx2gZhyizNkitJQCDI+vzUBQDJZn9ldsI9oYN/LQAYNKKSk9dKEIEhJ7ddTdTtnG1CZLzrYbfQ7T0mkNtj1gYt2rV/cDcKrnh0CbBr259MFTlL7387mOB/HCx4zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764848604; c=relaxed/simple;
	bh=pszKLqYMch9EXWk7hqcO0ilc+Iju7C6OS56hjaodHf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AVAMv6cAlRJ0NuY8fWe8QhRViwpuOBI4QGbClqIh8M2OFor7P7r3M1JcHiiGF579KEPmS5J+kktZyoy7cY28PvGBQEYktzYNMaCH3FK3CEHV08DzXO4RQmWuf9Y30zy5hsDjQivqyQ6kygHZBBl4mxZMG7jb52FMGjxOjoTHP8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uo9jT6be; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ALwjLNtx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uo9jT6be";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ALwjLNtx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764848602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2EFMX5ToBprEEJfI3u29l+Jc6cpS50lo6R0NjDBv3jw=;
	b=Uo9jT6beN9aQRlgwIF3bSfxBApjskAJSH0O2tCMcapPDhrcHY8JK4wp5QYNkmIvIrbriyC
	KmwUzlzILV/0eU3QJ0AGypXT5oJ1r75b+wqAH/kXoPBFCgS4/9pVXrB7pyyBkUu6xUMJOA
	bgpZIrgzYOivyfKmMThp/VMvBfkij0A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-_gN1xp5nPreWQnOeexvytQ-1; Thu, 04 Dec 2025 06:43:20 -0500
X-MC-Unique: _gN1xp5nPreWQnOeexvytQ-1
X-Mimecast-MFC-AGG-ID: _gN1xp5nPreWQnOeexvytQ_1764848599
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47904cdb9bbso16840685e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 03:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764848599; x=1765453399; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2EFMX5ToBprEEJfI3u29l+Jc6cpS50lo6R0NjDBv3jw=;
        b=ALwjLNtxhQNpOW+a5lDtQQOp79uM4BVPRSAUA1KfbOo67BzXflujMs2mrfDebEXkyG
         GxkDchRuBvP0nI5UufifJdRy7k8a3unUCYxIQ8YbnUdVxyWUw+PkdYFWR1l6PDg3BsTV
         gcgIDLhkRJztEhxFfFUi8CDZ7vmS6igec8vZpeqW1b6VX81juzd8rlycNSBYYbWPC8bm
         AW8C+bSQIkTJe5PUcRhuoXHhWk+528dXIqMEktOUnKnWBGfA9vQzILSBkgFpv7sMv5GH
         Op4JnCwOVpUI1B0K7na073JKMlkw1FeOT858bnegnG5qEgT/C9VYhIKmuBEEpYAwvDby
         6CvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764848599; x=1765453399;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2EFMX5ToBprEEJfI3u29l+Jc6cpS50lo6R0NjDBv3jw=;
        b=jPBycC3Ou4iU5hY4mK5ZzPQ8SsEYI9oPKqAhuZwvLcVPFki5gY/Y0AFG154/nhaxp4
         QCx31GQYzB/lnrH+9g3ri0lNG4haUR22adPyBG0WyUbe6G7ecpXHza3lJXSc0xhtefwy
         xhwwozr/PN2ZvWfQg5rzOsw9yNj0utcf2dSNprR31Zf8fHu6eZDTU2mdgPusTU0xf0m7
         F0tuYpjsDXoEoerlfhT83NEg/kS98ioMMZvoaJNLiPImQYpzjknHNQdHVjNZMr1zoF6e
         1p77LzpkEwyIlM8weQ2eOuH//fMWHTIQB7CckJJL7FMCgFp6fHVh3gbA+ZMXmenBrk3O
         FG1w==
X-Forwarded-Encrypted: i=1; AJvYcCU7pYFBhNT2Zmjf4KHJar64cuC/4Q5/vEcANxbY37YsJrCoYsn4OEaJoa0YXjfggis2ZUReZkYoUE5WEGA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywrt5IsopM7GSiURR6v5QbCiOCb9jSCcVPox1exFvU4nlVjw4Hr
	uso84TOsVpiV4wJNKh6ZKUfF4InlQQ918c2p/gCIcyz/d+wFKa9GtQNPDTuLAgsWYYA+XqK17Qu
	TWXXn2kKiwGm93Tim9eBxMWfoQA7P8dRY8+R8ezx9ijRW1yPH7sM7PJDfsS4x/ov7Ew==
X-Gm-Gg: ASbGnct0JNLBnDdmbjtYHFbaUQRIKwiI3ZExYlGtpsLzo/NrUrfz3VyQ8NO42Si2KqH
	U7cT8HVO/TzScrdWOXIF3foM5iBlnFB6GHf6Tnh0T5nU8aUI1nkTIAnYXepOpSgh1YcrDrysYcx
	Vf0PpSLy+OXED4HLih9WdWRt2XF7JSjwVNpYrvlUTqyt0k/m8ZklyG267waVISKKtzJcX35FA3N
	zHtmO4HAhxTvTl2HPtSAxnWfwMWvEmCuzo0gHyCXb8NASWqSUab5JLlhWZsewAlsZ8uuJJjEeR1
	oWqiq6XlsTddn7FXb3wqzUkga/ea5N8rZErK7YZhZ79AgIkuBJWpTlRAeIINngdkD6zTPhzF71x
	MFXYhqFWU5HZktwBVdRAym5xGAqb51MhRQA==
X-Received: by 2002:a05:600c:5683:b0:475:dadd:c474 with SMTP id 5b1f17b1804b1-4792eb5d6bbmr19075635e9.10.1764848599339;
        Thu, 04 Dec 2025 03:43:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFHIXX2959hjdYQ9fcDZ2zE6c//85R4NGcAv8WZunwk4afsGqi+eLHn8tuXLqs0cxhWVgNWIw==
X-Received: by 2002:a05:600c:5683:b0:475:dadd:c474 with SMTP id 5b1f17b1804b1-4792eb5d6bbmr19075435e9.10.1764848598837;
        Thu, 04 Dec 2025 03:43:18 -0800 (PST)
Received: from redhat.com (IGLD-80-230-38-228.inter.net.il. [80.230.38.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479311ed466sm24272535e9.13.2025.12.04.03.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 03:43:18 -0800 (PST)
Date: Thu, 4 Dec 2025 06:43:15 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bibo Mao <maobibo@loongson.cn>
Cc: Gonglei <arei.gonglei@huawei.com>, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 9/9] crypto: virtio: Add ecb aes algo support
Message-ID: <20251204064220-mutt-send-email-mst@kernel.org>
References: <20250701030842.1136519-1-maobibo@loongson.cn=20251204112227.2659404-1-maobibo@loongson.cn>
 <20251204112612.2659650-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204112612.2659650-1-maobibo@loongson.cn>

On Thu, Dec 04, 2025 at 07:26:11PM +0800, Bibo Mao wrote:
> ECB AES also is added here, its ivsize is zero and name is different
> compared with CBC AES algo.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>

you did not post the cover letter, so the mail thread is malformed.

> ---
>  .../virtio/virtio_crypto_skcipher_algs.c      | 74 +++++++++++++------
>  1 file changed, 50 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> index b4b79121c37c..9b4ba6a6b9cf 100644
> --- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
> @@ -559,31 +559,57 @@ static void virtio_crypto_skcipher_finalize_req(
>  					   req, err);
>  }
>  
> -static struct virtio_crypto_algo virtio_crypto_algs[] = { {
> -	.algonum = VIRTIO_CRYPTO_CIPHER_AES_CBC,
> -	.service = VIRTIO_CRYPTO_SERVICE_CIPHER,
> -	.algo.base = {
> -		.base.cra_name		= "cbc(aes)",
> -		.base.cra_driver_name	= "virtio_crypto_aes_cbc",
> -		.base.cra_priority	= 150,
> -		.base.cra_flags		= CRYPTO_ALG_ASYNC |
> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
> -		.base.cra_blocksize	= AES_BLOCK_SIZE,
> -		.base.cra_ctxsize	= sizeof(struct virtio_crypto_skcipher_ctx),
> -		.base.cra_module	= THIS_MODULE,
> -		.init			= virtio_crypto_skcipher_init,
> -		.exit			= virtio_crypto_skcipher_exit,
> -		.setkey			= virtio_crypto_skcipher_setkey,
> -		.decrypt		= virtio_crypto_skcipher_decrypt,
> -		.encrypt		= virtio_crypto_skcipher_encrypt,
> -		.min_keysize		= AES_MIN_KEY_SIZE,
> -		.max_keysize		= AES_MAX_KEY_SIZE,
> -		.ivsize			= AES_BLOCK_SIZE,
> +static struct virtio_crypto_algo virtio_crypto_algs[] = {
> +	{
> +		.algonum = VIRTIO_CRYPTO_CIPHER_AES_CBC,
> +		.service = VIRTIO_CRYPTO_SERVICE_CIPHER,
> +		.algo.base = {
> +			.base.cra_name		= "cbc(aes)",
> +			.base.cra_driver_name	= "virtio_crypto_aes_cbc",
> +			.base.cra_priority	= 150,
> +			.base.cra_flags		= CRYPTO_ALG_ASYNC |
> +				CRYPTO_ALG_ALLOCATES_MEMORY,
> +			.base.cra_blocksize	= AES_BLOCK_SIZE,
> +			.base.cra_ctxsize	= sizeof(struct virtio_crypto_skcipher_ctx),
> +			.base.cra_module	= THIS_MODULE,
> +			.init			= virtio_crypto_skcipher_init,
> +			.exit			= virtio_crypto_skcipher_exit,
> +			.setkey			= virtio_crypto_skcipher_setkey,
> +			.decrypt		= virtio_crypto_skcipher_decrypt,
> +			.encrypt		= virtio_crypto_skcipher_encrypt,
> +			.min_keysize		= AES_MIN_KEY_SIZE,
> +			.max_keysize		= AES_MAX_KEY_SIZE,
> +			.ivsize			= AES_BLOCK_SIZE,
> +		},
> +		.algo.op = {
> +			.do_one_request = virtio_crypto_skcipher_crypt_req,
> +		},
>  	},
> -	.algo.op = {
> -		.do_one_request = virtio_crypto_skcipher_crypt_req,
> -	},
> -} };
> +	{
> +		.algonum = VIRTIO_CRYPTO_CIPHER_AES_ECB,
> +		.service = VIRTIO_CRYPTO_SERVICE_CIPHER,
> +		.algo.base = {
> +			.base.cra_name		= "ecb(aes)",
> +			.base.cra_driver_name	= "virtio_crypto_aes_ecb",
> +			.base.cra_priority	= 150,
> +			.base.cra_flags		= CRYPTO_ALG_ASYNC |
> +				CRYPTO_ALG_ALLOCATES_MEMORY,
> +			.base.cra_blocksize	= AES_BLOCK_SIZE,
> +			.base.cra_ctxsize	= sizeof(struct virtio_crypto_skcipher_ctx),
> +			.base.cra_module	= THIS_MODULE,
> +			.init			= virtio_crypto_skcipher_init,
> +			.exit			= virtio_crypto_skcipher_exit,
> +			.setkey			= virtio_crypto_skcipher_setkey,
> +			.decrypt		= virtio_crypto_skcipher_decrypt,
> +			.encrypt		= virtio_crypto_skcipher_encrypt,
> +			.min_keysize		= AES_MIN_KEY_SIZE,
> +			.max_keysize		= AES_MAX_KEY_SIZE,
> +		},
> +		.algo.op = {
> +			.do_one_request = virtio_crypto_skcipher_crypt_req,
> +		},
> +	}
> +};
>  
>  int virtio_crypto_skcipher_algs_register(struct virtio_crypto *vcrypto)
>  {
> -- 
> 2.39.3

