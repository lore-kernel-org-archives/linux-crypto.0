From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH] hwrng: correct error check of kthread_run call
Date: Fri, 24 Jul 2015 13:13:30 +0200
Message-ID: <1437736410-39227-1-git-send-email-schwidefsky@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:51151 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbbGXLNm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2015 07:13:42 -0400
Received: from /spool/local
	by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <schwidefsky@de.ibm.com>;
	Fri, 24 Jul 2015 12:13:41 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id C02EA17D805F
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2015 12:15:02 +0100 (BST)
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6OBDdM033554526
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2015 11:13:39 GMT
Received: from d06av03.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6OBDb0L013668
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2015 05:13:38 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The kthread_run() function can return two different error values
but the hwrng core only checks for -ENOMEM. If the other error
value -EINTR is returned it is assigned to hwrng_fill and later
used on a kthread_stop() call which naturally crashes.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 drivers/char/hw_random/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index da8faf7..5643b65 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -429,7 +429,7 @@ static int hwrng_fillfn(void *unused)
 static void start_khwrngd(void)
 {
 	hwrng_fill = kthread_run(hwrng_fillfn, NULL, "hwrng");
-	if (hwrng_fill == ERR_PTR(-ENOMEM)) {
+	if (IS_ERR(hwrng_fill)) {
 		pr_err("hwrng_fill thread creation failed");
 		hwrng_fill = NULL;
 	}
-- 
2.3.8
