Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DA12727E6
	for <linux-crypto@vger.kernel.org>; Wed, 12 Nov 2025 09:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762940779; cv=none; b=QOUNa0sgICLD9tMr6BVr+igCR8sFKcfrpTtCmPlPqL+jJy7LzTa6KcOvz6WDOy8AUHa2t5Hi7EWVr2U4RG/uu9ba7DzxrpKMV6bT2GpPLlp1coXf/HMfGlmILnq+8uKP7wC63gbZJ4JYlwxvl+Gu6N2LHvcH2Xxx/cGG6sp4tNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762940779; c=relaxed/simple;
	bh=8vIallErldatIIpknUDD1YI8XXkWsYygZikQLjNWeao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NJHIL8x9eqMVhjF8lEXIgRitl2TKvww9gp3ZpWacMUNR77bnIiVE9VNAs8CXKJ7n1xr1WQN0FAJT6IOZTOWh0XmNh/G90+Tzx2nfU6UD2MKR7j5IETRoOAkrj+250JfMjXDOeo+bZVdyo5kpyqfYLzxER1iW/wmKomcPC8F/TOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JefUen9Q; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JefUen9Q"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5942ee7bc9dso621027e87.2
        for <linux-crypto@vger.kernel.org>; Wed, 12 Nov 2025 01:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762940776; x=1763545576; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W1/V2YXbuYAodqpAgnmEeCbBkEOrsNuONxmEzzkkrd8=;
        b=JefUen9QODpVL/8O3yGSFlUyI9DfrgIaGnfSxcoKurnfiKGrjeU9Jd5v/m/rp3Uszf
         layIlzUtL5702Vh3oxPsAwmy0ZSImA6j7xCRr66eqKvM1/qpCo/OKmVO9tKsg2mA5Y/G
         bJb2NLdTN3xNq124T02AldfYAlj9iJZ1m/imkOURugKiE2SLNTob0+OrAyuobP49tmYd
         y4d6wgIb4s5LjufVsQN6WNi0GjIAxAHbD7ZVh13idTDE/Iw0cggqIvykDq1TOoL+VUwH
         98epzg51UmqHOH6n1Iom90AtDNmBXCRLndjI2RXV0F7oxYA1Mr78QETf/WMGZDwHbxG4
         OcSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762940776; x=1763545576;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1/V2YXbuYAodqpAgnmEeCbBkEOrsNuONxmEzzkkrd8=;
        b=Xfd+ibTzQVL9h6Z+rCjMTATxHnhz+f8Zd9kH6HDCbP4vw83EhcGFE3gtp6V+JqyGHk
         1uo8sjw90kxMKMZtSUb49lXLZFlSTF7pMaiX3VG4GlluCWl3qC04cfxUi7EyouFRlV1c
         yzCeficJEqbBH4mGmX+9Rzv1h2GaSjCE59vRyXZzLAIfIMs/QbMt0PrUNawnwfxKoyxP
         qiarPT5ZBXYYMqRHXrhjjwErByyvx35KVC9fxsfrvVQnz6IZK/JnR8e2K5DY0GZ1JPZ7
         ylKUOsbHyeP64deyKyz0pHJyFqsw2vLzagPZLaLzwZP3pFlnOjn+9JllMXwyo0XhmQzH
         +5aA==
X-Forwarded-Encrypted: i=1; AJvYcCWrFyZugYbwnv53Npt6sC3Sv2qZ7KVMyBrJRrWM56VNucDndLAZfm+2o0U5eReN0mVI2lXNnyLxrcsm8Oc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5ciJYmPp/6U8AIu+Om+H5GK6JzZI7F79dSgwyIl4JHK7mgix3
	LjWfUS4GMS/+uQvf/vdTGG9DDMkrvCcztyk0dpjb91zp1hODCmcPvBNSR2eMa9IGp1vpRbQ1dcO
	31/47/dSiQeBd2fIdg6sEfIsNNW689lJSRFElIlHmyw==
