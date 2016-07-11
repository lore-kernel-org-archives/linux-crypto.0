From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH 6/6] crypto: img-hash - log a successful probe
Date: Mon, 11 Jul 2016 10:33:36 +0100
Message-ID: <1468229616-3888-7-git-send-email-will.thomas@imgtec.com>
References: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: James Hartley <james.hartley@imgtec.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:4898 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758186AbcGKJeQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jul 2016 05:34:16 -0400
Received: from HHMAIL01.hh.imgtec.org (unknown [10.100.10.19])
	by Forcepoint Email with ESMTPS id 9F93B2EC5CBBC
	for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2016 10:34:10 +0100 (IST)
In-Reply-To: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
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
index c2fdc35..f90fdf3 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -1012,7 +1012,7 @@ static int img_hash_probe(struct platform_device *pdev)
 	err = img_register_algs(hdev);
 	if (err)
 		goto err_algs;
-	dev_dbg(dev, "Img MD5/SHA1/SHA224/SHA256 Hardware accelerator initialized\n");
+	dev_info(dev, "Img MD5/SHA1/SHA224/SHA256 Hardware accelerator initialized\n");
 
 	return 0;
 
-- 
2.1.4
