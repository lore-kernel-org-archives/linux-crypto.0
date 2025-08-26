Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0074286D57;
	Tue, 26 Aug 2025 11:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208921; cv=none; b=hXBpKUaM4zRR2sQ/m3lLanXhPvtXrXir+yq7KqW6exHUirF1TvbPKwL//r0m7WCzVOyxoIvupYDu+FxaoOcpQ7jaqvPu0/w2ipBu5j6dvUhycGibtMZNAXs+LAQBLxg2EWvweijOcHDhBwiFrKszD8EdlYKEfsZKwjzsOCboC3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208921; c=relaxed/simple;
	bh=42pxmjwN5mCb+0AyK7e2qx6qwCHs3L8dSCXcC7dHO4U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=CEqNZM2N8gRUKtOXi5ZzMf+Ttmtz3A99UwoIIwvUSlvuMe9ZxNlcGnZ7z9cwv7IAa5HFyyYx+W2hw5HXyH7H1nd+l8Fp8NOekark4hw1hgcz2fY3zEb6jJfomjhnk1KRXZI2pE8AzMiB0k3i1g4jex5CY/JMm/ITMmoR/q+aw44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cB5R25mRHzPqfF;
	Tue, 26 Aug 2025 19:43:58 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D8DA8180064;
	Tue, 26 Aug 2025 19:48:34 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 26 Aug 2025 19:48:34 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 26 Aug 2025 19:48:34 +0800
Message-ID: <25abfbab-23da-4728-b245-9a8033e7a21a@huawei.com>
Date: Tue, 26 Aug 2025 19:48:33 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] crypto: hisilicon - add fallback function for
 hisilicon accelerater driver
From: huangchenghai <huangchenghai2@huawei.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>, <taoqi10@huawei.com>
References: <20250818065714.1916898-1-huangchenghai2@huawei.com>
 <aKvoPwhKyoVz8Yta@gondor.apana.org.au>
 <8896482c-c447-45f1-a59c-998a13119ece@huawei.com>
In-Reply-To: <8896482c-c447-45f1-a59c-998a13119ece@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200001.china.huawei.com (7.202.195.16)


On Tue, Aug 26, 2025 at 09:59 AM +0800, Herbert Xu wrote:
>
> 在 2025/8/25 12:36, Herbert Xu 写道:
>> On Mon, Aug 18, 2025 at 02:57:11PM +0800, Chenghai Huang wrote:
>>> Support fallback for zip/sec2/hpre when device is busy.
>>>
>>> V1: 
>>> https://lore.kernel.org/all/20250809070829.47204-1-huangchenghai2@huawei.com/
>>> Updates:
>>> - Remove unnecessary callback completions.
>>> - Add CRYPTO_ALG_NEED_FALLBACK to hisi_zip's cra_flags.
>>>
>>> Chenghai Huang (1):
>>>    crypto: hisilicon/zip - support fallback for zip
>>>
>>> Qi Tao (1):
>>>    crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware
>>>      queue unavailable
>>>
>>> Weili Qian (1):
>>>    crypto: hisilicon/hpre - support the hpre algorithm fallback
>>>
>>>   drivers/crypto/hisilicon/Kconfig            |   1 +
>>>   drivers/crypto/hisilicon/hpre/hpre_crypto.c | 314 
>>> +++++++++++++++++---
>>>   drivers/crypto/hisilicon/qm.c               |   4 +-
>>>   drivers/crypto/hisilicon/sec2/sec_crypto.c  |  62 +++-
>>>   drivers/crypto/hisilicon/zip/zip_crypto.c   |  52 +++-
>>>   5 files changed, 360 insertions(+), 73 deletions(-)
>> Are you mapping one hardware queue to a single tfm object?
> Yes, in our current implementation, each hardware queue is mapped
> to a dedicated tfm object.
>>
>> Hardware queues should be shared between tfm objects.
>>
>> Cheers,
> Thank you for your suggestion.
>
> We currently do not support sharing hardware queues between tfm
> objects. Our rationale is as follows:
> a) Queue multiplexing (allowing multiple tfms to share a queue)
> theoretically improves resource utilization. However, hardware
> resources are shared among all queues, and performance is also
> shared. Once the hardware reaches its physical limits, all new
> services can only queue up in the queue. Therefore, reuse will only
> make the queue longer, not increase processing speed, and instead
> increase business waiting latency. In cases of insufficient queues,
> it is better to directly fallback to software processing.
>
> In benchmark tests, only 16 queues or tfms are needed to achieve
> full hardware bandwidth performance.
>
> b) After a queue is initialized by a tfm, if a new tfm has a
> different algorithm from the original queue, it cannot share the
> queue. Queue reuse is limited by the type of tfm algorithm.
>
> Thanks
> Chenghai
Okay, we will decouple the hardware queue constraints from the
number of tfm to adapt to Crypto.

Thanks
Chenghai

>
>
