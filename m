Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C7476910
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2024 12:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706100077; cv=none; b=CDoLEXkLceD7zSmbU+EMMJpbgT/3+z/R9RI/WAwOKTi/ATKA+wsxnA4s7a2WoHZY2bc6Mq+Ulcswa9x3daQkzQS7BnnOwJg0aWeH6Wxrr54eOFFYqerXV76BnBaWgV4zd+uz0EkS/hrMXuHl39t0a/kcLmB+JUuNTjO3zt8clfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706100077; c=relaxed/simple;
	bh=PVbbIatoT6RIiV5abSmqSSxIjHXSV6lYXkgNUI5+2gg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NHRj+9AmtGQtiFCZAWzDUedRhvdusTxvxNQZnk1GkbwdBSj71ebvifdQosl/grphmFtOAtYiVPwNSZMrIf0sSnkO90k4vdpU42fw5FKQfXEzKGjMn5KJw0YA3gcozrahUC2QjIVt4PTjquJfFmXru4kdfYtcMFHzCMROrpeodTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FoaGqLNe; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FoaGqLNe"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-59969ec581aso2321683eaf.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2024 04:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706100075; x=1706704875; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AnkwrxW5Z4yXDJPF85seO+gGhJZrClAeKefqDE27GA8=;
        b=FoaGqLNe3BtKyBRX0DPtogglYibracChRn7NXRQ/N5GGrdOeYIMHHbtNYT00OkAAS+
         7aMhRFBmYl6L1w7e6pOsLkDm8PNZxUd4rT02EEUbdU05638VNhsJuIiYIyZlHo3H5qZ/
         Bo9jlE4AY8HOaZQBa/NQ6nOXNBjHy1bLkrDuantkB3T48f0z1eOHbwv20IYThoImakj0
         A5uRyWKtBZBkulqkCwiJjmMJFeokb3ADNh6IIOAohb0ZxDeQ3V0gtRomSlsmcKK9P7DM
         3UksFBq9eCWvPMMVFvN1cWPmJZ/CAFaqV5Ng4scJxJsXrnD0XaMavNZNKRMXHczEBXiF
         zM3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706100075; x=1706704875;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AnkwrxW5Z4yXDJPF85seO+gGhJZrClAeKefqDE27GA8=;
        b=BKD9/crOjKsbW7D1xWRFAo7ibLATD57ppogSTFeX0x81arGzM3SIFgkUZFAu+MIV8W
         +PewYYzfYqKeTL0JjrWviBstYQt+F8b++8nJ6bF0GcLf9MMqhOCSTrUA15jiiw7v5MLu
         dp3uDmcbj2W8Wb94c7OEn0mvvswzcd2k9CCN62XZQX7BoU6DhOXOcLyHqwZsIBCzSgGy
         Ktz5nRMzqD3aycEg/UqtHZ17cJ2yRBJDJpRLvFjAqpL405r6Gig7UVb3WOEow2UXGx2A
         C8J2HMbPZF4MSKjsqa4+VYOBA7zeoL90bqeaWNQduuFizD6tC23b/QG5qTid3cMAkf5O
         9YwA==
X-Gm-Message-State: AOJu0YwlLBRtPYC2p3kAWNEWMYctvsI3NuouFfFFsl2jA1Nzcnz4fhZ0
	hP/IQyA72X1ym4harrap0EtsK9yrSMh0bF+QI6lnb/QTacfypskeghKij9YiuRfgXPUVhXLE0UW
	WaGUpzkZOrbdkD/EQUzEHLgTuIgs=
X-Google-Smtp-Source: AGHT+IHg4IGpUO6XoQDqlpM5XvVGIhVLxKeS7j4I6xrHPwtKeYUfNZTpDUhUN4q+4sQkN5vU9g1YLKhr9sun9zL/el0=
X-Received: by 2002:a4a:bd09:0:b0:591:acf8:d08f with SMTP id
 n9-20020a4abd09000000b00591acf8d08fmr1244525oop.11.1706100075456; Wed, 24 Jan
 2024 04:41:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240124121032.8172-1-lirongqing@baidu.com>
In-Reply-To: <20240124121032.8172-1-lirongqing@baidu.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Wed, 24 Jan 2024 07:41:03 -0500
Message-ID: <CAJSP0QUEwd+VbYzwkmo0hZc6FPxv-3MTz0n6t6PCKo3Q-C3_8g@mail.gmail.com>
Subject: Re: [PATCH] virtio_crypto: remove duplicate check if queue is broken
To: Li RongQing <lirongqing@baidu.com>
Cc: mst@redhat.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	arei.gonglei@huawei.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Jan 2024 at 07:27, Li RongQing <lirongqing@baidu.com> wrote:
>
> virtqueue_enable_cb() will call virtqueue_poll() which will check if
> queue is broken at beginning, so remove the virtqueue_is_broken() call
>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/crypto/virtio/virtio_crypto_core.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

>
> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
> index 43a0838..3607b6f 100644
> --- a/drivers/crypto/virtio/virtio_crypto_core.c
> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> @@ -42,8 +42,6 @@ static void virtcrypto_ctrlq_callback(struct virtqueue *vq)
>                         virtio_crypto_ctrlq_callback(vc_ctrl_req);
>                         spin_lock_irqsave(&vcrypto->ctrl_lock, flags);
>                 }
> -               if (unlikely(virtqueue_is_broken(vq)))
> -                       break;
>         } while (!virtqueue_enable_cb(vq));
>         spin_unlock_irqrestore(&vcrypto->ctrl_lock, flags);
>  }
> --
> 2.9.4
>
>
