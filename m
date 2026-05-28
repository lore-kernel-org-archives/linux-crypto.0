Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81253E63B9;
	Thu, 28 May 2026 11:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779969435; cv=none; b=a7gbJANzibqqQD5+652cU+tLtpq5ucGZnP5k55+AFO0zFFo6XrabiXCfvY0gx0Fwy2KhoyNFUGvZDEIe4xG0t1gsa0m9qPKLZKFib8DTeViiXYXkLeLNYGOslzoz0R68k+Hbc/LPfwreB63nWWYjr288Ocs2ZDmzUZUlrxI0VhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779969435; c=relaxed/simple;
	bh=hX1WpG0y8qkBmdTtG9BOn5LUOQEiL1v9TfaL0Cy03Oc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V6NZCVFOpfgg2JlqHQDV0Bg84mXywzD4n93p36CDBeXTIgzwtIc/4kbXdWxzJi6kNDJ75HkeDuLTM1GEM/gHHp4bWVnwJKlQ1M6+TAyIRFxbQl2chCgBaYkksM1w2UX4Gv4wdW7/Ts5Lbjg26YIkr16sNAWgcJydOLTH9azTrhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=jy0UPAro; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="jy0UPAro"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WY/b8mrnY3M4GaZDZc7/fEQZnRdvXe/m58scRCY69AU=;
	b=jy0UPAroYzuoB9WE6aZsJ7fpmyz7fqyb0/2qz8AynKm2/EegpZLEY25dUUb8Yv71AheUgBBDm
	C0yym0UGe1GbpgN0psyXf7Qh+XVRNob3pJTVNlF2jNE6BmEnmhg8suZ5ZCl67OM9z2sjivW2MAI
	O8xyG2PcSbbWbjKwBB1gbMg=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gR4X86WYnzKmW7;
	Thu, 28 May 2026 19:49:12 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id B082C40572;
	Thu, 28 May 2026 19:57:01 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 28 May 2026 19:57:01 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH v2 5/5] crypto: hisilicon/sec2 - restore iv for ctr mode
Date: Thu, 28 May 2026 19:55:31 +0800
Message-ID: <20260528115531.174593-6-wuzongyu1@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260528115531.174593-1-wuzongyu1@huawei.com>
References: <20260528115531.174593-1-wuzongyu1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100008.china.huawei.com (7.202.195.119)

From: Wenkai Lin <linwenkai6@hisilicon.com>

Upon termination of the CTR task, the initial vector (IV) is
restored to guarantee valid IV availability for subsequent tasks.

Fixes: 7b44c0eecd6a ("crypto: hisilicon/sec - add new skcipher mode for SEC")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 901abe8761e5..03f873f68828 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1970,6 +1970,7 @@ static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
 
 static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 {
+	bool need_copy_iv = false;
 	int ret;
 
 	ret = sec_request_init(ctx, req);
@@ -1982,8 +1983,10 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 
 	/* Output IV as decrypto */
 	if (!req->c_req.encrypt && (ctx->c_ctx.c_mode == SEC_CMODE_CBC ||
-	    ctx->c_ctx.c_mode == SEC_CMODE_CTR))
+	    ctx->c_ctx.c_mode == SEC_CMODE_CTR)) {
+		need_copy_iv = true;
 		sec_update_iv(req, ctx->alg_type);
+	}
 
 	ret = ctx->req_op->bd_send(ctx, req);
 	if (likely(ret == -EINPROGRESS || ret == -EBUSY))
@@ -1992,7 +1995,7 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 		dev_err_ratelimited(ctx->dev, "send sec request failed!\n");
 
 	/* As failing, restore the IV from user */
-	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && !req->c_req.encrypt) {
+	if (need_copy_iv) {
 		if (ctx->alg_type == SEC_SKCIPHER)
 			memcpy(req->c_req.sk_req->iv, req->c_req.c_ivin,
 			       ctx->c_ctx.ivsize);
-- 
2.33.0

