Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A98157493
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 02:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741053621; cv=none; b=UeqNmBvfAUAKiwqTdnMDYaJN/H9xQrxAyZFMFU+jJMRuho/1TcL3rS1A9VGllTPSQNbotN2Ai1XJ+EswUvfN6dPun72akCh4L8uuviiYnz9Us4eYV/Q5dejpzZye1k2fThVcut8JJt8VWD2aPzB6oJ5HzaSw9TGgjqX4y7tJ9is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741053621; c=relaxed/simple;
	bh=JHk4X3vZ8MFvsUzR7DvpEVGisQVp8HYBRZBRGMOySDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PuGnsWe4jMKwZOFSsKPP4VFxfPWwtRIZjibala+ffZ5h9b/01RWDtVsMwsIGdIUUXdSkObPRop+7TqnWIH2NJNXlVq8spW06oy6v7xrciWDkvoenMFugL/BLPpRUxnhQLKPMJb39zEgAZL4fKz82zrJ853crG03uzSaRLRiRhyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XcxxmSdh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XcxxmSdh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741053618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m6ne55QwhftFYTm3pAMElTqpEZ/LORaNN0Mq/z5tJ9c=;
	b=XcxxmSdhYA+QsDzP8BKPqM+WnyNGQTSnQJvZ10UjR9X/3AAHuTBbnLsv7+VcHmhPPWp1gZ
	2bii9VAs6d9u41lsRHqglYvB72kTPm9haJ/IUagA7N16oaNW0SaI8vkga0nTvXvkr226mY
	DMZFdmJlM4SdTwK7bX5Wd9mA3YVH1jQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-hVR7aVIoNcOhDcpB2Nxxfw-1; Mon, 03 Mar 2025 21:00:11 -0500
X-MC-Unique: hVR7aVIoNcOhDcpB2Nxxfw-1
X-Mimecast-MFC-AGG-ID: hVR7aVIoNcOhDcpB2Nxxfw_1741053611
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5e4b3da6b49so4452552a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 03 Mar 2025 18:00:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741053610; x=1741658410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m6ne55QwhftFYTm3pAMElTqpEZ/LORaNN0Mq/z5tJ9c=;
        b=DMLcX1ib4oDc7V1CUqpKjzQW44CoE8OS6m2JPJx0SDIHX7a2N5Gv8L731EYuzvGT2b
         t0dtGfD440bc5/gLtdWGBugo0QJXzNUb49PJryz5bl7PBJryVmLeZ4l758NpB3UYRy2z
         iQXk3dxLGVPR+lxkwDlvzdTrQf9LfXnpwMXixSgbseeE4RoRUQ/4Qnu9nGt9DvaaL5aP
         e+RLZULKeJVzN26CsXGs/0rrozEer9bYFBh0kDjFVBGwfKkIdyi16YRQ5n7zb6Ott9xe
         2eJCR4ZAnEtcYyQZoGQY+SjqZPSdFPwl1oleFRoSmxyWAqxFH+zt5FZzQV5suy+es3zb
         HVpg==
X-Forwarded-Encrypted: i=1; AJvYcCVvgRLGo4xgRMZ05+42tskQ6qIUEe1WzbrtdbDk2+9pg1s5htrh3dAwYiw19w9VP6DMjurOlGz6I/JYxvg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwimyhRLXoyaqZ0EvGlOb4SYV3YWloNOTspPbsSU4QPnROP/obG
	k9USUM4sGVg+hT/97f68GLzUHXsRSsTi2yRUm8S/Uq54L6+JIC4K8kK8ClYHA+xIqsfl8SQR/5v
	SJQ8gUoKao05LX1XJZd0TxcHPlYxCijd4vuf7pbiQvyVV5LPbdByIFR5yRzFlqyZbIJoUYcB3Rr
	R9U3/rT53HSn+Ek+0S58suK87WoxSzBkm4ToU9
X-Gm-Gg: ASbGncvGb/fCKPino1u04l/5ceURY//tqiZEP1uF8XohwABUxIsM9E8NIa03ejFwVPH
	Y2sfa9g+fMsZdeK2KxoAmXeX2FBjIr6zbcaJA/9ePgrbLqFV4vNCoJ7DUaRw+rNLFlqE5yu+Qeg
	==
X-Received: by 2002:a05:6402:2714:b0:5e0:922e:527a with SMTP id 4fb4d7f45d1cf-5e4d6908f02mr43147290a12.0.1741053610610;
        Mon, 03 Mar 2025 18:00:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGotofsTvb2AxtGxiUYRTOJP55UijhwSHRdhPuwJsFglP+Wr3zMaapIUvoTk6CdgEnWdU6MOBQ50VkHbyyuLfo=
X-Received: by 2002:a05:6402:2714:b0:5e0:922e:527a with SMTP id
 4fb4d7f45d1cf-5e4d6908f02mr43147246a12.0.1741053610281; Mon, 03 Mar 2025
 18:00:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a18fc6cf356bc338c69b3cc44d7be8bd35c6d7d0.1741028854.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <a18fc6cf356bc338c69b3cc44d7be8bd35c6d7d0.1741028854.git.christophe.jaillet@wanadoo.fr>
From: Lei Yang <leiyang@redhat.com>
Date: Tue, 4 Mar 2025 09:59:33 +0800
X-Gm-Features: AQ5f1Jqo2O4hK3oJkjenR9LxQveC5GRpuyXs2Lm3CfD0L_mhdi24D2upTktGsNA
Message-ID: <CAPpAL=wW6szqfPm8goUfM=c2cat9-tyuB-UgwRdtx7s23xe81g@mail.gmail.com>
Subject: Re: [PATCH] crypto: virtio - Erase some sensitive memory when it is freed
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Gonglei <arei.gonglei@huawei.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

QE tested this patch with virtio-net regression tests, everything works fin=
e.

Tested-by: Lei Yang <leiyang@redhat.com>

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

