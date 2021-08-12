Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58B4C432BE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 11:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6B9D61058
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 11:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhHLLbj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 07:31:39 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52730 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232025AbhHLLbi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 07:31:38 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mE8vY-0003Kl-NN; Thu, 12 Aug 2021 19:31:12 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mE8vV-0002NX-R2; Thu, 12 Aug 2021 19:31:09 +0800
Date:   Thu, 12 Aug 2021 19:31:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, wangzhou1@hisilicon.com,
        liulongfang@huawei.com
Subject: Re: [PATCH 3/5] crypto: hisilicon - support runtime PM for
 accelerator device
Message-ID: <20210812113109.GA9121@gondor.apana.org.au>
References: <1628332356-33278-1-git-send-email-qianweili@huawei.com>
 <1628332356-33278-4-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628332356-33278-4-git-send-email-qianweili@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 07, 2021 at 06:32:34PM +0800, Weili Qian wrote:
>
> @@ -1083,6 +1105,10 @@ static void hpre_remove(struct pci_dev *pdev)
>  	hisi_qm_uninit(qm);
>  }
>  
> +const struct dev_pm_ops hpre_pm_ops = {
> +	SET_RUNTIME_PM_OPS(hisi_qm_suspend, hisi_qm_resume, NULL)
> +};
> +

This causes a warning as it should be static.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
