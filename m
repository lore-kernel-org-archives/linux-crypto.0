Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16FF37CD28
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 05:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786427019; cv=none; b=SKtGPogwn0phdJZ+Sd+b+cMnI76qFO5478XISXWLcHIxUTawRieYMOTQU0LafUBI1pYYVhLMGxWgWKNSCpWMtGbqX71UR8YZIRmBC2yK+W2dsi3yDsjnlvIf+aznXaGj578V9AaFlXp2mX2ahTB/2dWqjazatpfDAjm7FJPuCJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786427019; c=relaxed/simple;
	bh=wPpZD4LZBWQRM2iKn8wr9vITiwUreAJBuausKKOTH/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uTJOCoICDGaW6p9lDiHaAXoWPH+60bxIh+ePkCSAk5BMow9qOCOmDGagUpb6Lw4HR3joDQZ3yoP75IfxxH6zFRSqZOWZHg8F0JXLm74slicUydYGMkUrorZZCorYHsui/7cpM292mO0fdKLmIh+ExKcWyz93egHuZM+SOaechIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gNj9FnOq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oqDW8n3g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gNj9FnOq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oqDW8n3g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786427016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kXVmHoTiEI+YXfqh3vBCLgyHcwy9rlSMZjWkJIezcGM=;
	b=gNj9FnOqcEtT4s4fcJLw7xnDGIRtIfMutAWqtTSzaHhImIBPQugEMt7MhFEJA3znZvLiS7
	U21oLFR9JwZY73nrcDZE2rpvZ6U/ToIV4Okkw+8gt24EvZTT81gsN07wOgb+RY6LzFdQHE
	PwpL3/OIAeXKFhpV67mB/rCCfflYG+s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-9NtBKxRaOCu5m5aWdyltwg-1; Tue, 11 Aug 2026 01:43:22 -0400
X-MC-Unique: 9NtBKxRaOCu5m5aWdyltwg-1
X-Mimecast-MFC-AGG-ID: 9NtBKxRaOCu5m5aWdyltwg_1786427001
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4740be00302so2225683f8f.2
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 22:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786427001; x=1787031801; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kXVmHoTiEI+YXfqh3vBCLgyHcwy9rlSMZjWkJIezcGM=;
        b=oqDW8n3g4WGank4BI3+kp1sMa4aue4y0f+7vYJbugW+1wNacMeT6C8Ks5zS2QHJmPS
         lEpRcNCJzgnp/5M1pwPV6t4UZ2Sv1XNcdlHqEf4hX33DfV1i9mxetfX4h0ElzGln0Xkw
         sZBRf3QhzBW8JBTILwI+oNE4ABwr6IHO+F0/wiceRed71rSCTzZCX1tY3KGlysInL8GZ
         AGJ1/ZkByHWPaFutharbCi5ZrILMMinqp0ZbsezbB9GvjlzUb2Hws7Y+0o1f+AynkW7x
         +8TZov4giPguwD+P43hsYCpVVEzMstO7SHhulA5sSXWXsk2G7XafTAlfucFJ6sOA0nH+
         KREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786427001; x=1787031801;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kXVmHoTiEI+YXfqh3vBCLgyHcwy9rlSMZjWkJIezcGM=;
        b=HN7PScAhxN5bHeTI3VXCnUWA7O2wlNsqPsUWiFfGaILY0SDQ4+3ObR5ysBUGuWt3u1
         +/W3qgrFervNMmNxvl+sRyy1gFdYjPmyPoXedhq5e8HuvW8jGdK+GZ5CE6CbmcK03Q/G
         cEdH0+jpiXUjgUCOnTBq5o5Y1ItY6TSRgMGYpnTkF0F8NeBVNQTFED3siWlCtdfhMtrd
         1zWgwDpNBE4QkCU72lcEzEtHu2C7y0SM0JvsFAin8DyiF7kMI1LtJ47S3Bri0n90vWXz
         g0dlaSf8vi5XoOtqPHv56vBo88/o0mTLLhGVYfoeJqMeWd1CqV6s79iKe4OMa36Tx1bP
         thsA==
