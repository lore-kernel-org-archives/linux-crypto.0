Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31525169384
	for <linux-crypto@vger.kernel.org>; Wed, 29 May 2024 08:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716970142; cv=none; b=Jd8WIgBPuNRgWivJxxZN5EFLeLI9XWBsqdr3CkEo6yBNWAH7daivI5mxT3YvFJCYdDp1ZGQeWvZ5TYMOtRimH0Sfl6A5yTdQfFHbwUfY1xsH/p8VxQJRmcTiSma3AFHXxWahCRLM04aeo6qIrGik/boLVccyeCqCR0AC07ItV1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716970142; c=relaxed/simple;
	bh=96iFbUwojxwBoxA+H0JTEulerW3QRm1exN8DOQ8GsGs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Mz73u/BvGKYlUmnG4f4EjwXaLtcX0giuNoB+whRiwZY0+z3saxKIZTgBm4JMJ9toZkJsPQkY02R7hmDOidukOjhYtj0NG9kzBxQDh9ta+mdRL9T5RfGs7l5Yb1mMQ2xUGdcu9qAbcNLo0phtdzjcWFiuE23rNtIX2vDXClHXdxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1sCEMW-0002i8-0F; Wed, 29 May 2024 10:08:44 +0200
Received: from [2a0a:edc0:0:1101:1d::54] (helo=dude05.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1sCEMQ-003RAe-SQ; Wed, 29 May 2024 10:08:38 +0200
Received: from localhost ([::1] helo=dude05.red.stw.pengutronix.de)
	by dude05.red.stw.pengutronix.de with esmtp (Exim 4.96)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1sCEMQ-00EJoV-2e;
	Wed, 29 May 2024 10:08:38 +0200
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
Date: Wed, 29 May 2024 10:08:29 +0200
Subject: [PATCH v2] docs: crypto: async-tx-api: fix broken code example
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240529-async-dma-docs-v2-1-8faf87e72e6d@pengutronix.de>
X-B4-Tracking: v=1; b=H4sIAHziVmYC/3XMQQ6CMBCF4auQWTtmpmKCrryHYVHaEWZhS1okE
 MLdrexd/i953wZZkkqGe7VBklmzxlDCnCpwgw29oPrSYMjUdDUXtHkNDv3boo8uI5F03NhaiB2
 U05jkpcsBPtvSg+YppvXwZ/6tf6mZkbG7FZEaqoX5MUroP1OKQZezF2j3ff8Cf58CxLEAAAA=
To: Dan Williams <dan.j.williams@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>, 
 Andre Noll <maan@systemlinux.org>
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel@pengutronix.de, 
 Ahmad Fatoum <a.fatoum@pengutronix.de>
X-Mailer: b4 0.13-dev
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org

The code example fails to compile:

  1) addr_conv is defined twice, once as a VLA, which have been phased out

  2) submit is not a pointer, but is still dereferenced with ->

  3) The first call to async_xor() lacked the trailing semicolon

Fix these issues and while at it, fix some code style nitpicks as well:

  1) make the functions static as users are unlikely to export them

  2) include the relevant header

  3) Shorten the example a bit by removing a redundant variable
     definition

Fixes: 04ce9ab385dc ("async_xor: permit callers to pass in a 'dma/page scribble' region")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
Changes in v2:
- commit message: fix addr_conv typo (Andre)
- commit message: note addition of missing semicolon (Andre)
- add header include (Andre)
- shorten code by removing redundant variable definition (Andre)
- Link to v1: https://lore.kernel.org/r/20240523-async-dma-docs-v1-1-b900e0804e11@pengutronix.de
---
 Documentation/crypto/async-tx-api.rst | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/Documentation/crypto/async-tx-api.rst b/Documentation/crypto/async-tx-api.rst
index 27c146b54d71..f88a7809385e 100644
--- a/Documentation/crypto/async-tx-api.rst
+++ b/Documentation/crypto/async-tx-api.rst
@@ -150,38 +150,38 @@ of an operation.
 Perform a xor->copy->xor operation where each operation depends on the
 result from the previous operation::
 
-    void callback(void *param)
-    {
-	    struct completion *cmp = param;
+    #include <linux/async_tx.h>
 
-	    complete(cmp);
+    static void callback(void *param)
+    {
+	    complete(param);
     }
 
-    void run_xor_copy_xor(struct page **xor_srcs,
-			int xor_src_cnt,
-			struct page *xor_dest,
-			size_t xor_len,
-			struct page *copy_src,
-			struct page *copy_dest,
-			size_t copy_len)
+    #define NDISKS  2
+
+    static void run_xor_copy_xor(struct page **xor_srcs,
+				 struct page *xor_dest,
+				 size_t xor_len,
+				 struct page *copy_src,
+				 struct page *copy_dest,
+				 size_t copy_len)
     {
 	    struct dma_async_tx_descriptor *tx;
-	    addr_conv_t addr_conv[xor_src_cnt];
 	    struct async_submit_ctl submit;
 	    addr_conv_t addr_conv[NDISKS];
 	    struct completion cmp;
 
 	    init_async_submit(&submit, ASYNC_TX_XOR_DROP_DST, NULL, NULL, NULL,
 			    addr_conv);
-	    tx = async_xor(xor_dest, xor_srcs, 0, xor_src_cnt, xor_len, &submit)
+	    tx = async_xor(xor_dest, xor_srcs, 0, NDISKS, xor_len, &submit);
 
-	    submit->depend_tx = tx;
+	    submit.depend_tx = tx;
 	    tx = async_memcpy(copy_dest, copy_src, 0, 0, copy_len, &submit);
 
 	    init_completion(&cmp);
 	    init_async_submit(&submit, ASYNC_TX_XOR_DROP_DST | ASYNC_TX_ACK, tx,
 			    callback, &cmp, addr_conv);
-	    tx = async_xor(xor_dest, xor_srcs, 0, xor_src_cnt, xor_len, &submit);
+	    tx = async_xor(xor_dest, xor_srcs, 0, NDISKS, xor_len, &submit);
 
 	    async_tx_issue_pending_all();
 

---
base-commit: a38297e3fb012ddfa7ce0321a7e5a8daeb1872b6
change-id: 20240523-async-dma-docs-00eb18a4e01c

Best regards,
-- 
Ahmad Fatoum <a.fatoum@pengutronix.de>

