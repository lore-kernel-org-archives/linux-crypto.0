Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463F82FFF9D;
	Wed, 10 Jun 2026 01:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781056029; cv=none; b=Om+WPaexGiGKkHKiOgCVT6npx6yoajDvwcc/lUk9d/ufi8C/o68ot6Yw8L6SpqAq32NaFu6L/EYyOsOpeREQZpwXgZVyfEuovRh5xDPtaAj1uiU6nWnM0v6Z3YrDb0Qor96/IP8OQ/Ew5XU2UrKZYEkWh5qOSkWQmf8uv9WpfqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781056029; c=relaxed/simple;
	bh=YRfMwGHvz751/FzID/tLviLXUrHY7p3dyIMcJG1JHuc=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=g9VqT7rE/KXXwWl2FzGSvt54lpmG67af/ysZ+Pc/e9hMhHzZhLtL/dJyd+JCy2T/PygLQBRc/fh7r0jVZIGDPBuQoU8IoP7Ku/LhnNFsItvHc7N/teHroGyxflKbHCCm12b70h/jKQRVzOCjbwZqvIISUDBvBzM7Wb1UI7xutKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=qgQvh89P; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="qgQvh89P"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0GRQowiqy86F6wWwGj99SSIj8J8U6XTDL9K41o7flx4=;
	b=qgQvh89PoSoBxBrmLMijA+U0o1GIaMQyFrhRAhls6Ud73oCpjROz1jkhEKA77hTm9O7I+u1EZ
	mIXBDZ0KGdYCtUg4KFTKsRnJQ1N6PceeggXyOURjtECj6NhBBs2JdlYNVOMZ4ReK+x6paVQFOAf
	dDOFy7alIQntlCUxDkx3Epw=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gZpNF64vvz1K9Vw;
	Wed, 10 Jun 2026 09:39:09 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 920D34056C;
	Wed, 10 Jun 2026 09:47:02 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Jun 2026 09:47:01 +0800
Subject: Re: [PATCH] MAINTAINERS: update hisilicon zip driver maintainer
To: Chenghai Huang <huangchenghai2@huawei.com>, <shenyang39@huawei.com>,
	<fanghao11@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
References: <20260610013437.1354503-1-huangchenghai2@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <d0875aef-6efd-6370-99b5-3f055369aa02@huawei.com>
Date: Wed, 10 Jun 2026 09:47:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260610013437.1354503-1-huangchenghai2@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2026/6/10 9:34, Chenghai Huang wrote:
> Add Chenghai Huang as the maintainer of the hisilicon zip driver,
> replacing Yang Shen.
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
>

Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Longfang
Thanks.

