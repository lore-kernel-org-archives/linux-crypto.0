From: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] dt-bindings: rng: Document BCM7278 RNG200 compatible
Date: Wed,  1 Nov 2017 16:20:05 -0700
Message-ID: <20171101232006.3943-2-f.fainelli@gmail.com>
References: <20171101232006.3943-1-f.fainelli@gmail.com>
Cc: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Jon Mason <jonmason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE),
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
        Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Harald Freudenberger <freude-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Martin Kaiser <martin-XxZfDwE/svGeZLLa646FqQ@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:HARDWARE RANDOM NUMBER
        GENERATOR CORE),
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:OP
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101232006.3943-1-f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

BCM7278 includes a RGN200 hardware random number generator, document the
compatible string for that version of the IP.

Signed-off-by: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt b/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
index e25a456664b9..0014da9145af 100644
--- a/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
+++ b/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
@@ -1,7 +1,9 @@
 HWRNG support for the iproc-rng200 driver
 
 Required properties:
-- compatible : "brcm,iproc-rng200"
+- compatible : Must be one of:
+	       "brcm,bcm7278-rng200"
+	       "brcm,iproc-rng200"
 - reg : base address and size of control register block
 
 Example:
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
