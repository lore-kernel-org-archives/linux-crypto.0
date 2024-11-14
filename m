Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216021FAEF1;
	Thu, 14 Nov 2024 12:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731588439; cv=none; b=jAMQIVGofSRDs4HrkFCKoSP5NCbI0ROjHoW0sSySUQ2QK8NiYKCoEQp8I9UQJ/zMRoRcLpdAcahLTeouMQt8E3aL+afA2R1/9pjdca66KWow66Mb2om9jB3VUKXro0jVDfm342bAvdfdImxiMJFThTFzx9eAHWcpfDVfOl3/nQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731588439; c=relaxed/simple;
	bh=DaeNh3V8A7sNYaGhQTiNRCHuFCp5y9qxRS8NBKYI9hM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uawTyFqw6+7ZTXRLM32ZaNl0gG0H1Dpmw04YvxZxN0QXkjSNGWDLleM1AEGkfHNjVDixLv79slAvZXS3bdyb4KNxcB6wKijnVrTg45kiTILD7en0gni6/3B4xEs+mPE7MNQzjdh6VxrPybSRoTii9XtM1z817LXQ/4WIcPEc9kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Xq0HN50PNz1T54P;
	Thu, 14 Nov 2024 20:45:20 +0800 (CST)
Received: from kwepemk200007.china.huawei.com (unknown [7.202.194.73])
	by mail.maildlp.com (Postfix) with ESMTPS id AB39F140153;
	Thu, 14 Nov 2024 20:47:12 +0800 (CST)
Received: from [10.67.121.172] (10.67.121.172) by
 kwepemk200007.china.huawei.com (7.202.194.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 14 Nov 2024 20:47:12 +0800
Message-ID: <b67cecd0-e50c-40bd-99b7-b85482e55696@hisilicon.com>
Date: Thu, 14 Nov 2024 20:47:11 +0800
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
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

I have found another setup for fallback in the sec_aead_param_check 
function, so I need to fix it right too.

The orignal code:

static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
{

         if (ctx->sec->qm.ver == QM_HW_V2) {
                 if (unlikely(!req->cryptlen || (!sreq->c_req.encrypt &&
                              req->cryptlen <= authsize))) {
                         ctx->a_ctx.fallback = true;
                         return -EINVAL;
                 }
         }
}

After the modification, I used a temporary variable fallback to save the 
state:

static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req 
*sreq, bool *fallback)
{

         if (ctx->sec->qm.ver == QM_HW_V2) {
                 if (unlikely(!req->cryptlen || (!sreq->c_req.encrypt &&
                              req->cryptlen <= authsize))) {
                         *fallback = true;
                         return -EINVAL;
                 }
         }
}

Same with  the sec_aead_spec_check function.

static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req 
*sreq, bool *fallback) {

         /* Hardware does not handle cases where authsize is less than 4 
bytes */
         if (unlikely(sz < MIN_MAC_LEN)) {
                 *fallback = true;
                 return -EINVAL;
         }

}

Do you think it is a better way?

Thanks,

