Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30900171E7C;
	Thu, 20 Jun 2024 09:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718875641; cv=none; b=Lb4fOCW4KXEGQO5mbLrWtYC8kIKKyTGZZlsbZBt/YZzNG4uUaeOpcGT8l8McWcR+DZr89+jTPTTXhD7Wq7G17tFHQIMdaHR3Iwek0KFbX+CHL/pab1wt1Idjmqzlf3gz9aUhlQ4URIQFNG6gaoedmlJXX2mwk+KvH4X+0/qFTH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718875641; c=relaxed/simple;
	bh=0Mu03VNJ+fThgkuava8qDtHf7MBwdi9Udg1su8Z0OW8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HQa3C5n5gZirQ1ot3doyOrj9ZMV40acTJKDDj8GoKLElOiwSWLBfV12hpbU4O1rDULY1x5DWTrgHoAh5p75Gy2aGaY8DDrpq/J+ykiA/nBEW4rBvhYqi4vVmuVVvVDYTJrEKGwfhyTClOKTAQsmRhO7WiTFXddrWQSKe79cn2Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O30jpsTL; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O30jpsTL"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5c19d338401so320248eaf.0;
        Thu, 20 Jun 2024 02:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718875639; x=1719480439; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FROFlUneDLe4vhTKghMMJ/e6nscmWsFk47kSMER6MVc=;
        b=O30jpsTLmOY6mKtrtopfydeaArC12tcifhXwy5LGRIZykymLyeMnvEub4MM7kY2Pwx
         pqPzUVi+dvvlpX/+LGU1La6kmUVXSxQOQY8q4IzZZqUWwbawas5KInWY7SiVMMBACzkS
         w4ioaJVyPqDaNQ0PmNJ/rY8Y+gOMJiDkz2Q7ptACaaALsXaJocJwpZf6W353y6vVGUVV
         h9Xgqf14+xOw2voO1CqE83jD6j2Q1R09dmvmsrCd9oqq+OZiocJ2g8C8e454NFVhjQOJ
         bpkN8p5/9Rqv/7jUo2vJySa8V4H6RZIhSBbFCm7if0kB9NRugefFou0ACSHMBuzpOQM1
         oKqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718875639; x=1719480439;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FROFlUneDLe4vhTKghMMJ/e6nscmWsFk47kSMER6MVc=;
        b=LMInDX2RVXIQHj4g1znmA4UoPRt/KjroE1VrDniGB+yOBQN4WI/Q6UksJ2klmxibi/
         DnrouiQRsH0S0ErXNhnq47OKEHSSin3jx0Dp0tSU863C5kZODka30V0QV2TEYAIsqA/o
         dJeNwMGIjcqxOpCQ4vEPCWyzCf1i8QtA+BSNtIjz9I2/JIWumSEJh030nBIjHhQnUYGf
         Q2QlsezyZPoUez+3IN3sKUPvIXgttB2ZeqLg0VMgmeB2NtJhpY6QY01KqN3672IdSOyi
         W94DyTEP4Rlkipdi/wMBVWAWFoGgau80rB5HL+jIjt5Ya/h5qJTg3cmGO9l9Gm4TDxMg
         6i1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXEI0kMBKfwBCHPGiHtc+ASPwPXNvg3nv6oSB0eYX2HGMtil6Gw4lXRh2D457oNU32ldWzKQlx6lh4TMgTdksMiubqKvuYp2Nr8SsKCdbTrVrn4oIBu8V27es0oh77GBQhpauR/+A1jUimdoDwSIR1iWyxAS64qaoG4jRKvq+/gc2d09fAECP39Ue9gsb251ue5YWEajQ5XVv/EHG/1JdzEqbYhJWOnADRC
X-Gm-Message-State: AOJu0YyHDqv8RCtL0PJCzjqqCS3ispM2Wz/NfonzR9QIbW1FajrzE2Vx
	stfRJzVj+fdwbyz+meL17ppVkIDyDzwL/iVOAzesC6d8MxcJAfdqwYl6LhsFQ+H/UvwmL7PKdAI
	ILFrODTMkT16Atvlq7rHuqzw+K9k=
X-Google-Smtp-Source: AGHT+IFfg1F0VgT9U7HH46syTdFLN/j9mjNVjjK3LM5UPZUG03dA0siyK9W/UHDjGUhaFvaHXG8w+cqvHC76fvDnpIw=
X-Received: by 2002:a4a:8042:0:b0:5ba:f5f3:987b with SMTP id
 006d021491bc7-5c1adaea716mr4869639eaf.1.1718875639234; Thu, 20 Jun 2024
 02:27:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240618204523.9563-1-semen.protsenko@linaro.org> <20240618204523.9563-4-semen.protsenko@linaro.org>
In-Reply-To: <20240618204523.9563-4-semen.protsenko@linaro.org>
From: Anand Moon <linux.amoon@gmail.com>
Date: Thu, 20 Jun 2024 14:57:03 +0530
Message-ID: <CANAwSgQpPPP-2_9R9tenfQ4zMzF2d7BYBW8=nMRec5OVaEknMw@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] hwrng: exynos: Use devm_clk_get_enabled() to get
 the clock
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Alim Akhtar <alim.akhtar@samsung.com>, linux-samsung-soc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sam,

On Wed, 19 Jun 2024 at 02:15, Sam Protsenko <semen.protsenko@linaro.org> wrote:
>
> Use devm_clk_get_enabled() helper instead of calling devm_clk_get() and
> then clk_prepare_enable(). It simplifies the error handling and makes
> the code more compact. Also use dev_err_probe() to handle possible
> -EPROBE_DEFER errors if the clock is not available yet.
>
> Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
> ---
> Changes in v2:
>   - No changes (it's a new patch added in v2)
>

Reviewed-by: Anand Moon <linux.amoon@gmail.com>

Thanks

-Anand
