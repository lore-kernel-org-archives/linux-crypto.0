Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216B8405F7;
	Mon, 22 Dec 2025 03:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766372441; cv=none; b=jQm8ADHhd4I0YORTrjCXfyahHqhGf43uhQUZCkwGRKdFCwtDIgxdjnoD8Ov7ZWO14C4DAoa2XSzazwCth7x1MSQLqrTMX1pV9WyfXmmRqbURn+H+13wHDDALhPJzvs51lq/KfH/GkN2DLL1ApxNIt4w8qzz0GCdswujy5II4WLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766372441; c=relaxed/simple;
	bh=hDACPD6nTBY7R6Px9IJuK/LfOdhsEzGAA6VX2R19zQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=bHiEowMgAVkO7S6rhnOTWfQhsZYQXVisKWYCOGEhtoxLNepe4k/dO0qlKn6xxeBKv86d2ploihSxRqxAEXqPqo/Kq2CDVNDLRWKQatdSicdyNs0SUcb+f1b89xPD+80FdAXAbPuIYZxB7HCJ+PZCxYTmwTFxJD/h0rKHNcm5e9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=xseO0kNE; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="xseO0kNE"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Mf8XNBMqR878Avl5oyv/T0x34r+V31MxkRxyYqzGmDA=;
	b=xseO0kNEyVtWzPK6+bMa7Fb8XsS1rh9gKY/hqLZMtW5ydxvcGv8kF1lW6Fp/q+Ngz1TXY7Ex6
	OW6fVgng/S/ZLdMblPRqkm91KZF8D2xrMEMDET0lk+I+uESpr/vTsEqPRdqod2RW/Z34xEk4SNK
	/tl50e+fPlTZfy9H5y9Rx/A=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dZN8z3FfKzKm5N;
	Mon, 22 Dec 2025 10:57:23 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id AEA7E40565;
	Mon, 22 Dec 2025 11:00:29 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 11:00:29 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 11:00:28 +0800
Message-ID: <9e9b2fc3-7d6b-4ac2-86fe-2d88fbd2ca44@huawei.com>
Date: Mon, 22 Dec 2025 11:00:28 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: hisilicon/qm - fix incorrect judgment in
 qm_get_complete_eqe_num()
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linuxarm@openeuler.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<wangzhou1@hisilicon.com>
References: <20251120132124.1779549-1-huangchenghai2@huawei.com>
 <aUT3IW8vlYKwWDt2@gondor.apana.org.au>
From: huangchenghai <huangchenghai2@huawei.com>
Content-Language: en-US
In-Reply-To: <aUT3IW8vlYKwWDt2@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200001.china.huawei.com (7.202.195.16)


在 2025/12/19 14:56, Herbert Xu 写道:
> On Thu, Nov 20, 2025 at 09:21:24PM +0800, Chenghai Huang wrote:
>> In qm_get_complete_eqe_num(), the function entry has already
>> checked whether the interrupt is valid, so the interrupt event
>> can be processed directly. Currently, the interrupt valid bit is
>> being checked again redundantly, and no interrupt processing is
>> performed. Therefore, the loop condition should be modified to
>> directly process the interrupt event, and use do while instead of
>> the current while loop, because the condition is always satisfied
>> on the first iteration.
>>
>> Fixes: f5a332980a68 ("crypto: hisilicon/qm - add the save operation of eqe and aeqe")
>> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
>> ---
>>   drivers/crypto/hisilicon/qm.c | 9 ++++-----
>>   1 file changed, 4 insertions(+), 5 deletions(-)
> Patch applied.  Thanks.

This patch addresses an issue specific to version 6.19.

Could you please help including this patch in the 6.19?


Thanks,
Chenghai
