Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0053B2989A2
	for <linux-crypto@vger.kernel.org>; Mon, 25 Aug 2025 08:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756110051; cv=none; b=oi1/hRWJPHpP6q3wJyY3/3BPeLjBwFmfa6Az4j3xsT9+R1rQM4hTMExMb+O5EMi4F6zUFnMlx9LecE688yc4XmZho8sYOpsQxHRpMIMAQzPqz1Wph98D3heXFFnUp59fb/M4U8zhbr+a/OnZT9likBR8TO3he4ZtmbibIx+IxYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756110051; c=relaxed/simple;
	bh=sa455CH4zVVtWcW+HkzeM3tfZcEzY/2ePCEYSgzxiA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mRCPqYhuapZFKBLWV391JZ7qUZpvLPHQ/4nh/GNW4OE0DGLniQgt4LT8XhyHhDY4bxFjeeiPXShE/ZfPes9LSV3/VQWe3/boch3wCfiL4rP4GQlDb1YL/mnY3dWrRdjnZf9dETkg41EfqYAQiWESufFiRdkoaC5M0fQEr+6+bb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K9mHVcr+; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K9mHVcr+"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55ce526627dso4132327e87.3
        for <linux-crypto@vger.kernel.org>; Mon, 25 Aug 2025 01:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756110048; x=1756714848; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o2XJ019XSVpTAG7s7pZyslt6exkRC4t9YF2632Xgvaw=;
        b=K9mHVcr+aAEhElarR/Ng7Rt5QC9yQu3ZJgx1RFLq3WyX8kcCbXUcrseFwZzMgZoCb5
         CBRfVouB+aoclOkTyMQ7pz2/+VYxZIRfXZRWiyTrVjBM7F2lCrP58wrznn5nK31bLjcX
         lEt3lC3iHvz09rTZBsNnBZp/b1Iwtcng/BKplSWSCCue7q74BeMqbLfoWL4SbuUTVXjn
         GygqQArGxOfFppFWvWPOsbDZDaK+s/aUJBfr+Gu4BXJk8MME3U9uvff1x8BcP2ubltsC
         yDuFBGJgeZFRCkl2MMIakfdwiVn+/h5DkWylsE4gi33LbQ5W8aHCA+M+uGpxghIwnYZi
         QfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756110048; x=1756714848;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o2XJ019XSVpTAG7s7pZyslt6exkRC4t9YF2632Xgvaw=;
        b=lhKpdK9q9rjnZyJjyAjeUo3QNug4tcIEg8yEfVNEzU5sFpC/Uxw9TB/3OEXIm80Q1N
         sW7detaPxhjMFhC5lQWWFVFLmtJBAu60soTwweH8n5Ha/LxCcMTZWujAAxaDyQjWwQ/+
         Q7+66IbOSmLDvXJrLDr2VntPNLKb4xMEHpXY6w5L9vTf/eJjdB7EwpXDGlUwD2jlyU0I
         MwI9UtEdQUi0SKr8RMnSdeI3Yau2UOSXCgLbOEmdU7gi6A3MIPjySE5Yc/ecKm81s9bX
         qJnmHzBH0AxtHuvS6HUneJA0Fw49dzgeUpRmG8dO8pghhO89CnWTUT6cd62C8Nma8PJK
         MgAA==
X-Forwarded-Encrypted: i=1; AJvYcCXwRo9Fq1Ie6w8fXWqssWly7m/hLEAcT3vlk1TsHIRlI8eLRopW/twinjn+aNKRmZGnvLIsrQ9Uhb1u/oc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX6jzvKidtlbhXAIYaGAjdcheGSS+xm+u7elcNCS4bhmpXYeWS
	0Sr1Nvo9Y+rffRCN53lPvjy6AfAJL5aaRrROu3BOECLZI/jEXaeR1q6nle+cbESRrG7P41apZMb
	MqvIIBK5mBnxIcdv8I5AYGO20fzhsNhbl2yz6ERejkQ==
X-Gm-Gg: ASbGncvEitnwFvfdZlTZz22/gHujxWXtG4zMU91PSW8DXv3hjMpZi83PhMP6OpW3v7i
	ZOZR8JtOPer3z1DXtF7xevS1HlWvL8tWS9xX0AMIB/v+vFkLlARXr7kfY3sC5AeyZmfbXow7myJ
	sEXX1QFqUAbLsr4iSDY4QJlGXW8RijN1XOKDhuK0HMnVCQTgmhCPapa/E3vqhwNqyDIhpqSUtHe
	nmrDG+BEDyV
X-Google-Smtp-Source: AGHT+IEfOcim1GGklFBdmh8n+PPbfuo6xxnPCst4XodvADj4YOThtaoWwrye8U4l6bp48evx2aZRZysuNfFFZZys4MM=
X-Received: by 2002:a05:6512:124a:b0:55f:4107:ac4d with SMTP id
 2adb3069b0e04-55f4107b076mr1577885e87.32.1756110047971; Mon, 25 Aug 2025
 01:20:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250822103904.3776304-1-huangchenghai2@huawei.com> <20250822103904.3776304-2-huangchenghai2@huawei.com>
In-Reply-To: <20250822103904.3776304-2-huangchenghai2@huawei.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Mon, 25 Aug 2025 16:20:35 +0800
X-Gm-Features: Ac12FXxfHyoepBgYfmInjjCtjz-yIm9Kws3TvgWdlXZWETlNj3V7QoFu5Oykv14
Message-ID: <CABQgh9GwQ6mB1q12X8pci=QTCw4R7f4CXLkwMfT-VvGeM+qqkw@mail.gmail.com>
Subject: Re: [PATCH 1/4] uacce: fix for cdev memory leak
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: gregkh@linuxfoundation.org, wangzhou1@hisilicon.com, 
	linux-kernel@vger.kernel.org, linuxarm@huawei.com, 
	linux-crypto@vger.kernel.org, fanghao11@huawei.com, shenyang39@huawei.com, 
	qianweili@huawei.com, linwenkai6@hisilicon.com, liulongfang@huawei.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 22 Aug 2025 at 18:39, Chenghai Huang <huangchenghai2@huawei.com> wrote:
>
> From: Wenkai Lin <linwenkai6@hisilicon.com>
>
> If adding uacce cdev to the system fails, it could be due to two
> reasons: either the device's devt exists when the failure occurs,
> or the device_add operation fails. In the latter case, cdev_del
> will be executed, but in the former case, it will not, leading to a
> resource leak. Therefore, it is necessary to perform the cdev_del
> action during abnormal exit.
>
> Fixes: 015d239ac014 ("uacce: add uacce driver")
> Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/misc/uacce/uacce.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
> index 42e7d2a2a90c..3604f722ed60 100644
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
> +               cdev_del(uacce->cdev);

Can cdev_del be called multi-times? since cdev_device_add may call
cdev_device_add itself.
Does this introduce another issue?

Not understand the case: "either the device's devt exists when the
failure occurs,"
Looks it is cdev_device_add itself issue, or need add check
if (uacce->dev.devt)
 cdev_del(uacce->cdev);
how about other drivers' behavior.

Thanks
