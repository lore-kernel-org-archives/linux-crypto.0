From: Anup Patel <anup.patel@broadcom.com>
Subject: [PATCH 2/6] lib/raid6: Add log-of-2 table for RAID6 HW requiring disk position
Date: Thu,  2 Feb 2017 10:17:12 +0530
Message-ID: <1486010836-25228-3-git-send-email-anup.patel@broadcom.com>
References: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-raid@vger.kernel.org, Anup Patel <anup.patel@broadcom.com>
To: Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jassi Brar <jassisinghbrar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:35748 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751076AbdBBEsQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2017 23:48:16 -0500
Received: by mail-qt0-f175.google.com with SMTP id x49so9770116qtc.2
        for <linux-crypto@vger.kernel.org>; Wed, 01 Feb 2017 20:48:11 -0800 (PST)
In-Reply-To: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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

Signed-off-by: Anup Patel <anup.patel@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
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
