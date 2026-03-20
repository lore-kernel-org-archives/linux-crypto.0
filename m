Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D46361DB9
	for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 08:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773996583; cv=none; b=d+AmgClVWUISOHqN25sRwDlzW9a0Fi79Oji1kNxcsEQZFEQGTHEL8fLetxl+BHCIYmuidNsnE/uqCqEpj7NOLMk3Q7R7mFChYZ6zaYR+2uKeyQ4Arv6w7AnJpUjfFLPsU6XNl+TGcLnzkH+Ozt7xUhDLTmV9GUNy1jHHjXNlaKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773996583; c=relaxed/simple;
	bh=ahib7IbYp2cDCXT6vLdkvKmi5k8RioCG9oaxaS8HxBU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iTzbzh+SjAzw326L2TWenQOrNjJCOpzuqBFbMvD0gW0/AZ5Cu3j8PNsnpJOiJEn43OwCgXte5rpu4MuM45EK7LxRvPQHOQRHtcSoGHoqL0XljlqlyV/aZw71dAP0ZDiXsAIiP4A/4YCk3qsae4yqd9pf9NG6BLh4FOcvY8DcCls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=igP/iLuK; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="igP/iLuK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773996579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Z7Ypq/2sdtjtXxITYYiW9Wy8T7mWGhBOO/q+BwqcWKs=;
	b=igP/iLuKjQb5/GqbtIEiStlLNTdSw1sdmJBmW4o+d9qOmvRrmBSnP+zsMUvY6ndY9pDmtt
	lMIEO4cR0aGZOQLAPMsf99nj6gR8WewWwaLB9s76fbgNNj0iUKO7Jx28EAqaigVd1sYPxV
	0jWpD2C457eFQhV8eqF9unouRQLz/yI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: stm32 - use list_first_entry_or_null to simplify hash_find_dev
Date: Fri, 20 Mar 2026 09:49:13 +0100
Message-ID: <20260320084914.7180-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1185; i=thorsten.blum@linux.dev; h=from:subject; bh=ahib7IbYp2cDCXT6vLdkvKmi5k8RioCG9oaxaS8HxBU=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJl7ubhEMrm+KV0QmBve+uPYg++nWuft8vd82rPT0k74f Ms9rYXSHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRyWcY/tmG7/wYGXHYUuD8 g+s2r5ZMYQyZdLPx9KQfG+4/r97lE2zK8E/lUdvNwOS/W2f//2h69O0ZzrNLDDyv+LqtLk9y6/b uy+cBAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use list_first_entry_or_null() to simplify stm32_hash_find_dev() and
remove the now-unused local variable 'struct stm32_hash_dev *tmp'.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/stm32/stm32-hash.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index d60147a7594e..dada5951082c 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -792,19 +792,13 @@ static int stm32_hash_dma_send(struct stm32_hash_dev *hdev)
 
 static struct stm32_hash_dev *stm32_hash_find_dev(struct stm32_hash_ctx *ctx)
 {
-	struct stm32_hash_dev *hdev = NULL, *tmp;
+	struct stm32_hash_dev *hdev;
 
 	spin_lock_bh(&stm32_hash.lock);
-	if (!ctx->hdev) {
-		list_for_each_entry(tmp, &stm32_hash.dev_list, list) {
-			hdev = tmp;
-			break;
-		}
-		ctx->hdev = hdev;
-	} else {
-		hdev = ctx->hdev;
-	}
-
+	if (!ctx->hdev)
+		ctx->hdev = list_first_entry_or_null(&stm32_hash.dev_list,
+						     struct stm32_hash_dev, list);
+	hdev = ctx->hdev;
 	spin_unlock_bh(&stm32_hash.lock);
 
 	return hdev;
