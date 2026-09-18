Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA08A3CCFD4;
	Fri, 18 Sep 2026 12:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789734455; cv=none; b=VAVM+R5J1Mgpd5CWx+k4CL5lw+XqqOnqzSIqFs2hhpKUodV45wybTN2pR5ZzS8WRUNjWIeLWzv4DOUcnGCwB+s9qY5h3kJg3OAAqVDuOoPjDE85IGG5alNoGDmmFXmXPxNw5a47qcXL8i7K8lnm7PgYXth+e3TFV+WNywkoU6Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789734455; c=relaxed/simple;
	bh=0RLQ+Nw7W6ws5/BQWRF35FYRoL1AA3tMEctto32L4OI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ltgw4QJSEq8dltYVGist5OobmysfWL75B2igB4SX2wkrE5UWkyqYZiO8MWvOKnreVel354NS5oFli87PReHg5J4JbUXR1+eRfqy3PXfxtbvApRS/UYSde1QhJ31N0ZTgSs/mQHQqO7NiW1uEm7gcJnzwWCyycmFSPYp+xwL8GgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=cfIiJp6O; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="cfIiJp6O"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=89vysMK0wCmlF4ELxDP7tvpUD5j4NQPkhelV2nSX49I=;
	b=cfIiJp6OSAKWMblccZamCZKUI9jQphMaIJMI6WdzkXAoPJOC4su71gKDpG/Ju3GSpNr7hEqKF
	5H8+O8vO+yvVNDbgGe0p6HSrmVuLNF+sBx1X3xv8pOUKrlTektVi53FPeZPaxHmoegLUgdxKKP4
	HFWdPq6e6d40b8pdRY/kPro=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hmWnR6mDkzmV8f;
	Fri, 18 Sep 2026 20:16:27 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 1E267402AB;
	Fri, 18 Sep 2026 20:27:28 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 18 Sep 2026 20:27:27 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 1/7] crypto: hisilicon/hpre - fix pointer dereference before length check
Date: Fri, 18 Sep 2026 20:27:20 +0800
Message-ID: <20260918122726.3014899-2-qianweili@huawei.com>
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

In hpre_rsa_drop_leading_zeros(), the loop condition dereferences *ptr
before checking *len, causing an out-of-bounds read when *len is zero.

Swap to while (*len && !**ptr) to test length first.

Fixes: c8b4b477079d ("crypto: hisilicon - add HiSilicon HPRE accelerator")
Cc: stable@vger.kernel.org
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 09077abbf6ad..7894211b9972 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -720,7 +720,7 @@ static void hpre_dh_exit_tfm(struct crypto_kpp *tfm)
 
 static void hpre_rsa_drop_leading_zeros(const char **ptr, size_t *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.43.0