X-Gm-Gg: ASbGnctNkamvZjvtYH9goceEKu9ww3YZMeEP8V9EqfVOT59u/lkaz5pfFLg/0LWyPlG
	zCRO3WXgbYv4BBx2fFdzy22iV7soDWrAoqU/Yu/H9/tnfRosKUo28Je6yBDh7UzTptGsKsiLq9O
	NpQsP5OQf87J1wW3b0XSIOAzucl6j7o1/o3mFMi2deezUdC42chg8vYbr0vrto3BOHUY55577Md
	4K/75vBK0JHcchOjdtdl1CbWMIi3dNPj+Ex5wQQLe6r1WavbfrHNv0UNJBmPP4VsA==
X-Google-Smtp-Source: AGHT+IGD0G7XdFEc9kkI3XD2txQlDGCmedxcVcwXw73sg3bdIvO7yH1fEFrr96nDac9g/9uQLIFNTD0QRwWxluV5d5k=
X-Received: by 2002:a05:6512:3d26:b0:592:fbb6:889f with SMTP id
 2adb3069b0e04-59576df4c10mr718458e87.20.1762940775516; Wed, 12 Nov 2025
 01:46:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251111093536.3729-1-huangchenghai2@huawei.com> <20251111093536.3729-2-huangchenghai2@huawei.com>
In-Reply-To: <20251111093536.3729-2-huangchenghai2@huawei.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 12 Nov 2025 17:46:04 +0800
X-Gm-Features: AWmQ_bl1OCDE9RgLreec6kT78RkCRNfxq026i6JXnizuf1fqPFKGTb00tE_OArM
Message-ID: <CABQgh9GeqxyBPwe-posbstbGy2RBQdfGGBR27tr6+S+5dYzBDQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] uacce: fix cdev handling in register and remove paths
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: gregkh@linuxfoundation.org, wangzhou1@hisilicon.com, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	fanghao11@huawei.com, shenyang39@huawei.com, liulongfang@huawei.com, 
	qianweili@huawei.com, linwenkai6@hisilicon.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 11 Nov 2025 at 17:35, Chenghai Huang <huangchenghai2@huawei.com> wrote:
>
> From: Wenkai Lin <linwenkai6@hisilicon.com>
>
> This patch addresses a potential issue in the uacce driver where the
> cdev was not properly managed during error handling and cleanup paths.
Can we clarify that it was caused by cdev_device_add?

>
> Changes made:
> 1. In uacce_register(), store the return value of cdev_device_add()
>    and clear the cdev owner as a flag if registration fails.
> 2. In uacce_remove(), add additional check for cdev owner before
>    calling cdev_device_del() to prevent potential issues.
>
> Fixes: 015d239ac014 ("uacce: add uacce driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/misc/uacce/uacce.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> index 42e7d2a2a90c..688050c35d88 100644
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
> @@ -529,7 +531,11 @@ int uacce_register(struct uacce_device *uacce)
>         uacce->cdev->ops = &uacce_fops;
>         uacce->cdev->owner = THIS_MODULE;
>
> -       return cdev_device_add(uacce->cdev, &uacce->dev);
> +       ret = cdev_device_add(uacce->cdev, &uacce->dev);
> +       if (ret)
> +               uacce->cdev->owner = NULL;
If uacce is build in, THIS_MODULE = 0.


how about this, handle cdev_device_add fail for no device_add case.

+       if (ret) {
+               if (!device_is_registered(&uacce->dev)) {
+                       cdev_del(uacce->cdev);
+                       uacce->cdev = NULL;
+               }
+       }



> +
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(uacce_register);
>
> @@ -568,7 +574,7 @@ void uacce_remove(struct uacce_device *uacce)
>                 unmap_mapping_range(q->mapping, 0, 0, 1);
>         }
>
> -       if (uacce->cdev)
> +       if (uacce->cdev && uacce->cdev->owner)
>                 cdev_device_del(uacce->cdev, &uacce->dev);
is there an potential issue, uacce->cdev is not freed?

Thanks
