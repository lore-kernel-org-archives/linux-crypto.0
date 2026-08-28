Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BD0390230
	for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2026 09:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787909180; cv=none; b=mPaQ1LzZTMr0vu7z8Km2fecGuXb+PiTa1o1UPlYPV5cb/Zyrzu/S7ZeAhD1nCGmgy8rVX9dT9r09vdwIEp0pYK6WB9naDo38/SsEWMuLugBlCXir4tD3yzwU4+rBQJEUCNCBXb+u6L7HO7/lWMhzpabE1TuYpHFc/Adtn++COZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787909180; c=relaxed/simple;
	bh=Q75lXh1NMJcU//kPIH+flIw/E8KQREI1ClOhcFDN1Ok=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=V7NrfOYJZ4neFJOxxiA7/MXb+MSNALi/qPshrBZebVo/89M47lYwZjLFhhMTZbEhN/Pc3lem6+RDmZ/flI7aX4s62kSGdpRR1l9eNhj2KiIwJlRWbrXtMijfRUesRJkPNT9vWxcIBv0eKGyLfgH7sd2fYXb2phTa08QbV0CnxQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ShLuNI9J; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ShLuNI9J"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=v8WGaCpxVhd8Jqmarqqrl7HGY1KxE9D5gOfA/v5r8QQ=;
	b=ShLuNI9JlJV6mbW+1T2k9EoIKvzZf41dknZP9tHhuUboBsVMJleyFKUyqb4f+XnJRGxXuoSN5
	Gz86CmijIV/8Nf7tF8R2W5rp+yNiqIjIN7Zbjpx4yUNU3I7iLl2GYDp3Cyb12HlM0KhVQztAglE
	UutB0EseiG7C7u9BDepXUWY=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hWXm35lPnzKm5t;
	Fri, 28 Aug 2026 17:15:15 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 5CA3F4057A;
	Fri, 28 Aug 2026 17:26:06 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 28 Aug 2026 17:26:05 +0800
Subject: Re: [BUG] crypto: hisilicon/hpre: RSA request never completes during
 signed module verification on Kunpeng arm64
To: Evanshenf <archwse@gmail.com>, <linux-crypto@vger.kernel.org>
CC: Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
References: <178779980745.730913.5616603289665364629.hisi-hpre-7980@gmail.com>
 <5ec5464b-a84d-48c4-6ef7-d60944ae94a9@huawei.com>
 <178782001632.797153.17584967022446448195@gmail.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <dd6abf73-91d3-8949-59e8-549a2fe6c39e@huawei.com>
Date: Fri, 28 Aug 2026 17:26:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <178782001632.797153.17584967022446448195@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2026/8/27 16:40, Evanshenf wrote:
> Hello Longfang and all,
> 
> Thank you for the suggestion. I tested the alignment hypothesis on the affected system with an
> instrumented HPRE module built against the exact 7.0.14-6-pve headers.
> 
> The diagnostic patch detects in-place or unaligned RSA requests and routes source and destination
> through separate dma_alloc_coherent() buffers. Per-PF counters prove that this path was used.
> 
> Results:
> 
>   0000:3e:00.0: send=250, recv=250, bounce=250
>   0000:3a:00.0: send=250, recv=250, bounce=250
>   0000:7e:00.0: send=250, recv=250, bounce=250
>   0000:7a:00.0: first request hung, send=1, recv=0, bounce=1
>

Hello, We have analyzed and pinpointed this issue, and found that the following modification
can resolve it. You may give it a try:

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 99fcc5601ea4..fa45fd7ed173 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2665,6 +2665,10 @@ static int its_alloc_tables(struct its_node *its)
 			indirect = its_parse_indirect_baser(its, baser, &order,
 							    ITS_MAX_VPEID_BITS);
 			break;
+		case GITS_BASER_TYPE_COLLECTION:
+			indirect = its_parse_indirect_baser(its, baser, &order,
+							order_base_2(num_possible_cpus()));
+			break;
 		}

 		err = its_setup_baser(its, baser, cache, shr, order, indirect);

Thanks.
Longfang.

> For the failing PF:
> 
>   SEND_SQE_TO_ACC=1, ACC_FINISH=1, CQE_OUT=1, EQE_OUT=1
>   Linux completion IRQ count=0, HPRE recv_cnt=0
> 
> The task remained blocked in rsassa_pkcs1_verify(), at the same point as the original incident.
> Thus, in-place and unaligned buffers are present, but separate coherent bounce buffers do not fix
> the deterministic completion loss on 0000:7a:00.0. Alignment is not a sufficient root cause. The
> new evidence narrows the fault to the completion-notification path after accelerator completion
> and before the HPRE response callback.
> 
> Could you please help clarify:
> 
> 1. What are the exact meanings of QM_DFX_ACC_FINISH_CNT, QM_CQE_OUT, and QM_EQE_OUT?
> 2. With ACC_FINISH=1, CQE_OUT=1, EQE_OUT=1, and Linux IRQ=0, which additional QM/HPRE/GIC ITS
>    registers would be most useful?
> 3. Is there a known revision-30 19e5:a258 issue affecting one PF/NUMA node or its MSI path?
> 4. Is there a safe way to poll/recover the affected CQ/QP and complete the request with an error
>    while preventing a late-callback use-after-free?
> 
> I attached the complete report, experiment patch, and a sanitized evidence archive containing
> four-PF counters, QM/PCI/MSI state, raw IRQ counts, and the blocked-task stack. The archive contains
> no management addresses, credentials, serial numbers, or unrelated logs.
> 
> Attachment SHA-256:
> 
>   report: 610f08baf93177b0069a406c55279ed73fc1e9cd417ce64c813d8e29fa0e2108
>   patch:  811332a88a7338cc144b60268d9e9be4bae233ce6a0fdab587bead29ceacec50
>   data:   42567764d09204758b0f5e01c9b4d93fab4ed0d2a1a15afef64803d8b7c74815
> 
> The host is back on the safe baseline with hisi_hpre blacklisted and rsa-generic selected. A
> 200-cycle signed-module verification test across all four NUMA nodes passed after recovery.
> 
> Regards,
> Evanshenf
> GitHub: https://github.com/Evanshenf
> 
