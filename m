Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D88B1514C9;
	Fri, 31 May 2024 10:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717150150; cv=none; b=ObSNWx6goCqavKtVKuqgO8TGoco8US398E3zUnMckyh3SBDkyVbJeD4ongide46CRbNjgbtAqOnn7+++0s+wiwnVxvSnnTSwNeO32RLZKsrUM6HzYRtgWDgfNRp5DR8GRYjCdgny1evgCYlJuUi4+aYet3tTX1EKBwbBPSZEU/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717150150; c=relaxed/simple;
	bh=XF4il905GMY808BbBdZMyijfqf/CpyqJ+mtFoZOf7GM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CVSerbwS26M8VFAcmEamlpPXUfifa2sHfUMEw2PvZRyA7GAJ06KmGUY93ksllwDTJAdzqeUwT7VvOS5OKgs1eU0MmZkUDZHEP/k+k0Tu1bki3dQlUXpXlP6db17rFXXnHpXjRF8szJLYnprr92+jLShfT6DadP5cvV2ac42g8fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4VrJfT043VzPpBF;
	Fri, 31 May 2024 18:05:53 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id E114918007A;
	Fri, 31 May 2024 18:09:04 +0800 (CST)
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 18:09:04 +0800
Message-ID: <f1febadb-4cbd-4278-a3b0-dbb93d5af212@huawei.com>
Date: Fri, 31 May 2024 18:09:03 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] crypto: hisilicon/zip - optimize the address offset
 of the reg query function
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <shenyang39@huawei.com>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>
References: <20240506115953.2282155-1-huangchenghai2@huawei.com>
 <20240506115953.2282155-3-huangchenghai2@huawei.com>
 <ZlmZh5d8RDo3C-HS@gondor.apana.org.au>
From: huangchenghai <huangchenghai2@huawei.com>
In-Reply-To: <ZlmZh5d8RDo3C-HS@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500025.china.huawei.com (7.221.188.170)


在 2024/5/31 17:33, Herbert Xu 写道:
> On Mon, May 06, 2024 at 07:59:53PM +0800, Chenghai Huang wrote:
>> @@ -807,6 +786,18 @@ static int hisi_zip_regs_show(struct seq_file *s, void *unused)
>>   
>>   DEFINE_SHOW_ATTRIBUTE(hisi_zip_regs);
>>   
>> +static void __iomem *get_zip_core_addr(struct hisi_qm *qm, int core_num)
>> +{
>> +	u32 zip_comp_core_num = qm->cap_tables.dev_cap_table[ZIP_CLUSTER_COMP_NUM_CAP_IDX].cap_val;
>> +
>> +	if (core_num < zip_comp_core_num)
>> +		return qm->io_base + HZIP_CORE_DFX_BASE +
>> +			(core_num + 1) * HZIP_CORE_ADDR_INTRVL;
>> +
>> +	qm->io_base + HZIP_CORE_DFX_DECOMP_BASE +
>> +		(core_num - zip_comp_core_num) * HZIP_CORE_ADDR_INTRVL;
>> +}
>> +
> This doesn't even build.

I'm so sorry, I forgot to build it. I'll build and verify it carefully next time.

The second version will be corrected and send soon.

Thanks,
ChengHai

