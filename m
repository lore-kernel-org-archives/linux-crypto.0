Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0697740962E
	for <linux-crypto@vger.kernel.org>; Fri,  5 Jun 2026 23:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780701103; cv=none; b=GdM2epxf8Y/OuF3b3Y2eB2l6nRwGhHIwRKAln2w2GuhQR3EIeOGnksJEHjGLgOVzO/AuPueQp7DS470WrjMbDqVklS56W16kMR8UaWtZFkiRNjW5W/dkmeWg6SZ+D8UUkarLTyE3ZxFA1Gj4iuLYHei4/xH50/tACwhnGAvOfnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780701103; c=relaxed/simple;
	bh=kmL+jvX6tupzaaeLWp1D26AMv1qPy1e9W29OY6F6W6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGcmuoMNsvX06Am+X0tuS0e39nsG5tpBqTSm9Fe/iCMDz94CdXaRHql2JX9Z6tMSQSGJ2ae3GCuSgm3+JvfJ+5DjakBpfcqIpgRXpegWptX/j8G/MwuVssaCdaJej5jkaVeKK+ws/Jv7g38x9BR29tJ+3qN9OMO+4/XY8vMkRKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wX/ZjyPc; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wX/ZjyPc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780701097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+ycX3WlIlcMdbMGLbNNQsIr2jvmTW7NO0brVzFY8fI=;
	b=wX/ZjyPcUGWAtKiTEw1Zd1Rx5RBL4u8lt4DrfRwHL/YprzWQsBo+fIce5O25YuqGmafQN6
	pIJXHcfqhaHQAz9LZ/7zpqIUEKMrOoiwR8q1wNWR0mzRGqa1pVK4Sds9HsgUYM33dg1cBx
	ezN9SUKoi3SSHXdiJWrU2rmGiURW9lA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qat-linux@intel.com,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH v2 3/6] crypto: ccp - use 2-arg strscpy where destination size is known
Date: Sat,  6 Jun 2026 01:11:00 +0200
Message-ID: <20260605231056.1622060-11-thorsten.blum@linux.dev>
In-Reply-To: <20260605231056.1622060-8-thorsten.blum@linux.dev>
References: <20260605231056.1622060-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=926; i=thorsten.blum@linux.dev; h=from:subject; bh=kmL+jvX6tupzaaeLWp1D26AMv1qPy1e9W29OY6F6W6s=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnK4Q1F064sNGeOm+ciOe2+4W+x8vtrNJmT5//OTzb5f KRwtaRKRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAEykejnDP0Pd5jVsZUHX+d40 le36E/vgJZfrRu6e+Y8EjS4V/zWQKmH473fT5uu7J+yZkY7e8+K28GyxXNyR9jS3Jbo4Z++XEoa DDAA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To simplify the code, drop explicit and hard-coded size arguments from
strscpy() where the destination buffer has a fixed size and strscpy()
can automatically determine it using sizeof().

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/ccp/ccp-crypto-sha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 85058a89f35b..ff9bb253dbb2 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -426,7 +426,7 @@ static int ccp_register_hmac_alg(struct list_head *head,
 	*ccp_alg = *base_alg;
 	INIT_LIST_HEAD(&ccp_alg->entry);
 
-	strscpy(ccp_alg->child_alg, def->name, CRYPTO_MAX_ALG_NAME);
+	strscpy(ccp_alg->child_alg, def->name);
 
 	alg = &ccp_alg->alg;
 	alg->setkey = ccp_sha_setkey;
