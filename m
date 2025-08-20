Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0185D35962;
	Wed, 20 Aug 2025 08:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755680328; cv=none; b=m5Uv0Xjy4kXZUtGgxq5Y/V3WLxP1x6y26u8PaqxYQf58sJFrir9stAHtq+kzz+yxqUFKQAOVkJt5VccWjy4UJyG3h0dxE3irOpl/BNwAdbcqkCWphxGdPjRdfIay2cJRMdtASFNAovpp3OqysQZ5LYMUfaGwLn9MQ4FWtn7aLLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755680328; c=relaxed/simple;
	bh=r0C3Mk1B5D3Cv+GP4pImhjTeqYVCdUTLE5Mmes7Xwd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=r7Wnx96MZw/xuVHoHAFMdOg+kmHzdi59ZmKPVmxfmUpSTTYgcCO5UYXB0C73kQffv5mWNSFF2Iab9tBr/zSeDxa9+wafuktPCexks2BRBjVPj4t3Dhctu0hmpd0B0JJiJQtAmMle2CsAkPG0xKRTIwhjni/Hk9RUsVSgsbQQmcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=JdeMVuSl; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="JdeMVuSl"
Received: from lelvem-sh02.itg.ti.com ([10.180.78.226])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTP id 57K8wd1W212703;
	Wed, 20 Aug 2025 03:58:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1755680319;
	bh=JFLgPoqrC3YAfSg6/noYnK5qJLb/uF0fn468QJqqtzY=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=JdeMVuSlb23fPfXRJaibQ2wu0t7ytqpcXFHWmERcN8I5Hy9iVn9ouVSv4AKGGNm4f
	 7sNgkHrn4fBqQsTQNNPyQHCNZLJ5SUKIAV7VpUv/Mr/OPZPbUUv+hxpax2xE9Ejbcd
	 eROhwJgJAsz2mVT3ixvL08sn5SpE1FY14yrYT2F0=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
	by lelvem-sh02.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 57K8wdvX1674115
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Wed, 20 Aug 2025 03:58:39 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Wed, 20
 Aug 2025 03:58:39 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55 via
 Frontend Transport; Wed, 20 Aug 2025 03:58:39 -0500
Received: from [10.24.69.191] (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 57K8wZTf257008;
	Wed, 20 Aug 2025 03:58:36 -0500
Message-ID: <d1d70f62-fb3d-4af5-936e-b59491ee1c34@ti.com>
Date: Wed, 20 Aug 2025 14:28:35 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] crypto: ti: Add driver for DTHE V2 AES Engine
 (ECB, CBC)
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Vignesh
 Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal
 Mahaveer <vishalm@ti.com>,
        Kavitha Malarvizhi <k-malarvizhi@ti.com>
References: <20250819065844.3337101-1-t-pratham@ti.com>
 <20250819065844.3337101-3-t-pratham@ti.com>
 <e40d056b-731d-4e33-9347-20c0a7665ede@gmail.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <e40d056b-731d-4e33-9347-20c0a7665ede@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

On 19/08/25 15:26, Ovidiu Panait wrote:
> Hi,
> 
> On 8/19/25 9:12 AM, T Pratham wrote:
>> Add support for ECB and CBC modes in the AES Engine of the DTHE V2
>> hardware cryptography engine.
>>
>> Signed-off-by: T Pratham <t-pratham@ti.com>
>> ---
>>  MAINTAINERS                       |   1 +
>>  drivers/crypto/Kconfig            |   1 +
>>  drivers/crypto/Makefile           |   1 +
>>  drivers/crypto/ti/Kconfig         |  14 +
>>  drivers/crypto/ti/Makefile        |   3 +
>>  drivers/crypto/ti/dthev2-aes.c    | 411 ++++++++++++++++++++++++++++++
>>  drivers/crypto/ti/dthev2-common.c | 220 ++++++++++++++++
>>  drivers/crypto/ti/dthev2-common.h | 101 ++++++++
>>  8 files changed, 752 insertions(+)
>>  create mode 100644 drivers/crypto/ti/Kconfig
>>  create mode 100644 drivers/crypto/ti/Makefile
>>  create mode 100644 drivers/crypto/ti/dthev2-aes.c
>>  create mode 100644 drivers/crypto/ti/dthev2-common.c
>>  create mode 100644 drivers/crypto/ti/dthev2-common.h
>>
> 
> [...]
> 

[...]

>> +
>> +probe_reg_err:
>> +	crypto_engine_stop(dev_data->engine);
>> +probe_engine_start_err:
>> +	crypto_engine_exit(dev_data->engine);
> 
> crypto_engine_exit() calls crypto_engine_stop() internally, so there is
> no need to call both functions here. Just use crypto_engine_exit().
> 
> /**
>  * crypto_engine_exit - free the resources of hardware engine when exit
>  * @engine: the hardware engine need to be freed
>  */
> void crypto_engine_exit(struct crypto_engine *engine)
> {
> 	int ret;
> 
> 	ret = crypto_engine_stop(engine);
> 	if (ret)
> 		return;
> 
> 	kthread_destroy_worker(engine->kworker);
> }
> 

Thanks for this insight! Will correct this.

[...]

> 
> Ovidiu

Regards
T Pratham

