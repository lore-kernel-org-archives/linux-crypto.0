Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611DEC43463
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B8D121734
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgIRH31 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:29:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57636 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgIRH3Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:29:25 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kJApe-0003X6-Ua; Fri, 18 Sep 2020 17:29:24 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2020 17:29:22 +1000
Date:   Fri, 18 Sep 2020 17:29:22 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Longfang Liu <liulongfang@huawei.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/5] crypto: hisilicon - update ACC module parameter
Message-ID: <20200918072922.GG23319@gondor.apana.org.au>
References: <1599739003-23448-1-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1599739003-23448-1-git-send-email-liulongfang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 10, 2020 at 07:56:38PM +0800, Longfang Liu wrote:
> In order to pass kernel crypto test, the ACC module parameter
> pf_q_num needs to be set to an integer greater than 1,
> and then fixed two bugs.
> 
> Longfang Liu (5):
>   crypto: hisilicon - update mininum queue
>   crypto: hisilicon - update HPRE module parameter description
>   crypto: hisilicon - update SEC module parameter description
>   crypto: hisilicon - update ZIP module parameter description
>   crypto: hisilicon - fixed memory allocation error
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c  |  2 +-
>  drivers/crypto/hisilicon/qm.h              |  4 ++--
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 16 ++++++++++++----
>  drivers/crypto/hisilicon/sec2/sec_main.c   |  2 +-
>  drivers/crypto/hisilicon/zip/zip_main.c    |  2 +-
>  5 files changed, 17 insertions(+), 9 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
