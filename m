Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E1FC282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 05:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A0412084A
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 05:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfBAFWg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 00:22:36 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:56518 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfBAFWg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 00:22:36 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpRHe-0007YD-4w; Fri, 01 Feb 2019 13:22:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpRHa-0004uV-0K; Fri, 01 Feb 2019 13:22:30 +0800
Date:   Fri, 1 Feb 2019 13:22:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linuxarm@huawei.com,
        linux-kernel@vger.kernel.org, Kenneth Lee <liguozhu@hisilicon.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        Hao Fang <fanghao11@huawei.com>
Subject: Re: [PATCH v2 2/4] crypto: hisilicon: Add queue management driver
 for HiSilicon QM module
Message-ID: <20190201052229.wnjeirur6ephew7y@gondor.apana.org.au>
References: <1548248933-149853-1-git-send-email-wangzhou1@hisilicon.com>
 <1548248933-149853-3-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548248933-149853-3-git-send-email-wangzhou1@hisilicon.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 23, 2019 at 09:08:51PM +0800, Zhou Wang wrote:
>
> +/**
> + * hisi_qp_poll() - Poll current cqe to see if a task is finished.
> + * @qp: The qp which will poll.
> + *
> + * This function polls current cqe for a give qp to see if a task is finished.
> + * Return -ETIME if timeout.
> + */
> +int hisi_qp_poll(struct hisi_qp *qp)
> +{
> +	struct qm_cqe *cqe = qp->cqe + qp->qp_status.cq_head;
> +	struct qm_cqc *cqc = qp->cqc;
> +	int retries = 1000;
> +
> +	while (!(QM_CQE_PHASE(cqe) == (cqc->dw6 & 0x1))) {
> +		dma_rmb();
> +		if (!--retries) {
> +			dev_err(&qp->qm->pdev->dev, "Poll cqe failed!\n");
> +			return -ETIME;
> +		}
> +		udelay(10);
> +	}
> +
> +	qm_cq_head_update(qp);
> +	atomic_dec(&qp->qp_status.used);
> +
> +	qm_db(qp->qm, qp->qp_id, QM_DOORBELL_CMD_CQ, qp->qp_status.cq_head, 0);
> +	/* set c_flag */
> +	qm_db(qp->qm, qp->qp_id, QM_DOORBELL_CMD_CQ, qp->qp_status.cq_head, 1);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(hisi_qp_poll);

Polling in softirq context is unacceptable.  Can't your hardware
send interrupts to signal completion? What is the average speed
of processing a single 1500-byte packet on your hardware?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
