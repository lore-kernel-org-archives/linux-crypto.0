From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 12/24] staging: ccree: fix code indent
Date: Mon, 13 Nov 2017 14:45:40 +0000
Message-ID: <1510584358-29473-13-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix code ident not following the coding style.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c | 2 +-
 drivers/staging/ccree/ssi_sysfs.c  | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 957138a..4c1080a 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -140,7 +140,7 @@ static int validate_data_size(struct ssi_ablkcipher_ctx *ctx_p, unsigned int siz
 		break;
 	case S_DIN_to_DES:
 		if (likely(IS_ALIGNED(size, DES_BLOCK_SIZE)))
-				return 0;
+			return 0;
 		break;
 #if SSI_CC_HAS_MULTI2
 	case S_DIN_to_MULTI2:
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 8d50382..ed97dec 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -53,8 +53,10 @@ static ssize_t ssi_sys_help_show(struct kobject *kobj,
 	int i = 0, offset = 0;
 
 	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "Usage:\n");
-	for (i = 0; i < ARRAY_SIZE(help_str); i += 2)
-	   offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s\t\t%s\n", help_str[i], help_str[i + 1]);
+	for (i = 0; i < ARRAY_SIZE(help_str); i += 2) {
+		offset += scnprintf(buf + offset, PAGE_SIZE - offset,
+				    "%s\t\t%s\n", help_str[i], help_str[i + 1]);
+	}
 
 	return offset;
 }
-- 
2.7.4
