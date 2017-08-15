From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 20/22] staging: ccree: replace noop macro with inline
Date: Tue, 15 Aug 2017 09:26:48 +0300
Message-ID: <1502778412-16255-21-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Replace noop macro with a noop inline function

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 0b9c7e6..063a1cc 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -190,8 +190,8 @@ struct async_gen_req_ctx {
 #ifdef DX_DUMP_BYTES
 void dump_byte_array(const char *name, const u8 *the_array, unsigned long size);
 #else
-#define dump_byte_array(name, array, size) do {	\
-} while (0);
+static inline void dump_byte_array(const char *name, const u8 *the_array,
+				   unsigned long size) {};
 #endif
 
 int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe);
-- 
2.1.4
