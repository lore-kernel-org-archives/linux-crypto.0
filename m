Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E61238C16;
	Wed, 19 Aug 2026 06:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787122060; cv=none; b=nDgILrRqd1UI6AJmkYP2yK28J06IN3ID7xktPpVEIn35Eay3XWoVyN/sGCwLRfUCecpAScE7YjAzWz75kb3rBHul4jRPqCb7Z7KYc5YZKAQoDsEugv617gN3AmgGRYYipswDKd4QmjktZm7Ncq9PmSyK0XGPN+LRH+hoBVMmznk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787122060; c=relaxed/simple;
	bh=ancBZ0V6gZq2ALyH1Xxti+Pia3qxuL02ebH14vEmz4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qvdKffxAsGzbNJmZ1mxFl5RDejtruZeI0qt/2y7kOnzEjZOiEO0xEghHImTi1kJskcmC+Us5dPos17oIrSLnhWOESOzxlawVrHv8D0psEpbGYXYM2vYrEAqkU3xNmxyEUJvGfcTbU35ns9qYDLDgkf99dcB+GIOVkfhnLH3afOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Hh09aXj+; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Hh09aXj+"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=L5sSXGFSooViMyOMYqDPhme/w/XhisXJSB/05zbqMU4=;
	b=Hh09aXj+3qtIFkmiNlMkTcwrRp7nQvUyzOlbmruHC5j37w7uKX1EHWWiomvub6a5fGkan0tvr
	j+6H+9MakSUfaiX23+Hngpp3XBj8Mkkm8PTuUc5IA4rhObDM2e9jqTzXZe9aLjs4t496bM5e7F4
	81Y0RA7iE1yymBdHGDcACU4=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hPxgj3QFwz12LGB;
	Wed, 19 Aug 2026 14:37:05 +0800 (CST)
Received: from whupemk200001.china.huawei.com (unknown [7.152.184.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 9C95440538;
	Wed, 19 Aug 2026 14:47:26 +0800 (CST)
Received: from [10.67.120.171] (10.67.120.171) by
 whupemk200001.china.huawei.com (7.152.184.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 19 Aug 2026 14:47:25 +0800
Message-ID: <1d40794f-092f-459d-90a9-efcc266a7241@huawei.com>
Date: Wed, 19 Aug 2026 14:47:24 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: hisilicon/sec - remove SEC crypto block cipher
 accelerator
To: Eric Biggers <ebiggers@kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<xuwei5@huawei.com>, <prime.zeng@hisilicon.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <wangzhou1@hisilicon.com>
References: <20260818083132.1860726-1-huangchenghai2@huawei.com>
 <20260818172850.GC2249@quark>
From: huangchenghai <huangchenghai2@huawei.com>
Content-Language: en-US
In-Reply-To: <20260818172850.GC2249@quark>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk200001.china.huawei.com (7.152.184.93)


在 2026/8/19 1:28, Eric Biggers 写道:
> On Tue, Aug 18, 2026 at 04:31:32PM +0800, Chenghai Huang wrote:
>> The Hisilicon SEC crypto cipher accelerator has been superseded
>> by the newer SEC2 driver (drivers/crypto/hisilicon/sec2/). SEC2
>> provides wider algorithm coverage and is the maintained path forward,
>> and users have migrated to it.
>>
>> The legacy SEC driver has had no active users for some time, and its
>> primary maintainer, Jonathan Cameron, has moved on from Huawei and
>> is no longer in a position to maintain it. With thanks to Jonathan
>> for his contributions to this driver over the years, and with no one
>> left to keep it up to date, remove it from the tree.
>>
>> This drops the legacy SEC driver together with all of its residual
>> configuration, devicetree binding and board description references:
>>
>>    - drivers/crypto/hisilicon/sec/
>>    - CONFIG_CRYPTO_DEV_HISI_SEC Kconfig option
>>    - sec/ entry from drivers/crypto/hisilicon/Makefile
>>    - Documentation/devicetree/bindings/crypto/hisilicon,hip06-sec.yaml
>>    - hisilicon,hip07-sec device nodes and their supporting mbigen_alg /
>>      smmu_alg infrastructure from arch/arm64/boot/dts/hisilicon/hip07.dtsi
>>
>> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
>
> You might also need an ack from a devicetree maintainer for dropping the
> devicetree binding, though.  They sometimes like to keep the bindings
> around even with no driver for some reason.
>
> - Eric

Alright, I will resend it and send it to the devicetree maintainer.


Thanks,
Chenghai
