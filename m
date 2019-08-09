Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69278C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 07:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4835A208C4
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 07:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfHIHOl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 03:14:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60362 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725954AbfHIHOk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 03:14:40 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3DBCDBFB3BEAEDC60BD7;
        Fri,  9 Aug 2019 15:14:30 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 9 Aug 2019
 15:14:23 +0800
Subject: Re: [PATCH v3 0/7] crypto: hisilicon: Add HiSilicon QM and ZIP
 controller driver
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1564732676-35987-1-git-send-email-wangzhou1@hisilicon.com>
 <20190809061946.GN10392@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5D4D1D4E.2070906@hisilicon.com>
Date:   Fri, 9 Aug 2019 15:14:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20190809061946.GN10392@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/8/9 14:19, Herbert Xu wrote:
> On Fri, Aug 02, 2019 at 03:57:49PM +0800, Zhou Wang wrote:
>> This series adds HiSilicon QM and ZIP controller driver in crypto subsystem.
>>
>> A simple QM/ZIP driver which helps to provide an example for a general
>> accelerator framework is under review in community[1]. Based on this simple
>> driver, this series adds HW v2 support, PCI passthrough, PCI/misc error
>> handler, debug support. But unlike [1], driver in this patchset only registers
>> to crypto subsystem.
>>
>> There will be a long discussion about above accelerator framework in the
>> process of upstreaming. So let's firstly review and upstream QM/ZIP crypto
>> driver.
>>
>> Changes v2 -> v3:
>> - Change to register zlib/gzip to crypto acomp.
>> - As acomp is using sgl interface, add a common hardware sgl module which
>>   also can be used in other HiSilicon accelerator drivers.
>> - Change irq thread to work queue in the flow of irq handler in QM.
>> - Split SRIOV and debugfs out for the convenience of review.
>> - rebased on v5.3-rc1.
>> - Some tiny fixes.
>>
>> Links:
>> - v2  https://lkml.org/lkml/2019/1/23/358
>> - v1  https://lwn.net/Articles/775484/
>> - rfc https://lkml.org/lkml/2018/12/13/290
>>
>> Note: this series is based on https://lkml.org/lkml/2019/7/23/1135
>>
>> Reference:
>> [1] https://lkml.org/lkml/2018/11/12/1951
>>
>> Zhou Wang (7):
>>   crypto: hisilicon: Add queue management driver for HiSilicon QM module
>>   crypto: hisilicon: Add hardware SGL support
>>   crypto: hisilicon: Add HiSilicon ZIP accelerator support
>>   crypto: hisilicon: Add SRIOV support for ZIP
>>   Documentation: Add debugfs doc for hisi_zip
>>   crypto: hisilicon: Add debugfs for ZIP and QM
>>   MAINTAINERS: add maintainer for HiSilicon QM and ZIP controller driver
>>
>>  Documentation/ABI/testing/debugfs-hisi-zip |   50 +
>>  MAINTAINERS                                |   11 +
>>  drivers/crypto/hisilicon/Kconfig           |   23 +
>>  drivers/crypto/hisilicon/Makefile          |    3 +
>>  drivers/crypto/hisilicon/qm.c              | 1912 ++++++++++++++++++++++++++++
>>  drivers/crypto/hisilicon/qm.h              |  215 ++++
>>  drivers/crypto/hisilicon/sgl.c             |  214 ++++
>>  drivers/crypto/hisilicon/sgl.h             |   24 +
>>  drivers/crypto/hisilicon/zip/Makefile      |    2 +
>>  drivers/crypto/hisilicon/zip/zip.h         |   71 ++
>>  drivers/crypto/hisilicon/zip/zip_crypto.c  |  651 ++++++++++
>>  drivers/crypto/hisilicon/zip/zip_main.c    | 1013 +++++++++++++++
>>  12 files changed, 4189 insertions(+)
>>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-zip
>>  create mode 100644 drivers/crypto/hisilicon/qm.c
>>  create mode 100644 drivers/crypto/hisilicon/qm.h
>>  create mode 100644 drivers/crypto/hisilicon/sgl.c
>>  create mode 100644 drivers/crypto/hisilicon/sgl.h
>>  create mode 100644 drivers/crypto/hisilicon/zip/Makefile
>>  create mode 100644 drivers/crypto/hisilicon/zip/zip.h
>>  create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.c
>>  create mode 100644 drivers/crypto/hisilicon/zip/zip_main.c
> 
> All applied.  Thanks.

Many thanks.

Zhou

> 

