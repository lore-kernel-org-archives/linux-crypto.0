From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH v2 6/7] crypto: img-hash - log a successful probe
Date: Fri, 5 Aug 2016 14:00:19 +0100
Message-ID: <1470402020-10774-7-git-send-email-will.thomas@imgtec.com>
References: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	James Hartley <james.hartley@imgtec.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:13895 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759686AbcHENIP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 09:08:15 -0400
In-Reply-To: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: James Hartley <james.hartley@imgtec.com>

Currently the probe function only emits an output on success
when debug is specifically enabled. It would be more useful
if this happens by default.

Signed-off-by: James Hartley <james.hartley@imgtec.com>
Reviewed-by: Will Thomas <will.thomas@imgtec.com>
---
 drivers/crypto/img-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index fd4cd51..60410d7 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -1031,7 +1031,7 @@ static int img_hash_probe(struct platform_device *pdev)
 	err = img_register_algs(hdev);
 	if (err)
 		goto err_algs;
-	dev_dbg(dev, "Img MD5/SHA1/SHA224/SHA256 Hardware accelerator initialized\n");
+	dev_info(dev, "Img MD5/SHA1/SHA224/SHA256 Hardware accelerator initialized\n");
 
 	return 0;
 
-- 
2.1.4
