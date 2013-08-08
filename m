From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 0/3] ARM: dts: mxs: dcp cleanup patches
Date: Thu,  8 Aug 2013 15:30:26 +0200
Message-ID: <1375968629-10091-1-git-send-email-LW@KARO-electronics.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org,
 Tobias Rauter <tobiasrauter@gmail.com>, linux-crypto@vger.kernel.org,
 Rob Herring <rob.herring@calxeda.com>, Stephen Warren <swarren@wwwdotorg.org>
To: devicetree@vger.kernel.org
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

This patch series does the following:

- let the driver be "disabled" by default in imx28.dtsi
- coding style cleanups in drivers/crypto/dcp.c
- use the "official" 'fsl,' prefix in the 'compatible' property

The last patch adds a new entry to the of_match_table of the driver,
so that current DT blobs will still work. When out of tree users
(mentioned in the commit log of 519d8b1a "Added support for
Freescale's DCP co-processor") have updated their DTBs the old entry
'fsl-dsp' can be removed from the driver.

This patch series requires at least
"[PATCH 2/8] ARM: dts: mxs: add labels to most nodes for easier reference"
from the patch series:
<1375966287-6784-1-git-send-email-LW@KARO-electronics.de> to be
applied.

 arch/arm/boot/dts/imx28.dtsi      |    2 +-
 b/arch/arm/boot/dts/imx28-evk.dts |    4 ++++
 b/arch/arm/boot/dts/imx28.dtsi    |    3 ++-
 b/drivers/crypto/dcp.c            |   11 +++++------
 drivers/crypto/dcp.c              |    2 ++
 5 files changed, 14 insertions(+), 8 deletions(-)
