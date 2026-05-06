Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E5C30DD2F
	for <linux-crypto@vger.kernel.org>; Wed,  6 May 2026 08:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778057253; cv=none; b=IaEYYM07kXFd7aCoMMytzd7aO2uROiDnrWiXBLuKyrxxb92tB3G5/nLuv5GSLCM4QqWBSAW4m7pA78dUd3Hki107LBx6XIFyouSdh1b1YCf7TAzyBH8wwVVLPg4X5GnSxKV7dCUyHdlqQ19KldRyVkQMj5FSTsPaToWkxOIG3FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778057253; c=relaxed/simple;
	bh=pAYMlN9KjE0O8xKvhRva/kR3MhpvXMlcmOS5FFhLpWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F1cK3SOV/eExNZYbri551AvI6wryQRyXk9NkPYkzRErsDtizDGwI30cgxgRwEf1hXbf8Bxro065YMQQfHBs0ab9+ChLnTVHyl0U8ucRGWIRDC7zeaG9BIvwRZ4kd40Gs+yIOp2A1TPDiWOYd57ZB/DgUK5MAHBN625L2Uc6wWvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=k5FVrmd2; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="k5FVrmd2"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id F2B5DC5DC46;
	Wed,  6 May 2026 08:48:15 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id B04566053C;
	Wed,  6 May 2026 08:47:28 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DD8BA102F0D76;
	Wed,  6 May 2026 10:47:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778057247; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=TsRtcfCEb55BP+V2YMk7UzqaFZB34LOM1rDjqdG+OCE=;
	b=k5FVrmd2tOFdDv9egVzMCMy0yodjWKhwVWtUPPaZfthsqJ9/r9mcapvkyn7qAYlo0x5UC0
	gjI2EWMWDr1mQB72AhrA5VkxLemNiVhmjDmwM79ZdzRKoxN141hUlWzRzS3Jn5AbA5ztmn
	Y/i4He2bHL1e91cgLfC+Tn5ebjfGbFrjUrxB22oCgr2qfURbhw3Lq8+ctS68Q60j21ujyt
	mJZYtnjRngFXGPKB0OKAiHp/xKrP+8AeYk7KvSQ1/tQj0DWHNEgPEpCrJ1+4nB+TuY6aV1
	0cyPB6/8kKC61r/Ymqd6vJqzrNiUpyf7ZC+I6HWfn//XMalMvZiPlTOWiDlKZA==
Message-ID: <4720f1f5-9aae-449f-a80c-eb3808876c6f@bootlin.com>
Date: Wed, 6 May 2026 10:47:30 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] talitos: allocate channels with main struct
To: Herbert Xu <herbert@gondor.apana.org.au>, Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 open "list:KERNEL" HARDENING "(not" covered by other
 "areas):Keyword:b__counted_by(_le|_be)?b" <linux-hardening@vger.kernel.org>
References: <20260505073705.8810-1-rosenp@gmail.com>
 <afmo6sJlqbjCWd9A@gondor.apana.org.au>
Content-Language: en-US
From: Paul Louvel <paul.louvel@bootlin.com>
In-Reply-To: <afmo6sJlqbjCWd9A@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

FYI, all devices supported by the talitos driver has at least one channel.
The SEC1.2 (also called the SEC Lite) on the MPC885 SoC has one and only one 
crypto channel.

On 5/5/26 10:23 AM, Herbert Xu wrote:
> On Tue, May 05, 2026 at 12:37:05AM -0700, Rosen Penev wrote:
>> Use a flexible array member to combine allocations.
>>
>> Add __counted_by for extra runtime analysis.
>>
>> Signed-off-by: Rosen Penev <rosenp@gmail.com>
>> ---
>>   v2: add check for of_property_read_u32
>>   drivers/crypto/talitos.c | 19 +++++++------------
>>   drivers/crypto/talitos.h |  5 +++--
>>   2 files changed, 10 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
>> index bc61d0fe3514..e1f009684216 100644
>> --- a/drivers/crypto/talitos.c
>> +++ b/drivers/crypto/talitos.c
>> @@ -3409,14 +3409,20 @@ static int talitos_probe(struct platform_device *ofdev)
>>   	struct device *dev = &ofdev->dev;
>>   	struct device_node *np = ofdev->dev.of_node;
>>   	struct talitos_private *priv;
>> +	unsigned int num_channels;
>>   	int i, err;
>>   	int stride;
>>   	struct resource *res;
>>   
>> -	priv = devm_kzalloc(dev, sizeof(struct talitos_private), GFP_KERNEL);
>> +	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
>> +		num_channels = 0;
> Does this driver still work with zero channels? It should just fail
> the probe.
>
> Thanks,

-- 
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

