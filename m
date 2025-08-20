Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEF1179A3;
	Wed, 20 Aug 2025 07:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755673287; cv=none; b=qsoFHJu5EATrTShMaIkMj31yT4cOQfVZWNw9Jj8sHBM0936SImtX0yyvuE/Wv/JjI4m4KWQ4m4yPpkdAwcFl4l75OS2jogTZEHpIwLZt5/4f1fjVE+NC0gWSHK4f+2cITyPagg2YLirNOkNnWFda0QKbMmYqeZRUw9dNg3PJOKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755673287; c=relaxed/simple;
	bh=/tYmo8JEk9hrANABqjMWLCeoK3N07c3bevddqxrtCkM=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bF0jOCYZxTwNIdo7+Hl+Q5+lQBmpa86ZD/8OeGKpr4fMFJLNFIHEdypRs8sFnEp9SF2pzvCfvL9YSCgZlzuzt1JTQ783DyvqE3vwSsoF7ldOEyh86B2O7eNQctDmOS5xv9XsYioQ6s6+O+pDQPvlCO3NZrAIAoPFmuAl0pd7Q/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c6HRf1PDMz14MVf;
	Wed, 20 Aug 2025 15:01:18 +0800 (CST)
Received: from kwepemk500010.china.huawei.com (unknown [7.202.194.95])
	by mail.maildlp.com (Postfix) with ESMTPS id E676F180495;
	Wed, 20 Aug 2025 15:01:21 +0800 (CST)
Received: from [10.67.120.153] (10.67.120.153) by
 kwepemk500010.china.huawei.com (7.202.194.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 20 Aug 2025 15:01:21 +0800
Subject: Re: [PATCH 1/6] crypto: hisilicon - re-enable address prefetch after
 device resuming
To: Chenghai Huang <huangchenghai2@huawei.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
References: <20250816102834.828655-1-huangchenghai2@huawei.com>
 <20250816102834.828655-2-huangchenghai2@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>
From: Weili Qian <qianweili@huawei.com>
Message-ID: <bf8c34d6-72b3-e0ad-62f0-9e5e8be3c132@huawei.com>
Date: Wed, 20 Aug 2025 15:01:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250816102834.828655-2-huangchenghai2@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk500010.china.huawei.com (7.202.194.95)



On 2025/8/16 18:28, Chenghai Huang wrote:
> When the device resumes from a suspended state, it will revert to its
> initial state and requires re-enabling. Currently, the address prefetch
> function is not re-enabled after device resuming. Move the address prefetch
> enable to the initialization process. In this way, the address prefetch
> can be enabled when the device resumes by calling the initialization
> process.
> 
> Fixes: 607c191b371d ("crypto: hisilicon - support runtime PM for accelerator device")
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 86 +++++++++++------------
>  drivers/crypto/hisilicon/qm.c             |  3 -
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 80 ++++++++++-----------
>  drivers/crypto/hisilicon/zip/zip_main.c   |  2 +-
>  4 files changed, 84 insertions(+), 87 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
> index f5b47e5ff48a..dbe8f62f556b 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
> @@ -466,6 +466,47 @@ struct hisi_qp *hpre_create_qp(u8 type)
>  	return NULL;
>  }
>  
> +static void hpre_close_sva_prefetch(struct hisi_qm *qm)
> +{
> +	u32 val;
> +	int ret;
> +
> +	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
> +		return;
> +
> +	val = readl_relaxed(qm->io_base + HPRE_PREFETCH_CFG);
> +	val |= HPRE_PREFETCH_DISABLE;
> +	writel(val, qm->io_base + HPRE_PREFETCH_CFG);
> +
> +	ret = readl_relaxed_poll_timeout(qm->io_base + HPRE_SVA_PREFTCH_DFX,
> +					 val, !(val & HPRE_SVA_DISABLE_READY),
> +					 HPRE_REG_RD_INTVRL_US,
> +					 HPRE_REG_RD_TMOUT_US);
> +	if (ret)
> +		pci_err(qm->pdev, "failed to close sva prefetch\n");
> +}
> +
> +static void hpre_open_sva_prefetch(struct hisi_qm *qm)
> +{
> +	u32 val;
> +	int ret;
> +
> +	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
> +		return;
> +
> +	/* Enable prefetch */
> +	val = readl_relaxed(qm->io_base + HPRE_PREFETCH_CFG);
> +	val &= HPRE_PREFETCH_ENABLE;
> +	writel(val, qm->io_base + HPRE_PREFETCH_CFG);
> +
> +	ret = readl_relaxed_poll_timeout(qm->io_base + HPRE_PREFETCH_CFG,
> +					 val, !(val & HPRE_PREFETCH_DISABLE),
> +					 HPRE_REG_RD_INTVRL_US,
> +					 HPRE_REG_RD_TMOUT_US);
> +	if (ret)
> +		pci_err(qm->pdev, "failed to open sva prefetch\n");
> +}
> +
>  static void hpre_config_pasid(struct hisi_qm *qm)
>  {
>  	u32 val1, val2;
> @@ -484,6 +525,8 @@ static void hpre_config_pasid(struct hisi_qm *qm)
>  	}
>  	writel_relaxed(val1, qm->io_base + HPRE_DATA_RUSER_CFG);
>  	writel_relaxed(val2, qm->io_base + HPRE_DATA_WUSER_CFG);
> +
> +	hpre_open_sva_prefetch(qm);

