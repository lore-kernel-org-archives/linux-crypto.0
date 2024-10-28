Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA4D18BC3D;
	Mon, 28 Oct 2024 02:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730081027; cv=none; b=TlwDv3vnAVwc/3VBm+Yj0KfVsvI3LslOLhoq9cFmf25lpGvP/79P34SboJ0Ht2lSEMJZoWM6A3DebKPNBTIqlkH7eeZj/CWmczI1ke5HtbldsSkOHlyB2nXRAQz6XOEkhy8FKo+eUEFHHbCICdEXcB5GKBkSUKjDlI6YkN7QlRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730081027; c=relaxed/simple;
	bh=blrUG543I1S2tDgTmlh4Q4ciJj/I0eUv/11slpumQSw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Unu67pGS596welYFBlSsPhseOdVC6+Z7HYu/gh3usbzp8pAiWluy1fTRYU6wQOceL1LwVDzZ6NLD6irgb3atEbpdnlDJRxbQhk4uZMsSwWtT021217EE5TyQobOcn6bR3ypnmIPVMYGIpE0tRcrm+jA9zCsrum0lRHs2d5lnepk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XcGpd1lx2zpXN8;
	Mon, 28 Oct 2024 10:01:45 +0800 (CST)
Received: from kwepemk200007.china.huawei.com (unknown [7.202.194.73])
	by mail.maildlp.com (Postfix) with ESMTPS id 480721800D9;
	Mon, 28 Oct 2024 10:03:41 +0800 (CST)
Received: from [10.67.121.172] (10.67.121.172) by
 kwepemk200007.china.huawei.com (7.202.194.73) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 28 Oct 2024 10:03:40 +0800
Message-ID: <aef8c5ec-4dba-4ec0-9157-6c0e02608d57@hisilicon.com>
Date: Mon, 28 Oct 2024 10:03:40 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] crypto: hisilicon/sec2 - fix for aead icv error
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Chenghai Huang <huangchenghai2@huawei.com>, <davem@davemloft.net>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
References: <20241018105830.169212-1-huangchenghai2@huawei.com>
 <20241018105830.169212-2-huangchenghai2@huawei.com>
 <ZxyMnWbTkf7JEnT7@gondor.apana.org.au>
 <02e70357-1a3a-44f4-b25d-0e8e7f430cb6@hisilicon.com>
 <ZxyvT1PnY83Ilvyb@gondor.apana.org.au>
From: "linwenkai (C)" <linwenkai6@hisilicon.com>
In-Reply-To: <ZxyvT1PnY83Ilvyb@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemk200007.china.huawei.com (7.202.194.73)


在 2024/10/26 16:58, Herbert Xu 写道:
> On Sat, Oct 26, 2024 at 03:50:58PM +0800, linwenkai (C) wrote:
>> Hi, do you want me to remove this variable and use the old way to get the
>> authsize?
> The authsize parameter is meant to be constant throughout a single
> encryption/decryption operation.  So saving a copy of it for the
> duration of that operation makes no sense.
>
> What is the actual problem that you're trying to fix?
>
> Cheers,

Hi,

In earlier version, the authsize is set to the old mac_len during 
registration and it is the max value of the algorithm,

it leads to the hardware calculates a wrong mac when the authsize is not 
equal to the maximum.

Now, the driver gets the actual authsize from crypto_aead_authsize(), 
actx->authsize can reduce the number

of calling crypto_aead_authsize, because a lot of code uses this value.

Finally If you think the variable is not needed, I can delete it and use 
crypto_aead_authsize to get it every time.

Thanks.

