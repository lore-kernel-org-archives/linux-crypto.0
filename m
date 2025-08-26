Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D9C286D57;
	Tue, 26 Aug 2025 11:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756209144; cv=none; b=JtIWK3OGwgLFZ7mlOJjSdSPugAvFcvWQme9+JEVV7lOYCBZb5h9QWz/SAdaaeV8mXawISt7m1YABwq1hLTW46RpfUFzXP4baQFL3U6DH4njE3tQi5uaMGYum52oeBqVextbmEu7DdvPk8AS8iZHCK6jiOIUt2n2IghYYujnv48w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756209144; c=relaxed/simple;
	bh=UxRslV8N+IUjhGxl2xF2jciS+lDT2rf6CQKBBq7NsTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BzLSYio4U23xwgBeW0O0lRSvCyX/l8/Ecx1cBk4gzT0M2+gNFNDsVpXteFaWGyfaQ8MHeTkwr0Yp6gg4YTTHWerIjHQX8IFr9iN/ehgKKM5ltulGQztAfXvwEszQP3SVA3x2O6rRHU7kqd4U8SXxzm2pWuw2P8jKEMOcwYOWQMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cB5WK60VdzPqh3;
	Tue, 26 Aug 2025 19:47:41 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 054C61400CD;
	Tue, 26 Aug 2025 19:52:18 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 26 Aug 2025 19:52:17 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 26 Aug 2025 19:52:17 +0800
Message-ID: <422b6648-6668-4f40-b79e-4611936576c6@huawei.com>
Date: Tue, 26 Aug 2025 19:52:16 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] crypto: hisilicon - add fallback function for
 hisilicon accelerater driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>, <taoqi10@huawei.com>
References: <20250818065714.1916898-1-huangchenghai2@huawei.com>
 <aKvoPwhKyoVz8Yta@gondor.apana.org.au>
 <8896482c-c447-45f1-a59c-998a13119ece@huawei.com>
 <aK0VAaqSLUVgMpbJ@gondor.apana.org.au>
From: huangchenghai <huangchenghai2@huawei.com>
In-Reply-To: <aK0VAaqSLUVgMpbJ@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200001.china.huawei.com (7.202.195.16)


On Tue, Aug 26, 2025 at 09:59 AM +0800, Herbert Xu wrote:
> On Mon, Aug 25, 2025 at 09:00:37PM +0800, huangchenghai wrote:
>> We currently do not support sharing hardware queues between tfm
>> objects. Our rationale is as follows:
>> a) Queue multiplexing (allowing multiple tfms to share a queue)
>> theoretically improves resource utilization. However, hardware
>> resources are shared among all queues, and performance is also
>> shared. Once the hardware reaches its physical limits, all new
>> services can only queue up in the queue. Therefore, reuse will only
>> make the queue longer, not increase processing speed, and instead
>> increase business waiting latency. In cases of insufficient queues,
>> it is better to directly fallback to software processing.
>>
>> In benchmark tests, only 16 queues or tfms are needed to achieve
>> full hardware bandwidth performance.
>>
>> b) After a queue is initialized by a tfm, if a new tfm has a
>> different algorithm from the original queue, it cannot share the
>> queue. Queue reuse is limited by the type of tfm algorithm.
> Sorry but this is not acceptable.  The number of tfms are meant
> to be large.  If your driver isn't able to support that then it
> should be just deleted.
>
> Thanks,
Okay, we will decouple the hardware queue constraints from the
number of tfm to adapt to Crypto.

Thanks
Chenghai
