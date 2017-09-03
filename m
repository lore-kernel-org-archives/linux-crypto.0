From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 7/8] staging: ccree: replace noop macro with inline
Date: Sun,  3 Sep 2017 11:56:49 +0300
Message-ID: <1504429011-25514-8-git-send-email-gilad@benyossef.com>
References: <1504429011-25514-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1504429011-25514-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Replace noop macro with a noop inline function

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 06a3c48..81ba827 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -187,8 +187,8 @@ struct async_gen_req_ctx {
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
