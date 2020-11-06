Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E11C2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 07:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C29A120B80
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 07:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgKFHDE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 02:03:04 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:35080 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgKFHDD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 02:03:03 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kavlv-00084x-Qt; Fri, 06 Nov 2020 18:02:56 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2020 18:02:55 +1100
Date:   Fri, 6 Nov 2020 18:02:55 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH 0/8] crypto: hisilicon/qm - misc clean up
Message-ID: <20201106070255.GI11620@gondor.apana.org.au>
References: <1604135228-18410-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604135228-18410-1-git-send-email-qianweili@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 31, 2020 at 05:07:00PM +0800, Weili Qian wrote:
> This patchset makes some clean up, please see comments in each patch.
> 
> Weili Qian (8):
>   crypto: hisilicon/qm - numbers are replaced by macros
>   crypto: hisilicon/qm - modify the return type of function
>   crypto: hisilicon/qm - modify the return type of debugfs interface
>   crypto: hisilicon/qm - modify return type of 'qm_set_sqctype'
>   crypto: hisilicon/qm - replace 'sprintf' with 'scnprintf'
>   crypto: hisilicon/qm - split 'qm_qp_ctx_cfg' into smaller pieces
>   crypto: hisilicon/qm - split 'qm_eq_ctx_cfg' into smaller pieces
>   crypto: hisilicon/qm - split 'hisi_qm_init' into smaller pieces
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c |   4 +-
>  drivers/crypto/hisilicon/qm.c             | 207 +++++++++++++++++++-----------
>  drivers/crypto/hisilicon/qm.h             |   2 +-
>  drivers/crypto/hisilicon/sec2/sec_main.c  |   4 +-
>  drivers/crypto/hisilicon/zip/zip_main.c   |   4 +-
>  5 files changed, 134 insertions(+), 87 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
