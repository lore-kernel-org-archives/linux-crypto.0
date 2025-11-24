Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA88836D50C;
	Mon, 24 Nov 2025 02:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763949795; cv=none; b=qQ7VYAXpPEh/BLeTGTlvoZM3bqLvLZsMwpaUDawzV8rXsfqSPuE9RItrS9ShT6ob2QX8ZC4yuH7dQ3Pz0vtUuaJ6qDxgoXkfD6QENkUwo4WWtyxCmdxq+QUGOcueHP35ZV2baQ4IX9wfgNcg3kNXqUC9ALW+UYDPRr0iR7n0BF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763949795; c=relaxed/simple;
	bh=5NRppy3W8zhGnNy+FYhR3FfKxiIHd65j4sERlc3zOzE=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=l18Kq8r+2jIkPKhs19AddWkotDgLZtjoIU09SqBcDjNQqGRuaqMydhybo8Y0UcvM8jAA+KcGBQpOZvnNw4csuVLWMtlZmkDp/k4CgY8MVYibv+ukVI7ZbbkNizfaDdGAEU03hlp6aKXfHJ7KmZHZtFDcQ71+zQM/2aILBy2rjUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=pDecdpni; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="pDecdpni"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wPrsnTCw++0vxYv4JjRvCsKF0M6it0gN1Je20893Q64=;
	b=pDecdpniZxDonAgHNexkx6XB5Qsho3ROBV4R2EgGGh8dp0p+lcXH6OTjndmNf2x9X1pycHHCK
	VWg89xxEgeOnqY0hWYwBQDUXFsVGVo1B+3LtkfQgMcZPPALDNZdHEx+OFUwiY7Sq9MkhMLGT+xD
	zHby9/7I1F1MFFg5ct2L51c=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dF8FB2FxlzmVCj;
	Mon, 24 Nov 2025 10:01:18 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 10181140155;
	Mon, 24 Nov 2025 10:03:05 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 24 Nov 2025 10:03:04 +0800
Subject: Re: [PATCH] crypto: hisilicon/qm - fix device leak on QoS updates
To: Johan Hovold <johan@kernel.org>, Weili Qian <qianweili@huawei.com>, Zhou
 Wang <wangzhou1@hisilicon.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
CC: Kai Ye <yekai13@huawei.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20251121111130.25025-1-johan@kernel.org>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <f7a83c28-af17-7479-0b39-ff3b06ee4b8c@huawei.com>
Date: Mon, 24 Nov 2025 10:03:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251121111130.25025-1-johan@kernel.org>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/11/21 19:11, Johan Hovold wrote:
> Make sure to drop the reference taken when looking up the PCI device on
> QoS updates.
> 
> Fixes: 22d7a6c39cab ("crypto: hisilicon/qm - add pci bdf number check")
> Cc: stable@vger.kernel.org	# 6.2
> Cc: Kai Ye <yekai13@huawei.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/crypto/hisilicon/qm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index a5b96adf2d1e..ef6fdcc3dbcb 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -3871,11 +3871,14 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
>  	pdev = container_of(dev, struct pci_dev, dev);
>  	if (pci_physfn(pdev) != qm->pdev) {
>  		pci_err(qm->pdev, "the pdev input does not match the pf!\n");
> +		put_device(dev);
>  		return -EINVAL;
>  	}
>  
>  	*fun_index = pdev->devfn;
>  
> +	put_device(dev);
> +
>  	return 0;
>  }
>  
> 

This issue has already been fixed by the following patch:
"[PATCH] crypto: hisilicon/qm - Fix device reference leak in qm_get_qos_value".

Thanks.
Longfang.
