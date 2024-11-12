Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D72BE6C;
	Tue, 12 Nov 2024 02:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731379633; cv=none; b=ROoZ5GFnrv4o1wbhdvQ4eA+7jfthfzfOHXVvqjY0JPoKU5xyvMRsDXeLMtd7mWbyq3LEQEZzwbJ2Pc75LX+ZRMtFWalUPI+juBnXevSAJXFF/zdc2sTlKHyqIgUNcLxZONLk8JrmNROd7HMVI6Hm91ZGYljWjMkDD6atc+3Bsuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731379633; c=relaxed/simple;
	bh=OjJ2uYF8uRzDJLybvAfY5ze80pNjP7y672YZlhvuFgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=V8UlKpWogiVle8SvQnLun3mbm4Hc5ynyK/YsqW8+IMDWZFkMV4gwiKvKmPAGDRVJZxMnxrLkJLgD3huAZ2T5TT1E7IPWXjrmuuhsHbPm7E7YFpXjz9SX1QpRU7w2mxMZ8rNaqaxwkDp/CTA7+CWtRsTbwuH2IeIsqBjU+alorJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XnW3r0Vr9z1hwR4;
	Tue, 12 Nov 2024 10:45:12 +0800 (CST)
Received: from kwepemk200007.china.huawei.com (unknown [7.202.194.73])
	by mail.maildlp.com (Postfix) with ESMTPS id EA9E014010D;
	Tue, 12 Nov 2024 10:47:00 +0800 (CST)
Received: from [10.67.121.172] (10.67.121.172) by
 kwepemk200007.china.huawei.com (7.202.194.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 Nov 2024 10:47:00 +0800
Message-ID: <d141b2a6-6c7c-4640-a301-858c9d8d0b03@hisilicon.com>
Date: Tue, 12 Nov 2024 10:46:59 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] crypto: hisilicon/sec2 - fix for aead invalid
 authsize
To: Herbert Xu <herbert@gondor.apana.org.au>, Chenghai Huang
	<huangchenghai2@huawei.com>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <wangzhou1@hisilicon.com>
References: <20241102025559.2256734-1-huangchenghai2@huawei.com>
 <20241102025559.2256734-3-huangchenghai2@huawei.com>
 <ZzAqQhiebKSuRzOm@gondor.apana.org.au>
From: "linwenkai (C)" <linwenkai6@hisilicon.com>
In-Reply-To: <ZzAqQhiebKSuRzOm@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemk200007.china.huawei.com (7.202.194.73)


在 2024/11/10 11:36, Herbert Xu 写道:
> On Sat, Nov 02, 2024 at 10:55:59AM +0800, Chenghai Huang wrote:
>> @@ -2226,15 +2236,15 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
>>   	struct device *dev = ctx->dev;
>>   	int ret;
>>   
>> -	if (unlikely(req->cryptlen + req->assoclen > MAX_INPUT_DATA_LEN ||
>> -	    req->assoclen > SEC_MAX_AAD_LEN)) {
>> -		dev_err(dev, "aead input spec error!\n");
>> +	/* Hardware does not handle cases where authsize is less than 4 bytes */
>> +	if (unlikely(sz < MIN_MAC_LEN)) {
>> +		ctx->a_ctx.fallback = true;
> This is broken.  sec_aead_spec_check is a per-request function,
> called without any locking.  Therefore it must not modify any
> field in the tfm context (at least not without additional locking),
> because multiple requests can be issued on the same tfm at any time.
>
> I suppose for this field in particular you could move it to
> set_authsize and there it would be safe to change the tfm context.
>
> Cheers,
Hi,
Thanks for your advice, it's better to move the setup to set_authsize, I 
will send a new patchset soon.
