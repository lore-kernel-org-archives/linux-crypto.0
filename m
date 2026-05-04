Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0B5302756
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 21:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777928516; cv=none; b=VFIgjxlFHQkmea/mWExUkQGahlqR7tFt546w4un2ihEtRasxF7H5k03fwdxLm4mroZdzKboMm7G0ntPgcXTmkosUch7qFQ4NZU/QABHa4HR2UN46AgTSdu9HaPRHh3JFOGqlDF06fgodQ6eVfrWi4qoZwTrnV9XdquaqRjmKWCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777928516; c=relaxed/simple;
	bh=VmSXVD3JTHn924FOX94nzojXXzoLulX3vKK8x1K2ndw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nFNzY3dA2280M63j7Ti67k5b1xD0aSYdXoM01QwTN3Uhy3puv74IqAZSVMc576gVj8C7PYR599UMETowPEDahCX0wvWVu9FjNIZygt/GleqB0OxacU/wxOKjLb82GfiufOFr2zAjU0YU5ES1vXrCxSioF23JgnZOnMgSAc/3BvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YW/t7PYu; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YW/t7PYu"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488b150559bso30834915e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 04 May 2026 14:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777928513; x=1778533313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8V3EEF5vuXOGGZWzOmCLTd7Ai3hmXK/x8X4/6fRIf9c=;
        b=YW/t7PYuYEjItA8subcyJiCgehG1/knIeGeZGcuOrEJrnq9zeTLoqyjg5+hMaErAH8
         jA5B3imTEVIgDQLhhCeKxza+I/30933e48428NCQXNo8OwuMWzEOkffps03P6okwTe4i
         lzvmv4QQvZkluZ1WJuLByEH9uIqGgXc4G2qo/CLkiLbGYOfqiy+NgR2P9AojLv3iecM3
         fpMwg6oAX+9AJTiOs6Jxx82rsB5zdAwDAoSTlbSB0OmhLDBZhrqdq+Ku2EBGbX0Qt7RR
         j9mELeJSL0xLWF2vXt/5TKtSJZFMbRxrz43k1zx+dfbR5zqTEplpUL9x0HM2VAGprStA
         tUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777928513; x=1778533313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8V3EEF5vuXOGGZWzOmCLTd7Ai3hmXK/x8X4/6fRIf9c=;
        b=RH4xDjaYGKRf1NHJn/crM9hyAm8g9B62Kq15T2HQcvi/+KDsLNf91MCpSwzmYobY+n
         wMhLuZIPTXPqsEe5QHr8BJ3ft/Nmyt+rrDmhBx4NTSJQ3OuUVCAs+vDwKGGoEalL/f8n
         oBlsslv3Sr3GNCPT434T5FGrAcFlADWBhZoA66FCzIbntEVeZ+eFLfYWsTCfyayBLhvK
         kryRJKkB3Vraz87BdbMosJA159716DGAVKGL/0eeLGsdqeDzDjKoJOfi8l96qlQEwdBo
         0AUjvdN6twV1+9RzoV2fGHGBUoAY7zdnA0XNUkOjN8m6ftxeGu13pdCeDavZDcmGSoW/
         RuOA==
X-Forwarded-Encrypted: i=1; AFNElJ/ap0VuN98HBFT5M5SoySZdYNmRkT2xivXys70GwYS285GnmBLz2LOIhA5d4u7yrUdmBMC4PxComjEcYtQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVp9OqOO4NB+cHQNP5AHFpET7h/lRudUwSxi/6sJ60IqPABFWb
	ssmG4c5K7sPtqiehmx63uQoKTX47AKlpHiNk6aLpg2A1lBzMc8gxbz27
X-Gm-Gg: AeBDietqfogNY+3Ln/1ZocXhTDqKUUk2gj4TwUyZPaDnDeI5mwbs6Tm/BDe7pNJfYEJ
	7Ahyvx2x8A4CdYDYk/VKVnh1Af7xbSgl2NTtx0pmtL13cyTmrwMTBi6H8UC9njfQKBs6qKphV1u
	qkGBN7DzodzbC5UZuLi+LCK32TMeRLhzV2r+9FgYomCysPluh+oGhPa1WYlH3eey6ijaqyZmEr/
	FcseL8sOeSKr/0kczGY0Iyv+1iob1ymlzaTAY0fleFqfQWdqgZ2OPMsJl/rxbJr9HvdTvk5hLf8
	3U/OtkVDueeJW+ERC7crTYIWR3eV8IVw0VAcSD117Q6d5ytGRXWgXZ6kP9BcxEF8x+HSBC2gpw2
	ynWvq6kd4JQCd0Ee4Z6vvH0BrHPxHaB/6LlP3VR3IFMLSaeJ66PTBfHWAxoSGKov9i2EONfT6zp
	yjsKuoP2TN6StFEyNlInUf4fErX/Pi1pncfks5CW1ieHz5C8rTkpGx71XuXJZH6MkzDlbU14FqE
	eo=
X-Received: by 2002:a05:600c:18a5:b0:48d:364:6c54 with SMTP id 5b1f17b1804b1-48d03646d09mr86616225e9.23.1777928512657;
        Mon, 04 May 2026 14:01:52 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48d184e197asm1027725e9.30.2026.05.04.14.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 14:01:52 -0700 (PDT)
Date: Mon, 4 May 2026 22:01:50 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Lianjie Wang
 <karin0.zst@gmail.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Olivia Mackall <olivia@selenic.com>, Thorsten
 Blum <thorsten.blum@linux.dev>, Manuel Ebner <manuelebner@mailbox.org>
Subject: Re: [PATCH v1 1/1] hwrng: core - Replace strlcat() with better
 alternative
Message-ID: <20260504220150.5e6ce43e@pumpkin>
In-Reply-To: <20260504130259.473382-1-andriy.shevchenko@linux.intel.com>
References: <20260504130259.473382-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  4 May 2026 15:02:59 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> strlcpy() and strlcat() are confusing APIs and the former one already
> gone from the kernel.
> 
> In preparation to kill strlcat() replace it with the better alternative.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: David Laight <david.laight.linux@gmail.com>

> ---
>  drivers/char/hw_random/core.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index aba92d777f72..c789699bd773 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -418,21 +418,21 @@ static ssize_t rng_available_show(struct device *dev,
>  				  struct device_attribute *attr,
>  				  char *buf)
>  {
> +	int len = 0;
>  	int err;
>  	struct hwrng *rng;
>  
>  	err = mutex_lock_interruptible(&rng_mutex);
>  	if (err)
>  		return -ERESTARTSYS;
> -	buf[0] = '\0';
> -	list_for_each_entry(rng, &rng_list, list) {
> -		strlcat(buf, rng->name, PAGE_SIZE);
> -		strlcat(buf, " ", PAGE_SIZE);
> -	}
> -	strlcat(buf, "none\n", PAGE_SIZE);
> +
> +	list_for_each_entry(rng, &rng_list, list)
> +		len += sysfs_emit_at(buf, len, "%s ", rng->name);
> +	len += sysfs_emit_at(buf, len, "none\n");
> +
>  	mutex_unlock(&rng_mutex);
>  
> -	return strlen(buf);
> +	return len;
>  }
>  
>  static ssize_t rng_selected_show(struct device *dev,

