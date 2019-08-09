Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBA5C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8D34208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 06:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405618AbfHIGUC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 02:20:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37460 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405630AbfHIGUC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 02:20:02 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hvyFh-0007Ol-EG; Fri, 09 Aug 2019 16:19:49 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hvyFe-0002r6-Tw; Fri, 09 Aug 2019 16:19:46 +1000
Date:   Fri, 9 Aug 2019 16:19:46 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linuxarm@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] crypto: hisilicon: Add HiSilicon QM and ZIP
 controller driver
Message-ID: <20190809061946.GN10392@gondor.apana.org.au>
References: <1564732676-35987-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564732676-35987-1-git-send-email-wangzhou1@hisilicon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 02, 2019 at 03:57:49PM +0800, Zhou Wang wrote:
> This series adds HiSilicon QM and ZIP controller driver in crypto subsystem.
> 
> A simple QM/ZIP driver which helps to provide an example for a general
> accelerator framework is under review in community[1]. Based on this simple
> driver, this series adds HW v2 support, PCI passthrough, PCI/misc error
> handler, debug support. But unlike [1], driver in this patchset only registers
> to crypto subsystem.
> 
> There will be a long discussion about above accelerator framework in the
> process of upstreaming. So let's firstly review and upstream QM/ZIP crypto
> driver.
> 
> Changes v2 -> v3:
> - Change to register zlib/gzip to crypto acomp.
> - As acomp is using sgl interface, add a common hardware sgl module which
>   also can be used in other HiSilicon accelerator drivers.
> - Change irq thread to work queue in the flow of irq handler in QM.
> - Split SRIOV and debugfs out for the convenience of review.
> - rebased on v5.3-rc1.
> - Some tiny fixes.
> 
> Links:
> - v2  https://lkml.org/lkml/2019/1/23/358
> - v1  https://lwn.net/Articles/775484/
> - rfc https://lkml.org/lkml/2018/12/13/290
> 
> Note: this series is based on https://lkml.org/lkml/2019/7/23/1135
> 
> Reference:
> [1] https://lkml.org/lkml/2018/11/12/1951
> 
> Zhou Wang (7):
>   crypto: hisilicon: Add queue management driver for HiSilicon QM module
>   crypto: hisilicon: Add hardware SGL support
>   crypto: hisilicon: Add HiSilicon ZIP accelerator support
>   crypto: hisilicon: Add SRIOV support for ZIP
>   Documentation: Add debugfs doc for hisi_zip
>   crypto: hisilicon: Add debugfs for ZIP and QM
>   MAINTAINERS: add maintainer for HiSilicon QM and ZIP controller driver
> 
>  Documentation/ABI/testing/debugfs-hisi-zip |   50 +
>  MAINTAINERS                                |   11 +
>  drivers/crypto/hisilicon/Kconfig           |   23 +
>  drivers/crypto/hisilicon/Makefile          |    3 +
>  drivers/crypto/hisilicon/qm.c              | 1912 ++++++++++++++++++++++++++++
>  drivers/crypto/hisilicon/qm.h              |  215 ++++
>  drivers/crypto/hisilicon/sgl.c             |  214 ++++
>  drivers/crypto/hisilicon/sgl.h             |   24 +
>  drivers/crypto/hisilicon/zip/Makefile      |    2 +
>  drivers/crypto/hisilicon/zip/zip.h         |   71 ++
>  drivers/crypto/hisilicon/zip/zip_crypto.c  |  651 ++++++++++
>  drivers/crypto/hisilicon/zip/zip_main.c    | 1013 +++++++++++++++
>  12 files changed, 4189 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-zip
>  create mode 100644 drivers/crypto/hisilicon/qm.c
>  create mode 100644 drivers/crypto/hisilicon/qm.h
>  create mode 100644 drivers/crypto/hisilicon/sgl.c
>  create mode 100644 drivers/crypto/hisilicon/sgl.h
>  create mode 100644 drivers/crypto/hisilicon/zip/Makefile
>  create mode 100644 drivers/crypto/hisilicon/zip/zip.h
>  create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.c
>  create mode 100644 drivers/crypto/hisilicon/zip/zip_main.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
