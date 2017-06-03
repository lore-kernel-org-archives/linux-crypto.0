From: srishti sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: ccree: ssi_aead.h: Fixed a comment coding style issue.
Date: Sat,  3 Jun 2017 18:04:59 +0530
Message-ID: <1496493300-3012-1-git-send-email-srishtishar@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        srishti sharma <srishtishar@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fixed a comment coding style issue , block comments use * on subsequent lines.

Signed-off-by: srishti sharma <srishtishar@gmail.com>
---
 drivers/staging/ccree/ssi_aead.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index 9cf5225..4b592b7 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -14,8 +14,9 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */

-/* \file ssi_aead.h
-   ARM CryptoCell AEAD Crypto API
+/*
+ * \file ssi_aead.h
+ *  ARM CryptoCell AEAD Crypto API
  */

 #ifndef __SSI_AEAD_H__
--
2.7.4
