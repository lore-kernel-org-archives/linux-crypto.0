Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458CDC4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18CAF2067B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 12:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387787AbfJJMyj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 08:54:39 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37610 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728339AbfJJMyj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 08:54:39 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iIXxg-0001rW-Lx; Thu, 10 Oct 2019 23:54:33 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2019 23:54:32 +1100
Date:   Thu, 10 Oct 2019 23:54:32 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zaibo Xu <xuzaibo@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxarm@huawei.com,
        forest.zhouchang@huawei.com
Subject: Re: [PATCH 0/5] crypto: hisilicon - add HPRE support
Message-ID: <20191010125432.GC31566@gondor.apana.org.au>
References: <1569835209-44326-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569835209-44326-1-git-send-email-xuzaibo@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 30, 2019 at 05:20:04PM +0800, Zaibo Xu wrote:
> This series adds HiSilicon high performance RSA engine(HPRE) driver
> in crypto subsystem. HPRE driver provides PCIe hardware device initiation
> with RSA and DH algorithms registered to Crypto. Meanwhile, some debug
> supporting of DebugFS is given.
> 
> Zaibo Xu (5):
>   crypto: hisilicon - add HiSilicon HPRE accelerator
>   crypto: hisilicon - add SRIOV support for HPRE
>   Documentation: Add debugfs doc for hisi_hpre
>   crypto: hisilicon: Add debugfs for HPRE
>   MAINTAINERS: Add maintainer for HiSilicon HPRE driver
> 
>  Documentation/ABI/testing/debugfs-hisi-hpre |   57 ++
>  MAINTAINERS                                 |    9 +
>  drivers/crypto/hisilicon/Kconfig            |   11 +
>  drivers/crypto/hisilicon/Makefile           |    1 +
>  drivers/crypto/hisilicon/hpre/Makefile      |    2 +
>  drivers/crypto/hisilicon/hpre/hpre.h        |   83 ++
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 1137 +++++++++++++++++++++++++++
>  drivers/crypto/hisilicon/hpre/hpre_main.c   | 1052 +++++++++++++++++++++++++
>  8 files changed, 2352 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-hpre
>  create mode 100644 drivers/crypto/hisilicon/hpre/Makefile
>  create mode 100644 drivers/crypto/hisilicon/hpre/hpre.h
>  create mode 100644 drivers/crypto/hisilicon/hpre/hpre_crypto.c
>  create mode 100644 drivers/crypto/hisilicon/hpre/hpre_main.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
