Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8A430F942
	for <linux-crypto@vger.kernel.org>; Wed, 12 Nov 2025 11:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762947361; cv=none; b=soeKxC3q42S9WXCeLKaGjKeYLTnXbLX2yWooaPOk6l35U+COYbphY7WfrmpjPTLt/0g6w9AVcddjRjrvMmpshhigiijteSPUofDkTNgszGD2hA2JKcD9xoXIF4AzuGZur73r2Kgycy5PHSwP0NSA41k4CsOMRNMt/XtmSjL/BUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762947361; c=relaxed/simple;
	bh=hNifgGjK9XZ690CF8Irk1+yA6eXY0eoXQPm5dtUihkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KxZYw4RDu3pz3w18EB37uxHhvSjuE79eMGJWWrl8v5aS4kOso12RxLwPADr5hR3G84tNpDc9gwl/2jcSyLvzmyOg6cm8Pa0amXtB5EDKyD0dRCB9x9LaT4Km7F8omgC49OtCyfWjfLSLCy7MI5Nf30wzgWKoj4vs6mNg679XHgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fSyaK5z7; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fSyaK5z7"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-594476f218fso513691e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 12 Nov 2025 03:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762947358; x=1763552158; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=skMVjwCP7LYz5n9pgbxkQMIb1CKWHlcsndeKQCWO/0k=;
        b=fSyaK5z7BZ6U7I5iB7xEJhuwZY0sIrMcv+5CCohguusTQ+RsQYFg+f/6wPnIqTL59G
         vk5/WMdO7uMjG4OTQDz2hIzz3LMd9ZxzISIxbgZRi1Za2PDUXJgol5EW4dAgUlifXUOq
         mnoWYbJk6ZApX5VYCEBJh8OghZIPdOwPN5SyCpk66Xj9Err4CkajBOtW6dVx28JGLHD6
         kKltxlqDJf5pMrzl+BXor2vae7xqHo0OxfOPdPDTTjKNobykTUhs7SmbhyTvKTl/4RTS
         yoV8yhvoWqNtOyj21VfWzbfOP86es1rbVKEOV8n9heJAyWoQc3oklywOyfC0G/7er77O
         IPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762947358; x=1763552158;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=skMVjwCP7LYz5n9pgbxkQMIb1CKWHlcsndeKQCWO/0k=;
        b=gaDZ6CmTz5U+m3jRuoIj5Y5W49WW8PNQZbXVSWAAa3Mx3mdt9RlauatsTZfZUlmCiA
         xtgjQS/AgXqsbjDXV+5DZ5ECFLmRw28g0XrWNtcvAME2+EcVtCcEmiRXUTM/xGkb75F/
         d7N/bUH0ZEnA6biY/NPyApTSW/uUC3GMcOpZxWfY2qfS03OMR/SMpkXcl/JSmY1ZJjQX
         mKneiH7wo1l4UvLk2nVRaFkaJQ1x7r9HtCL04weZ1lRmvSULEr26XWUpHr95Nw21EVy4
         CRpC4il77pcgSan2Gc66r89ET5tk85DJFILjGFAREBWCSNPy7b1SmSG95iGWlkj3SLTP
         3+dg==
X-Forwarded-Encrypted: i=1; AJvYcCVOcNrJgp731V/5BVS3uBU4J9LFbBNES98r92Z7nRbILu6fBtMb7DjrH/XwZfde6JpYNpHHoIOcZ+Ls/to=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3gUvOKeAdWKsVfe6JpYuT9u2UlXiNHV5gBURD6Vwtrzb8wOpB
	1ShnOtGYAAatc1limskZTV8SjRhnzIR/CWwFtIwbbCv6m030WHg6k+2O1dhMTuIuzBR+ds2PWRI
	k8KvlHPSrmexrHA6sCNoCOBFOetAJ05XWi9X0o6JbBqd7f/cMDCcm2lTEJBF1
X-Gm-Gg: ASbGncs7NUbAy1G6FEBGm7nui0B+5KSTKntXZrLYXgzPFIaWKxFQXbzxVNBibZ2ITLi
	yEJk97F7cbxVh13L2o5fkcfjYfTRw+4/y/Dcj13nWXyWghRzrL4kLYMZcxJgvZlGzA1rGoxED+D
	erLph213MghuTxTQY+WT2Zzqr2qrYh2lIDKlkpI9cn6clAE8UUlsgeZMZ0yPecx4VyqqO8prtqt
	C4CyW1XQXuH5iSHhOCVitzof4anW5cpr3kANEZeG/3I4ibUHaOTT6kWcmHK++FQdkTaw0Y=
X-Google-Smtp-Source: AGHT+IHhNExbIj/3W2XhoR0Xuu2aGUHsUvEAOA0150BYe9ylvPiV9Mt3JobnM1Vuu3SAPETl9yEYmgDYccHW+z4gGVk=
X-Received: by 2002:a05:6512:3f04:b0:55f:4633:7b2 with SMTP id
 2adb3069b0e04-59576e665a1mr1221208e87.46.1762947357705; Wed, 12 Nov 2025
 03:35:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251111093536.3729-1-huangchenghai2@huawei.com>
 <20251111093536.3729-2-huangchenghai2@huawei.com> <CABQgh9GeqxyBPwe-posbstbGy2RBQdfGGBR27tr6+S+5dYzBDQ@mail.gmail.com>
