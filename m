From: Rishabh Hardas <rishabhhardas@gmail.com>
Subject: [PATCH] staging/ccree: Declare compiled out functions static inline
Date: Thu, 12 Oct 2017 18:06:53 +0530
Message-ID: <1507811813-21578-1-git-send-email-rishabhhardas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Rishabh Hardas <rishabhhardas@gmail.com>,
 gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: gilad@benyossef.com
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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

Sparse was giving out a warning for symbols
'cc_set_ree_fips_status' and 'fips_handler'
that they were not declared and need to be
made static. This patch makes both the symbols
static inline, to remove the warnings.

Signed-off-by: Rishabh Hardas <rishabhhardas@gmail.com>
---
 drivers/staging/ccree/ssi_fips.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index 369ddf9..63bcca7 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -40,8 +40,8 @@ static inline int ssi_fips_init(struct ssi_drvdata *p_drvdata)
 }
 
 static inline void ssi_fips_fini(struct ssi_drvdata *drvdata) {}
-void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
-void fips_handler(struct ssi_drvdata *drvdata) {}
+static inline void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
+static inline void fips_handler(struct ssi_drvdata *drvdata) {}
 
 #endif /* CONFIG_CRYPTO_FIPS */
 
-- 
1.9.1
