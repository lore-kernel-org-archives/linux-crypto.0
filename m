Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27A22110E
	for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2024 02:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729478425; cv=none; b=l293Dso2j5AGMJyXQP6JGJvQOic8UlUUlHwqkfQMna2yb+v/zW65RjLnmaicEX+g9AnzCJD5KSM4pG5H8PBNaqzM4+4eIB90x3RS104ahhueNiJSVwfyH8w+S9UsxPLVOMOwIlz36cTjAzILl7vkxTSN3ZZ+FLWMH+efkiyHu5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729478425; c=relaxed/simple;
	bh=6KUQovbrwqynnhoU99AxI3EF/r3gUF34rq3nkHnBdfg=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UT97gyNwpqTQmN1zQkCq/1k1e1zWib8P+1p2DJjDQ7r+mkEJ56BOEjyK4n86sl5PLZgIB7iR33DbeZxlIwLd/cBHIIMgnoVWQqsyyG3XBoYvvTCywRxoEsEO+E0FuOq/uykObAUj/KfOgCv28W9BccxO+YJnQqlzKjkk6d6XwZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XWzxz1V5RzpSsm;
	Mon, 21 Oct 2024 10:38:15 +0800 (CST)
Received: from kwepemk200016.china.huawei.com (unknown [7.202.194.82])
	by mail.maildlp.com (Postfix) with ESMTPS id A0723180105;
	Mon, 21 Oct 2024 10:40:12 +0800 (CST)
Received: from [10.67.108.122] (10.67.108.122) by
 kwepemk200016.china.huawei.com (7.202.194.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 21 Oct 2024 10:40:12 +0800
Subject: Re: [PATCH -next] crypto: testmgr - don't generate WARN for -EAGAIN
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Steffen Klassert <steffen.klassert@secunet.com>, <davem@davemloft.net>,
	<mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
	<lujialin4@huawei.com>, <linux-crypto@vger.kernel.org>, Daniel Jordan
	<daniel.m.jordan@oracle.com>
References: <20240802114947.3984577-1-yiyang13@huawei.com>
 <ZrG7zWxeXQn-Mkhn@gondor.apana.org.au> <ZrSZdQxeKaXVmi9E@gauss3.secunet.de>
 <ZrSbGs646zd20TBe@gauss3.secunet.de> <ZrSftdpqJnlxd7Gx@gondor.apana.org.au>
 <a47169a3-b357-8c8c-7c21-bf6cf1f61e5b@huawei.com>
 <Zr1ij_rbPicAc6-f@gondor.apana.org.au>
From: "yiyang (D)" <yiyang13@huawei.com>
Message-ID: <f384632a-54f2-f8dc-e596-b3830d73b175@huawei.com>
Date: Mon, 21 Oct 2024 10:40:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Zr1ij_rbPicAc6-f@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemk200016.china.huawei.com (7.202.194.82)


On 2024/8/15 10:06, Herbert Xu wrote:
> On Thu, Aug 15, 2024 at 09:25:39AM +0800, yiyang (D) wrote:
>>
>> Does this mean that the user needs to call the interface of the crypto layer
>> in this case? rather than requiring the kernel to handle this.
> 
> No it means that pcrypt should intercept the error and retry the
> request without going through padata.  Could you please redo the
> patch through pcrypt?
> 
> Thanks,
> 

Hi,Herbert,I sent the patch several days ago.
I don't know whether you have received it. I hope you have time to look
into it, and I am still looking forward to your reply.

patch:
https://lore.kernel.org/all/20241015020935.296691-1-yiyang13@huawei.com/

Best regards,
Yiyang
