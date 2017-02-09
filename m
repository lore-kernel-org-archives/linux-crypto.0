From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH next 2/2] crypto: atmel-sha: fix error management in
 atmel_sha_start()
Date: Thu, 9 Feb 2017 17:51:21 +0100
Message-ID: <3852cb16370171988f6669b3bac98b06477bacb6.1486655562.git.cyrille.pitchen@atmel.com>
References: <cover.1486655562.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>, dan.carpenter@oracle.com,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
 <nicolas.ferre@atmel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1486655562.git.cyrille.pitchen@atmel.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

This patch clarifies and fixes how errors should be handled by
atmel_sha_start().

For update operations, the previous code wrongly assumed that
(err != -EINPROGRESS) implies (err == 0). It's wrong because that doesn't
take the error cases (err < 0) into account.

This patch also adds many comments to detail all the possible returned
values and what should be done in each case.

Especially, when an error occurs, since atmel_sha_complete() has already
been called, hence releasing the hardware, atmel_sha_start() must not call
atmel_sha_finish_req() later otherwise atmel_sha_complete() would be
called a second time.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index d6c3d9529d36..0d207dac9aa2 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1106,22 +1106,39 @@ static int atmel_sha_start(struct atmel_sha_dev *dd)
 						ctx->op, req->nbytes);
 
 	err = atmel_sha_hw_init(dd);
-
 	if (err)
-		goto err1;
+		return atmel_sha_complete(dd, err);
+
+	/*
+	 * atmel_sha_update_req() and atmel_sha_final_req() can return either:
+	 *  -EINPROGRESS: the hardware is busy and the SHA driver will resume
+	 *                its job later in the done_task.
+	 *                This is the main path.
+	 *
+	 * 0: the SHA driver can continue its job then release the hardware
+	 *    later, if needed, with atmel_sha_finish_req().
+	 *    This is the alternate path.
+	 *
+	 * < 0: an error has occurred so atmel_sha_complete(dd, err) has already
+	 *      been called, hence the hardware has been released.
+	 *      The SHA driver must stop its job without calling
+	 *      atmel_sha_finish_req(), otherwise atmel_sha_complete() would be
+	 *      called a second time.
+	 *
+	 * Please note that currently, atmel_sha_final_req() never returns 0.
+	 */
 
 	dd->resume = atmel_sha_done;
 	if (ctx->op == SHA_OP_UPDATE) {
 		err = atmel_sha_update_req(dd);
-		if (err != -EINPROGRESS && (ctx->flags & SHA_FLAGS_FINUP))
+		if (!err && (ctx->flags & SHA_FLAGS_FINUP))
 			/* no final() after finup() */
 			err = atmel_sha_final_req(dd);
 	} else if (ctx->op == SHA_OP_FINAL) {
 		err = atmel_sha_final_req(dd);
 	}
 
-err1:
-	if (err != -EINPROGRESS)
+	if (!err)
 		/* done_task will not finish it, so do it here */
 		atmel_sha_finish_req(req, err);
 
-- 
2.7.4
