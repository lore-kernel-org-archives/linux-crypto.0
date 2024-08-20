Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A120D1B813;
	Tue, 20 Aug 2024 08:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142525; cv=none; b=BI9hAV1Ul8Yaf2aLXaDTJbajeq8bMbnOgLcU1kf7QhObMAl35Bd355JH+cGWa76396wYkYNokIt4YfBqHaK+2ymRCcFhWlrikSclwblNAVfYrasRb6WgzMHgwxkV776NGW/pDEaYttEAdPiJYNwnRAkmrpT1WQvDTasNHpJ1t68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142525; c=relaxed/simple;
	bh=cVGni+heFe898rdaKvUQWC+wriO5HTILOVfkp6jqjYo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kol3Eu2RpFdqX/M0xacMFE7eCU+bURdQWpgcaLHr0SDPVxpkVMqlLR/NubqQg/i+lAsoHqrxHWWqml0++x2hr7hp72vACBsxcZAo5mYfQxyyjwMSE2kxOichOKgCcaiQNNpBJgE0D7TOI2NUnHaxt5Xwz3XlCC6hq7QqeJkwz98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Wp2YV5fPBz20m7J;
	Tue, 20 Aug 2024 16:23:58 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 40E7C1401F4;
	Tue, 20 Aug 2024 16:28:39 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 20 Aug
 2024 16:28:38 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<clabbe@baylibre.com>, <linus.walleij@linaro.org>, <atenart@kernel.org>,
	<arno@natisbad.org>, <bbrezillon@kernel.org>, <thomas.lendacky@amd.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-amlogic@lists.infradead.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -next 1/6] crypto: safexcel - Remove unused declaration safexcel_ring_first_rptr()
Date: Tue, 20 Aug 2024 16:25:20 +0800
Message-ID: <20240820082525.259337-2-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240820082525.259337-1-yuehaibing@huawei.com>
References: <20240820082525.259337-1-yuehaibing@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf500002.china.huawei.com (7.185.36.57)

Commit 9744fec95f06 ("crypto: inside-secure - remove request list to
improve performance") declar this but never implemented.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/crypto/inside-secure/safexcel.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index d0059ce954dd..0c79ad78d1c0 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -897,7 +897,6 @@ int safexcel_init_ring_descriptors(struct safexcel_crypto_priv *priv,
 int safexcel_select_ring(struct safexcel_crypto_priv *priv);
 void *safexcel_ring_next_rptr(struct safexcel_crypto_priv *priv,
 			      struct safexcel_desc_ring *ring);
-void *safexcel_ring_first_rptr(struct safexcel_crypto_priv *priv, int  ring);
 void safexcel_ring_rollback_wptr(struct safexcel_crypto_priv *priv,
 				 struct safexcel_desc_ring *ring);
 struct safexcel_command_desc *safexcel_add_cdesc(struct safexcel_crypto_priv *priv,
-- 
2.34.1

