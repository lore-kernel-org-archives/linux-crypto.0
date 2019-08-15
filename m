Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D97C3A589
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 14:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C68D2084D
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 14:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732635AbfHOOR7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 10:17:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4716 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732816AbfHOOR7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 10:17:59 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D944B868952EBB349EBB
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 22:17:40 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 15 Aug 2019
 22:17:37 +0800
Subject: Re: crypto: hisilicon - Fix warning on printing %p with dma_addr_t
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>
References: <20190815120313.GA29253@gondor.apana.org.au>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5D556981.2080309@hisilicon.com>
Date:   Thu, 15 Aug 2019 22:17:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20190815120313.GA29253@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/8/15 20:03, Herbert Xu wrote:
> This patch fixes a printk format warning by replacing %p with %#lx
> for dma_addr_t.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index d72e062..3095284 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -347,8 +347,8 @@ static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
>  	struct qm_mailbox mailbox;
>  	int ret = 0;
>  
> -	dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%pad\n", queue,
> -		cmd, dma_addr);
> +	dev_dbg(&qm->pdev->dev, "QM mailbox request to q%u: %u-%#lxad\n",
> +		queue, cmd, (unsigned long)dma_addr);

Thanks. However, to be honest I can't get why we fix it like this.
Can you give me a clue?

>  
>  	mailbox.w0 = cmd |
>  		     (op ? 0x1 << QM_MB_OP_SHIFT : 0) |
> 

