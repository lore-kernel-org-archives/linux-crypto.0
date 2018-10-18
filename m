Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:40895 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727550AbeJRV6d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 17:58:33 -0400
Message-Id: <b587c4952ab56b672383d3657c1bc9b6d31ad0da.1539870727.git.christophe.leroy@c-s.fr>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH] powerpc/8xx: Add DT node for using the SEC engine of the
 MPC885
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, devicetree@vger.kernel.org,
        MAZEYRAT Ludovic <ludovic.mazeyrat@alstomgroup.com>
Date: Thu, 18 Oct 2018 13:57:22 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The MPC885 has SEC engine version 1.2 with the following details:
- Number of Crypto channels: 1
- Exec Units: DEU, MDEU and AESU
- Available descriptors: 00010, 00100, 00110, 01000, 11000, 11010

It is also supposed to have descriptor 00000, but it doesn't work
properly so we keep it out for the moment.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 arch/powerpc/boot/dts/mpc885ads.dts | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
index 5b037f51741d..3aa300afbbca 100644
--- a/arch/powerpc/boot/dts/mpc885ads.dts
+++ b/arch/powerpc/boot/dts/mpc885ads.dts
@@ -72,7 +72,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		device_type = "soc";
-		ranges = <0x0 0xff000000 0x4000>;
+		ranges = <0x0 0xff000000 0x28000>;
 		bus-frequency = <0>;
 
 		// Temporary -- will go away once kernel uses ranges for get_immrbase().
@@ -224,6 +224,17 @@
 				#size-cells = <0>;
 			};
 		};
+
+		crypto@20000 {
+			compatible = "fsl,sec1.2", "fsl,sec1.0";
+			reg = <0x20000 0x8000>;
+			interrupts = <1 1>;
+			interrupt-parent = <&PIC>;
+			fsl,num-channels = <1>;
+			fsl,channel-fifo-len = <24>;
+			fsl,exec-units-mask = <0x4c>;
+			fsl,descriptor-types-mask = <0x05000154>;
+		};
 	};
 
 	chosen {
-- 
2.13.3
