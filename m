From: <sean.wang@mediatek.com>
Subject: [PATCH v2 0/2] hwrng: mtk: add support for hardware random generator on MT7623 SoC
Date: Fri, 21 Apr 2017 00:24:24 +0800
Message-ID: <1492705466-27287-1-git-send-email-sean.wang@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <weiyongjun1@huawei.com>, <devicetree@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <keyhaede@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
To: <herbert@gondor.apana.org.au>, <mpm@selenic.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <clabbe.montjoie@gmail.com>, <prasannatsmkumar@gmail.com>,
        <romain.perier@free-electrons.com>, <shannon.nelson@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:33518 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S971021AbdDTQYk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 12:24:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sean Wang <sean.wang@mediatek.com>

This patchset introduces support for Mediatek hardware random generator (RNG)
Currently, the driver is already tested successfully with rng-tools on MT7623
SoC. And it should also be workable on other similar Mediatek SoCs.

Changes since v1:
- remove unnecessary warning message
- remove mistakenly changed line
- refine macro definition with keeping one space between name and define
- remove redundant platform_get_resource() call

Sean Wang (2):
  dt-bindings: hwrng: Add Mediatek hardware random generator bindings
  hwrng: mtk: Add driver for hardware random generator on MT7623 SoC

 Documentation/devicetree/bindings/rng/mtk-rng.txt |  18 +++
 drivers/char/hw_random/Kconfig                    |  14 ++
 drivers/char/hw_random/Makefile                   |   1 +
 drivers/char/hw_random/mtk-rng.c                  | 168 ++++++++++++++++++++++
 4 files changed, 201 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/mtk-rng.txt
 create mode 100644 drivers/char/hw_random/mtk-rng.c

-- 
1.9.1
