From: srishti sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: ccree: ssi_aead.h: Fixed a pointer declaration error.
Date: Sat,  3 Jun 2017 04:15:17 +0530
Message-ID: <1496443518-18497-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 srishti sharma <srishtishar@gmail.com>, linux-crypto@vger.kernel.org
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

Fixed a pointer declaration error , the dereferencing operator was misplaced.

Signed-off-by: srishti sharma <srishtishar@gmail.com>
---
 drivers/staging/ccree/ssi_aead.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index 654a181..9cf5225 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -97,8 +97,8 @@ struct aead_req_ctx {
	struct ssi_mlli assoc;
	struct ssi_mlli src;
	struct ssi_mlli dst;
-	struct scatterlist* srcSgl;
-	struct scatterlist* dstSgl;
+	struct scatterlist *srcSgl;
+	struct scatterlist *dstSgl;
	unsigned int srcOffset;
	unsigned int dstOffset;
	enum ssi_req_dma_buf_type assoc_buff_type;
--
2.7.4
