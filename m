Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05247C43463
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C479521734
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgIRH2n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:28:43 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57600 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgIRH2n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:28:43 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kJAor-0003Ui-Vh; Fri, 18 Sep 2020 17:28:35 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2020 17:28:33 +1000
Date:   Fri, 18 Sep 2020 17:28:33 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v2 00/10] crypto: hisilicon/zip - misc clean up
Message-ID: <20200918072833.GC23319@gondor.apana.org.au>
References: <1599466922-10323-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599466922-10323-1-git-send-email-shenyang39@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 07, 2020 at 04:21:52PM +0800, Yang Shen wrote:
> This patchset make some clean up:
> patch 1:remove useless parameters
> patch 4:replace 'sprintf' with 'scnprintf'
> patch 7:fix static check warning
> and the rest patch fix some coding style
> 
> v2:
> - remove the return check of 'scnprintf' in PATCH 4
> 
> Shukun Tan (1):
>   crypto: hisilicon/zip - modify debugfs interface parameters
> 
> Yang Shen (9):
>   crypto: hisilicon/zip - remove some useless parameters
>   crypto: hisilicon/zip - unify naming style for functions and macros
>   crypto: hisilicon/zip - replace 'sprintf' with 'scnprintf'
>   crypto: hisilicon/zip - use a enum parameter instead of some macros
>   crypto: hisilicon/zip - add print for error branch
>   crypto: hisilicon/zip - fix static check warning
>   crypto: hisilicon/zip - move some private macros from 'zip.h' to
>     'zip_crypto.c'
>   crypto: hisilicon/zip - supplement some comments
>   crypto: hisilicon/zip - fix some coding styles
> 
>  drivers/crypto/hisilicon/zip/zip.h        |  15 ----
>  drivers/crypto/hisilicon/zip/zip_crypto.c | 112 ++++++++++++++++++--------
>  drivers/crypto/hisilicon/zip/zip_main.c   | 126 ++++++++++++++----------------
>  3 files changed, 135 insertions(+), 118 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
