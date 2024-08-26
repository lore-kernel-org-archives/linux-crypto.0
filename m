Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B6463D
	for <linux-crypto@vger.kernel.org>; Mon, 26 Aug 2024 06:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724654522; cv=none; b=MWAciEg8m+L7SYwn8iAJIG/R8gkGBuHj0PUov9NOdJhOI5tPcR/k4Ndz8LDHHIrB57zbyGBjWqyslLYXbyM7wXY18F5je7O+T+E/Pf3Z6+yZkPdHN2EGwlsiqnYFb0PoVAF/aIec2dXERArainriztj4wFSSylu/o1igZZTUUeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724654522; c=relaxed/simple;
	bh=C6+fVH2FGCeOMJzZK6QyV/3RYcXYiPxnDNM1vbqrjGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ujNtbblJ8M6kAi6Vprkt4fYneZjStT8AN6y+ddi9bYCvXT6vbWVmX6k70wmym0fPRzhleTDPBru5+L3RBdCKEYgLHnBWvHMSSNZIAOz6MmlHL0r9mB3a761PWkWHUHMVf6GxMwl8TS2e3S5kdWC/iNZiyYrTxpZiirBIIsNCH7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=b4hRgfIz; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="b4hRgfIz"
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5C7FB3F67D
	for <linux-crypto@vger.kernel.org>; Mon, 26 Aug 2024 06:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1724654511;
	bh=+iGhqdq8Nm6zibPdgyg1lBX8pBlA7d0Q+MAWA1vQXy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=b4hRgfIzB/mDIrfYtHj/G34XG7dmLkxh4yORHqlvGPDzoE9P0g+mPEQe3ySx5gUDn
	 b6VcKp+1O6+tFgzcFITOYQlMS/xApUM1pZINLHXtmvuMb+1D5Z92arJp0fzXTX8YpF
	 hDvYFWN924lfG0APugTqHtELGDVQDfQS9R7RS367DQPTWId3tIcCB9MBa9kLZdXvd/
	 7jhJ7ZJ2OLZK0xIlvqQEFmYcNgabPcGgP8K+XtgEIwbzjEDHAqSmVrS4LCKrE5+TpP
	 /tOd7txN48cDFrC3zjbAAiuRv6GUAVMXYWCw3TtYRfylOQfV+7QLMq6sY9G/WPqlWn
	 kK9rC5bOCSHmQ==
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7141ab07fddso3362273b3a.0
        for <linux-crypto@vger.kernel.org>; Sun, 25 Aug 2024 23:41:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724654509; x=1725259309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+iGhqdq8Nm6zibPdgyg1lBX8pBlA7d0Q+MAWA1vQXy0=;
        b=jaaj61VBacklgsjT7YXlTG+im9qcF56vPoGKopZP7Qn/RkUIZNf38hdUexTopGhkqX
         zzGMdBM/6jlYnxEHrjMINW8e19DqAKuA5dbI+CQ+dE4m0Y3qxxsBMxzUuw+LXIpG2eDr
         BURoAS9ctodIA/NUdOcD+Srt5u9WqHVfKUeC7DCtx1qY9NrZv8iEJI7fHY11Pci97OGG
         l+xSix0+XhoHm/JmHt3vbnZ6WLo/4bFdL+/utP0iuMT2lVrmOglezEBQOeBxXIfzZtf4
         +gLt2Ktqkrf9DP1RiUCHLYDlCpGG2UxMEHFRYgRed7qPz8zfLKCTU6p9OjDyicsWW3w4
         /9wQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5/uGehucA3lZvHxusftZKDiwPeO9fzM/pu/WmMiwqMw0yiWY4B/EwGJ7NsnmeFDh5CHdSaRAuoYEPcdM=@vger.kernel.org
