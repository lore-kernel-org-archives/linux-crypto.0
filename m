Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734E1C0650F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 12:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ED9A2171F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 12:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbfHHMlk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 08:41:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4195 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726285AbfHHMlk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 08:41:40 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DFEF553C41FAB80B3D61;
        Thu,  8 Aug 2019 20:41:34 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 8 Aug 2019
 20:41:24 +0800
Subject: Re: [PATCH v3 0/7] crypto: hisilicon: Add HiSilicon QM and ZIP
 controller driver
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
References: <1564732676-35987-1-git-send-email-wangzhou1@hisilicon.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5D4C1874.6030200@hisilicon.com>
Date:   Thu, 8 Aug 2019 20:41:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <1564732676-35987-1-git-send-email-wangzhou1@hisilicon.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/8/2 15:57, Zhou Wang wrote:
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
> 

Any comments for this version?

Best,
Zhou

