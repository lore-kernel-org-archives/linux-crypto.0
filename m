Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30CF397698;
	Wed,  8 Apr 2026 08:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775635668; cv=none; b=q8Ypkf3q3GkJVGcTX496NUtCECVvTVgasnLKB6kBS5XIIMKWyP5TRWCknsmlpP9KxLGAiopMqv+XWeXHpgHJ5U2z/4H8iZs3Nlm59vkJOPnkOOKXzAK6XyXTEggKhQBiH+mqh3gW04jlAczUz1JPwIEzcvMHhIJnKTOCDFk89nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775635668; c=relaxed/simple;
	bh=pQ/poFH3FHgZsLUSUCy8sfb2prMRFfFY/Beh5sSQzRw=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AvkZLAoTb9PG34AvFlIjoskkJUyH/BxZXZXYGpJYFJ4CdlHH7z4o7DTO0hUxbPpAguJp9Qch6WgBxIahQ2sdYXdZDCjCmJfqr5vitssxQn2J4437SlQwAsoWni3EiPwji2Xor49PyiQLNHC85bCr1nq7P5tpWIcXPYXM/jW6IEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=m0jFcrU1; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="m0jFcrU1"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yDnwTnpB7RqrkOrBP4zO/1DeewnHWTgIU1dzZOBqu3k=;
	b=m0jFcrU1ZU4cDCDbo8mJBzL9EVgTzn1DukboBNJFwLT/E+D90zssGx5sIUITY8961SUwKCpPB
	FlKWkbV6mw9TNLITuduZmSddFCi++7devkWHGArLZKVgzylNxlQ7+WRj2IVMRp4JnZwMxArNImi
	0buVFAc7yOJmxK5F3dbfHpw=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4frFrJ14cYz12LCq;
	Wed,  8 Apr 2026 16:01:20 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 31ABC40576;
	Wed,  8 Apr 2026 16:07:42 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 8 Apr 2026 16:07:41 +0800
Subject: Re: [PATCH 0/5] crypto: hisilicon - series of cleanups and format
 fixes for hisilicon driver
To: Chenghai Huang <huangchenghai2@huawei.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<yinzhushuai@huawei.com>
References: <20260330062531.2976138-1-huangchenghai2@huawei.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <7b23bd5e-9a3c-f7cc-7d23-11efb75b08e7@huawei.com>
Date: Wed, 8 Apr 2026 16:07:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260330062531.2976138-1-huangchenghai2@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2026/3/30 14:25, Chenghai Huang wrote:
> 1.Fixed a format string type mismatch issue identified through static
> analysis and code review, which could have caused display errors.
> 2.A const qualifier addition to improve type safety.
> 3.Removing unnecessary else statements after a return.
> 4.Removal of redundant variable initializations that are overwritten
> before their first use.
> 5.A cleanup of unused and non-public APIs to shrink the public interface
> and remove dead code.
> 
> Chenghai Huang (4):
>   crypto: hisilicon/qm - add const qualifier to info_name in struct
>     qm_cmd_dump_item
>   crypto: hisilicon/qm - remove else after return
>   crypto: hisilicon/qm - drop redundant variable initialization
>   crypto: hisilicon - remove unused and non-public APIs for qm and sec
> 
> Zhushuai Yin (1):
>   crypto: hisilicon - fix the format string type error
> 
>  drivers/crypto/hisilicon/debugfs.c       | 22 +++++++++++-----------
>  drivers/crypto/hisilicon/qm.c            | 16 ++++++++--------
>  drivers/crypto/hisilicon/sec2/sec.h      |  2 --
>  drivers/crypto/hisilicon/sec2/sec_main.c |  2 +-
>  include/linux/hisi_acc_qm.h              |  2 --
>  5 files changed, 20 insertions(+), 24 deletions(-)
> 
Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Thanks.
