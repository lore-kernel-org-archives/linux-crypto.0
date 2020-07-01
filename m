Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FB8C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 11:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F76C206CB
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 11:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgGALgW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 07:36:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7328 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730196AbgGALgW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 07:36:22 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1D11C33996FA9CB4829A
        for <linux-crypto@vger.kernel.org>; Wed,  1 Jul 2020 19:36:19 +0800 (CST)
Received: from [10.63.139.185] (10.63.139.185) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 1 Jul 2020 19:36:15 +0800
Subject: Re: [PATCH] crypto: hisilicon/qm: Change type of pasid to u32
To:     Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ravi V Shankar <ravi.v.shankar@intel.com>
References: <1593115632-31417-1-git-send-email-fenghua.yu@intel.com>
CC:     <linux-crypto@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5EFC752E.6020507@hisilicon.com>
Date:   Wed, 1 Jul 2020 19:36:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <1593115632-31417-1-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020/6/26 4:07, Fenghua Yu wrote:
> PASID is defined as "int" although it's a 20-bit value and shouldn't be
> negative int. To be consistent with PASID type in iommu, define PASID
> as "u32".
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

Hi Fenghua,

Looks good to me, thanks for fixing this.

Zhou

> ---
> PASID type will be changed consistently as u32:
> https://lore.kernel.org/patchwork/patch/1257770/
> 
>  drivers/crypto/hisilicon/qm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index 9bb263cec6c3..8697dacf926d 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -1741,7 +1741,7 @@ void hisi_qm_release_qp(struct hisi_qp *qp)
>  }
>  EXPORT_SYMBOL_GPL(hisi_qm_release_qp);
>  
> -static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, int pasid)
> +static int qm_qp_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
>  {
>  	struct hisi_qm *qm = qp->qm;
>  	struct device *dev = &qm->pdev->dev;
> @@ -1813,7 +1813,7 @@ static int qm_start_qp_nolock(struct hisi_qp *qp, unsigned long arg)
>  	struct hisi_qm *qm = qp->qm;
>  	struct device *dev = &qm->pdev->dev;
>  	int qp_id = qp->qp_id;
> -	int pasid = arg;
> +	u32 pasid = arg;
>  	int ret;
>  
>  	if (!qm_qp_avail_state(qm, qp, QP_START))
> 
