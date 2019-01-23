Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06FCC282C2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 13:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFBF520823
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 13:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfAWNIn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 08:08:43 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36360 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbfAWNIn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 08:08:43 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 47EEC813A4F9BBDD5C5F;
        Wed, 23 Jan 2019 21:08:40 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.408.0; Wed, 23 Jan 2019 21:08:29 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH v2 0/4] crypto: hisilicon: Add HiSilicon QM and ZIP controller driver
Date:   Wed, 23 Jan 2019 21:08:49 +0800
Message-ID: <1548248933-149853-1-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series adds HiSilicon QM and ZIP controller driver in crypto subsystem.

A simple QM/ZIP driver which helps to provide an example for a general
accelerator framework is under review in community[1]. Based on this simple
driver, this series adds HW v2 support, PCI passthrough, reset, PCI/misc error
handler, debug support. But unlike [1], driver in this patchset only registers
to crypto subsystem.

There will be a long discussion about above accelerator framework in the
process of upstreaming. So let's firstly review and upstream QM/ZIP crypto
driver.

Changes v1 -> v2:
- Change to register zlib/gzip to scomp.
- Remove hisi_qm_mem_init/uninit, make QM interfaces compact.
- Some tiny fixes.

Links:
- v1  https://lwn.net/Articles/775484/
- rfc https://lkml.org/lkml/2018/12/13/290

Reference:
[1] https://lkml.org/lkml/2018/11/12/1951

Zhou Wang (4):
  Documentation: Add debugfs doc for hisi_zip
  crypto: hisilicon: Add queue management driver for HiSilicon QM module
  crypto: hisilicon: Add HiSilicon ZIP accelerator support
  MAINTAINERS: add maintainer for HiSilicon QM and ZIP controller driver

 Documentation/ABI/testing/debugfs-hisi-zip |   50 +
 MAINTAINERS                                |    8 +
 drivers/crypto/hisilicon/Kconfig           |   11 +
 drivers/crypto/hisilicon/Makefile          |    2 +
 drivers/crypto/hisilicon/qm.c              | 1736 ++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h              |  276 +++++
 drivers/crypto/hisilicon/zip/Makefile      |    2 +
 drivers/crypto/hisilicon/zip/zip.h         |   60 +
 drivers/crypto/hisilicon/zip/zip_crypto.c  |  484 ++++++++
 drivers/crypto/hisilicon/zip/zip_main.c    | 1199 +++++++++++++++++++
 10 files changed, 3828 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-zip
 create mode 100644 drivers/crypto/hisilicon/qm.c
 create mode 100644 drivers/crypto/hisilicon/qm.h
 create mode 100644 drivers/crypto/hisilicon/zip/Makefile
 create mode 100644 drivers/crypto/hisilicon/zip/zip.h
 create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.c
 create mode 100644 drivers/crypto/hisilicon/zip/zip_main.c

-- 
2.8.1

