From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: ccp - Fix non static symbol warning
Date: Mon, 17 Oct 2016 15:08:50 +0000
Message-ID: <1476716930-9831-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-crypto@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36384 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933633AbcJQPJL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2016 11:09:11 -0400
Received: by mail-pf0-f193.google.com with SMTP id r16so12961732pfg.3
        for <linux-crypto@vger.kernel.org>; Mon, 17 Oct 2016 08:09:10 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fixes the following sparse warning:

drivers/crypto/ccp/ccp-dev.c:44:6: warning:
 symbol 'ccp_error_codes' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/ccp/ccp-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index cafa633..c25515a 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -41,7 +41,7 @@ struct ccp_tasklet_data {
 };
 
 /* Human-readable error strings */
-char *ccp_error_codes[] = {
+static char *ccp_error_codes[] = {
 	"",
 	"ERR 01: ILLEGAL_ENGINE",
 	"ERR 02: ILLEGAL_KEY_ID",
