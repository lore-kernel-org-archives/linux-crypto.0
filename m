Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22D020C48A
	for <linux-crypto@vger.kernel.org>; Fri,  5 Dec 2025 01:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764897723; cv=none; b=TVCVcUdPmC0cNmrPhyUFuli+VbI1fmpF/7Fw510atAyQAriLKj07pLHI1fBpXxScSSghkTwXXJtBN5Aq4Ra0eBCek/dDGVjX0LqTcuPb0ZmXBfEHN91JfiSUB76fUDEy/ErZ30Kdjr5UD0ybCr6ZHG5j2CoGSoBpFSfr7WB0H1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764897723; c=relaxed/simple;
	bh=moXJy1ndyc8YAWeLaKyiIjfpRubjyBmv4THSzKELYCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EJKmCrUYWCem8cMEhzc0i5yWqx0Y8692kFIguYkZ7s2U/bxNyc9Iyz2Jb5i7aWVtjzJ2Zu5Sj2AIGIJPudHyByk84o/BrX/v72eerIgR9+5Dn5ymEG1e5zERJE2YxYjqK3+EobjvFgxP2tZCUOT1tbhnqxQ/My83QWfbhPQn+BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K/CnCv5P; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=n6AmSGfH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K/CnCv5P";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="n6AmSGfH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764897720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fYiaCMznb7Jh7gyLxXu/TY8tpQriPJlFFUBGVN8VVpM=;
	b=K/CnCv5PawEizp8pcLnKKWkpk2vwCofq0uKzKaYSg9QUV7VP51CMhQK6LVD7MQcQIQq/Zw
	x5GTAdH55R8mnIjreNjcKDQOpyw0Nw8a6pma4KNivfoyXfscIJd/pbxwIWnGi0Pxc4pTQg
	0gXl8KKsTPJTou0Ed1U5COs2KXDOF38=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-VnN48ZoUPUmJrY14Bhz7Pg-1; Thu, 04 Dec 2025 20:21:59 -0500
X-MC-Unique: VnN48ZoUPUmJrY14Bhz7Pg-1
X-Mimecast-MFC-AGG-ID: VnN48ZoUPUmJrY14Bhz7Pg_1764897718
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-297dfae179bso31807755ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 17:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764897718; x=1765502518; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fYiaCMznb7Jh7gyLxXu/TY8tpQriPJlFFUBGVN8VVpM=;
        b=n6AmSGfH1xKuImCVj5KzJQS2/3REaUQCEnh3ghMHUUOSD+1OJo3HTDzNsLvXSl9Xep
         39Fdbvh8rsGPoMxLVsI6SzB6fwHBXuJdCVuuY3V5zDlzy9fUhtD6VNyp2QFQc2RfAiv+
         CXhxCCVNXEQH+RQwt5seYyLFdHkY7TSD4ZgCdIfsr2kffbZkDCe8XpfUBtP/ER3l/WuG
         czIoBuqedW0H4EMHBLAAlO6BXfLFuYlbIyRNhMwNeZT/ZxzoPSgpUOogBRlytF7rdYjU
         1WN7Qw6Nx2l8fOu9wiqytAh0TSu5ffZZf+OfEgF5ewOcvqDhot6OK2kKGMj8DaVzAH/P
         Zjog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764897718; x=1765502518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fYiaCMznb7Jh7gyLxXu/TY8tpQriPJlFFUBGVN8VVpM=;
        b=XlRQ51xCulmu7SiLtLO+EngpbORQNw2S6n910Dji4w+S1KeP3oWscA/2DuiA0rZoUd
         LdSNwbqvq1Iiws8XL+xOtnNS5lKo7MCZ/G132lPBX3thnebV9Xw1PIfjVsXcJaVFuGkI
         FrWHM4HUlKSNFjJmjhUUgmXskpfi4hFrSwuuUcmwo9HNLdBjY0/9S4fGEJeTiPkMb8pN
         ENVJtSI/K/N6tcVRc792ahcGi6fVUPzqoyoIMOrTkFxA0SZZdlsGXDPnm8/OuM6GSfxt
         JST3d5GJBgEE489z5qdq18/vGYRes2/GKimh2YBLPpIc8zAQLJu7xs1BeVvSxR5ttMHG
         xn0w==
