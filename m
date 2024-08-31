Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DF418EB1
	for <linux-crypto@vger.kernel.org>; Sat, 31 Aug 2024 01:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725069308; cv=none; b=NuDart7g9o9Go+rTkawgdMHr6Skc8PoZZYMstu3Xw4RUguC0I50VHjlxmOLA47+h/+j6ZjcFqnQ0hkqUIitFBczVN7181quWVY9Lh2bVs6hNGX8J5wcGlRUogSx/k6wgREier3SNxw+xJ4sOCET1MqbRlIajD/ibg+cKkk5WWBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725069308; c=relaxed/simple;
	bh=/49X5HIHx087L2R2KETHVO8tqiYMe4EHx3xXIfbEJN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=D6JJBPg68MFaaeFr3TfZyt3jrr9WKc55nm0d7SAJfXSlS4+Q5SJ9ykGZT965Xs6G15v+wA4wwyTqjMZOCt+G3M1Fo2IASomJ2KBQ8Gs5/eY4vH/HoOUjaQwDR1e5Rpzg6O0i1JUZfr3ZbyGiQiqt2vNYM6lYpAeDDdTnKfbCJh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WwdPM2NYmz1S9W0;
	Sat, 31 Aug 2024 09:54:47 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 9F205140109;
	Sat, 31 Aug 2024 09:55:02 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 31 Aug 2024 09:55:02 +0800
Message-ID: <41e37215-2e03-4ac2-9420-8b3370e60a06@huawei.com>
Date: Sat, 31 Aug 2024 09:55:01 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] crypto: Remove unused parameter from macro ROLDQ
Content-Language: en-US
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
References: <20240823065707.3327267-1-lihongbo22@huawei.com>
 <ZtGbKYhHXQWBQbbM@gondor.apana.org.au>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <ZtGbKYhHXQWBQbbM@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/8/30 18:12, Herbert Xu wrote:
> On Fri, Aug 23, 2024 at 02:57:07PM +0800, Hongbo Li wrote:
>> The parameter w1 is not used in macro ROLDQ, so we can
>> remove it to simplify the code.
>>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>> ---
>>   crypto/camellia_generic.c | 42 +++++++++++++++++++--------------------
>>   1 file changed, 21 insertions(+), 21 deletions(-)
> 
> I don't think the churn caused by this change is worth it.
> 
Although it seems a bit risky, the new code does not have to consider 
passing in unnecessary arguments when using the ROLDQ macro. Of course, 
I'm not sure if there will be other new places using it.

Thanks,
Hongbo

> Cheers,
