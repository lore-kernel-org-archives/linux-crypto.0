Received: from smtp.smtpout.orange.fr (smtp-24.smtpout.orange.fr [80.12.242.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E571946F;
	Fri, 31 May 2024 20:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717186434; cv=none; b=ER4qO4XcdzAROO+kn3NzqA7dKbet/mE0VgTVizkmwiHsm4Nhtkx8sYVM+PcjwXuHiXMpNSKfLh8YZZZupZpDLWYGtW6JlM8sDP9TQFiHFvbtnMiN8dz3jwmPciOmx5zEGWVTWpRgofMRqZMYqwXctX8xUR5+0o2oiiZcf3u0HnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717186434; c=relaxed/simple;
	bh=w6X6T/ksufCsAz4gKWToTB/1NUfx2HyXeF6R64j7EVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CjS2ik28eY+E1TNPbJoOJDEfl6hEVVSkxpz20Qf2Nam9LD0p1Z482UA+c0mvyLvDVT6SPemfLfUVaG6y+rGbiWFG6G5s6nHj5lHS9xLKYAOqp2P4TJaeU/s6YqCdNY55rApouyYaAj8bJ74FPbfCCHR3W+VVPoNHndJebn67wjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=Up9l4fE+; arc=none smtp.client-ip=80.12.242.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="Up9l4fE+"
Received: from [192.168.1.37] ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id D8UfsaUbIp3DQD8UfsPBfT; Fri, 31 May 2024 22:04:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1717185896;
	bh=IMWkqEz3tcT2fpRarPXYT4LJHuLYonGiraVHDo/QMJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=Up9l4fE+1Acu5z0JyIgdduw8EDNsBJpvZBzn+1QGM8ZH+B1vhLvhfrbHVYkCl7ele
	 oxCAPYYjwh+PvWEKKWurdX8Gs8d7BmbEDWRsm2Lqw3XqIsusbpNhaZAfXl3/YX5vMx
	 eVxjnXtmSuWftN0V56LBawSd2aXq6XQENGC+13UYvIAXU8YqN/a9fdobJOeLsXGyGG
	 x37iBNUR0Bj3g+zjyoTMJaaxL1HSpkjLJgItZCgL1zG3ZJn4fVqO1eF3eaUQT3bpkr
	 YXm8efQ+aFxsTFdtcdGVh+3XyGBI7tX98vTi+pMUJTaDY4c0n9Uis1pYXhiqtKFVK4
	 4afmwchI27h6w==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 31 May 2024 22:04:56 +0200
X-ME-IP: 86.243.17.157
Message-ID: <95572851-8750-4a1f-8034-443e0bc9c6b8@wanadoo.fr>
Date: Fri, 31 May 2024 22:04:52 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_free()
 call in tegra_se_remove()
To: Akhil R <akhilrajeev@nvidia.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
 Thierry Reding <thierry.reding@gmail.com>, Jon Hunter
 <jonathanh@nvidia.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <ea775b351a3dbe4cef4056ea89da25084f73df22.1716650050.git.christophe.jaillet@wanadoo.fr>
 <SJ1PR12MB633943D654272A0612695F1DC0F22@SJ1PR12MB6339.namprd12.prod.outlook.com>
 <Zllexnetg3eu6dSW@gondor.apana.org.au>
 <SJ1PR12MB633958B0DC8504F1D7868CA0C0FC2@SJ1PR12MB6339.namprd12.prod.outlook.com>
Content-Language: en-MW
From: Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <SJ1PR12MB633958B0DC8504F1D7868CA0C0FC2@SJ1PR12MB6339.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


Le 31/05/2024 à 07:36, Akhil R a écrit :
>> -----Original Message-----
>> From: Herbert Xu <herbert@gondor.apana.org.au>
>> Sent: Friday, May 31, 2024 10:53 AM
>> To: Akhil R <akhilrajeev@nvidia.com>
>> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>; David S. Miller
>> <davem@davemloft.net>; Thierry Reding <thierry.reding@gmail.com>; Jon
>> Hunter <jonathanh@nvidia.com>; linux-kernel@vger.kernel.org; kernel-
>> janitors@vger.kernel.org; linux-crypto@vger.kernel.org; linux-
>> tegra@vger.kernel.org
>> Subject: Re: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_free()
>> call in tegra_se_remove()
>>
>> External email: Use caution opening links or attachments
>>
>>
>> On Wed, May 29, 2024 at 06:53:42AM +0000, Akhil R wrote:
>>>> The only iommu function call in this driver is a
>>>> tegra_dev_iommu_get_stream_id() which does not allocate anything and
>> does
>>>> not take any reference.
>>>>
>>>> More-over, what is freed is "se->dev" which has been devm_kzalloc()'ed in the
>>>> probe.
>>> I did not completely understand what is being tried to convey here.
>>> If I understand it right, iommu_fwspec_free() does not do anything
>>> with the "devm_kzalloc"ed variable.
>>>
>>> It would probably be a good idea to remove this line from the commit message.
>> I think he means that as the memory was allocated via devm, it will
>> be automatically freed by the kernel and the driver does not need
>> to (and should not) free the memory by hand.


Yes, that is my point.

> Ya. But iommu_fwspec_free() does not free the memory allocated via devm.
>
> I think iommu_fwspec_free() is expected to be called in symmetry with
> iommu_fwspec_init(). So, I do agree that the SE driver does not allocate
> what is freed by iommu_fwspec_free(), but I feel this line is a bit misleading.
>
Yes, I spoke too fast.
What is freed is dev_iommu_fwspec_get(dev);, not dev. So the sentence I 
wrote makes no sense and should be removed :(


CJ


