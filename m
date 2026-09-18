Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB083C3F66;
	Fri, 18 Sep 2026 12:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789734455; cv=none; b=u4GjQyYcnxymibmEmLBOZn7K/Kjha8XO/YCytdsSxmehJYmUJzZuJa1cylzCFmXRsXyhiLwQQpBiEIwMXLp8raidyO82oy2qSDYn6jU2b3/LyHFO2oGeWWggTQjealp62gPfDZh90JECkKrc1q25MoxA/qOVPA1FDnygp1Lb1ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789734455; c=relaxed/simple;
	bh=LI+Uhva6eJJpMwwRaASsp69sBznwxkQNwrdv8aJfCiw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EojXWt1DKm0f2Hkgwk1PFYb2FvOUWgpBnnq/vSIU7t3Z3E0OZqHNuyTjfXkHiC6yDGeReXY0/O+RQ7le1GcFW25LHkV4ETgmoqIc/Gqjg/nNQ5krVCLVfEOZMsmf8FE7qdNannpp0zzH5fMcwxU+0nnSSH9JL79ITaP7RtqENlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=gKF6OXE0; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="gKF6OXE0"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vuCDgkswYZewxfTmNHghToleKyEAFZUP8mxAdm+1/sw=;
	b=gKF6OXE0N4RePI0U1kTrjB17qrHclmzuDJfAA6JQ7GVxdHvw7USV9/g2PjjoJ3ZiI2aqRhQtn
	W0rMgv0rt6ojK4wvN2E9IKJfgaa5MZzxPqxD6fjKiiykYceKQFVKfl3Vb8kOsldJGF1SjBBx1Ay
	DTHqIq5Siflyme/fUTWEtkI=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hmWnR2FDCz1prN6;
	Fri, 18 Sep 2026 20:16:27 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id A404D4058C;
	Fri, 18 Sep 2026 20:27:28 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 18 Sep 2026 20:27:28 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 3/7] crypto: hisilicon/hpre - return -EOVERFLOW for small ECDH output buffer
Date: Fri, 18 Sep 2026 20:27:22 +0800
Message-ID: <20260918122726.3014899-4-qianweili@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918122726.3014899-1-qianweili@huawei.com>
References: <20260918122726.3014899-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf200011.china.huawei.com (7.202.181.237)

hpre_ecdh_msg_request_set() returns -EINVAL when the output buffer
is too small, after setting req->dst_len to the required size.
-EINVAL is misleading because the caller can retry with a larger
buffer. Return -EOVERFLOW as other kpp implementations do.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 8551d6ccb78d..6dea9ce5bae2 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1450,7 +1450,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 
 	if (req->dst_len < ctx->key_sz << 1) {
 		req->dst_len = ctx->key_sz << 1;
-		return -EINVAL;
+		return -EOVERFLOW;
 	}
 
 	tmp = kpp_request_ctx(req);
-- 
2.43.0

