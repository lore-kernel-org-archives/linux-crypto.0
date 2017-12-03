From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 04/10] staging: ccree: fix indentation of var assignment
Date: Sun,  3 Dec 2017 13:58:15 +0000
Message-ID: <1512309503-29766-5-git-send-email-gilad@benyossef.com>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
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

Fix indentation of var assignment split across lines for
better readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 0b085dc..f214df7 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1238,10 +1238,10 @@ static enum cc_flow_mode ssi_aead_get_data_flow_mode(
 	} else { /* Decrypt */
 		if (setup_flow_mode == S_DIN_to_AES)
 			data_flow_mode = is_single_pass ?
-					AES_and_HASH : DIN_AES_DOUT;
+				AES_and_HASH : DIN_AES_DOUT;
 		else
 			data_flow_mode = is_single_pass ?
-					DES_and_HASH : DIN_DES_DOUT;
+				DES_and_HASH : DIN_DES_DOUT;
 	}
 
 	return data_flow_mode;
-- 
2.7.4
