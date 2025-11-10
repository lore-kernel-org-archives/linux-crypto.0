Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1088021CC64;
	Mon, 10 Nov 2025 07:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762759255; cv=none; b=p7MORnCm1Was759pZoOXvVuSCLtZHRleAtx0N4W2CKX1v4tnmZl+Xut2GPapbEKGnoiWAKCkoaWEWkUjEH4u4mBDWOA+O7Pn+1cBo24ghIQ1W/GuDVxehcgPiiaGti5BycCCZEX5WJzffJ8BcEmM+obS0uH0FYRlWecdEcCbrEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762759255; c=relaxed/simple;
	bh=8kLArvmlgfu3jBH0P7V+k+Ee5IjH+0qfY+EyhZHK81Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C4ChehhVNl4zgQ2cimcQL9MKthq6RQeHXtMmfbvbp7ZXWfds9ackZ+rJC7OrlQnPsN+cVBxxlKteGWI7OjmWiXLZ+X1AJnhNzJOlP0BR+BM4nMdqpi7aHdM2ktrRG2xIvQYtfbabANMtHfRW4CBhjVz6q0rmzrSbf0U7x+WmM8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S (unknown [124.16.141.245])
	by APP-03 (Coremail) with SMTP id rQCowABX59lLkhFpSAA1AA--.10157S2;
	Mon, 10 Nov 2025 15:20:45 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: gilad@benyossef.com
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH] crypto: ccree: Correctly handle return of sg_nents_for_len
Date: Mon, 10 Nov 2025 15:20:41 +0800
Message-ID: <20251110072041.941-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABX59lLkhFpSAA1AA--.10157S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJryfAr1kAFyrKFyUAF1UWrg_yoW8ArWrpF
	Z8GrZYvrWFqw12vFy7tFy5WFWF9a9ruF42krWktwn7CrySvF9rXFyjka42v3WDCr1Iyr18
	Ka1qka18G3WUXaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvv14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCY02Avz4vE14v_GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
	1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
	14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
	IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
	IFyTuYvjfUnzuWDUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwsCA2kRjlkPawAAsG

Fix error handling in cc_map_hash_request_update where sg_nents_for_len
return value was assigned to u32, converting negative errors to large
positive values before passing to sg_copy_to_buffer.

Check sg_nents_for_len return value and propagate errors before
assigning to areq_ctx->in_nents.

Fixes: b7ec8530687a ("crypto: ccree - use std api when possible")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 3963bb91321f..dc7e0cd51c25 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -1235,6 +1235,7 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 	int rc = 0;
 	u32 dummy = 0;
 	u32 mapped_nents = 0;
+	int sg_nents;
 
 	dev_dbg(dev, " update params : curr_buff=%p curr_buff_cnt=0x%X nbytes=0x%X src=%p curr_index=%u\n",
 		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
@@ -1248,7 +1249,10 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 	if (total_in_len < block_size) {
 		dev_dbg(dev, " less than one block: curr_buff=%p *curr_buff_cnt=0x%X copy_to=%p\n",
 			curr_buff, *curr_buff_cnt, &curr_buff[*curr_buff_cnt]);
-		areq_ctx->in_nents = sg_nents_for_len(src, nbytes);
+		sg_nents = sg_nents_for_len(src, nbytes);
+		if (sg_nents < 0)
+			return sg_nents;
+		areq_ctx->in_nents = sg_nents;
 		sg_copy_to_buffer(src, areq_ctx->in_nents,
 				  &curr_buff[*curr_buff_cnt], nbytes);
 		*curr_buff_cnt += nbytes;
-- 
2.50.1.windows.1