In-Reply-To: <CABQgh9GeqxyBPwe-posbstbGy2RBQdfGGBR27tr6+S+5dYzBDQ@mail.gmail.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 12 Nov 2025 19:35:46 +0800
X-Gm-Features: AWmQ_bmIYwRflA4kVrE8oikjaYeyBERXmoePE5_IWRr5w60v7ipWHkRMoK9cYkg
Message-ID: <CABQgh9F3E7SHC3VvcbL+x6p5kJ-4=UgCMDgno=-EROcSfQT+-w@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] uacce: fix cdev handling in register and remove paths
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: gregkh@linuxfoundation.org, wangzhou1@hisilicon.com, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	fanghao11@huawei.com, shenyang39@huawei.com, liulongfang@huawei.com, 
	qianweili@huawei.com, linwenkai6@hisilicon.com
Content-Type: text/plain; charset="UTF-8"

.

On Wed, 12 Nov 2025 at 17:46, Zhangfei Gao <zhangfei.gao@linaro.org> wrote:
>
> On Tue, 11 Nov 2025 at 17:35, Chenghai Huang <huangchenghai2@huawei.com> wrote:
> >
> > From: Wenkai Lin <linwenkai6@hisilicon.com>
> >
> > This patch addresses a potential issue in the uacce driver where the
> > cdev was not properly managed during error handling and cleanup paths.
> Can we clarify that it was caused by cdev_device_add?
>
> >
> > Changes made:
> > 1. In uacce_register(), store the return value of cdev_device_add()
> >    and clear the cdev owner as a flag if registration fails.
> > 2. In uacce_remove(), add additional check for cdev owner before
> >    calling cdev_device_del() to prevent potential issues.
> >
> > Fixes: 015d239ac014 ("uacce: add uacce driver")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> > Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> > ---
> >  drivers/misc/uacce/uacce.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> > index 42e7d2a2a90c..688050c35d88 100644
> > --- a/drivers/misc/uacce/uacce.c
> > +++ b/drivers/misc/uacce/uacce.c
> > @@ -519,6 +519,8 @@ EXPORT_SYMBOL_GPL(uacce_alloc);
> >   */
> >  int uacce_register(struct uacce_device *uacce)
> >  {
> > +       int ret;
> > +
> >         if (!uacce)
> >                 return -ENODEV;
> >
> > @@ -529,7 +531,11 @@ int uacce_register(struct uacce_device *uacce)
> >         uacce->cdev->ops = &uacce_fops;
> >         uacce->cdev->owner = THIS_MODULE;
> >
> > -       return cdev_device_add(uacce->cdev, &uacce->dev);
> > +       ret = cdev_device_add(uacce->cdev, &uacce->dev);
> > +       if (ret)
> > +               uacce->cdev->owner = NULL;
> If uacce is build in, THIS_MODULE = 0.
>
>
> how about this, handle cdev_device_add fail for no device_add case.
>
> +       if (ret) {
> +               if (!device_is_registered(&uacce->dev)) {
> +                       cdev_del(uacce->cdev);
> +                       uacce->cdev = NULL;
> +               }
> +       }
>
>
>
> > +
> > +       return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(uacce_register);
> >
> > @@ -568,7 +574,7 @@ void uacce_remove(struct uacce_device *uacce)
> >                 unmap_mapping_range(q->mapping, 0, 0, 1);
> >         }
> >
> > -       if (uacce->cdev)
> > +       if (uacce->cdev && uacce->cdev->owner)
> >                 cdev_device_del(uacce->cdev, &uacce->dev);
> is there an potential issue, uacce->cdev is not freed?

And cdev_device_add(uacce->cdev, &uacce->dev) will not add refcount to
&uacce->dev
as usual when failing beforehand, so uacce_remove:
put_device(&uacce->dev) will have
refcount_t: underflow; use-after-free, need check as well.

@@ -558,8 +558,12 @@ int uacce_register(struct uacce_device *uacce)
        uacce->cdev->owner = THIS_MODULE;

        ret = cdev_device_add(uacce->cdev, &uacce->dev);
-       if (ret)
-               uacce->cdev->owner = NULL;
+       if (ret) {
+               if (!device_is_registered(&uacce->dev)) {
+                       kobject_put(&uacce->cdev->kobj);
+                       uacce->cdev = NULL;
+               }
+       }
        return ret;
 }

@@ -610,7 +614,8 @@ void uacce_remove(struct uacce_device *uacce)
        uacce->ops = NULL;
        uacce->parent = NULL;
        mutex_unlock(&uacce->mutex);
-       put_device(&uacce->dev);
+       if (device_is_registered(&uacce->dev))
+               put_device(&uacce->dev);
 }

Just one possible solution, FYI.

Thanks
