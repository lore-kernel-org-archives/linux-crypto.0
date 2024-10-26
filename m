Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779D72CA8;
	Sat, 26 Oct 2024 07:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729929068; cv=none; b=HAGQB5PNtG7wfDDzPoDVE8gQirWmNBSdKxl1IBpDyf0yXiNduTA1KdGvo+1dHLwYt1WYtwavZLY4Yu+Rc8MMLMEvGFgz+h1chgJfhGjc8ukdkjIYaiykI8MXBKHnBVtcL7VvOKwsLQEhKZP3QY9fJX7PTzy19mB9tofeIq6IKYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729929068; c=relaxed/simple;
	bh=JxWokorK50CojRa0tazDi2p30f2MypeWqqtGdL9phkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eBBxsHEfojYmd9FC1vFktUgIImqIy+4LV5ZzxhAzV5Ks2ke5r/TdstOXiexTaQLhdJhoj+114UAW55wv6MIpeFbC/tqV+w3afM70Vghtc9VL2rjeNc6+xgg3tfHKAfl/y3FZVByriSVOjyn7IvR7a4zcWUNdYLh7/BFaPDPBJ90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XbBch6b5zzyTlG;
	Sat, 26 Oct 2024 15:49:24 +0800 (CST)
Received: from kwepemk200007.china.huawei.com (unknown [7.202.194.73])
	by mail.maildlp.com (Postfix) with ESMTPS id 8868F1800DB;
	Sat, 26 Oct 2024 15:50:59 +0800 (CST)
Received: from [10.67.121.172] (10.67.121.172) by
 kwepemk200007.china.huawei.com (7.202.194.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 26 Oct 2024 15:50:58 +0800
Message-ID: <02e70357-1a3a-44f4-b25d-0e8e7f430cb6@hisilicon.com>
Date: Sat, 26 Oct 2024 15:50:58 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] crypto: hisilicon/sec2 - fix for aead icv error
To: Herbert Xu <herbert@gondor.apana.org.au>, Chenghai Huang
	<huangchenghai2@huawei.com>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <liulongfang@huawei.com>,
	<shenyang39@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>
References: <20241018105830.169212-1-huangchenghai2@huawei.com>
 <20241018105830.169212-2-huangchenghai2@huawei.com>
 <ZxyMnWbTkf7JEnT7@gondor.apana.org.au>
From: "linwenkai (C)" <linwenkai6@hisilicon.com>
In-Reply-To: <ZxyMnWbTkf7JEnT7@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemk200007.china.huawei.com (7.202.194.73)


在 2024/10/26 14:30, Herbert Xu 写道:
> On Fri, Oct 18, 2024 at 06:58:29PM +0800, Chenghai Huang wrote:
>> @@ -911,10 +910,8 @@ static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
>>   		return -EINVAL;
>>   	}
>>   	if (!c_req->encrypt && ctx->alg_type == SEC_AEAD) {
>> -		tfm = crypto_aead_reqtfm(aead_req);
>> -		authsize = crypto_aead_authsize(tfm);
>> -		mac_offset = qp_ctx->res[req_id].pbuf + copy_size - authsize;
>> -		memcpy(a_req->out_mac, mac_offset, authsize);
>> +		mac_offset = qp_ctx->res[req_id].pbuf + copy_size - a_ctx->authsize;
>> +		memcpy(a_req->out_mac, mac_offset, a_ctx->authsize);
> You've lost me.  a_ctx->authsize is set to the value of
> crypto_aead_authsize(tfm).  In other words nothing has changed.
> What am I missing?
>
>> @@ -2356,10 +2331,12 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
>>   	struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
>>   	struct sec_req *req = aead_request_ctx(a_req);
>>   	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
>> +	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
>>   	int ret;
>>   
>>   	req->flag = a_req->base.flags;
>>   	req->aead_req.aead_req = a_req;
>> +	a_ctx->authsize = crypto_aead_authsize(tfm);
>>   	req->c_req.encrypt = encrypt;
>>   	req->ctx = ctx;
> Cheers,

Hi, do you want me to remove this variable and use the old way to get 
the authsize?

The variable is added to make code simple and to reduce some function calls.

Thanks.

