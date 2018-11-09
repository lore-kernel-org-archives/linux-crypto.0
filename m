Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55863 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbeKIW5Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 17:57:16 -0500
From: Colin King <colin.king@canonical.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] padata: clean an indentation issue, remove extraneous space
Date: Fri,  9 Nov 2018 13:16:39 +0000
Message-Id: <20181109131639.20739-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to clean up an indentation issue

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index d568cc56405f..3e2633ae3bca 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -720,7 +720,7 @@ int padata_start(struct padata_instance *pinst)
 	if (pinst->flags & PADATA_INVALID)
 		err = -EINVAL;
 
-	 __padata_start(pinst);
+	__padata_start(pinst);
 
 	mutex_unlock(&pinst->lock);
 
-- 
2.19.1