For compatibility considerations, address prefetch enablement relies on the device's capability
configuration rather than the chip version. The function should be called before the version check.

Thanks,
Weili

>  }
>  
>  static int hpre_cfg_by_dsm(struct hisi_qm *qm)
> @@ -563,47 +606,6 @@ static void disable_flr_of_bme(struct hisi_qm *qm)
>  	writel(PEH_AXUSER_CFG_ENABLE, qm->io_base + QM_PEH_AXUSER_CFG_ENABLE);
>  }
>  
> -static void hpre_open_sva_prefetch(struct hisi_qm *qm)
> -{
> -	u32 val;
> -	int ret;
> -
> -	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
> -		return;
> -
> -	/* Enable prefetch */
> -	val = readl_relaxed(qm->io_base + HPRE_PREFETCH_CFG);
> -	val &= HPRE_PREFETCH_ENABLE;
> -	writel(val, qm->io_base + HPRE_PREFETCH_CFG);
> -
> -	ret = readl_relaxed_poll_timeout(qm->io_base + HPRE_PREFETCH_CFG,
> -					 val, !(val & HPRE_PREFETCH_DISABLE),
> -					 HPRE_REG_RD_INTVRL_US,
> -					 HPRE_REG_RD_TMOUT_US);
> -	if (ret)
> -		pci_err(qm->pdev, "failed to open sva prefetch\n");
> -}
> -
> -static void hpre_close_sva_prefetch(struct hisi_qm *qm)
> -{
> -	u32 val;
> -	int ret;
> -
> -	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
> -		return;
> -
> -	val = readl_relaxed(qm->io_base + HPRE_PREFETCH_CFG);
> -	val |= HPRE_PREFETCH_DISABLE;
> -	writel(val, qm->io_base + HPRE_PREFETCH_CFG);
> -
> -	ret = readl_relaxed_poll_timeout(qm->io_base + HPRE_SVA_PREFTCH_DFX,
> -					 val, !(val & HPRE_SVA_DISABLE_READY),
> -					 HPRE_REG_RD_INTVRL_US,
> -					 HPRE_REG_RD_TMOUT_US);
> -	if (ret)
> -		pci_err(qm->pdev, "failed to close sva prefetch\n");
> -}
> -
>  static void hpre_enable_clock_gate(struct hisi_qm *qm)
>  {
>  	unsigned long offset;
> @@ -1450,8 +1452,6 @@ static int hpre_pf_probe_init(struct hpre *hpre)
>  	if (ret)
>  		return ret;
>  
> -	hpre_open_sva_prefetch(qm);
> -
>  	hisi_qm_dev_err_init(qm);
>  	ret = hpre_show_last_regs_init(qm);
>  	if (ret)
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index 2e4ee7ecfdfb..a5cc0ccd94f1 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -4447,9 +4447,6 @@ static void qm_restart_prepare(struct hisi_qm *qm)
>  {
>  	u32 value;
>  
> -	if (qm->err_ini->open_sva_prefetch)
> -		qm->err_ini->open_sva_prefetch(qm);
> -
>  	if (qm->ver >= QM_HW_V3)
>  		return;
>  
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index 72cf48d1f3ab..ddb20f380b54 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -464,6 +464,45 @@ static void sec_set_endian(struct hisi_qm *qm)
>  	writel_relaxed(reg, qm->io_base + SEC_CONTROL_REG);
>  }
>  
> +static void sec_close_sva_prefetch(struct hisi_qm *qm)
> +{
> +	u32 val;
> +	int ret;
> +
> +	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
> +		return;
> +
> +	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
> +	val |= SEC_PREFETCH_DISABLE;
> +	writel(val, qm->io_base + SEC_PREFETCH_CFG);
> +
> +	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_SVA_TRANS,
> +					 val, !(val & SEC_SVA_DISABLE_READY),
> +					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
> +	if (ret)
> +		pci_err(qm->pdev, "failed to close sva prefetch\n");
> +}
> +
> +static void sec_open_sva_prefetch(struct hisi_qm *qm)
> +{
> +	u32 val;
> +	int ret;
> +
> +	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
> +		return;
> +
> +	/* Enable prefetch */
> +	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
> +	val &= SEC_PREFETCH_ENABLE;
> +	writel(val, qm->io_base + SEC_PREFETCH_CFG);
> +
> +	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_PREFETCH_CFG,
> +					 val, !(val & SEC_PREFETCH_DISABLE),
> +					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
> +	if (ret)
> +		pci_err(qm->pdev, "failed to open sva prefetch\n");
> +}
> +
>  static void sec_engine_sva_config(struct hisi_qm *qm)
>  {
>  	u32 reg;
> @@ -497,45 +536,7 @@ static void sec_engine_sva_config(struct hisi_qm *qm)
>  		writel_relaxed(reg, qm->io_base +
>  				SEC_INTERFACE_USER_CTRL1_REG);
>  	}
> -}
> -
> -static void sec_open_sva_prefetch(struct hisi_qm *qm)
> -{
> -	u32 val;
> -	int ret;
> -
> -	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
> -		return;
> -
> -	/* Enable prefetch */
> -	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
> -	val &= SEC_PREFETCH_ENABLE;
> -	writel(val, qm->io_base + SEC_PREFETCH_CFG);
> -
> -	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_PREFETCH_CFG,
> -					 val, !(val & SEC_PREFETCH_DISABLE),
> -					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
> -	if (ret)
> -		pci_err(qm->pdev, "failed to open sva prefetch\n");
> -}
> -
> -static void sec_close_sva_prefetch(struct hisi_qm *qm)
> -{
> -	u32 val;
> -	int ret;
> -
> -	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
> -		return;
> -
> -	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
> -	val |= SEC_PREFETCH_DISABLE;
> -	writel(val, qm->io_base + SEC_PREFETCH_CFG);
> -
> -	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_SVA_TRANS,
> -					 val, !(val & SEC_SVA_DISABLE_READY),
> -					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
> -	if (ret)
> -		pci_err(qm->pdev, "failed to close sva prefetch\n");
> +	sec_open_sva_prefetch(qm);
>  }
>  
>  static void sec_enable_clock_gate(struct hisi_qm *qm)
> @@ -1152,7 +1153,6 @@ static int sec_pf_probe_init(struct sec_dev *sec)
>  	if (ret)
>  		return ret;
>  
> -	sec_open_sva_prefetch(qm);
>  	hisi_qm_dev_err_init(qm);
>  	sec_debug_regs_clear(qm);
>  	ret = sec_show_last_regs_init(qm);
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index d8ba23b7cc7d..96687c78a8dc 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -565,6 +565,7 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
>  		writel(AXUSER_BASE, base + HZIP_DATA_WUSER_32_63);
>  		writel(AXUSER_BASE, base + HZIP_SGL_RUSER_32_63);
>  	}
> +	hisi_zip_open_sva_prefetch(qm);
>  
>  	/* let's open all compression/decompression cores */
>  
> @@ -1255,7 +1256,6 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
>  	if (ret)
>  		return ret;
>  
> -	hisi_zip_open_sva_prefetch(qm);
>  	hisi_qm_dev_err_init(qm);
>  	hisi_zip_debug_regs_clear(qm);
>  
> 
