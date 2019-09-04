Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCEBC3A5A9
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 08:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FB362343A
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 08:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbfIDIPU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:15:20 -0400
Received: from 8bytes.org ([81.169.241.247]:53108 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfIDIPU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Sep 2019 04:15:20 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 8A42E445; Wed,  4 Sep 2019 10:15:17 +0200 (CEST)
Date:   Wed, 4 Sep 2019 10:15:17 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        arno@natisbad.org, gregkh@linuxfoundation.org,
        iommu@lists.linux-foundation.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] iommu/pamu: Use kzfree rather than its implementation
Message-ID: <20190904081517.GA29855@8bytes.org>
References: <1567566079-7412-1-git-send-email-zhongjiang@huawei.com>
 <1567566079-7412-3-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567566079-7412-3-git-send-email-zhongjiang@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 04, 2019 at 11:01:18AM +0800, zhong jiang wrote:
> Use kzfree instead of memset() + kfree().
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/iommu/fsl_pamu.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
> index cde281b..ca6d147 100644
> --- a/drivers/iommu/fsl_pamu.c
> +++ b/drivers/iommu/fsl_pamu.c
> @@ -1174,10 +1174,8 @@ static int fsl_pamu_probe(struct platform_device *pdev)
>  	if (irq != NO_IRQ)
>  		free_irq(irq, data);
>  
> -	if (data) {
> -		memset(data, 0, sizeof(struct pamu_isr_data));
> -		kfree(data);
> -	}
> +	if (data)
> +		kzfree(data);

kzfree() is doing its own NULL-ptr check, no need to do it here.

Regards,

	Joerg
