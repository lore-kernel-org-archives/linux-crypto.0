Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4747539AF0
	for <linux-crypto@vger.kernel.org>; Wed, 31 Jan 2024 22:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706740621; cv=none; b=oD1IztUWFnHzeT15egis+bS5ZpvGN7xalLBZ/wth33Ru0h8SZIeg7F59ZKjFkZLbDdWOpcdZ1liqI+/8HVUuPM/N3v6iHxAfc0xvHvw18SC0t9JNVppMasMxIOhmy9ssf6n01dK5qNA6VCl/QVsfS3v9OLv1zQwKBwn8BXEs2HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706740621; c=relaxed/simple;
	bh=Iu+8D8k16qGF05cFe22hv0MQBwz9+bj5LdTjBKDOWeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XrJCN7Eq1MLOVotvvKzzeoaiJhNft1+f8qx+x9D4PKi0sVKdBdrr6lV48cih1PCQCqnOMjnRx1Bz8M8h4FrlEXjYV+eZFwQSbAG23gIZ8wCt0k9yeYyFQ9FD1ZO8kMhA/PqpQ1ettoW3pG7Wq7hgAPoUFkP8l3Gmq069ajt6Uxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pp/t1pJe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pp/t1pJe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706740618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pCoZH7HUiSU0yflw5IfG5DX6qgN8kXKIe4+R5MH+S1U=;
	b=Pp/t1pJe9FkBKxQawWmrE41nXMZG3iXS7rjSYNsC9ZgSdN0u/YJqSKUhL3fnYTkdC+JGNZ
	qJVQbNgVw/ug+VUxAJBPhPSCeNO50GZBNuyQlT1/7Czh0rvBX5v8kdcJwoyZJ6NHKExWM/
	qyFX6oaPLHJFewzKlyYMZI7NBR9VpZ4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-2cMT88fBM-aj09Y4ByT62Q-1; Wed, 31 Jan 2024 17:36:56 -0500
X-MC-Unique: 2cMT88fBM-aj09Y4ByT62Q-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5110bf1635eso176136e87.0
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jan 2024 14:36:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706740615; x=1707345415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pCoZH7HUiSU0yflw5IfG5DX6qgN8kXKIe4+R5MH+S1U=;
        b=ksvAD+32ZaHRHH8cXaE23LcPr3YIbeGJoTgDXRRN2Zgf1gUAMwflJNWqdAR1X3/64Q
         tCxNxLYvkkESFyjI2PU+gV67EcxY/scxIlJyoRY27eHJZsn+jqorZwaxdagEKCVQ7pMp
         2+ZvTVeOIyRjNcGZ6IWFTi5BF0QvufjvnEyM8ezfkIsh7cb/Xmn0Hk08BEHBHcady+TD
         TH/4cBDOgZsmTBP2jNJWdhzL0nL1/hTjgsUU8RCmZ96m7iT/pG3TPyDPNlJL3IzumLFM
         L6/C7FgPMT9ANXxcKG5mK6tWqy8e/UKW9+lFHve1CXHwWPUyoEhO4HCwvJXMagTAX4QU
         m+0w==
X-Gm-Message-State: AOJu0Yz/91mkANodIpaepWfLptBKZakbKqiWbHTyvMLy0P8mSFsT/wem
	RNjyoMOulpEC1EtbF4/NDBRdLOn4UC5JI/7k4+FD5rbjZFh6E76frRNFONz37Sq44SGCp7RntsJ
	weoW5yBKsM32wO30I6XIpniVtdgeAyNuONILeh4lD2awspWs0SknXJkTpywjK1g==
X-Received: by 2002:a19:4f42:0:b0:510:11f4:6741 with SMTP id a2-20020a194f42000000b0051011f46741mr368286lfk.17.1706740615141;
        Wed, 31 Jan 2024 14:36:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFdYe2Nb5HfdKCFeTwFRTgm6BrtfqRQRuKBw02G2lHJDzsRV/wKxyLsFBX60j2fd+FOCZ/FZQ==
X-Received: by 2002:a19:4f42:0:b0:510:11f4:6741 with SMTP id a2-20020a194f42000000b0051011f46741mr368273lfk.17.1706740614525;
        Wed, 31 Jan 2024 14:36:54 -0800 (PST)
Received: from redhat.com ([2a02:14f:177:15f2:27d8:8291:1cb6:8df6])
        by smtp.gmail.com with ESMTPSA id fx20-20020a170906b75400b00a34b15c5cedsm6703708ejb.170.2024.01.31.14.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 14:36:53 -0800 (PST)
Date: Wed, 31 Jan 2024 17:36:45 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: zhenwei pi <pizhenwei@bytedance.com>
Cc: arei.gonglei@huawei.com, jasowang@redhat.com,
	herbert@gondor.apana.org.au, xuanzhuo@linux.alibaba.com,
	virtualization@lists.linux.dev, nathan@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
Subject: Re: [PATCH] crypto: virtio/akcipher - Fix stack overflow on memcpy
Message-ID: <20240131173615-mutt-send-email-mst@kernel.org>
References: <20240130112740.882183-1-pizhenwei@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130112740.882183-1-pizhenwei@bytedance.com>

On Tue, Jan 30, 2024 at 07:27:40PM +0800, zhenwei pi wrote:
> sizeof(struct virtio_crypto_akcipher_session_para) is less than
> sizeof(struct virtio_crypto_op_ctrl_req::u), copying more bytes from
> stack variable leads stack overflow. Clang reports this issue by
> commands:
> make -j CC=clang-14 mrproper >/dev/null 2>&1
> make -j O=/tmp/crypto-build CC=clang-14 allmodconfig >/dev/null 2>&1
> make -j O=/tmp/crypto-build W=1 CC=clang-14 drivers/crypto/virtio/
>   virtio_crypto_akcipher_algs.o
> 
> Fixes: 59ca6c93387d ("virtio-crypto: implement RSA algorithm")
> Link: https://lore.kernel.org/all/0a194a79-e3a3-45e7-be98-83abd3e1cb7e@roeck-us.net/
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>

Cc: stable@vger.kernel.org
Acked-by: Michael S. Tsirkin <mst@redhat.com>



> ---
>  drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> index 2621ff8a9376..de53eddf6796 100644
> --- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
> @@ -104,7 +104,8 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
>  }
>  
>  static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher_ctx *ctx,
> -		struct virtio_crypto_ctrl_header *header, void *para,
> +		struct virtio_crypto_ctrl_header *header,
> +		struct virtio_crypto_akcipher_session_para *para,
>  		const uint8_t *key, unsigned int keylen)
>  {
>  	struct scatterlist outhdr_sg, key_sg, inhdr_sg, *sgs[3];
> @@ -128,7 +129,7 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
>  
>  	ctrl = &vc_ctrl_req->ctrl;
>  	memcpy(&ctrl->header, header, sizeof(ctrl->header));
> -	memcpy(&ctrl->u, para, sizeof(ctrl->u));
> +	memcpy(&ctrl->u.akcipher_create_session.para, para, sizeof(*para));
>  	input = &vc_ctrl_req->input;
>  	input->status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
>  
> -- 
> 2.34.1

