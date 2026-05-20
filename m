Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F93D3C13F5;
	Wed, 20 May 2026 09:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779269280; cv=none; b=XjbsQkgl0M6uj9XV2Tc2C5hHPGk5rp0q5sPCAi9icgF03/LCxH6cCTYu3777JEb+xQINbknwLrcZiUnJSYuWJhQ43ycpbJ8HwYY2KwY/QjNdJgCaPeX495fmbSRv5YtpUz2Y5WhWYGuEyXBmAn/ZfkDo3gUX1r6er+cFvFOkDaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779269280; c=relaxed/simple;
	bh=HqRnGj9pHYgkYz2cPo50Qp+9boGxEaEYcq86laIGxig=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pypICJwcA2jBPaFXzskp6K33hCQ4MclWFnoU+yZlCyuQCIpoHNBdFXXKHMOE+1Yi4z1ADThI5ZD0tCosswhROsOEbQjbNhAVT8RGGU2ltaYbeqqS78Fd+xcBhyXsCT+GYDhZaRYLV2oXq4UWjH9/EtB7C8hYdyQDj/gBTE9MW10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=njaoBSIf; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="njaoBSIf"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AJzAIdbcXZvGZB9XVraw+KEoFqT40VVuS6P5oWkz4fo=;
	b=njaoBSIf+rNhk9oNnWeeGH5Zb6nDen8ch7kBGjbWVpPDkMA5QuP2KVPTBv9sdm0bjbGw0CUQZ
	9KWaVLFImdOgvKkD1P6o+DGPlZd1A8tZdnB72awr79lonw3YK/b4KK0aPY9rNH13aVy0ygryiTe
	9Kv2IoVGA9MFxaUVB4bKSGo=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gL5bv4Z8zzcbR9;
	Wed, 20 May 2026 17:20:11 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id AA9CB40538;
	Wed, 20 May 2026 17:27:45 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 20 May 2026 17:27:45 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 20 May 2026 17:27:45 +0800
Message-ID: <7039be8e-a94f-4356-b981-6ec06bc467a5@huawei.com>
Date: Wed, 20 May 2026 17:27:44 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: hisilicon/sec2 - lower priority for hisilicon
 crypto implementations
To: Eric Biggers <ebiggers@kernel.org>, liulongfang <liulongfang@huawei.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>
References: <20260511004927.3469951-1-huangchenghai2@huawei.com>
 <fe78b23b-37bb-5995-94b5-64fcf9578722@huawei.com>
 <20260520013240.GC1875993@google.com>
From: huangchenghai <huangchenghai2@huawei.com>
Content-Language: en-US
In-Reply-To: <20260520013240.GC1875993@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200001.china.huawei.com (7.202.195.16)


在 2026/5/20 9:32, Eric Biggers 写道:
> On Wed, May 20, 2026 at 09:22:49AM +0800, liulongfang wrote:
>> On 2026/5/11 8:49, Chenghai Huang wrote:
>>> From: lizhi <lizhi206@huawei.com>
>>>
>>> Lower the priority of HiSilicon's crypto implementations to allow more
>>> suitable alternatives to be selected. For example, certain kernel
>>> use-cases do not benefit from HiSilicon's symmetric crypto algorithms.
>>> This change ensures that more appropriate options are chosen first while
>>> retaining HiSilicon's implementations as alternatives.
>>>
>>> Signed-off-by: lizhi <lizhi206@huawei.com>
>>> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
>>> ---
>>>   drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>>> index 2471a4dd0b50..77e0e03cbcab 100644
>>> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
>>> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>>> @@ -20,7 +20,7 @@
>>>   #include "sec.h"
>>>   #include "sec_crypto.h"
>>>   
>>> -#define SEC_PRIORITY		4001
>>> +#define SEC_PRIORITY		80
>>>   #define SEC_XTS_MIN_KEY_SIZE	(2 * AES_MIN_KEY_SIZE)
>>>   #define SEC_XTS_MID_KEY_SIZE	(3 * AES_MIN_KEY_SIZE)
>>>   #define SEC_XTS_MAX_KEY_SIZE	(2 * AES_MAX_KEY_SIZE)
>>>
>> Reviewed-by: Longfang Liu <liulongfang@huawei.com>
> Makes sense, but perhaps this driver should just be removed entirely?
>
> - Eric
>
Hi Eric,

Thanks for the review.
We still have use cases to keep the driver.

1.Lowering the priority frees up hardware acceleration resources for 
targeted commercial use cases like storage encryption.
2.On old version of Kunpeng storage server, crypto instruction 
extensions may not be available, or the supported algorithm sets are 
limited. In these environments, users still use the HiSilicon hardware 
accelerator for encryption. Completely removing the driver would break 
support for those deployments.
3.Make the driver an optional backup, like QAT.

Best regards,
Chenghai
