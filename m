From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH next 0/2] crypto: atmel-sha: fix error management
Date: Thu, 9 Feb 2017 17:51:19 +0100
Message-ID: <cover.1486655562.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>, dan.carpenter@oracle.com,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
 <nicolas.ferre@atmel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
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

Hi all,

this series is based on next-20170209.

The first patch fixes a bug reported by Dan Carpenter. I didn't put a
Fixes tag since the buggy patch is only in linux-next for now so its
commit ID is likely to change when entering Linus' tree.
It fixes a wrong 'sed' command: many "return -EINVAL;" lines should have
been replaced by "return atmel_sha_complete(dd, -EINVAL);" but instead
were replaced by direct calls of "atmel_sha_complete(dd, -EINVAL);".
My bad, sorry for that!

The second patch fixes the way error cases are handled from
atmel_sha_start(). For instance, when atmel_sha_update_req() returned an
error, atmel_sha_final_req() may have been called after anyway. This issue
was present even before my rework of the request queue management, which
introduced atmel_sha_start(), so I guess this is a long time issue.

Finally, for driver maintainance purpose, I'm preparing other patches to
fix the very same and very unlikely issue in both atmel-aes.c and
atmel-sha.c:

atmel_{aes|sha}_hw_init() may fail, for instance if clk_enable() fails.
If so, atmel_{aes|sha}_complete() is called to release the hardware and
report the error. Indeed this _complete() function should be called to
report and handle any error. However it also incondionnally calls
clk_disable(). Hence the following sequence may be buggy:

err = atmel_{aes|sha}_hw_init(dd); /* clk_enable() may have failed. */
if (err)
	return atmel_{aes|sha}_hw_init(dd, err);
	/* clk_disable() is called anyway. */

I didn't finalize my fixes yet for this unlikely bug. Besides the bug was
already present in v4.9 and before, so before introducing
atmel_sha_complete().

from atmel_sha_handle_queue(), the older sequence was:

	err = atmel_sha_hw_init(dd);

	if (err)
		goto err1;

	[...]

err1:
	if (err != -EINPROGRESS)
		/* done_task will not finish it, so do it here */
		atmel_sha_finish_req(req, err);

Best regards,

Cyrille

Cyrille Pitchen (2):
  crypto: atmel-sha: fix missing "return" instructions
  crypto: atmel-sha: fix error management in atmel_sha_start()

 drivers/crypto/atmel-sha.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

-- 
2.7.4
