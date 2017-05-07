From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] staging: MAINTAINERS: add GBY as ccree maintainer
Date: Sun,  7 May 2017 16:18:27 +0300
Message-ID: <1494163107-26131-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

I work for Arm on maintaining the TrustZone CryptoCell driver.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

---

The original patch went out with the patch set introducing the ccree
driver but somehow failed to end up in Linus's tree, maybe because
I omitted the "staging:" prefix.
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b948dfa..684ddb3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3100,6 +3100,14 @@ F:	drivers/net/ieee802154/cc2520.c
 F:	include/linux/spi/cc2520.h
 F:	Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 
+CCREE ARM TRUSTZONE CRYPTOCELL 700 REE DRIVER
+M:	Gilad Ben-Yossef <gilad@benyossef.com>
+L:	linux-crypto@vger.kernel.org
+L:	driverdev-devel@linuxdriverproject.org
+S:	Supported
+F:	drivers/staging/ccree/
+W:	https://developer.arm.com/products/system-ip/trustzone-cryptocell/cryptocell-700-family
+
 CEC FRAMEWORK
 M:	Hans Verkuil <hans.verkuil@cisco.com>
 L:	linux-media@vger.kernel.org
-- 
2.1.4
