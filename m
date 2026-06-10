Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BAF40D595;
	Wed, 10 Jun 2026 03:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781060955; cv=none; b=XJG3CCeuaD1b0KdDD2QxZ7lmsIx1OVi0Q33VtX0HfRQlCXrs/kgEqQR3OCJZCwzPOXGrbhEwpO7n8g5yDycFCs30iJkq1RBaHtw4VwGu7K31lSiLLM6ImQHU1iCWw5v+D/34nlO6RIczAz+BMKKhpKKGJ5E7qisu0joHGZPt1tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781060955; c=relaxed/simple;
	bh=H9OpCGWQv62pHxsu1twbJNTYO9rQfi/ld/MUujnuRoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pwc9u3JdXY5Mbz2SAYSX1rzcnqGkMp37PdJpddxx+3b88BAOC8PnRxhyiOfvFPlo3/OiL0c3L3rS70uIAt8fPMTpqeNCHQwaUBJLW9wuk7ndrPwscTSETQDFUdl3l5qXlfCHUROueZswQBJ8T6AKrooACfRJvnDpg/B8QPVFZbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from canpmsgout04.his.huawei.com (unknown [172.19.92.133])
	by szxga01-in.huawei.com (SkyGuard) with ESMTPS id 4gZrMp4j5Mz1BFQD;
	Wed, 10 Jun 2026 11:08:54 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gZrBl5byzz1prLy;
	Wed, 10 Jun 2026 11:01:03 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 618E240538;
	Wed, 10 Jun 2026 11:09:00 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Jun 2026 11:09:00 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Jun 2026 11:08:59 +0800
Message-ID: <0a01c2db-1591-af6b-e0b2-f50153fb7fe2@hisilicon.com>
Date: Wed, 10 Jun 2026 11:08:48 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] MAINTAINERS: update hisilicon zip driver maintainer
Content-Language: en-US
To: Chenghai Huang <huangchenghai2@huawei.com>, <shenyang39@huawei.com>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
References: <20260610013437.1354503-1-huangchenghai2@huawei.com>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <20260610013437.1354503-1-huangchenghai2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2026/6/10 9:34, Chenghai Huang wrote:
> Add Chenghai Huang as the maintainer of the hisilicon zip driver,
> replacing Yang Shen.

Many thanks for the work from shenyang about maintaining this driver.
It is very pleasure to work with you in these years, may you have a nice
job in future!

Acked-by: Zhou Wang <wangzhou1@hisilicon.com>

> 
> Signed-off-by: Chenghai Huang<huangchenghai2@huawei.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 882214b0e7db..7c66740aeb3c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11714,7 +11714,7 @@ W:	http://www.hisilicon.com
>  F:	drivers/spi/spi-hisi-sfc-v3xx.c
>  
>  HISILICON ZIP Controller DRIVER
> -M:	Yang Shen <shenyang39@huawei.com>
> +M:	Chenghai Huang<huangchenghai2@huawei.com>
>  M:	Zhou Wang <wangzhou1@hisilicon.com>
>  L:	linux-crypto@vger.kernel.org
>  S:	Maintained
