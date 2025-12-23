Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281FF1758B;
	Tue, 23 Dec 2025 01:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766454399; cv=none; b=SIvNKP6CncQVL9RfrE1lw4c+RTPpNQBvAZZOXJSlMbXMmm2xxuQoyv/PVnb+j3lvHPM924ZLFid54ojFz3wIk4AzE8rHcg1zklJ/HUfaeJGpSPvhHOkwDTE34p2QDMUoUnmVl6MoziQ3zAdGwDcq2TuK5Xssv51AECj8im3ZXO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766454399; c=relaxed/simple;
	bh=hCSMdRUmkfdljkcGOweHKmihno3/TCMzGpUDkPq10Ao=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Hw0ZFtv4iFrdQ/VFRQPVWAul1/4otbgrcm6AePWn+shEcs6fUuc/z9OCO3VwGKovO+zxXmhnxCA9cVHE/CITVAWk7eizC/5a+b3w2q37E0uCPp77Ng6QG3GtykOolchkd+ZEG6hmi67CgrzZ2S9Nl7kNqQVKKlt3xtLTgxfyomg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=NxwAzCG7; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="NxwAzCG7"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MNIJ7aJgF66Wvcfuj2QZg8E0oO/L+5983FBE+sXS0TQ=;
	b=NxwAzCG79tnmU1V/sE4gi2gNNChcj5oh8adQQG8HMXkUkYUUluFIk6xlz3NKVlFtkoUarJJIb
	L60GqYPw0jiJhBtXfwJ816G7qmNglzHA4Rm8GCsCVhhCA6NHZ+bq2vKYq45iIdxOIVyk5layL9x
	rR9XQxhLLv25vAEYbLcbcs8=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dZyTD38rWz1K98s;
	Tue, 23 Dec 2025 09:43:28 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 85CF04056C;
	Tue, 23 Dec 2025 09:46:32 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 23 Dec 2025 09:46:32 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 23 Dec 2025 09:46:31 +0800
Message-ID: <cde67fee-c90a-437e-a8be-a27865f8a2ed@huawei.com>
Date: Tue, 23 Dec 2025 09:46:31 +0800
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
	<linux-crypto@vger.kernel.org>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>
References: <20251120132124.1779549-1-huangchenghai2@huawei.com>
 <aUT3IW8vlYKwWDt2@gondor.apana.org.au>
 <9e9b2fc3-7d6b-4ac2-86fe-2d88fbd2ca44@huawei.com>
 <aUjHoK9DoVIJj6oP@gondor.apana.org.au>
From: huangchenghai <huangchenghai2@huawei.com>
Content-Language: en-US
In-Reply-To: <aUjHoK9DoVIJj6oP@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq200001.china.huawei.com (7.202.195.16)


在 2025/12/22 12:22, Herbert Xu 写道:
> On Mon, Dec 22, 2025 at 11:00:28AM +0800, huangchenghai wrote:
>> 在 2025/12/19 14:56, Herbert Xu 写道:
>>> On Thu, Nov 20, 2025 at 09:21:24PM +0800, Chenghai Huang wrote:
>>>> In qm_get_complete_eqe_num(), the function entry has already
>>>> checked whether the interrupt is valid, so the interrupt event
>>>> can be processed directly. Currently, the interrupt valid bit is
>>>> being checked again redundantly, and no interrupt processing is
>>>> performed. Therefore, the loop condition should be modified to
>>>> directly process the interrupt event, and use do while instead of
>>>> the current while loop, because the condition is always satisfied
>>>> on the first iteration.
>>>>
>>>> Fixes: f5a332980a68 ("crypto: hisilicon/qm - add the save operation of eqe and aeqe")
>>>> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
>>>> ---
>>>>    drivers/crypto/hisilicon/qm.c | 9 ++++-----
>>>>    1 file changed, 4 insertions(+), 5 deletions(-)
>>> Patch applied.  Thanks.
>> This patch addresses an issue specific to version 6.19.
>>
>> Could you please help including this patch in the 6.19?
> The patch looked like a clean-up rather than a bug fix.
>
> Could you please explain how it makes any difference at all?
>
> Thanks,

Commit f5a332980a68 ("crypto: hisilicon/qm - add the save operation of 
eqe and aeqe")

introduced an incorrect condition check, which prevents

the while loop from being entered to handle interrupt tasks.

Normally, the code should enter the while loop to process these tasks.


Chenghai

