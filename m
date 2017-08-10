From: Lars Persson <lars.persson@axis.com>
Subject: [PATCH v4 4/4] MAINTAINERS: Add ARTPEC crypto maintainer
Date: Thu, 10 Aug 2017 14:53:54 +0200
Message-ID: <ea2baf287bd5d52ebe99246f93adae9a878a9edc.1502368677.git.larper@axis.com>
References: <cover.1502368677.git.larper@axis.com>
Cc: Lars Persson <larper@axis.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1502368677.git.larper@axis.com>
In-Reply-To: <cover.1502368677.git.larper@axis.com>
References: <cover.1502368677.git.larper@axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Assign the Axis kernel team as maintainer for crypto drivers under
drivers/crypto/axis.

Signed-off-by: Lars Persson <larper@axis.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d5b6c71e783e..72186cf9820d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1129,6 +1129,7 @@ L:	linux-arm-kernel@axis.com
 F:	arch/arm/mach-artpec
 F:	arch/arm/boot/dts/artpec6*
 F:	drivers/clk/axis
+F:	drivers/crypto/axis
 F:	drivers/pinctrl/pinctrl-artpec*
 F:	Documentation/devicetree/bindings/pinctrl/axis,artpec6-pinctrl.txt
 
-- 
2.11.0
