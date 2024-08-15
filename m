Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5EF36D
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 01:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723685145; cv=none; b=oCJbSvQYHvk6XQ1a5mYd5fl2yOxBKMLc68CYlUodgPHplfsLcFKhWNxPt+8uM73S/wJ0ncjVkMahE+ISuSRIGUuVNHeEC9Jez+EuytQ/u5WVwiIZMtgp05NYnStvT/KVKbsM0MoPr5WFwHGaOrczsJm8ekEYhVn42xdrKVoOqmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723685145; c=relaxed/simple;
	bh=oyd6ELh+eQPVk5pzvSn05EbP2cDeBFmhW72WozBUkQo=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BNaVm7VGacBn90hMuUN1m4mXUj6DzS/H6VCaLpge3K9c329WdyYJJmj5lTERZObF2o998uUklsR00mFbpMkElFsm0M2DP5pNB7Waz+ktKcat4P+K57IJNMDfp73iB7sBmz2iWqUGeeX7h6sBDJ/EnbY6Hq8Qza6hSAJLR/ORZ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WknSt5Zt5zhXlY;
	Thu, 15 Aug 2024 09:23:42 +0800 (CST)
Received: from kwepemm600014.china.huawei.com (unknown [7.193.23.54])
	by mail.maildlp.com (Postfix) with ESMTPS id 481B8140155;
	Thu, 15 Aug 2024 09:25:40 +0800 (CST)
Received: from [10.67.111.5] (10.67.111.5) by kwepemm600014.china.huawei.com
 (7.193.23.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 15 Aug
 2024 09:25:39 +0800
Subject: Re: [PATCH -next] crypto: testmgr - don't generate WARN for -EAGAIN
To: Herbert Xu <herbert@gondor.apana.org.au>, Steffen Klassert
	<steffen.klassert@secunet.com>
CC: <davem@davemloft.net>, <mcoquelin.stm32@gmail.com>,
	<alexandre.torgue@foss.st.com>, <lujialin4@huawei.com>,
	<linux-crypto@vger.kernel.org>, Daniel Jordan <daniel.m.jordan@oracle.com>
References: <20240802114947.3984577-1-yiyang13@huawei.com>
 <ZrG7zWxeXQn-Mkhn@gondor.apana.org.au> <ZrSZdQxeKaXVmi9E@gauss3.secunet.de>
 <ZrSbGs646zd20TBe@gauss3.secunet.de> <ZrSftdpqJnlxd7Gx@gondor.apana.org.au>
From: "yiyang (D)" <yiyang13@huawei.com>
Message-ID: <a47169a3-b357-8c8c-7c21-bf6cf1f61e5b@huawei.com>
Date: Thu, 15 Aug 2024 09:25:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZrSftdpqJnlxd7Gx@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600014.china.huawei.com (7.193.23.54)


On 2024/8/8 18:36, Herbert Xu wrote:
> On Thu, Aug 08, 2024 at 12:16:58PM +0200, Steffen Klassert wrote:
>>
>> Maybe pcrypt can call the crypto layer directly without
>> parallelization in that case.
> 
> Yes that should work.
> 
> Thanks,
> 
Does this mean that the user needs to call the interface of the crypto 
layer in this case? rather than requiring the kernel to handle this.

Thanks,
-- 
