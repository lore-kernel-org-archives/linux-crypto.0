Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B4AE573
	for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2026 05:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782020005; cv=none; b=YZMyykgYI82SVMu5gQpOWoYYiQ7E0WsEmRxArVYkvaKRHZs5s0g6OP/iIiHMn+vkCs6HcwXmU0Ntel1/Q8CJaD+x88FzGWA6PWiKAyw67PBtVX/aOBivyJMOncc0O5U8e7N42uqsgvjdjqiJrla8Q5Xi4OCJRKM1/AtteFnvgoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782020005; c=relaxed/simple;
	bh=7IXgE6bKdUBoyITIytNaAB4oVQtOuc5MoAabCRbQPA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KN5Fjy1Ugyx9Tsya/ghI6bJ02gNWcmLXFCqTzkiBFcjVg5nEezQ35JLbopthRvuAoKXfq5y3IJFmgZC7/HEnd4kldB+WxTC/S8OVC0jZt+1g/T1XKPZmaSfjILON/uYanYV2psuXr88m4Dgsk3J4jXFyPjSoo2s3pDbrsyFpV1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J0S2ac5S; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FOGxVqlr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J0S2ac5S";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FOGxVqlr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782020003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3KhV9nn6ENAoii49nltbnc+k1VDXTF1dIVeYs6uUbM=;
	b=J0S2ac5Swbwa13RTfmCPGLjODfBRIDA1Um9Jv7kbxxbvg6eyUy5vM5fh1mYhCaxsLF0T+l
	jTtbin+DrXUFXQwtFi5OPrQBjqFHrlIS78J7tBfQH1A3OejqDGbR5NwxpXdfqh6iomNDyV
	A9OrXtFMYS/NJ5DKmX0n+sRT6JzRsLI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-6YDzCLQsM5Wm7_xe3OMJig-1; Sun, 21 Jun 2026 01:33:21 -0400
X-MC-Unique: 6YDzCLQsM5Wm7_xe3OMJig-1
X-Mimecast-MFC-AGG-ID: 6YDzCLQsM5Wm7_xe3OMJig_1782020000
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4619ee2bb93so1995633f8f.1
        for <linux-crypto@vger.kernel.org>; Sat, 20 Jun 2026 22:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1782020000; x=1782624800; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z3KhV9nn6ENAoii49nltbnc+k1VDXTF1dIVeYs6uUbM=;
        b=FOGxVqlrSnbUh0sPCa3VXcjYnVxPEVstwJGgM1pdacQw2mPe5JDZuZCqpXGQJUuQYU
         JyzTJzuUefhW6xgm6svleK4bCApSUDgFlOF9WjszvyzaDBB6ER4lqrYHa0IWMaIP8v0F
         DQYKoRQLNvWSCEU2lfh/Hd4W48bUI1MKK/sfm1m00xiKXcZ7L5UVdXfxer1PFhymiQYw
         7H2ZcTqC5ZyxX8yR0DzFqhqfjSpjaowjmPnFwdMdl7VpfcXyjDTczn0WW7Q+x01SZOrE
         /nVuBcf1q54tLEpDZa1Etl7ZAiDa04GzoMlalqeNazenByF02dsWYdNmwekk9RN4nIC7
         a46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782020000; x=1782624800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z3KhV9nn6ENAoii49nltbnc+k1VDXTF1dIVeYs6uUbM=;
        b=VMn9kB4gGObyixRi4C8QpF5goTbRPYlSS2F9QU7uJV8Z5oviFR0TsMuKRgNWi/co1S
         fa18WIkcjhkmJO4Uwuv/lu38gF/qTXR9PganqzgpF6yXQO8jr2yX1c07GswCoaeZRhcg
         Wwa1YGHnzadz0pulvbx2Mb3w7R53+L9ESq9j9abSJBiOYkrwaeSAjlKqtKP3uWJEcMNR
         88aFPTSiEdLoB3le3zraJVdnI+gG5LufaHpJIgaegmnbvxdEjGRRV6wrM5jPKvuh06+3
         ZcBHe97MaxEfJxqOL7NCDOq1B6IGqt6WkVHDchrESQmAVG2JuhRziztctjjmsy7SVUU3
         So/w==
