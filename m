From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 16/26] staging: ccree: remove unused field
Date: Mon,  1 Jan 2018 12:06:43 +0000
Message-ID: <1514808421-21993-17-git-send-email-gilad@benyossef.com>
References: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove unused struct field.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 9d71b33..c64b4b5 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -23,7 +23,6 @@ struct cc_hash_handle {
 	cc_sram_addr_t digest_len_sram_addr; /* const value in SRAM*/
 	cc_sram_addr_t larval_digest_sram_addr;   /* const value in SRAM */
 	struct list_head hash_list;
-	struct completion init_comp;
 };
 
 static const u32 digest_len_init[] = {
-- 
2.7.4
