From: Joshua Henderson <joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Subject: [PATCH v2 1/2] dt/bindings: Add bindings for the PIC32 random number generator
Date: Mon, 8 Feb 2016 14:17:52 -0700
Message-ID: <1454966283-14965-1-git-send-email-joshua.henderson@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Joshua Henderson <joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Kieran Bingham <kieranbingham-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Pankaj Dev <pankaj.dev-qxv4g6HH51o@public.gmane.org>,
	Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
	Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Purna Chandra Mandal <purna.mandal-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>,
	Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Document the devicetree bindings for the random number generator found
on Microchip PIC32 class devices.

Signed-off-by: Joshua Henderson <joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 .../bindings/rng/microchip,pic32-rng.txt           |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/microchip,pic32-rng.txt

diff --git a/Documentation/devicetree/bindings/rng/microchip,pic32-rng.txt b/Documentation/devicetree/bindings/rng/microchip,pic32-rng.txt
new file mode 100644
index 0000000..c6d1003
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/microchip,pic32-rng.txt
@@ -0,0 +1,17 @@
+* Microchip PIC32 Random Number Generator
+
+The PIC32 RNG provides a pseudo random number generator which can be seeded by
+another true random number generator.
+
+Required properties:
+- compatible : should be "microchip,pic32mzda-rng"
+- reg : Specifies base physical address and size of the registers.
+- clocks: clock phandle.
+
+Example:
+
+	rng: rng@1f8e6000 {
+		compatible = "microchip,pic32mzda-rng";
+		reg = <0x1f8e6000 0x1000>;
+		clocks = <&PBCLK5>;
+	};
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