X-Forwarded-Encrypted: i=1; AHgh+RrR5MCVixvYA9HZ9XX5CoaMSKIXbukkW/1wScsOj6Zv69YyrxJgFINF8pK6e70V3d+PFXMqr7ba4M3dvwc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVQXxE1OAGt3u44FlLYBhfM2HcAkTrJKh6mUivLQULwsAqnnpx
	iTKDMlfz2MdlWBRp+cCa3066Qg+qHVGrvu6F/Q/ucRIstQTP/K0ugNwNgOIbXYMIBCPK5fjSxgZ
	T2Qoa5PkouFO8oaTT/5IBlOTtBfHS+oP8tpsogbZrnC0VHxK/gk0V80aCcdJg+xFntw==
X-Gm-Gg: AfdE7cluS3db99XN9nzxnWrMDL4jgnZReADNVPp4vJpd4B46jLkrF61ZBVXcghY31NQ
	RsRS2KoywZQFHZ6gMo9jRAZGZOwaMygCjOJR2TkPrIGMk3fMJaKFjWOKJ7F3AR14gVClRnLiHee
	EHFw7EtGdpeFT3lBtHtdlZKwuKjDiP9kg/6SI2zRcxvI74xssasdtPhcTS1mGXR+frtOxR+IySR
	6oVRR2h6w1Hac5ajAiVrgKT3ZptHYCp+/iIurOfwJYyeFdEqpZ8pmqzVjGMNvlERwQlhBktf4mM
	SWZhwLSe90Nvi/3NmCzezv5r4hvym2kR7zIXXcTiJsvr4xR1ObzYwj8KkKDepae9vaPfE9peAYt
	a7RCTNkeDD8iaT3QvyY5Bx93afbz3WgaqojFvjdjQBA==
X-Received: by 2002:a05:6000:1844:b0:460:25f3:b25a with SMTP id ffacd0b85a97d-46503176022mr16556262f8f.34.1782019999814;
        Sat, 20 Jun 2026 22:33:19 -0700 (PDT)
X-Received: by 2002:a05:6000:1844:b0:460:25f3:b25a with SMTP id ffacd0b85a97d-46503176022mr16556229f8f.34.1782019999322;
        Sat, 20 Jun 2026 22:33:19 -0700 (PDT)
Received: from redhat.com (bzq-79-177-155-162.red.bezeqint.net. [79.177.155.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4666678828dsm13793325f8f.19.2026.06.20.22.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 22:33:18 -0700 (PDT)
Date: Sun, 21 Jun 2026 01:33:16 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: hexlabsecurity@proton.me
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>, Gonglei <arei.gonglei@huawei.com>,
	virtualization@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: virtio - bound the device-reported akcipher
 result
Message-ID: <20260621013215-mutt-send-email-mst@kernel.org>
References: <20260620-b4-disp-27caeeac-v1-1-956e8f9c4f01@proton.me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260620-b4-disp-27caeeac-v1-1-956e8f9c4f01@proton.me>

On Sat, Jun 20, 2026 at 09:44:21PM -0500, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> length


some kind of corruption here.

> virtio_crypto_dataq_akcipher_callback() sets the result length from the
> device-reported response length without bounding it to the destination
> buffer, which was allocated for the original request length.
> sg_copy_from_buffer() then reads that many bytes from the destination
> buffer; a backend reporting a larger length over-reads adjacent kernel
> heap into the caller's scatterlist (an out-of-bounds read).
> 
> Clamp the reported length to the originally requested destination length.
> A conforming device reports no more than that, so valid results are
> unaffected.
> 
> Fixes: a36bd0ad9fbf ("virtio-crypto: adjust dst_len at ops callback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
>  drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> index d8d452cac391..64ea141f018c 100644
> --- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> @@ -88,7 +88,8 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
>  	}
>  
>  	/* actual length may be less than dst buffer */
> -	akcipher_req->dst_len = len - sizeof(vc_req->status);
> +	akcipher_req->dst_len = min_t(unsigned int, len - sizeof(vc_req->status),
> +				      akcipher_req->dst_len);
>  	sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
>  			    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
>  	virtio_crypto_akcipher_finalize_req(vc_akcipher_req, akcipher_req, error);
> 
> ---
> base-commit: 1a3746ccbb0a97bed3c06ccde6b880013b1dddc1
> change-id: 20260620-b4-disp-27caeeac-5b8b67962fdd
> 
> Best regards,
> -- 
> Bryam Vargas <hexlabsecurity@proton.me>
> 

