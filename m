From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 20/27] Drivers: ccree: ssi_buffer_mgr.h - align block comments
Date: Wed, 24 May 2017 16:46:10 +1200
Message-ID: <20170524044610.30794-1-robsonde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Derek Robson <robsonde@gmail.com>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: gilad@benyossef.com,
	gregkh@linuxfoundation.org
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

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
index 4acbb4b6afc9..98355dd789e5 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -15,7 +15,7 @@
  */
 
 /* \file buffer_mgr.h
-   Buffer Manager
+ * Buffer Manager
  */
 
 #ifndef __SSI_BUFFER_MGR_H__
-- 
2.12.2