X-Forwarded-Encrypted: i=1; AHgh+Rq/w63uZfYgqgauy1NnZFA9A+tPuFmoN2s+puJ9z7PB11vh6PspRb13oFWlgZoRi3cljvupgv7EAXkgly4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJTWiSpWDUl6jPdQofDM89lUTiXxbWgIVmjJTV/VTlb6KMrUku
	/hnhwFHFnbPEaTqimDM2OAiyk72bArwTNL4xF2A3ili4EB80nXqEzUDdZnKLQfdVQOHwYwMsxfs
	oyN1TnSvh+DbQ1QmB6kbz/2WfB0sVEKNm8gLhOnMjmcSpQEUuTmKV+WGfHjc3qK0HNA==
X-Gm-Gg: AR+sD12NUzy6ExZKonaEv8B1RSmSF/JdhvMKD1Pok5VtXFPVD6jIam9AwpvDKFlnRRe
	22Ed7FNl+CXiQ8xbdB7IHexlno9/ElC7x9Z2FcI6GckBDcD5wYeg051i5rTCFUXxwkumdtqS/eh
	00veWSl1u2UsqsFc9x5YuGEdmUcaSy2CpgrUKFoIlvQy5ahRL6l1Je6Z1wxUSxnnskiAeWtqI+F
	nrR6FLsxpZH8Otujd8McMZXBILwIn+v7uu1DNY4vz3NdoCpM8L2YWuglz2ml1YuhbV7bIy6tj14
	8ThzbQozC0ybhUpjp6Q/ml/UXOslBga6+PfIcmZwp4Xuqmu6f/KFcKLLDPluKCmQG8CBNtzB
X-Received: by 2002:a5d:5c81:0:b0:47f:8480:4abd with SMTP id ffacd0b85a97d-4814aeec2aemr1116591f8f.29.1786427000980;
        Mon, 10 Aug 2026 22:43:20 -0700 (PDT)
X-Received: by 2002:a5d:5c81:0:b0:47f:8480:4abd with SMTP id ffacd0b85a97d-4814aeec2aemr1116554f8f.29.1786427000665;
        Mon, 10 Aug 2026 22:43:20 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.24])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a7165a3sm1369970f8f.26.2026.08.10.22.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 22:43:20 -0700 (PDT)
Message-ID: <a736b169-8803-4eb7-b23c-03ddbf46de44@redhat.com>
Date: Tue, 11 Aug 2026 07:43:18 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: s5p-sss: pass s5p_aes_dev to irq handler
To: Rosen Penev <rosenp@gmail.com>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, Vladimir Zapolskiy <vz@mleia.com>,
 "David S. Miller" <davem@davemloft.net>,
 "open list:SAMSUNG S5P Security SubSystem (SSS) DRIVER"
 <linux-samsung-soc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20260811043358.136042-1-rosenp@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260811043358.136042-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/08/2026 06.33, Rosen Penev wrote:
> The threaded irq handler takes the platform device and calls
> platform_get_drvdata() to recover the driver data.  Pass the driver
> data directly as the devm_request_threaded_irq() argument instead,
> dropping the platform_get_drvdata() call.
> 
> Assisted-by: opencode:deepseek-v4-flash-free
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>   drivers/crypto/s5p-sss.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index bdda7b39af85..f20c02e9d646 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -638,8 +638,7 @@ static int s5p_hash_rx(struct s5p_aes_dev *dev)
>   
>   static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
>   {
> -	struct platform_device *pdev = dev_id;
> -	struct s5p_aes_dev *dev = platform_get_drvdata(pdev);
> +	struct s5p_aes_dev *dev = dev_id;
>   	struct skcipher_request *req;
>   	int err_dma_tx = 0;
>   	int err_dma_rx = 0;
> @@ -2221,7 +2220,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>   	}
>   	err = devm_request_threaded_irq(dev, pdata->irq_fc, NULL,
>   					s5p_aes_interrupt, IRQF_ONESHOT,
> -					pdev->name, pdev);
> +					pdev->name, pdata);
>   	if (err < 0) {
>   		dev_warn(dev, "feed control interrupt is not available.\n");
>   		goto err_irq;

Reviewed-by: Thomas Huth <thuth@redhat.com>

