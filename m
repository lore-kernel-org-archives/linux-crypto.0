From: <sean.wang@mediatek.com>
Subject: [PATCH 4/4] MAINTAINERS: add entry for MediaTek Random Number Generator
Date: Thu, 1 Jun 2017 02:44:16 +0800
Message-ID: <896100e7f54d7bf1e1c4926ec5b63b27b99e4890.1496255334.git.sean.wang@mediatek.com>
References: <cover.1496255334.git.sean.wang@mediatek.com>
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
In-Reply-To: <cover.1496255334.git.sean.wang@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

I work for MediaTek on maintaining the MediaTek RNG driver
for the existing SoCs and adding support for the following
SoCs.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cf86519..da473d0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8262,6 +8262,11 @@ L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/mediatek/mt7601u/
 
+MEDIATEK RANDOM NUMBER GENERATOR SUPPORT
+M:      Sean Wang <sean.wang@mediatek.com>
+S:      Maintained
+F:      drivers/char/hw_random/mtk-rng.c
+
 MEGACHIPS STDPXXXX-GE-B850V3-FW LVDS/DP++ BRIDGES
 M:	Peter Senna Tschudin <peter.senna@collabora.com>
 M:	Martin Donnelly <martin.donnelly@ge.com>
-- 
1.9.1