X-Gm-Message-State: AOJu0YypiWuzNyqLBF34QgBFI0LkJstYXBFAbukeOr6RnKkmKz8v5Fs9
	RX7YLj2Z25idfURLxI5ojiFzQ1gY+kV0Ho+UyAlbmk4ETc4obzoJKz0fvefZqiP5NG42buSofDD
	QKjbtDoDAozjC5x+0IFqWx2eFm0E/CTtM5WM4XkUJg+t/+LNrl7o4m9FE6Q/FDkl0K35XiZL/kr
	G7/gnwXE8pS3rE
X-Received: by 2002:a05:6a00:3cd1:b0:706:700c:7864 with SMTP id d2e1a72fcca58-714457368a3mr8681945b3a.4.1724654509393;
        Sun, 25 Aug 2024 23:41:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5927KxkvcimyRd0Hf6bimnbLUHMBkrmoZO83HLCrfQIBH6ObNVYTI30V7dd/ecJKIUo9InQ==
X-Received: by 2002:a05:6a00:3cd1:b0:706:700c:7864 with SMTP id d2e1a72fcca58-714457368a3mr8681926b3a.4.1724654508934;
        Sun, 25 Aug 2024 23:41:48 -0700 (PDT)
Received: from [127.0.0.1] ([103.172.41.203])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714343404b0sm6467253b3a.220.2024.08.25.23.41.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Aug 2024 23:41:48 -0700 (PDT)
Message-ID: <2914fb9f-da8e-4415-ba8b-e12d3792712b@canonical.com>
Date: Mon, 26 Aug 2024 14:41:42 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hwrng: mtk - Add remove function
To: Chen-Yu Tsai <wenst@chromium.org>
Cc: sean.wang@mediatek.com, olivia@selenic.com, herbert@gondor.apana.org.au,
 matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20240826014419.5151-1-guoqing.jiang@canonical.com>
 <CAGXv+5G6AToabUmvPvcHQZaU-A6b-Y82ErUGxBVDojK5gMBz+w@mail.gmail.com>
Content-Language: en-US
From: Guoqing Jiang <guoqing.jiang@canonical.com>
In-Reply-To: <CAGXv+5G6AToabUmvPvcHQZaU-A6b-Y82ErUGxBVDojK5gMBz+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/26/24 13:17, Chen-Yu Tsai wrote:
> On Mon, Aug 26, 2024 at 9:45 AM Guoqing Jiang
> <guoqing.jiang@canonical.com> wrote:
>> Add mtk_rng_remove function which calles pm_runtime relevant funcs
>> and unregister hwrng to paired with mtk_rng_probe.
>>
>> And without remove function, pm_runtime complains below when reload
>> the driver.
>>
>> mtk_rng 1020f000.rng: Unbalanced pm_runtime_enable!
>>
>> Signed-off-by: Guoqing Jiang <guoqing.jiang@canonical.com>
>> ---
>>   drivers/char/hw_random/mtk-rng.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
>> index 302e201b51c2..1b6aa9406b11 100644
>> --- a/drivers/char/hw_random/mtk-rng.c
>> +++ b/drivers/char/hw_random/mtk-rng.c
>> @@ -149,6 +149,15 @@ static int mtk_rng_probe(struct platform_device *pdev)
>>          return 0;
>>   }
>>
>> +static void mtk_rng_remove(struct platform_device *pdev)
>> +{
>> +        struct mtk_rng *priv = platform_get_drvdata(pdev);
>> +
>> +       pm_runtime_disable(&pdev->dev);
> Instead maybe just replace pm_runtime_enable() with devm_pm_runtime_enable()
> in the probe function?

Good point, will try it though it seems the function was not called by 
any hwrng driver so far.

>> +       pm_runtime_set_suspended(&pdev->dev);
> Not sure if this is needed? I'm not super familiar with runtime PM.
>
>> +       devm_hwrng_unregister(&pdev->dev, &priv->rng);
> The fact that it is already devm_* means that you shouldn't need to
> call it.

Okay, will remove the unnecessary calls.

Thanks,
Guoqing


