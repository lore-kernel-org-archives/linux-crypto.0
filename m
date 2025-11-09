Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693942DE70C;
	Sun,  9 Nov 2025 14:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762700226; cv=none; b=bqdSxr9PWUhDwpFDLvXxT9WlKNlOCmhIy5xz968u7hHQ9MX8PiC4XQUMn/IhhfEeINO5nm78E+zc0Qx5woctbwUakOHel7vCsnOqDSBIsxsLInNmKVa6Q32b5AxwtzhBBVIHuzQgmslkWV0ZL6HMFHBhsz8JNjFgN8X/V/4yMxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762700226; c=relaxed/simple;
	bh=m4XFGKFTDrqGxPfpMveNvzc7LGZutlSuep9QA58X1PQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZFnt5XRWB1pzfrdXs/ZuDdw9kyklNnGihRFmtwdb8jMQvDMxSagqnCIWPBMSxT2HO6X1AzMIDehL9NbgHIeiJnO2L+t0esHaVS3+iOxa97V+wRVwpSXL8VvI+LluYf4Otd7Fo+oPA1TWaOrAXJMD57yHxMwYnmj6W4VjvztKARo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=DxZJL26u; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="DxZJL26u"
Received: from LAPTOP-N070L597.localdomain (unknown [221.228.238.82])
	by smtp.qiye.163.com (Hmail) with ESMTP id 28ea96242;
	Sun, 9 Nov 2025 22:56:52 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: kristen.c.accardi@intel.com
Cc: vinicius.gomes@intel.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] crypto: iaa - Fix incorrect return value in save_iaa_wq()
Date: Sun,  9 Nov 2025 14:56:48 +0000
Message-Id: <20251109145648.3678596-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9a691eb6cd03a1kunm1909047a9f17dc
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZHh9MVkxMHk9OS0xKT0geT1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlLVUtVS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=DxZJL26uSGz+LvKxIh380zmk686Y7XAVGOmPi2t7CLnAMeWsXUel4dqhm0JUN+kLUD3BkkKD3h1ddf83MOnM/VEf/XQnU56jOo1onV4wL5WpoAoY64as1k1e8ltiNWqTzig6Q0TmRXE8II9UaEGqGCkBNwQBpVNtQdWMuqNGgXA=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=NYEg8jeFNgjtfLM1mSioLcSsaf0LlHh9g3RjFmqChaw=;
	h=date:mime-version:subject:message-id:from;

The save_iaa_wq() function unconditionally returns 0, even when an error
is encountered. This prevents the error code from being propagated to the
caller.

Fix this by returning the 'ret' variable, which holds the actual status
of the operations within the function.

Fixes: ea7a5cbb43696 ("crypto: iaa - Add Intel IAA Compression Accelerator crypto driver core")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 23f585219fb4..d0058757b000 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -805,7 +805,7 @@ static int save_iaa_wq(struct idxd_wq *wq)
 	if (!cpus_per_iaa)
 		cpus_per_iaa = 1;
 out:
-	return 0;
+	return ret;
 }
 
 static void remove_iaa_wq(struct idxd_wq *wq)
-- 
2.34.1

