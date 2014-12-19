From: Rabin Vincent <rabin.vincent@axis.com>
Subject: [PATCH] crypto: af_alg: fix backlog handling
Date: Fri, 19 Dec 2014 13:36:08 +0100
Message-ID: <1418992568-1275-1-git-send-email-rabin.vincent@axis.com>
Cc: linux-crypto@vger.kernel.org, Rabin Vincent <rabinv@axis.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:54237 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaLSMgc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Dec 2014 07:36:32 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If a request is backlogged, it's complete() handler will get called
twice: once with -EINPROGRESS, and once with the final error code.

af_alg's complete handler, unlike other users, does not handle the
-EINPROGRESS but instead always completes the completion that recvmsg()
is waiting on.  This can lead to a return to user space while the
request is still pending in the driver.  If userspace closes the sockets
before the requests are handled by the driver, this will lead to
use-after-frees (and potential crashes) in the kernel due to the tfm
having been freed.

The crashes can be easily reproduced (for example) by reducing the max
queue length in cryptod.c and running the following (from
http://www.chronox.de/libkcapi.html) on AES-NI capable hardware:

 $ while true; do kcapi -x 1 -e -c '__ecb-aes-aesni' \
    -k 00000000000000000000000000000000 \
    -p 00000000000000000000000000000000 >/dev/null & done

Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>
---
 crypto/af_alg.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 1fa7bc3..4665b79 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -455,6 +455,9 @@ void af_alg_complete(struct crypto_async_request *req, int err)
 {
 	struct af_alg_completion *completion = req->data;
 
+	if (err == -EINPROGRESS)
+		return;
+
 	completion->err = err;
 	complete(&completion->completion);
 }
-- 
1.7.10.4
