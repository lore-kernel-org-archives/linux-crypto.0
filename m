From: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 1/4] lib/raid6: Add log-of-2 table for RAID6 HW requiring disk position
Date: Tue, 14 Feb 2017 12:21:49 +0530
Message-ID: <1487055112-5185-2-git-send-email-anup.patel@broadcom.com>
References: <1487055112-5185-1-git-send-email-anup.patel@broadcom.com>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Jon Mason <jonmason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
To: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487055112-5185-1-git-send-email-anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

The raid6_gfexp table represents {2}^n values for 0 <= n < 256. The
Linux async_tx framework pass values from raid6_gfexp as coefficients
for each source to prep_dma_pq() callback of DMA channel with PQ
capability. This creates problem for RAID6 offload engines (such as
Broadcom SBA) which take disk position (i.e. log of {2}) instead of
multiplicative cofficients from raid6_gfexp table.

This patch adds raid6_gflog table having log-of-2 value for any given
x such that 0 <= x < 256. For any given disk coefficient x, the
corresponding disk position is given by raid6_gflog[x]. The RAID6
offload engine driver can use this newly added raid6_gflog table to
get disk position from multiplicative coefficient.

Signed-off-by: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Scott Branden <scott.branden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Ray Jui <ray.jui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 include/linux/raid/pq.h |  1 +
 lib/raid6/mktables.c    | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 4d57bba..30f9453 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -142,6 +142,7 @@ int raid6_select_algo(void);
 extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
 extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
 extern const u8 raid6_gfexp[256]      __attribute__((aligned(256)));
+extern const u8 raid6_gflog[256]      __attribute__((aligned(256)));
 extern const u8 raid6_gfinv[256]      __attribute__((aligned(256)));
 extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));
 
diff --git a/lib/raid6/mktables.c b/lib/raid6/mktables.c
index 39787db..e824d08 100644
--- a/lib/raid6/mktables.c
+++ b/lib/raid6/mktables.c
@@ -125,6 +125,26 @@ int main(int argc, char *argv[])
 	printf("EXPORT_SYMBOL(raid6_gfexp);\n");
 	printf("#endif\n");
 
+	/* Compute log-of-2 table */
+	printf("\nconst u8 __attribute__((aligned(256)))\n"
+	       "raid6_gflog[256] =\n" "{\n");
+	for (i = 0; i < 256; i += 8) {
+		printf("\t");
+		for (j = 0; j < 8; j++) {
+			v = 255;
+			for (k = 0; k < 256; k++)
+				if (exptbl[k] == (i + j)) {
+					v = k;
+					break;
+				}
+			printf("0x%02x,%c", v, (j == 7) ? '\n' : ' ');
+		}
+	}
+	printf("};\n");
+	printf("#ifdef __KERNEL__\n");
+	printf("EXPORT_SYMBOL(raid6_gflog);\n");
+	printf("#endif\n");
+
 	/* Compute inverse table x^-1 == x^254 */
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
 	       "raid6_gfinv[256] =\n" "{\n");
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
