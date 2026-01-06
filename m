Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A894230270;
	Tue,  6 Jan 2026 02:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767667145; cv=none; b=ipHSqVcwpi5I8rNKfI4umRyP2iRxflSfrPq2Nxb20Ifj12lXrZKlhV2MhYlaq0wLDJuvHWCBN7fU9Fp9HWnbVUq6BV/Kly4iBXPAmmZiERlETFJNQs0OWRDk3tT/wy0/NNmwp5q+4f+78MyscqGmb17T4Oy5G+V7zCXRiok5q4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767667145; c=relaxed/simple;
	bh=IqgTM7rDXt06+VW2Qq4b8Cf0D1LzDC8iYuGc6dmp3IM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=hfFp7sePkbfoAEgP0nAtrNfFsrLw2/lY+TNALmT+YJjzQcNk/Vri3JpY6qM0IzqDttgtBekI0b0APYAiPk1AlciCKA3kwKHWHPo2yaYNo59tnwWdCGhMUw2Qk8G5XlJ6hVCGbDH3D6qBMAgiclTTD9qcxJlvX80muAYTx16158M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=o4AMp07c; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="o4AMp07c"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eUJqBj6o1yLo7PGZNNapVkv03nS/Y313TuX0KxvwUtM=;
	b=o4AMp07cqIQZWFgGXa/vAEhEEOclZgQn7hxry/cDxK3KuaMXtckFMIwmCpQmAKD0aMeIqgE8s
	6vEbKA2KfUX92jNNqmwgUbeL4zCz0sV14bmU4EbSZ+D366PUkiiFGmkG1JLxu9Kmn5rvwiSLG2j
	krzbcxHkZHAPPE4wuL2CvFg=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dlZzD61V5znTwP;
	Tue,  6 Jan 2026 10:35:52 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id DAE5540539;
	Tue,  6 Jan 2026 10:38:57 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 6 Jan 2026 10:38:47 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 6 Jan 2026 10:38:47 +0800
Message-ID: <828e0dcd-ae17-448b-ba33-97603031fc60@huawei.com>
Date: Tue, 6 Jan 2026 10:38:46 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/4] uacce: driver fixes for memory leaks and state
 management
From: huangchenghai <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <shenyang39@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>
References: <20251202061256.4158641-1-huangchenghai2@huawei.com>
Content-Language: en-US
In-Reply-To: <20251202061256.4158641-1-huangchenghai2@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200001.china.huawei.com (7.202.195.16)

Kindly ping for this fix.


Cheers,
Chenghai

在 2025/12/2 14:12, Chenghai Huang 写道:
> This patch series addresses several issues in the uacce:
> 1.Fix cdev handling in the cleanup path.
> 2.Fix sysfs file creation conditions.
> 3.Add error reporting for unsupported mremap operations.
> 4.Ensuring safe queue release with proper state management.
>
> ---
> Changes in v6:
> - In patch 1, if cdev_device_add() fails, it will automatically free the cdev, however,
>    we need to set uacce->cdev to NULL to prevent cdev_device_del() from being called.
> - Link to v5: https://lore.kernel.org/all/20251111093536.3729-1-huangchenghai2@huawei.com/
>
> Changes in v5:
> - There is no memory leak issue when cdev_device_add fails, but it is necessary
>    to check a flag to avoid calling cdev_device_del during abnormal exit.
> - Link to v4: https://lore.kernel.org/all/20251022021149.1771168-1-huangchenghai2@huawei.com/
>
> Changes in v4:
> - Revert the interception of sysfs creation for isolate_strategy.
> - Link to v3: https://lore.kernel.org/all/20251021135003.786588-1-huangchenghai2@huawei.com/
>
> Changes in v3:
> - Move the checks for the 'isolate_strategy_show' and
>    'isolate_strategy_store' functions to their respective call sites.
> - Use kobject_put to release the cdev memory instead of modifying
>    cdev to be a static structure member.
> - Link to v2: https://lore.kernel.org/all/20250916144811.1799687-1-huangchenghai2@huawei.com/
>
> Changes in v2:
> - Use cdev_init to allocate cdev memory to ensure that memory leaks
>    are avoided.
> - Supplement the reason for intercepting the remapping operation.
> - Add "cc: stable@vger.kernel.org" to paths with fixed.
> - Link to v1: https://lore.kernel.org/all/20250822103904.3776304-1-huangchenghai2@huawei.com/
>
> Chenghai Huang (2):
>    uacce: fix isolate sysfs check condition
>    uacce: ensure safe queue release with state management
>
> Wenkai Lin (1):
>    uacce: fix cdev handling in the cleanup path
>
> Yang Shen (1):
>    uacce: implement mremap in uacce_vm_ops to return -EPERM
>
>   drivers/misc/uacce/uacce.c | 48 +++++++++++++++++++++++++++++++-------
>   1 file changed, 40 insertions(+), 8 deletions(-)
>