X-Forwarded-Encrypted: i=1; AJvYcCWMfd8V/cRqxbIrXb4AuIyes1MpkDyT/YMqF1c6tbLNNY1d1k8n1f5YxoOa+XYJz0aIc772sF0yPcCnB4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIGeWoh6l1TALLJ0aIDaI+97Aqs6Ib+v4HM8k8/Qq2DgtsPApi
	97p755yFwyBIljVxZg37DjjtEJW60NAg/zXOwHoAa+AmcQpVH3GWETpuxq/sKKbTzqd2Pp3nfdh
	ON0xgqAoWyt32mftBCTSgi/FUHJneW3vR/lxwCVEm3IlC8Th76pCOK5K+GD77EyJ13t/ghHncjK
	/sy6WLbjLkf/sd6Ih9xh3lFib26fe1K03eDx3sUldH
X-Gm-Gg: ASbGncuvAJxLC444xz16pe5eiQAEBtctpQQs1NFVbVRCUoFeIkXjuluy56ZvDonwfDx
	f01lC8n49bEJZxmCxuTzRqQFs3PlU/z/R4N9g5rbwkIhFW6c4YmVrAhQMj0ZtBJgNwo4OMRDvkw
	QMbYTUQJT2Sa27+1b/gEApDzpz8wIEmVTu//P2jZegdV0rMmXMLfrlKMVhxz14vnHN1g==
X-Received: by 2002:a17:903:1a90:b0:295:7b89:cb8f with SMTP id d9443c01a7336-29d681c5ff8mr95179495ad.0.1764897718165;
        Thu, 04 Dec 2025 17:21:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGEz6UQheUOskXAPVFiyJ31BXhLmKjKvRKhbFz9taEXKwU/ReS1/visXCISoRNqAu5RAwOmGVEMng+JiImGULU=
X-Received: by 2002:a17:903:1a90:b0:295:7b89:cb8f with SMTP id
 d9443c01a7336-29d681c5ff8mr95179235ad.0.1764897717759; Thu, 04 Dec 2025
 17:21:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204112227.2659404-1-maobibo@loongson.cn> <20251204112227.2659404-2-maobibo@loongson.cn>
In-Reply-To: <20251204112227.2659404-2-maobibo@loongson.cn>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 5 Dec 2025 09:21:45 +0800
X-Gm-Features: AWmQ_bkFuyGkNmhfuUOM0G1Rk65Kgzdae-EzAbpNlnvQLHxjomxthjfe9VjMPoo
Message-ID: <CACGkMEsjhw2=XCFH6qoYu60NjTf-DJ-oaB89qjaeWpsk+5t6JQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] crypto: virtio: Add spinlock protection with
 virtqueue notification
To: Bibo Mao <maobibo@loongson.cn>
Cc: Gonglei <arei.gonglei@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	wangyangxin <wangyangxin1@huawei.com>, stable@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 7:22=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrote=
:
>
> When VM boots with one virtio-crypto PCI device and builtin backend,
> run openssl benchmark command with multiple processes, such as
>   openssl speed -evp aes-128-cbc -engine afalg  -seconds 10 -multi 32
>
> openssl processes will hangup and there is error reported like this:
>  virtio_crypto virtio0: dataq.0:id 3 is not a head!
>
> It seems that the data virtqueue need protection when it is handled
> for virtio done notification. If the spinlock protection is added
> in virtcrypto_done_task(), openssl benchmark with multiple processes
> works well.
>
> Fixes: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  drivers/crypto/virtio/virtio_crypto_core.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/=
virtio/virtio_crypto_core.c
> index 3d241446099c..ccc6b5c1b24b 100644
> --- a/drivers/crypto/virtio/virtio_crypto_core.c
> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> @@ -75,15 +75,20 @@ static void virtcrypto_done_task(unsigned long data)
>         struct data_queue *data_vq =3D (struct data_queue *)data;
>         struct virtqueue *vq =3D data_vq->vq;
>         struct virtio_crypto_request *vc_req;
> +       unsigned long flags;
>         unsigned int len;
>
> +       spin_lock_irqsave(&data_vq->lock, flags);
>         do {
>                 virtqueue_disable_cb(vq);
>                 while ((vc_req =3D virtqueue_get_buf(vq, &len)) !=3D NULL=
) {
> +                       spin_unlock_irqrestore(&data_vq->lock, flags);
>                         if (vc_req->alg_cb)
>                                 vc_req->alg_cb(vc_req, len);
> +                       spin_lock_irqsave(&data_vq->lock, flags);
>                 }
>         } while (!virtqueue_enable_cb(vq));
> +       spin_unlock_irqrestore(&data_vq->lock, flags);
>  }

Another thing that needs to care:

There seems to be a redundant virtqueue_kick() in
virtio_crypto_skcipher_crypt_req() which is out of the protection of
the spinlock.

I think we can simply remote that?

Thanks

>
>  static void virtcrypto_dataq_callback(struct virtqueue *vq)
> --
> 2.39.3
>

