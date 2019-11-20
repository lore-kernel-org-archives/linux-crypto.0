Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B66C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 12:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C52FA224F6
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 12:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbfKTMT1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 07:19:27 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6253 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728943AbfKTMT1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 07:19:27 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CCA281A39208A5582348;
        Wed, 20 Nov 2019 20:19:25 +0800 (CST)
Received: from [127.0.0.1] (10.57.77.109) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Wed, 20 Nov 2019
 20:19:19 +0800
Subject: Re: [PATCH v3 0/5] crypto: hisilicon - add HiSilicon SEC V2 support
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
References: <1573643468-1812-1-git-send-email-xuzaibo@huawei.com>
CC:     <forest.zhouchang@huawei.com>, <linuxarm@huawei.com>,
        <zhangwei375@huawei.com>, <yekai13@huawei.com>,
        <linux-crypto@vger.kernel.org>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <038b55c4-afc7-f69b-add8-fc94d5148630@huawei.com>
Date:   Wed, 20 Nov 2019 20:19:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <1573643468-1812-1-git-send-email-xuzaibo@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.77.109]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 2019/11/13 19:11, Zaibo Xu wrote:
> This series adds HiSilicon Security Engine (SEC) version 2 controller
> driver in Crypto subsystem. It includes PCIe enabling, Skcipher, DebugFS
> and SRIOV support of SEC.
>
> This patchset rebases on:
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
>
> This patchset is based on:
> https://www.spinics.net/lists/linux-crypto/msg43520.html
>
> Changes on v3:
>   - bugfixed as running CRYPTO extra tests.
>
> Changes on v2:
>   - delete checking return value of debugfs_create_xxx functions.
>
> Change log:
> v3:    - bugfixed as running CRTPTO extra tests.
> v2:    - remove checking return value of debugfs_create_xxx functions.
>
> Longfang Liu (1):
>    Documentation: add DebugFS doc for HiSilicon SEC
>
> Zaibo Xu (4):
>    crypto: hisilicon - add HiSilicon SEC V2 driver
>    crypto: hisilicon - add SRIOV for HiSilicon SEC
>    crypto: hisilicon - add DebugFS for HiSilicon SEC
>    MAINTAINERS: Add maintainer for HiSilicon SEC V2 driver
>
>   Documentation/ABI/testing/debugfs-hisi-sec |   43 ++
>   MAINTAINERS                                |   10 +
>   drivers/crypto/hisilicon/Kconfig           |   16 +
>   drivers/crypto/hisilicon/Makefile          |    1 +
>   drivers/crypto/hisilicon/sec2/Makefile     |    2 +
>   drivers/crypto/hisilicon/sec2/sec.h        |  156 ++++
>   drivers/crypto/hisilicon/sec2/sec_crypto.c |  889 ++++++++++++++++++++++
>   drivers/crypto/hisilicon/sec2/sec_crypto.h |  198 +++++
>   drivers/crypto/hisilicon/sec2/sec_main.c   | 1095 ++++++++++++++++++++++++++++
>   9 files changed, 2410 insertions(+)
>   create mode 100644 Documentation/ABI/testing/debugfs-hisi-sec
>   create mode 100644 drivers/crypto/hisilicon/sec2/Makefile
>   create mode 100644 drivers/crypto/hisilicon/sec2/sec.h
>   create mode 100644 drivers/crypto/hisilicon/sec2/sec_crypto.c
>   create mode 100644 drivers/crypto/hisilicon/sec2/sec_crypto.h
>   create mode 100644 drivers/crypto/hisilicon/sec2/sec_main.c
Any comments for this version?

Cheers,
Zaibo


