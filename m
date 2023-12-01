Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gtOBrj03"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7B710F9
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 06:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701442283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F6+fTNyVfQbvpv0mXBsvFlerCoSqluEuKgG50iz8c2Q=;
	b=gtOBrj030a1bxEoGeAchjZY27qCQK/ybYlFg4niH4lNwrYB17XEuu4UgxXA4LEAxC2cIqj
	XX2fGP2pi9Eduhj8F+817l4hxNspdOHrlOpWPhrI8cAW3J427BJ3DX0rRcDHsJQZYBiK5q
	vn1DN9EloXkJEtivEiEiY5Q4moU1nUI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-lfeP_kguMjOsYrL3ybk-dA-1; Fri, 01 Dec 2023 09:51:22 -0500
X-MC-Unique: lfeP_kguMjOsYrL3ybk-dA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40b4c9c3cffso14972875e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 01 Dec 2023 06:51:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701442281; x=1702047081;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6+fTNyVfQbvpv0mXBsvFlerCoSqluEuKgG50iz8c2Q=;
        b=BlzD8gRPw9JoCN0JFwuhs3UnO0rg+EV2pPbBAqvUr1cKY39ytSBfwNNiL7RqpzbJvk
         HcD4SnMvybXFIA0VUbfpK9RuaStfpMfAIvSIRGph7NVBx+qFdvq+80jVFzZtsfJLlSua
         5xUKm690CyIhfPTv2aLGQ4xjuJPjXNzV99byYdkKk0riZNrXu5RT3HtMzPbZpsQ9wfvx
         RfJyUyQt39KwExpb12EJFOcB4RqtDVklC8lTbKmFchEFdttHSxEWFL6s2BfJxGTDwgxT
         W/LkGHzFAXpR11NwAoFsbQ5o3OD63Tnqg61f5BEnucu6WfOucw38+oW4pQKVk38HU45h
         OBAg==
X-Gm-Message-State: AOJu0YxyV3oEUmemsTIuIVSUEqIPGp+ltc7kb/6mlHLomRnGuWKXYTd5
	YjWb4ZSPhpWLAXrOgw5We8yjH0qnFUg4EfzsB4PE17bHn8wpXJ2CmNag08GpPs75KkYYijF7wFc
	jokcwDtbndb+Zc8bPwcaWGiGw
X-Received: by 2002:a05:600c:20cb:b0:40b:5e59:f747 with SMTP id y11-20020a05600c20cb00b0040b5e59f747mr254909wmm.185.1701442281100;
        Fri, 01 Dec 2023 06:51:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHncDO0+zubuDh1bCnaDyIbO8GXaUPF25vZ6m/789yYxQkh40rx+2WA/B7iuPeVv2rjMudyJw==
X-Received: by 2002:a05:600c:20cb:b0:40b:5e59:f747 with SMTP id y11-20020a05600c20cb00b0040b5e59f747mr254905wmm.185.1701442280788;
        Fri, 01 Dec 2023 06:51:20 -0800 (PST)
Received: from redhat.com ([2a06:c701:73e1:6f00:c7ce:b553:4096:d504])
        by smtp.gmail.com with ESMTPSA id fs20-20020a05600c3f9400b0040b5517ae31sm8521738wmb.6.2023.12.01.06.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 06:51:19 -0800 (PST)
Date: Fri, 1 Dec 2023 09:51:17 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Halil Pasic <pasic@linux.ibm.com>, Jason Wang <jasowang@redhat.com>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	wangyangxin <wangyangxin1@huawei.com>
Subject: Re: [PATCH] crypto: virtio-crypto: Handle dataq logic  with tasklet
Message-ID: <20231201095024-mutt-send-email-mst@kernel.org>
References: <b2fe5c6a60984a9e91bd9dea419c5154@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2fe5c6a60984a9e91bd9dea419c5154@huawei.com>

