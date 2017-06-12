From: <sean.wang@mediatek.com>
Subject: [PATCH v2 0/3] add support of hardware random generator on MediaTek MT7622
Date: Mon, 12 Jun 2017 23:56:53 +0800
Message-ID: <cover.1497280813.git.sean.wang@mediatek.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

Changes since v1:
- update the bindings with the specific "mediatek,mt7622-rng"
  instead of the generic one as "mediatek,generic-rng"

The series add support of hardware RNG on MediaTek MT7622 and
, runtime PM support and add me as the maintainer for the existing
and following chipset.

Sean Wang (3):
  dt-bindings: rng: add MediaTek MT7622 Hardware Random Generator
    bindings
  hwrng: mtk - add runtime PM support
  MAINTAINERS: add entry for MediaTek Random Number Generator

 Documentation/devicetree/bindings/rng/mtk-rng.txt |  4 ++-
 MAINTAINERS                                       |  5 +++
 drivers/char/hw_random/mtk-rng.c                  | 42 +++++++++++++++++++++++
 3 files changed, 50 insertions(+), 1 deletion(-)

-- 
1.9.1
