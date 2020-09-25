Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE41C4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FDEC207C4
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgIYIR3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:17:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53406 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgIYIR3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 04:17:29 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLiv0-0007Pl-TK; Fri, 25 Sep 2020 18:17:27 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Sep 2020 18:17:26 +1000
Date:   Fri, 25 Sep 2020 18:17:26 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH 0/2] crypto: hisilicon/qm - misc fixes
Message-ID: <20200925081726.GT6381@gondor.apana.org.au>
References: <1600513296-29287-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600513296-29287-1-git-send-email-qianweili@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 19, 2020 at 07:01:34PM +0800, Weili Qian wrote:
> This patchset fix some driver bugs
> 
> Resend this patch series because it depends on
> https://patchwork.kernel.org/cover/11760159/
> (crypto: hisilicon/zip - misc clean up).
> Now the patch series has been applied.
> 
> Weili Qian (1):
>   crypto: hisilicon/qm - remove the update of flags
> 
> Yang Shen (1):
>   crypto: hisilicon/qm - fix wrong return type of 'pci_get_drvdata'
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 3 +--
>  drivers/crypto/hisilicon/qm.c             | 1 -
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 3 +--
>  drivers/crypto/hisilicon/zip/zip_main.c   | 3 +--
>  4 files changed, 3 insertions(+), 7 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
