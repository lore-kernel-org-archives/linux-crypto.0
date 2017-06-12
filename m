From: <sean.wang@mediatek.com>
Subject: [PATCH v2 1/3] dt-bindings: rng: add MediaTek MT7622 Hardware Random
 Generator bindings
Date: Mon, 12 Jun 2017 23:56:54 +0800
Message-ID: <89b9b682ff9e294df7cda75787c1439c95ffc992.1497280813.git.sean.wang@mediatek.com>
References: <cover.1497280813.git.sean.wang@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree@vger.kernel.org, keyhaede@gmail.com,
 Sean Wang <sean.wang@mediatek.com>, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-crypto@vger.kernel.org,
 weiyongjun1@huawei.com, linux-arm-kernel@lists.infradead.org
To: <herbert@gondor.apana.org.au>, <mpm@selenic.com>, <robh+dt@kernel.org>,
 <mark.rutland@arm.com>, <clabbe.montjoie@gmail.com>,
 <prasannatsmkumar@gmail.com>, <romain.perier@free-electrons.com>,
 <shannon.nelson@oracle.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1497280813.git.sean.wang@mediatek.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

Document the bindings used by MediaTek MT7622 SoC hardware random number
generator.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 Documentation/devicetree/bindings/rng/mtk-rng.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.txt b/Documentation/devicetree/bindings/rng/mtk-rng.txt
index a6d62a2..366b99b 100644
--- a/Documentation/devicetree/bindings/rng/mtk-rng.txt
+++ b/Documentation/devicetree/bindings/rng/mtk-rng.txt
@@ -2,7 +2,9 @@ Device-Tree bindings for Mediatek random number generator
 found in Mediatek SoC family
 
 Required properties:
-- compatible	    : Should be "mediatek,mt7623-rng"
+- compatible	    : Should be
+			"mediatek,mt7622-rng", 	"mediatek,mt7623-rng" : for MT7622
+			"mediatek,mt7623-rng" : for MT7623
 - clocks	    : list of clock specifiers, corresponding to
 		      entries in clock-names property;
 - clock-names	    : Should contain "rng" entries;
-- 
1.9.1
