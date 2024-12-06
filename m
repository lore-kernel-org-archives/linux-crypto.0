Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F2128684;
	Fri,  6 Dec 2024 02:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733451233; cv=none; b=PgShgm/52Kvmr1Ciqb5mWYIG2DUNh0lXd/C4a0OLws9jdiBaTH8f1pN73JlexEQp85Z8FGk/dLCVMPWW4lWMDCDyrmlUm6ZDGhpVKBFBjMIMcKyur4hxkdSZdXQ2h3eej2Nj7aoEEoJMcWkhwAdtUNplQh8yb745W/49SdmuJv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733451233; c=relaxed/simple;
	bh=PVniwpOcdArUCZ5TUc82rVqQYAAKx7gKjsdXlFcW2UA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=K3QPBX/41cMBzWB3eU0dI3LoX0j12obHe6XnRXCEZZIMkvzJC1MRIVFFN/U+S1c5z+ANGHk5wKXp2bLv9g+QLBByruXcoWPBzMD/PrViPRPBLzoX6NADrfpv8PCwBsFDeOB+BHZu/2tEHcEJHzukyHaqGhOu6eQtr/UBBOBf0bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y4F9s1Vm1z1kvSs;
	Fri,  6 Dec 2024 10:11:29 +0800 (CST)
Received: from kwepemd100013.china.huawei.com (unknown [7.221.188.163])
	by mail.maildlp.com (Postfix) with ESMTPS id EFCBD140136;
	Fri,  6 Dec 2024 10:13:47 +0800 (CST)
Received: from [10.67.109.79] (10.67.109.79) by kwepemd100013.china.huawei.com
 (7.221.188.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 6 Dec
 2024 10:13:47 +0800
Message-ID: <28357e74-88d3-4382-ab2e-4058de185a18@huawei.com>
Date: Fri, 6 Dec 2024 10:13:46 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] padata: add pd get/put refcnt helper
To: Daniel Jordan <daniel.m.jordan@oracle.com>, Chen Ridong
	<chenridong@huaweicloud.com>
CC: <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wangweiyang2@huawei.com>
References: <20241123080509.2573987-1-chenridong@huaweicloud.com>
 <20241123080509.2573987-2-chenridong@huaweicloud.com>
 <pr7mhqz6twrtnlgy2nphr2nznk747tymlnooxab7xvvgolykmt@lr4z2a72tqur>
Content-Language: en-US
From: chenridong <chenridong@huawei.com>
In-Reply-To: <pr7mhqz6twrtnlgy2nphr2nznk747tymlnooxab7xvvgolykmt@lr4z2a72tqur>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd100013.china.huawei.com (7.221.188.163)



On 2024/12/6 7:03, Daniel Jordan wrote:
> On Sat, Nov 23, 2024 at 08:05:08AM +0000, Chen Ridong wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> Add helpers for pd to get/put refcnt to make code consice.
> 
> Seems reasonable.
> 
>> +static inline void padata_put_pd(struct parallel_data *pd)
>> +{
>> +	if (refcount_dec_and_test(&pd->refcnt))
>> +		padata_free_pd(pd);
>> +}
>> +
>> +static inline void padata_put_pd_cnt(struct parallel_data *pd, int cnt)
>> +{
>> +	if (refcount_sub_and_test(cnt, &pd->refcnt))
>> +		padata_free_pd(pd);
>> +}
> 
> padata_put_pd could be defined as padata_put_pd_cnt(pd, 1).
> 

Thank you, will update.

Best regards,
Ridong
