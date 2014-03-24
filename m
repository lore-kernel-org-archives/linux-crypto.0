From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V2 21/21] staging: crypto: skein: add TODO file
Date: Mon, 24 Mar 2014 01:49:18 +0000
Message-ID: <caca14d10abb9978b076cd360c47fc36909a6c63.1395625123.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <cover.1395625123.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33273 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751699AbaCXBts (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Mar 2014 21:49:48 -0400
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
In-Reply-To: <cover.1395625123.git.jason@lakedaemon.net>
References: <cover.1395625123.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/TODO | 11 +++++++++++
 1 file changed, 11 insertions(+)
 create mode 100644 drivers/staging/skein/TODO

diff --git a/drivers/staging/skein/TODO b/drivers/staging/skein/TODO
new file mode 100644
index 000000000000..f5c167a305ae
--- /dev/null
+++ b/drivers/staging/skein/TODO
@@ -0,0 +1,11 @@
+skein/threefish TODO
+
+ - rename camelcase vars
+ - rename camelcase functions
+ - rename files
+ - move macros into appropriate header files
+ - add / pass test vectors
+ - module support
+
+Please send patches to Jason Cooper <jason@lakedaemon.net> in addition to the
+staging tree mailinglist.
-- 
1.9.1