On Mon, Nov 20, 2023 at 11:49:45AM +0000, Gonglei (Arei) wrote:
> Doing ipsec produces a spinlock recursion warning.
> This is due to crypto_finalize_request() being called in the upper half.
> Move virtual data queue processing of virtio-crypto driver to tasklet.
> 
> Fixes: dbaf0624ffa57 ("crypto: add virtio-crypto driver")
> Reported-by: Halil Pasic <pasic@linux.ibm.com>
> Signed-off-by: wangyangxin <wangyangxin1@huawei.com>
> Signed-off-by: Gonglei <arei.gonglei@huawei.com>
> ---
>  drivers/crypto/virtio/virtio_crypto_common.h |  2 ++
>  drivers/crypto/virtio/virtio_crypto_core.c   | 23 +++++++++++++----------
>  2 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
> index 59a4c02..5c17c6e 100644
> --- a/drivers/crypto/virtio/virtio_crypto_common.h
> +++ b/drivers/crypto/virtio/virtio_crypto_common.h
> @@ -10,6 +10,7 @@
>  #include <linux/virtio.h>
>  #include <linux/crypto.h>
>  #include <linux/spinlock.h>
> +#include <linux/interrupt.h>
>  #include <crypto/aead.h>
>  #include <crypto/aes.h>
>  #include <crypto/engine.h>
> @@ -28,6 +29,7 @@ struct data_queue {
>  	char name[32];
>  
>  	struct crypto_engine *engine;
> +	struct tasklet_struct done_task;
>  };
>  
>  struct virtio_crypto {
> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
> index 1198bd3..e747f4f 100644
> --- a/drivers/crypto/virtio/virtio_crypto_core.c
> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> @@ -72,27 +72,28 @@ int virtio_crypto_ctrl_vq_request(struct virtio_crypto *vcrypto, struct scatterl
>  	return 0;
>  }
>  
> -static void virtcrypto_dataq_callback(struct virtqueue *vq)
> +static void virtcrypto_done_task(unsigned long data)
>  {
> -	struct virtio_crypto *vcrypto = vq->vdev->priv;
> +	struct data_queue *data_vq = (struct data_queue *)data;
> +	struct virtqueue *vq = data_vq->vq;
>  	struct virtio_crypto_request *vc_req;
> -	unsigned long flags;
>  	unsigned int len;
> -	unsigned int qid = vq->index;
>  
> -	spin_lock_irqsave(&vcrypto->data_vq[qid].lock, flags);
>  	do {
>  		virtqueue_disable_cb(vq);
>  		while ((vc_req = virtqueue_get_buf(vq, &len)) != NULL) {
> -			spin_unlock_irqrestore(
> -				&vcrypto->data_vq[qid].lock, flags);
>  			if (vc_req->alg_cb)
>  				vc_req->alg_cb(vc_req, len);
> -			spin_lock_irqsave(
> -				&vcrypto->data_vq[qid].lock, flags);
>  		}
>  	} while (!virtqueue_enable_cb(vq));
> -	spin_unlock_irqrestore(&vcrypto->data_vq[qid].lock, flags);
> +}
> +
> +static void virtcrypto_dataq_callback(struct virtqueue *vq)
> +{
> +	struct virtio_crypto *vcrypto = vq->vdev->priv;
> +	struct data_queue *dq = &vcrypto->data_vq[vq->index];
> +
> +	tasklet_schedule(&dq->done_task);
>  }
>

Don't we then need to wait for tasklet to complete on
device remove?

  
>  static int virtcrypto_find_vqs(struct virtio_crypto *vi)
> @@ -150,6 +151,8 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
>  			ret = -ENOMEM;
>  			goto err_engine;
>  		}
> +		tasklet_init(&vi->data_vq[i].done_task, virtcrypto_done_task,
> +				(unsigned long)&vi->data_vq[i]);
>  	}
>  
>  	kfree(names);
> -- 
> 1.8.3.1
> 
> 

