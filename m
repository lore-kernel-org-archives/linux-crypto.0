Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A9DBC4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C580A207C4
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 08:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgIYIRZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:17:25 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53402 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgIYIRY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 04:17:24 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLiuq-0007Ol-Ax; Fri, 25 Sep 2020 18:17:17 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Sep 2020 18:17:16 +1000
Date:   Fri, 25 Sep 2020 18:17:16 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     yumeng 00484669 <yumeng18@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] crypto: hisilicon/hpre - misc clean up and fixes
Message-ID: <20200925081716.GS6381@gondor.apana.org.au>
References: <1600485232-39831-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600485232-39831-1-git-send-email-yumeng18@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 19, 2020 at 11:13:49AM +0800, yumeng 00484669 wrote:
> Adjust some tiny coding problems and fix a bug of DH algorithm.
> 
> Changes since v1:
> Remove 'u64' cast in 'cpu_to_le64';
> 
> Meng Yu (3):
>   crypto: hisilicon/hpre - remove useless code
>   crypto: hisilicon/hpre - adjust some coding style
>   crypto: hisilicon/hpre - fix a bug in dh algorithm
> 
>  drivers/crypto/hisilicon/hpre/hpre.h        |  1 -
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 23 +++++++++++------------
>  2 files changed, 11 insertions(+), 13 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
