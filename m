Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDFA9C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 07:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1700208E4
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 07:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731791AbgGaH5g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Jul 2020 03:57:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39922 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731787AbgGaH5f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Jul 2020 03:57:35 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k1Pus-0001rJ-Mf; Fri, 31 Jul 2020 17:57:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Jul 2020 17:57:22 +1000
Date:   Fri, 31 Jul 2020 17:57:22 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v3 08/10] crypto: hisilicon/qm - fix the process of
 register algorithms to crypto
Message-ID: <20200731075722.GA20350@gondor.apana.org.au>
References: <1595488780-22085-1-git-send-email-shenyang39@huawei.com>
 <1595488780-22085-9-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595488780-22085-9-git-send-email-shenyang39@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 23, 2020 at 03:19:38PM +0800, Yang Shen wrote:
> When the devices are removed or not existing, the corresponding algorithms
> which are registered by 'hisi-zip' driver can't be used.
> 
> Move 'hisi_zip_register_to_crypto' from 'hisi_zip_init' to
> 'hisi_zip_probe'. The algorithms will be registered to crypto only when
> there is device bind on the driver. And when the devices are removed,
> the algorithms will be unregistered.
> 
> In the previous process, the function 'xxx_register_to_crypto' need a lock
> and a static variable to judge if the registration is the first time.
> Move this action into the function 'hisi_qm_alg_register'. Each device
> will call 'hisi_qm_alg_register' to add itself to qm list in probe process
> and registering algs when the qm list is empty.
> 
> Signed-off-by: Yang Shen <shenyang39@huawei.com>
> Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>

You still haven't resolved the issue of unregistering crypto
algorithms that may be allocated.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
