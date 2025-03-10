Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE6A1A23BE
	for <linux-crypto@vger.kernel.org>; Mon, 10 Mar 2025 04:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582555; cv=none; b=mFrVJ0fXICgdHdsWLEqavLTNxvK+aQi0C4oXS80fAl9Nozf7EllArB4WKJATUMsfldghjs4ZyH10+fVTNMZz7L0QxWpn7EzlZQSyJwHNHfQIyERhc9CXKD/ES7uvdYnWh2Q8E/1h8bUszJJ6GTjKjVKTL9GfwrjdTwezuobqnYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582555; c=relaxed/simple;
	bh=s8/EMeFEWEYah/ToEcdcQneRc/EsdPCJPwOwk2JfRWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o95SIKUmcz3QcGE0bNBH58d5M2v65p/hdfE7gfMhMjQ+HxrTT/dF40yndc3WQPJVko8las5FupmWrZAwLRRpOxuIAmZrrqI4N3IZZWayAD4vSLkmpIVfCXTO3ej4tT90d4mjCzdaNCdZ0E7owFeKGkITzBWUwgB2YUvgn2NgfPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Txcghfbu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Txcghfbu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741582553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AGNHJW4HHjvj/4hx7d09Bc4jJVzUfVQWIWoaRlJrRIo=;
	b=TxcghfbuUQtUG4gamZLjBFMY+mfm+pclXStjYaxUGUGkWCIxgHP5Jd/4G+PT1mTArAve3d
	FI5NwAI8zgp2v1P91ehfwVqmFYWzR+iXdS3PkyfCJ3W07ZHw4fROmHWp9g296eU+YzBWIX
	CzVE86fc5A7uOqqYtTAC+H5yFh29+wc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-pYHwA1C3Oja6c2ATkSGmIA-1; Mon, 10 Mar 2025 00:55:52 -0400
X-MC-Unique: pYHwA1C3Oja6c2ATkSGmIA-1
X-Mimecast-MFC-AGG-ID: pYHwA1C3Oja6c2ATkSGmIA_1741582551
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2f816a85facso6794026a91.3
        for <linux-crypto@vger.kernel.org>; Sun, 09 Mar 2025 21:55:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582550; x=1742187350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AGNHJW4HHjvj/4hx7d09Bc4jJVzUfVQWIWoaRlJrRIo=;
        b=WmSvOJPjXqj0fSrSyCFuo6ENGOVXRIHSkww5CgVL1IzlzCB61UPoMAx+ylqtTyTXsI
         Cp0ohPyy0g2J0uySRTj3sbBxiOKxWHeMcZE6j5ImogIO0eDOdjj2VFeMaB+eq4W3C/5m
         dis7l8qinSL+6XPpYeuIWCQMxAGURUUKhiYhGL7Cg8MRYkWdBc3Crnnxj/5oGkQoOqqf
         jRUt+RZd1x0H84f3qtoOGivhh4iYrfWB+pGZGB+TxCtImsK8t6S6+ZTBekdAFVAgnm1W
         7aA44na/jcQ3x8wf9u03Kwu70zd2CfA0k5Y54H3kerTvYiwjrSOzvg48jG7PctnCAOmj
         s/uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXA6uVtO4eVsxPTsEROTwaX/5rj1PTwsLNyxGVxhrtawiRZHsEWDBjeGfUXWiYrX/ldSOMNF1308jAPRwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcnqpFEVz6vS7inOeo8zLEf3Cnj5GxnLK4lqZYEeFn5/EMpD5z
	5TxFafXNQDnx2C+qsIBQlOqplW0SIDfZ6hUdCEqD7bwsktOYUiEsPRs4JCaMEltEjLiPl6NaS0S
	8ma7k2yvxs+/iBvEyFSqeT3tAnLnieC+GV7sorn8WBzl79oH1ckpmX99VRitvbbixVy1ZJ5mC8u
	tVa1q80LNTc1Nw05B0yZItIqvl+A0NZNBJHjP2luo3yQVUvAZ6BMgj
X-Gm-Gg: ASbGncvAkuX9/vJMaSMQwtOW/QbR2HhUCnhkVJgn4gOuQyfxfPV+yj0MyscAE5yiwg7
	zwYvSldH8Wy9lrUyzttRLhZJ3heAGUFnHdxh1z+cwNRHxLhjUhMEHtXXHZd6Thpy21EKs//bd3Q
	==
X-Received: by 2002:a17:90b:1dca:b0:2fc:a3b7:108e with SMTP id 98e67ed59e1d1-2ff7ce63264mr18532340a91.4.1741582550420;
        Sun, 09 Mar 2025 21:55:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9Xo0gpzEFD/TRddMKMUNDMbauhJ46adEgdxNBxtmb8EtkPrUSIh1rFd5iEsD5Yp2BE7jzIDOi/82H1hGyNkU=
X-Received: by 2002:a17:90b:1dca:b0:2fc:a3b7:108e with SMTP id
 98e67ed59e1d1-2ff7ce63264mr18532310a91.4.1741582550025; Sun, 09 Mar 2025
 21:55:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a18fc6cf356bc338c69b3cc44d7be8bd35c6d7d0.1741028854.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <a18fc6cf356bc338c69b3cc44d7be8bd35c6d7d0.1741028854.git.christophe.jaillet@wanadoo.fr>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 10 Mar 2025 12:55:38 +0800
X-Gm-Features: AQ5f1JpXzBv8TIF6oxVj41FiZlnmi8yR2xYeZ4UVuxEvdCcbm3NW-Nyvl6onBwo
Message-ID: <CACGkMEtRFtzb-hbt6N8YJo8nfOOvaPcaw4dLkfs5CWN+ypkLeg@mail.gmail.com>
Subject: Re: [PATCH] crypto: virtio - Erase some sensitive memory when it is freed
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Gonglei <arei.gonglei@huawei.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 4, 2025 at 3:08=E2=80=AFAM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> virtcrypto_clear_request() does the same as the code here, but uses
> kfree_sensitive() for one of the free operation.
>
> So, better safe than sorry, use virtcrypto_clear_request() directly to
> save a few lines of code and cleanly free the memory.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> I've no idea if this is needed or not, but it looks not consistent to me.
>
> If safe as-is, maybe the kfree_sensitive() in virtcrypto_clear_request()
> should be removed instead.
> ---
>  drivers/crypto/virtio/virtio_crypto_core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/=
virtio/virtio_crypto_core.c
> index d0278eb568b9..0d522049f595 100644
> --- a/drivers/crypto/virtio/virtio_crypto_core.c
> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> @@ -480,10 +480,8 @@ static void virtcrypto_free_unused_reqs(struct virti=
o_crypto *vcrypto)
>
>         for (i =3D 0; i < vcrypto->max_data_queues; i++) {
>                 vq =3D vcrypto->data_vq[i].vq;
> -               while ((vc_req =3D virtqueue_detach_unused_buf(vq)) !=3D =
NULL) {
> -                       kfree(vc_req->req_data);
> -                       kfree(vc_req->sgs);
> -               }
> +               while ((vc_req =3D virtqueue_detach_unused_buf(vq)) !=3D =
NULL)
> +                       virtcrypto_clear_request(vc_req);
>                 cond_resched();
>         }
>  }
> --
> 2.48.1
>
>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

