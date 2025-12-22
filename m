Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B4231C567;
	Mon, 22 Dec 2025 03:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766374592; cv=none; b=sI3LjRlOomFVraKWAzLtJ7PEADEgkYWzkJj5YLAuIlAvgThhFxNgqqepfAdj0bnzPfKN6rsy/YHi1D9Q2jsyw6mRruiTV4bPgSwwY/r8rfKLZ2+IL9/W1506k8oEsd6eBTiF+f3cmBmy1B4D+zmXprAC7m4JN/1mAieqnD+dAes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766374592; c=relaxed/simple;
	bh=s8OJK+q7MwhQy/hFbJmZqn2KZJ3KyhtW1x8VG/XzYMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MPKPvN+zfzZ4UtP5u23PZP09PKXuhbrAuaGWvZnvRASPfy2gQiyOqMG4wtz7+KCMc1tpzgkSXU9ONfXkYIAcFphLowlWwp5btBNMCcopfPnwRD3T/7dm6g8SRh5eeeWsJMYv+WX5Cpx6l45hZsR4I/+UX5CP8qLow+wajUmlHro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=NXHo/Hjp; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="NXHo/Hjp"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IkRFKaiWt3I8LjktGWnB3Up4swONT50V3dXB+lQbbDA=;
	b=NXHo/HjpPotrQSzTlLMRlxrqJhzTffLMshe+IJ1zIrmtV7Qu8BwEcPjsG1QtJVKHFI6ywKb3N
	FjtISltLNuZ11kBtezxtyiMYfJOcpxVxMB3E4s1SSSZypdayQPqNGW54pXw1K8U1IaFd5DcD8AA
	WFX82W1Wj3XG88bBCFug/r4=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dZNzQ5xpTz12LCr;
	Mon, 22 Dec 2025 11:34:10 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D283B4036C;
	Mon, 22 Dec 2025 11:36:21 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 11:36:21 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 11:36:20 +0800
Message-ID: <1b60e2e2-ad38-40e2-8e15-bb37f1fabd0c@huawei.com>
Date: Mon, 22 Dec 2025 11:36:20 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] crypto: hisilicon/trng - support tfms sharing the
 device
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <fanghao11@huawei.com>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<wangzhou1@hisilicon.com>
References: <20251120135812.1814923-1-huangchenghai2@huawei.com>
 <20251120135812.1814923-3-huangchenghai2@huawei.com>
 <aUTBQjke3PxSREAu@gondor.apana.org.au>
From: huangchenghai <huangchenghai2@huawei.com>
Content-Language: en-US
In-Reply-To: <aUTBQjke3PxSREAu@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200001.china.huawei.com (7.202.195.16)


在 2025/12/19 11:06, Herbert Xu 写道:
> On Thu, Nov 20, 2025 at 09:58:12PM +0800, Chenghai Huang wrote:
>> +static int hisi_trng_reseed(struct hisi_trng *trng)
>> +{
>> +	u8 seed[SW_DRBG_SEED_SIZE];
>> +	int size;
>>   
>> -	return ret;
>> +	/* Allow other threads to acquire the lock and execute their jobs. */
>> +	mutex_unlock(&trng->lock);
>> +	mutex_lock(&trng->lock);
> If we have a bunch threads doing generate, then they will all hit
> reseed and end up here for no reason at all.
>
> If you want to stop one thread from hogging the lock, perhaps move
> it inside the read loop in hisi_trng_generate?
>
> Cheers,

Okay, I will move the lock inside the read loop in hisi_trng_generate.


Thanks,

Chenghai

