Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8C64457C2;
	Wed, 23 Sep 2026 07:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147375; cv=none; b=XUPU5bxwmFYUFpfLM2HUM5IX+whkYfzGynFwZrVtegqvjwhyH9p6AAj8q4L4NhKuhpKfw684XZ7/e+yzagDaRQeGODBcUWWQe6vygnrVJiCXCUFWBBDkYLxaQX2cSTNRc8qcmbFl4/KoMS/oJQTkWmThmwnKRY17LpKH/hNlJrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147375; c=relaxed/simple;
	bh=L/aaJexQOyT76ubSikJ4bsjGJgZYDNnvJgdoQpFWVvc=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VED2x6sWB2SZFVCj9ZSNQvk7IvAvkE+2V3vAiuDYgfOjUazTU3gPyMwIFjGi8v+B4X5+6Rzn/xwoEgPsEcjZY67WK2B9hIa9aCWjA4SC8E6asEPGN1zWwfVU8m2RKSIhCIga0BPO2m4wobfu5Fu/fp+rnYetgj3z5fcZ+Xn1RwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=tiU6Wgwq; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="tiU6Wgwq"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jCIGTjYCDsagnL4yfhFZnaCVjjOSu85DOW9Gp/qMZeI=;
	b=tiU6WgwqSKNNczP+FPNT99CCQ2bTOSg9DV3Zv4kw329wLgydixDnloDDjNzwVuU5NyuP1uB1w
	3c19YNB8ibY5NMiwV17Qw+oRhQiEPM5/TBU8vMD2jeCW0BqKV4oSJ36LBD7+ptSfTIvNFIoW9Kr
	U2hn0PDw+X868zmr110Ujf8=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hqSSx0l3NzLlXX;
	Wed, 23 Sep 2026 14:57:21 +0800 (CST)
Received: from whupemk100014.china.huawei.com (unknown [7.152.184.20])
	by mail.maildlp.com (Postfix) with ESMTPS id 6E17D4048B;
	Wed, 23 Sep 2026 15:09:26 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 whupemk100014.china.huawei.com (7.152.184.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 23 Sep 2026 15:09:25 +0800
Subject: Re: [PATCH] crypto: hisilicon/qm - annotate cap_tables with
 __counted_by_ptr
To: Bill Wendling <morbo@google.com>, Zhiqi Song <songzhiqi1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Weili Qian <qianweili@huawei.com>, Zhou Wang
	<wangzhou1@hisilicon.com>, Chenghai Huang <huangchenghai2@huawei.com>
CC: Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva"
	<gustavoars@kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>,
	<codemender-patching+linux@google.com>
References: <20260923060114.2605310-1-morbo@google.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <e645b41d-ce68-58d8-b5d2-03c02d16819b@huawei.com>
Date: Wed, 23 Sep 2026 15:09:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260923060114.2605310-1-morbo@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk100014.china.huawei.com (7.152.184.20)

On 2026/9/23 14:01, Bill Wendling wrote:
> Annotate the 'qm_cap_table' and 'dev_cap_table' pointer fields in
> 'struct hisi_qm_cap_tables' with the '__counted_by_ptr' attribute.
> This improves bounds checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE, allowing KASAN and compiler diagnostics to
> detect out-of-bounds accesses.
> 
> The 'qm_cap_table' pointer is associated with 'qm_cap_size' which
> specifies its element count. Similarly, 'dev_cap_table' is associated
> with 'dev_cap_size'.
> 
> To ensure safety under compiler instrumentation, the assignments in the
> initialization paths have been updated to set the 'size'/'count' fields
> prior to setting the pointer fields. This prevents any transient state
> where the pointer is valid but the count is 0 (or uninitialized),
> ensuring that subsequent accesses to these tables do not trigger
> false-positive bounds check panics.
> 
> Cc: codemender-patching+linux@google.com
> Assisted-by: LLM
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 2 +-
>  drivers/crypto/hisilicon/qm.c             | 2 +-
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 2 +-
>  drivers/crypto/hisilicon/zip/zip_main.c   | 2 +-
>  include/linux/hisi_acc_qm.h               | 4 ++--
>  5 files changed, 6 insertions(+), 6 deletions(-)
>

Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Thanks.
Longfang.

> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
> index b6903fce6071..4a1b2de476f5 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
> @@ -1234,8 +1234,8 @@ static int hpre_pre_store_cap_reg(struct hisi_qm *qm)
>  		return -EINVAL;
>  	}
>  
> -	qm->cap_tables.dev_cap_table = hpre_cap;
>  	qm->cap_tables.dev_cap_size = size;
> +	qm->cap_tables.dev_cap_table = hpre_cap;
>  
>  	return 0;
>  }
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index c01966a4a33f..7d13476451e3 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -5743,8 +5743,8 @@ static int qm_pre_store_caps(struct hisi_qm *qm)
>  							i, qm->cap_ver);
>  	}
>  
> -	qm->cap_tables.qm_cap_table = qm_cap;
>  	qm->cap_tables.qm_cap_size = size;
> +	qm->cap_tables.qm_cap_table = qm_cap;
>  
>  	return 0;
>  }
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index 752565200c16..ac423d016998 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -1285,8 +1285,8 @@ static int sec_pre_store_cap_reg(struct hisi_qm *qm)
>  				     i, qm->cap_ver);
>  	}
>  
> -	qm->cap_tables.dev_cap_table = sec_cap;
>  	qm->cap_tables.dev_cap_size = size;
> +	qm->cap_tables.dev_cap_table = sec_cap;
>  
>  	return 0;
>  }
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index 706a73656977..10091ad4a6a8 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -1400,8 +1400,8 @@ static int zip_pre_store_cap_reg(struct hisi_qm *qm)
>  				     i, qm->cap_ver);
>  	}
>  
> -	qm->cap_tables.dev_cap_table = zip_cap;
>  	qm->cap_tables.dev_cap_size = size;
> +	qm->cap_tables.dev_cap_table = zip_cap;
>  
>  	return 0;
>  }
> diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
> index f7570a409905..8dc49fa2123b 100644
> --- a/include/linux/hisi_acc_qm.h
> +++ b/include/linux/hisi_acc_qm.h
> @@ -332,9 +332,9 @@ struct hisi_qm_cap_record {
>  
>  struct hisi_qm_cap_tables {
>  	u32 qm_cap_size;
> -	struct hisi_qm_cap_record *qm_cap_table;
> +	struct hisi_qm_cap_record *qm_cap_table __counted_by_ptr(qm_cap_size);
>  	u32 dev_cap_size;
> -	struct hisi_qm_cap_record *dev_cap_table;
> +	struct hisi_qm_cap_record *dev_cap_table __counted_by_ptr(dev_cap_size);
>  };
>  
>  struct hisi_qm_list {
> 
