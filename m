Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6741119A
	for <linux-crypto@vger.kernel.org>; Mon, 26 Aug 2024 05:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724649485; cv=none; b=s+15WW3FneYTOuKoOBwfqeRGSRKp5bWvkLRkRYepMkoGyEKSxDLV0Cq/0NjaTRQ1CE5xW2f24xgkfpfKg1KL3L2X8RHH5FnOFiUnpQ+BanqCK5WYH5WJ1XYYtGbJ73+HaHO7SyvyN8+mwQ1apHYwkaj5mK+ytNGP3istNJruJwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724649485; c=relaxed/simple;
	bh=jB0/RPIXS9pdPmyd40DRI0N3AT6Io4cllgYT7G2Ijfw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bUYTnRWXNB8dQvNCue/53V9OxxQb6BNgeyb0H+Y2lBtlCJHvYCMaHq8hKcqkmRHLm8pBLCsdaqp0pDLJQdnY4jKHvSv7+WAwQEHcv6mMxUVSLJ2sh/U4uTuB1wIJ/coCBnYXQCluJYV4l7ACLeF4FxEERj4B2xhFFWZv3xp5mGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=bKRvw/X7; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bKRvw/X7"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53346132348so4490171e87.2
        for <linux-crypto@vger.kernel.org>; Sun, 25 Aug 2024 22:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724649482; x=1725254282; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBi6WqSTf8FC6xwJzYMYM89MMQd/hd27NLSyQMmk8BM=;
        b=bKRvw/X7XD2vIP0sBFJNJgoVjBDTrjxhhny+7BZOEd1eMORX2ISy/oEjR2p7XSwjK0
         42SK3JBhv6LOL/CEfwf280sQNZMYEAoH7Y5I9gmKsvAjz4G/ZCIZIM/xLXZ0njzaB9aH
         UvdS0hKz5/kZZcnUjn/JLDzFLGjrbJGt0JLAI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724649482; x=1725254282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WBi6WqSTf8FC6xwJzYMYM89MMQd/hd27NLSyQMmk8BM=;
        b=oytYL4ipSbc5FjOZ7j+eXwCBs2o6U1B4yKHPyFXhj7vvKwPBMJLD7+hnv8gL6lKumd
         hSO3R+3kUFx4WN7CY2DoE2rplplaTMqLQ9F54Mhh6D+X/A68sSEu28Slt097Dr2qDqCN
         H7W1DU8q36NnmQxeB/EsUSq8mJ9zU3cQesoii9Sm9NmV/3AunjZBjiFqgmn5OzHnW+/6
         V9aOjSID7DSMEXJHVxwVxdJt5nxpSUASYEINHUpziYufjXwLX0Q0aEx3755m/lwytoj/
         7wbLBo+dagapYGL+SeIBMjqX481nUkaaJCycPdorhCEs9pCld/vxfEMLN5UJop2L5Qph
         +Q8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWm1cYqH4m5ILaIkhX5gb/jGfK4p71M0SR1uG5ezncnck8OEUcbqCaKJUBAugWWDx6jKkpFyczS+aeGiMU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyO2Oe5IyQ1J9/PfM83j4kOy4fez5C839G17nZfCeOsSJGKv8Wv
	XtzpmfN98izO+OXo2mMAQiDLu836dhOhuPYGWtNgdLOq4k1VBuDPFJMuxAFZrGdTUIqiDS1H/B4
	K3+E4WcZlKWdjkbGczj/XN7xLr9kMXR2qEaBI
X-Google-Smtp-Source: AGHT+IHVTY5sJTAr69bRtw0O0k6zDRln3oL7Hx6o0x/ihjgK98b9yiE0d0nBhAd2Q/s80ymcCqEG9Bl7y/fyoZTQUjI=
X-Received: by 2002:a05:6512:1048:b0:533:1cb8:ec6e with SMTP id
 2adb3069b0e04-534387858b2mr7000897e87.33.1724649481695; Sun, 25 Aug 2024
 22:18:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826014419.5151-1-guoqing.jiang@canonical.com>
In-Reply-To: <20240826014419.5151-1-guoqing.jiang@canonical.com>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Mon, 26 Aug 2024 13:17:50 +0800
Message-ID: <CAGXv+5G6AToabUmvPvcHQZaU-A6b-Y82ErUGxBVDojK5gMBz+w@mail.gmail.com>
Subject: Re: [PATCH] hwrng: mtk - Add remove function
To: Guoqing Jiang <guoqing.jiang@canonical.com>
Cc: sean.wang@mediatek.com, olivia@selenic.com, herbert@gondor.apana.org.au, 
	matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 26, 2024 at 9:45=E2=80=AFAM Guoqing Jiang
<guoqing.jiang@canonical.com> wrote:
>
> Add mtk_rng_remove function which calles pm_runtime relevant funcs
> and unregister hwrng to paired with mtk_rng_probe.
>
> And without remove function, pm_runtime complains below when reload
> the driver.
>
> mtk_rng 1020f000.rng: Unbalanced pm_runtime_enable!
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@canonical.com>
> ---
>  drivers/char/hw_random/mtk-rng.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mt=
k-rng.c
> index 302e201b51c2..1b6aa9406b11 100644
> --- a/drivers/char/hw_random/mtk-rng.c
> +++ b/drivers/char/hw_random/mtk-rng.c
> @@ -149,6 +149,15 @@ static int mtk_rng_probe(struct platform_device *pde=
v)
>         return 0;
>  }
>
> +static void mtk_rng_remove(struct platform_device *pdev)
> +{
> +        struct mtk_rng *priv =3D platform_get_drvdata(pdev);
> +
> +       pm_runtime_disable(&pdev->dev);

Instead maybe just replace pm_runtime_enable() with devm_pm_runtime_enable(=
)
in the probe function?

> +       pm_runtime_set_suspended(&pdev->dev);

Not sure if this is needed? I'm not super familiar with runtime PM.

> +       devm_hwrng_unregister(&pdev->dev, &priv->rng);

The fact that it is already devm_* means that you shouldn't need to
call it.


ChenYu


> +}
> +
>  #ifdef CONFIG_PM
>  static int mtk_rng_runtime_suspend(struct device *dev)
>  {
> @@ -186,6 +195,7 @@ MODULE_DEVICE_TABLE(of, mtk_rng_match);
>
>  static struct platform_driver mtk_rng_driver =3D {
>         .probe          =3D mtk_rng_probe,
> +       .remove_new     =3D mtk_rng_remove,
>         .driver =3D {
>                 .name =3D MTK_RNG_DEV,
>                 .pm =3D MTK_RNG_PM_OPS,
> --
> 2.34.1
>
>
