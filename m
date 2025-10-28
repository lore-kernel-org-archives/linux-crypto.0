Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FA7222599;
	Tue, 28 Oct 2025 01:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761614729; cv=none; b=EuCG/NRpch8vCtj6KgqRr1C1F+2HqDDrNhcKoojpKHQQC5O5fhiRj+PHpw4ZBHEETG66ZwhgKAzedkBHhVJZsCtMi6yimTvBu72vUMHy7g3pbStwk3c7NG5QmzHgLKvHmXDRgxhmn363NGJJqH1IjmKkAKT5Oi0j84pKavguOFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761614729; c=relaxed/simple;
	bh=XNraAoXVxJntG+i7sio8dph+Y4eKVdGqB+1lKwdY904=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Dpylm8ZiN4jGCC4cb5kaAPmZdeCSZIhpWpqrtvI5DlP/7o4JCj466QTJ++9TM74+rdRwbCqbiwiG7SXV05w412i6IfhB9vEfyNah4jzomIDggi8OcissgCj15bIk94pXASOUsrdpi9q9AG7XzS0Dcf6zVffjNhuOqXye7XBFlwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Q3SQMxe+; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Q3SQMxe+"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Ij22skuYDh27GVFz5vurhnY/A38QKFjHqmKXW3cnNng=;
	b=Q3SQMxe+jJwvyyUrsf8Z1NpeXw/4OpqSY6G4NthBt1239SQU3JCmtCWlRxDgS+Ju6f96Cdjl0
	QhmHiDXYArqnu1sO7v0ygAllTUdFrYK+lNUM1/OM/tT1MK8qbyoTxqyWjMVPWHXBTpVAMOBtWB1
	4YHedYwWdIi65I+J1dha9V0=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4cwXjf2NGtzmV6g;
	Tue, 28 Oct 2025 09:24:54 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 5685D1800B2;
	Tue, 28 Oct 2025 09:25:22 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Oct 2025 09:25:21 +0800
Subject: Re: [PATCH] crypto: hisilicon/qm - Fix device reference leak in
 qm_get_qos_value
To: Miaoqian Lin <linmq006@gmail.com>, Weili Qian <qianweili@huawei.com>, Zhou
 Wang <wangzhou1@hisilicon.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Kai Ye <yekai13@huawei.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>
References: <20251027150934.60013-1-linmq006@gmail.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <fdcaf975-590e-be7e-40ce-1c8eea75f8ce@huawei.com>
Date: Tue, 28 Oct 2025 09:25:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251027150934.60013-1-linmq006@gmail.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/10/27 23:09, Miaoqian Lin wrote:
> The qm_get_qos_value() function calls bus_find_device_by_name() which
> increases the device reference count, but fails to call put_device()
> to balance the reference count and lead to a device reference leak.
> 
> Add put_device() calls in both the error path and success path to
> properly balance the reference count.
> 
> Found via static analysis.
> 
> Fixes: 22d7a6c39cab ("crypto: hisilicon/qm - add pci bdf number check")
> Cc: stable@vger.kernel.org
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index a5b96adf2d1e..3b391a146635 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -3871,10 +3871,12 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
>  	pdev = container_of(dev, struct pci_dev, dev);
>  	if (pci_physfn(pdev) != qm->pdev) {
>  		pci_err(qm->pdev, "the pdev input does not match the pf!\n");
> +		put_device(dev);
>  		return -EINVAL;
>  	}
>  
>  	*fun_index = pdev->devfn;
> +	put_device(dev);
>  
>  	return 0;
>  }
> 

Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Thanks.
