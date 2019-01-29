Return-Path: <SRS0=zJfq=QF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1064C282D0
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Jan 2019 01:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9456521738
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Jan 2019 01:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfA2BTY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jan 2019 20:19:24 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:2789 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726993AbfA2BTY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jan 2019 20:19:24 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7450794E94F0EC393648;
        Tue, 29 Jan 2019 09:19:22 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.408.0; Tue, 29 Jan 2019
 09:19:14 +0800
Subject: Re: [PATCH v2 0/4] crypto: hisilicon: Add HiSilicon QM and ZIP
 controller driver
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
References: <1548248933-149853-1-git-send-email-wangzhou1@hisilicon.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5C4FAA19.7010807@hisilicon.com>
Date:   Tue, 29 Jan 2019 09:19:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <1548248933-149853-1-git-send-email-wangzhou1@hisilicon.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/1/23 21:08, Zhou Wang wrote:
> This series adds HiSilicon QM and ZIP controller driver in crypto subsystem.
> 
> A simple QM/ZIP driver which helps to provide an example for a general
> accelerator framework is under review in community[1]. Based on this simple
> driver, this series adds HW v2 support, PCI passthrough, reset, PCI/misc error
> handler, debug support. But unlike [1], driver in this patchset only registers
> to crypto subsystem.
> 
> There will be a long discussion about above accelerator framework in the
> process of upstreaming. So let's firstly review and upstream QM/ZIP crypto
> driver.
> 
> Changes v1 -> v2:
> - Change to register zlib/gzip to scomp.
> - Remove hisi_qm_mem_init/uninit, make QM interfaces compact.
> - Some tiny fixes.
> 
> Links:
> - v1  https://lwn.net/Articles/775484/
> - rfc https://lkml.org/lkml/2018/12/13/290
> 
> Reference:
> [1] https://lkml.org/lkml/2018/11/12/1951
> 
> Zhou Wang (4):
>   Documentation: Add debugfs doc for hisi_zip
>   crypto: hisilicon: Add queue management driver for HiSilicon QM module
>   crypto: hisilicon: Add HiSilicon ZIP accelerator support
>   MAINTAINERS: add maintainer for HiSilicon QM and ZIP controller driver
> 
>  Documentation/ABI/testing/debugfs-hisi-zip |   50 +
>  MAINTAINERS                                |    8 +
>  drivers/crypto/hisilicon/Kconfig           |   11 +
>  drivers/crypto/hisilicon/Makefile          |    2 +
>  drivers/crypto/hisilicon/qm.c              | 1736 ++++++++++++++++++++++++++++
>  drivers/crypto/hisilicon/qm.h              |  276 +++++
>  drivers/crypto/hisilicon/zip/Makefile      |    2 +
>  drivers/crypto/hisilicon/zip/zip.h         |   60 +
>  drivers/crypto/hisilicon/zip/zip_crypto.c  |  484 ++++++++
>  drivers/crypto/hisilicon/zip/zip_main.c    | 1199 +++++++++++++++++++
>  10 files changed, 3828 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-zip
>  create mode 100644 drivers/crypto/hisilicon/qm.c
>  create mode 100644 drivers/crypto/hisilicon/qm.h
>  create mode 100644 drivers/crypto/hisilicon/zip/Makefile
>  create mode 100644 drivers/crypto/hisilicon/zip/zip.h
>  create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.c
>  create mode 100644 drivers/crypto/hisilicon/zip/zip_main.c
> 

Any comments for this version?

Best,
Zhou

