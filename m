Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924421C2DB2;
	Wed, 20 Aug 2025 07:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755674510; cv=none; b=jjzEpqgODnrGz5lGQt4du4uoIoLARSTz3TxZy1H3YkWJuegwxIqlpu26VWbTdK5OrW7tUsWsgTG0DK/VjXEeRBdwHg5IwgXFw4Rekgxbr32C8aOXKhI1k6QUPH/bKdjKy3Ke1qXIQrusJMaMe/H1+1YL39rK7N7lOhcX0CsXwPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755674510; c=relaxed/simple;
	bh=Ks9uZlKlcTNozA+7hkt21klx9tmExvGF+B7pLIGG+2k=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DD7pWj7k0T5XBtcdvh9NVe2xCUB0cq8IJHwuSdWGw5dnuxMSMmt0WQV5S+GQa4+WlGvGLxjapGTr6DfR2aRXpzLWk46a5oCcWkqWYR4h6GfCu1eNLJCY8ib1RROeKxb6nReV2RBkJk9C86c9Mxif1B9Sc0bPsCF7yywnVg46FPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c6Hr00P86z2TTLw;
	Wed, 20 Aug 2025 15:18:56 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 13B0E140275;
	Wed, 20 Aug 2025 15:21:45 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 20 Aug 2025 15:21:44 +0800
Subject: Re: [PATCH v2 0/3] crypto: hisilicon - add fallback function for
 hisilicon accelerater driver
To: Chenghai Huang <huangchenghai2@huawei.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<wangzhou1@hisilicon.com>, <taoqi10@huawei.com>
References: <20250818065714.1916898-1-huangchenghai2@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <cbdbd1d5-ae1a-8c4a-4df7-bb78957632c0@huawei.com>
Date: Wed, 20 Aug 2025 15:21:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250818065714.1916898-1-huangchenghai2@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/8/18 14:57, Chenghai Huang wrote:
> Support fallback for zip/sec2/hpre when device is busy.
> 
> V1: https://lore.kernel.org/all/20250809070829.47204-1-huangchenghai2@huawei.com/
> Updates:
> - Remove unnecessary callback completions.
> - Add CRYPTO_ALG_NEED_FALLBACK to hisi_zip's cra_flags.
> 
> Chenghai Huang (1):
>   crypto: hisilicon/zip - support fallback for zip
> 
> Qi Tao (1):
>   crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware
>     queue unavailable
> 
> Weili Qian (1):
>   crypto: hisilicon/hpre - support the hpre algorithm fallback
> 
>  drivers/crypto/hisilicon/Kconfig            |   1 +
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 314 +++++++++++++++++---
>  drivers/crypto/hisilicon/qm.c               |   4 +-
>  drivers/crypto/hisilicon/sec2/sec_crypto.c  |  62 +++-
>  drivers/crypto/hisilicon/zip/zip_crypto.c   |  52 +++-
>  5 files changed, 360 insertions(+), 73 deletions(-)
> 

Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Thanks.
