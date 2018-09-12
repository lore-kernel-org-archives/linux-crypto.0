From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 0/2] dt-bindings: Cleanup spurious commas in hisilicon hip07
 dt.
Date: Wed, 12 Sep 2018 17:05:50 +0100
Message-ID: <20180912160552.11604-1-Jonathan.Cameron@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 xuwei <xuwei5@huawei.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: <linux-crypto@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
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

Rob Herring picked up on an issue in our sec dt binding doc where we had
an unnecessary comma in the addresses provided as part of the node name.
The comment wasn't fixed before the series was applied, hence this follow up.

This was a cut and paste job from a few of the its entries already present
in the hip07 dtsi.

This series tidies up this loose end.  It has no particular urgency
as nothing stops working if you have a comma present and it is unlikely
an userspace code would be using these.

Jonathan Cameron (2):
  dt-bindings: crypto: hip07-sec, drop incorrect commas
  arm64: dts: hisilicon hip07: drop commas from @address node names

 .../bindings/crypto/hisilicon,hip07-sec.txt   |  2 +-
 arch/arm64/boot/dts/hisilicon/hip07.dtsi      | 28 +++++++++----------
 2 files changed, 15 insertions(+), 15 deletions(-)

-- 
2.18.0
