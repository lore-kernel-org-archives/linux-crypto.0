Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EF7C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04B2F208C3
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733300AbfJJMy0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 08:54:26 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37602 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728339AbfJJMy0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 08:54:26 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iIXxT-0001oh-FL; Thu, 10 Oct 2019 23:54:20 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2019 23:54:13 +1100
Date:   Thu, 10 Oct 2019 23:54:13 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH 0/4] crypto: hisilicon: misc sgl fixes
Message-ID: <20191010125413.GB31566@gondor.apana.org.au>
References: <1569827335-21822-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569827335-21822-1-git-send-email-wangzhou1@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 30, 2019 at 03:08:51PM +0800, Zhou Wang wrote:
> This series fixes some preblems in sgl code. The main change is merging sgl
> code into hisi_qm module. 
> 
> These problem are also fixed:
>  - Let user driver to pass the configure of sge number in one sgl when
>    creating hardware sgl resources.
>  - When disabling SMMU, it may fail to allocate large continuous memory. We
>    fixes this by allocating memory by blocks.
> 
> This series is based on Arnd's patch: https://lkml.org/lkml/2019/9/19/455
> 
> Shunkun Tan (1):
>   crypto: hisilicon - add sgl_sge_nr module param for zip
> 
> Zhou Wang (3):
>   crypto: hisilicon - merge sgl support to hisi_qm module
>   crypto: hisilicon - fix large sgl memory allocation problem when
>     disable smmu
>   crypto: hisilicon - misc fix about sgl
> 
>  MAINTAINERS                               |   1 -
>  drivers/crypto/hisilicon/Kconfig          |   9 --
>  drivers/crypto/hisilicon/Makefile         |   4 +-
>  drivers/crypto/hisilicon/qm.h             |  13 +++
>  drivers/crypto/hisilicon/sgl.c            | 182 +++++++++++++++++++-----------
>  drivers/crypto/hisilicon/sgl.h            |  24 ----
>  drivers/crypto/hisilicon/zip/zip.h        |   1 -
>  drivers/crypto/hisilicon/zip/zip_crypto.c |  44 ++++++--
>  8 files changed, 167 insertions(+), 111 deletions(-)
>  delete mode 100644 drivers/crypto/hisilicon/sgl.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
