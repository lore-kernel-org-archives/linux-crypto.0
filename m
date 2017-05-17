From: Rick Altherr <raltherr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 1/2] dt-bindings: timeriomem_rng: Add entropy quality property
Date: Wed, 17 May 2017 15:29:10 -0700
Message-ID: <20170517222911.9295-1-raltherr@google.com>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Rick Altherr <raltherr-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---

 Documentation/devicetree/bindings/rng/timeriomem_rng.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/timeriomem_rng.txt b/Documentation/devicetree/bindings/rng/timeriomem_rng.txt
index 6616d15866a3..214940093b55 100644
--- a/Documentation/devicetree/bindings/rng/timeriomem_rng.txt
+++ b/Documentation/devicetree/bindings/rng/timeriomem_rng.txt
@@ -5,6 +5,13 @@ Required properties:
 - reg : base address to sample from
 - period : wait time in microseconds to use between samples
 
+Optional properties:
+- quality : estimated number of bits of true entropy per 1024 bits read from the
+            rng.  Defaults to zero which causes the kernel's default quality to
+            be used instead.  Note that the default quality is usually zero
+            which disables using this rng to automatically fill the kernel's
+            entropy pool.
+
 N.B. currently 'reg' must be four bytes wide and aligned
 
 Example:
-- 
2.13.0.303.g4ebf302169-goog

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
