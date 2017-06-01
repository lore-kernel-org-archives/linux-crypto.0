From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 19/20] staging: ccree: remove spurious blank line
Date: Thu,  1 Jun 2017 14:03:09 +0300
Message-ID: <1496314993-30229-20-git-send-email-gilad@benyossef.com>
References: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove spurious blank line from cc_regs.h

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_regs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ccree/cc_regs.h b/drivers/staging/ccree/cc_regs.h
index e83938b..915c863 100644
--- a/drivers/staging/ccree/cc_regs.h
+++ b/drivers/staging/ccree/cc_regs.h
@@ -14,7 +14,6 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
-
 /*!
  * @file
  * @brief This file contains macro definitions for accessing ARM TrustZone
-- 
2.1.4
