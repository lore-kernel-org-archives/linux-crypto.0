Return-Path: <SRS0=Yf/g=65=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DC9C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 06:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5246A20760
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 06:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgEOGVZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 May 2020 02:21:25 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34334 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgEOGVZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 May 2020 02:21:25 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jZTik-0007V6-Bg; Fri, 15 May 2020 16:21:23 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2020 16:21:22 +1000
Date:   Fri, 15 May 2020 16:21:22 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shukun Tan <tanshukun1@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v2 00/12] crypto: hisilicon - misc cleanup and
 optimizations
Message-ID: <20200515062122.GC22330@gondor.apana.org.au>
References: <1589017445-15514-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589017445-15514-1-git-send-email-tanshukun1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 09, 2020 at 05:43:53PM +0800, Shukun Tan wrote:
> This patchset includes some misc updates.
> patch 1-3: modify the accelerator probe process.
> patch 4: refactor module parameter pf_q_num.
> patch 5-6: add state machine and FLR support.
> patch 7: remove use_dma_api related useless codes.
> patch 8-9: QM initialization process and memory management optimization.
> patch 10-11: add device error report through abnormal irq.
> patch 12: tiny change of zip driver.
> 
> Longfang Liu (3):
>   crypto: hisilicon/sec2 - modify the SEC probe process
>   crypto: hisilicon/hpre - modify the HPRE probe process
>   crypto: hisilicon/zip - modify the ZIP probe process
> 
> Shukun Tan (5):
>   crypto: hisilicon - refactor module parameter pf_q_num related code
>   crypto: hisilicon - add FLR support
>   crypto: hisilicon - remove use_dma_api related codes
>   crypto: hisilicon - remove codes of directly report device errors
>     through MSI
>   crypto: hisilicon - add device error report through abnormal irq
> 
> Weili Qian (2):
>   crypto: hisilicon - unify initial value assignment into QM
>   crypto: hisilicon - QM memory management optimization
> 
> Zhou Wang (2):
>   crypto: hisilicon/qm - add state machine for QM
>   crypto: hisilicon/zip - Use temporary sqe when doing work
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c |  107 ++-
>  drivers/crypto/hisilicon/qm.c             | 1101 +++++++++++++++++++----------
>  drivers/crypto/hisilicon/qm.h             |   75 +-
>  drivers/crypto/hisilicon/sec2/sec_main.c  |  134 ++--
>  drivers/crypto/hisilicon/zip/zip_crypto.c |   11 +-
>  drivers/crypto/hisilicon/zip/zip_main.c   |  128 ++--
>  6 files changed, 950 insertions(+), 606 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
