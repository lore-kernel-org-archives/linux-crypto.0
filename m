Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986E62D8DA8
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 06:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761113874; cv=none; b=NSacuR+DaQEuxCEF2jc8wId0ed4Dbt8CM7Dz26+wSYrrdn2rRLKzObnrn+2I46pLq/VNy2VutLMwCidUJh0qcY5fSN2YIb/wrLbTBF2IGvjWjRyiKsvG5W2/49hyDeEacUmqOqGexWEh5aDwo8QnNJETTYEp5oZdT+8BQ9RLn0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761113874; c=relaxed/simple;
	bh=tJ2SLhKeJHRkOm7NmqWKDFbTUH8Da+/KF/tTBGd+IRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MNv4UiuHAX7/A9NPj5V9qWOLggk1ptxbe1/1MnKMdQK1/MRxsoF3HQ7WvRV233vUNZckEC0IcwDJzmG55a2t2ja/Z3e+SyDpLHDlRxKUbMGi2nVsoBnearCLSsfaxEgFtas+7lNll0V650ojKZE/uhyVAg2Pd/U5Lld9QgsgqtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=exnnUBj2; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="exnnUBj2"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-36639c30bb7so58739241fa.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Oct 2025 23:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761113870; x=1761718670; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UWnH0z3/I2vnbb5PD9yTp0U3AaENDgRIUOGh+uP8nRQ=;
        b=exnnUBj2xwpbdLT0xd4DCwwnyevoIiZA4+5OIkEshMBGPb6N9jGIypk055LnrFDLs5
         mcZhsqi7bld4M9HjFPRTJaQ7EmkWgPE+ApvW4ZVBudcKdXM9TwTRM5JdP/lzqkkqKnFO
         XhWvUS0FB9fj8WDJ21tG0R0TMWdsVzXquDnXyl3yLonjnz8He3ZExikT5V5edeyY7gws
         NnzBAgMhi2z9DCNGs5ewCh61LHmsMBJNgm25J6HN+vY5WJ8QtcwlnhoS6gqolfMdRKEV
         BZP42oXHO0MWiXF86QLtpGPU9fhUOfxZf+4EAHIq++KcQ+vnOjRU59l3jdVzcUfRwJ6W
         AhaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761113870; x=1761718670;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UWnH0z3/I2vnbb5PD9yTp0U3AaENDgRIUOGh+uP8nRQ=;
        b=G9BXKyog2mudnhRbDF/2GxNeSpZw6/iJ4NMWcby0Pv1WBM6Qg4iYTPPXSm3RK+PY0g
         0BEds+u9im9Q7vVgyvAnWkQwrGDbVeQCKJRifvtJHyta70N/rzK9HkqqXe53CpcHP+2m
         rFxT0bOPIm1RDDu2y4+pccfCzSCl9lqVX94D1JcuGnVBSkLFUHnWK4MbK3S58ton14rE
         K5UIvs+S9oyMBLWtrqa2dOysu9yPmziwEWK1aqTj7pMmBikCnwBbn6ZbwjK+II0tJSV5
         ncSkRxeAT+3olFk4U9lF2K2Qlktf5/EG2wPgQOCZDNARaEFwF6zXs/Udi6oFVES2q1Ej
         tNsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIf9C7TEhWpQhd8aI/RAASgR8B9vQhNNfyvIT7GXs8bsEPsQg0Pm+FukbDoemlMV0XPFGBUWm7VqsVgGo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYlwSpL89NIqLJoj70iudkRM4HLfPO/CzUkuxkGPkW6lmYmx2v
	QPOgUi1aqQedMus/jfTq0V/60TWlXpxi7x+qQDF8gQy498Y4x5ztFO7XZsevrBFoLJTsyj4RACA
	KfbB/m1wQLTO9dt4tczBzHfbcQo4211nHNcOk7dyjUQ==
X-Gm-Gg: ASbGncu/KMSsFRMZZRt3fPMhM8BXGCUqo8YhX9K9CQNkf+6yEhJhz3Fm52BnkgnZXic
	kkDEuzkeu/j3KYWLfgvci3ukiwkN9kmIGcYmJ4GEmapNQpvJEYolwAUaXU2DuxxlhkRjNNoYl/n
	y4oDTsIHB4811dtVJ7m0HBTRkF8+hn29c8Kv12Y4adZ+qNDFR3m3NoBM3q5HkNFFOq/UnpNUMIB
	sYdnt2GB/05pLLVwoKIMxKgyUyezCihdDydHggxeKX1WX2FhhlahkkheDU=
X-Google-Smtp-Source: AGHT+IEOYG8NIPEs5pKzMS9oFvhSSNaRqyK08+8A+zRLCXw0GMyrztPKw+JpYE7Ez8iSMADnEUIr8G8Bnm4c5IDluno=
X-Received: by 2002:a2e:bc87:0:b0:36b:c7d2:3aec with SMTP id
 38308e7fff4ca-37797a3b35bmr64944861fa.31.1761113869658; Tue, 21 Oct 2025
 23:17:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251022021149.1771168-1-huangchenghai2@huawei.com> <20251022021149.1771168-2-huangchenghai2@huawei.com>
In-Reply-To: <20251022021149.1771168-2-huangchenghai2@huawei.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 22 Oct 2025 14:17:38 +0800
X-Gm-Features: AS18NWAFtm0-ZzGTC5xVfvePf8YH974eaCsbWSlfE8Zb9Q6UX9QnJZCOcf1gynk
Message-ID: <CABQgh9HFHSstR19NtOw5c6E+qS7_d_=6qnCYq9VY6DNKT6o3ng@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] uacce: fix for cdev memory leak
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: gregkh@linuxfoundation.org, wangzhou1@hisilicon.com, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	fanghao11@huawei.com, shenyang39@huawei.com, liulongfang@huawei.com, 
	qianweili@huawei.com, linwenkai6@hisilicon.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Oct 2025 at 10:12, Chenghai Huang <huangchenghai2@huawei.com> wrote:
>
> From: Wenkai Lin <linwenkai6@hisilicon.com>
>
> In uacce_register(), if cdev_device_add() fails, we should properly
> decrease the reference count of the cdev kobject and set uacce->cdev
> to NULL to avoid potential use-after-free or double free issues.
>
> This change adds proper error handling after cdev_device_add() fails,
> ensuring that kobject_put() is called and uacce->cdev is cleared.
>
> Fixes: 015d239ac014 ("uacce: add uacce driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/misc/uacce/uacce.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> index 42e7d2a2a90c..9b82a6731832 100644
> --- a/drivers/misc/uacce/uacce.c
> +++ b/drivers/misc/uacce/uacce.c
> @@ -519,6 +519,8 @@ EXPORT_SYMBOL_GPL(uacce_alloc);
>   */
>  int uacce_register(struct uacce_device *uacce)
>  {
> +       int ret;
> +
>         if (!uacce)
>                 return -ENODEV;
>
> @@ -529,7 +531,14 @@ int uacce_register(struct uacce_device *uacce)
>         uacce->cdev->ops = &uacce_fops;
>         uacce->cdev->owner = THIS_MODULE;
>
> -       return cdev_device_add(uacce->cdev, &uacce->dev);
> +       ret = cdev_device_add(uacce->cdev, &uacce->dev);
> +       if (ret) {
> +               kobject_put(&uacce->cdev->kobj);

Not understanding this,
What if kobject_put(&p->kobj) is called twice?
cdev_device_add would call cdev_del->kobject_put(&p->kobj) as well.

If you think cdev_device_add has an issue, maybe fixing
cdev_device_add itself is better?

Thanks
