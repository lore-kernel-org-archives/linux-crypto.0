From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: ccp - Fix non static symbol warning
Date: Fri, 12 Aug 2016 00:00:09 +0000
Message-ID: <1470960009-17784-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux-crypto@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>,
	Gary Hook <gary.hook@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33369 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbcHLAAR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2016 20:00:17 -0400
Received: by mail-pa0-f66.google.com with SMTP id vy10so494331pac.0
        for <linux-crypto@vger.kernel.org>; Thu, 11 Aug 2016 17:00:16 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes the following sparse warning:

drivers/crypto/ccp/ccp-dev.c:62:14: warning:
 symbol 'ccp_increment_unit_ordinal' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
---
 drivers/crypto/ccp/ccp-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 38a98d8..5d36eef 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -59,7 +59,7 @@ static struct ccp_device *ccp_rr;
 
 /* Ever-increasing value to produce unique unit numbers */
 static atomic_t ccp_unit_ordinal;
-unsigned int ccp_increment_unit_ordinal(void)
+static unsigned int ccp_increment_unit_ordinal(void)
 {
 	return atomic_inc_return(&ccp_unit_ordinal);
 }
