From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: ensure backlog is initialised
Date: Tue, 14 Apr 2015 11:51:29 -0500
Message-ID: <1429030289-4070-1-git-send-email-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42188 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869AbbDNQxU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Apr 2015 12:53:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

backlog is not initialised so in the case where
cpg->eng_st != ENGINE_IDLE it is never initialised and
hence which could lead to an illegal memory dereference
in the statement:

  backlog->complete(backlog, -EINPROGRESS);

Discovered with cppcheck static analsys:
[drivers/crypto/mv_cesa.c:616]:
   (error) Uninitialized variable: backlog

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/mv_cesa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index f91f15d..e63efbd 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -595,7 +595,7 @@ static int queue_manag(void *data)
 	cpg->eng_st = ENGINE_IDLE;
 	do {
 		struct crypto_async_request *async_req = NULL;
-		struct crypto_async_request *backlog;
+		struct crypto_async_request *backlog = NULL;
 
 		__set_current_state(TASK_INTERRUPTIBLE);
 
-- 
2.1.4
