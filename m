Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F0837E308;
	Tue,  4 Aug 2026 02:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785810142; cv=none; b=DvZajk6H1KKxZJ8fS5v9OZWg3gPf9wPdVJOvaYKzsIaTOjPYftjG2rUQZJmgU7JCPhgsi9x85WNRVuigeHoqGG8sN7s7vbWhzarR/SbKg562FXlTd8/1fe/gJGHLhifTCeDppufmiHA3sjTMHFAUC0p6vibuljrlwFHVDAloI/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785810142; c=relaxed/simple;
	bh=IeNtS8T0lwwJwNLOHMtj0k983NZqLeGnup937K/MkZc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kDbpU7kl/NnYpyzxhtkyu3c3cakWlOs7JrW+KnG5eiDtWF2YjVjerqgTtime6xLgiJNVtDgRAv+7ck1Vuc3K5FiLtadRC0R0KFdpaXwChj95WL7PEYAdkEsQPsZqTD1nPKiocYhOQRQYUuNaC8SALYJ+sHbaUc8Ia80PYoh7/MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=jzOQRCNz; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="jzOQRCNz"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JMvDmmYkko02Q/g1EF4rg7an/zg8u7xLPZdq9G8r7Zw=;
	b=jzOQRCNzN41Db0wliD16wRtEPlq76d1W06c7WkBjnGI53h+myk0CcXsGt9Iv4LrNtAH8OIf4j
	ESMjzMSGBs3leoOCiAfaiPJeQKV/R3dG3YC/Hre9JrM+wJnxdqUAVVMQpJWdmTdfDx66l4VPp7u
	6JdibPU5iwJuRVQ9xe0w0+c=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hDcWV3GSczLlTg;
	Tue,  4 Aug 2026 10:12:38 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 087A1402AB;
	Tue,  4 Aug 2026 10:22:09 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Aug 2026 10:22:08 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Aug 2026 10:22:08 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<prime.zeng@hisilicon.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <yinzhushuai@huawei.com>
Subject: [PATCH] crypto: hisilicon/sec2: fix CCM algorithm long packet failure
Date: Tue, 4 Aug 2026 10:22:07 +0800
Message-ID: <20260804022207.4073268-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Zhushuai Yin <yinzhushuai@huawei.com>

In the CCM B0 block the message-length field Q spans L bytes, where
L (cl in the driver) is derived from the cipher IV flags byte as
c_ivin[0] + 1. set_aead_auth_iv() hardcoded writing only the last 2
bytes of a_ivin with cryptlen, implicitly assuming cl = 2.

When cl = 3 (a shorter nonce yielding a 3-byte length field) and the
packet is longer than 65535 bytes, cryptlen no longer fits in 2 bytes.
The dropped high byte made the auth IV built by the driver differ from
the one consumed by the hardware, so the software/hardware comparison
failed and the CCM request errored out.

Write the last cl bytes of a_ivin in a loop driven by the IV's CL
value, so the length-field width always matches the algorithm
configuration instead of assuming a fixed 2-byte field.

Fixes: c16a70c1f253 ("crypto: hisilicon/sec - add new algorithm mode for AEAD")
Signed-off-by: Zhushuai Yin <yinzhushuai@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 01eb76f616fc..0a2f7c8b44fc 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -96,7 +96,6 @@
 #define IV_FLAGS_OFFSET	0x6
 #define IV_CM_OFFSET		0x3
 #define IV_LAST_BYTE1		1
-#define IV_LAST_BYTE2		2
 #define IV_LAST_BYTE_MASK	0xFF
 #define IV_CTR_INIT		0x1
 #define IV_BYTE_OFFSET		0x8
@@ -1700,7 +1699,7 @@ static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 	struct sec_cipher_req *c_req = &req->c_req;
 	u32 data_size = aead_req->cryptlen;
 	u8 flage = 0;
-	u8 cm, cl;
+	u8 cm, cl, i;
 
 	/* the specification has been checked in aead_iv_demension_check() */
 	cl = c_req->c_ivin[0] + 1;
@@ -1724,15 +1723,16 @@ static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 	 * the last 32bit is counter's initial number,
 	 * but the nonce uses the first 16bit
 	 * the tail 16bit fill with the cipher length
+	 * When CL is 3, the tail 24bit fill with the cipher length.
 	 */
 	if (!c_req->encrypt)
 		data_size = aead_req->cryptlen - authsize;
 
-	a_req->a_ivin[ctx->c_ctx.ivsize - IV_LAST_BYTE1] =
-			data_size & IV_LAST_BYTE_MASK;
-	data_size >>= IV_BYTE_OFFSET;
-	a_req->a_ivin[ctx->c_ctx.ivsize - IV_LAST_BYTE2] =
+	for (i = 1; i <= cl; i++) {
+		a_req->a_ivin[ctx->c_ctx.ivsize - i] =
 			data_size & IV_LAST_BYTE_MASK;
+		data_size >>= IV_BYTE_OFFSET;
+	}
 }
 
 static void sec_aead_set_iv(struct sec_ctx *ctx, struct sec_req *req)
-- 
2.43.0

