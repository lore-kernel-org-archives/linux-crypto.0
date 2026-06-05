Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A7A3CEBBD
	for <linux-crypto@vger.kernel.org>; Fri,  5 Jun 2026 23:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780701102; cv=none; b=qfCQisZ8/4e5GCbF5Z5+WHNQPOA1sUVUIv+u4fD0oDz8dOd38IafmH4vP6WHjNSwAmLa9xiDLL74VIfAaMNFR8nxNAfykDogZ0lH1NwMY24ZYzrV5r1wkaPpg7xsfVy6TadTSaKlRDwDAe+y8fbJEpR0Zix3ujRHUJnJ9VpGmlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780701102; c=relaxed/simple;
	bh=rAFBy20kMjE1SncDj6NWXZlCkboK/emltp9Xq2RDBFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaDHJBMPUWloD4C1zmdT7qvtry5wZxU8JR3kMtAtaD8DBSALPhQj58+ahYug7MDo1jwt823kZgKweOk9KsuktmCVc0Qon5JIdNvRXK+CQlRAtnP55XwIcWzQ3qX8RWqicHUmM63n3hhTDuHt6P10XOhdPV578KZ1frHjxYlu3iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L+zV87zu; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L+zV87zu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780701099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mgAFIjZlhXPIapctdZCpPiSBDw3WrJwz8erDLBXDFsE=;
	b=L+zV87zuEKCT5MIMQ8AoORTVbq9kFFcDCFVlcC2MZ7zbm2ikCYQY13t/4VUrxjihAkJiUR
	mI0HxYkf41VYe9pGw3+MmK9/zYeDmd8rjUmqqKgG9ACUOhvLOpn9tIR6fIJNL13u15nMaz
	/UmbTqGXunjkdlNv6JwkplrrCpTZ8oQ=
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
	Thorsten Blum <thorsten.blum@linux.dev>,
	Longfang Liu <liulongfang@huawei.com>
Subject: [PATCH v2 4/6] crypto: hisilicon - use 2-arg strscpy where destination size is known
Date: Sat,  6 Jun 2026 01:11:01 +0200
Message-ID: <20260605231056.1622060-12-thorsten.blum@linux.dev>
In-Reply-To: <20260605231056.1622060-8-thorsten.blum@linux.dev>
References: <20260605231056.1622060-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=994; i=thorsten.blum@linux.dev; h=from:subject; bh=rAFBy20kMjE1SncDj6NWXZlCkboK/emltp9Xq2RDBFk=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnK4Q2F6T1vprdvmNzxZN+GWvWmO9kzJ6ZFnv+fJj+1h nu56iKZjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZjIglWMDF1BGp2CJvZ8+xgU uO6oRYppTRO9PmfVkwVBniYPxJ9O02dkOMTy9MzHQ7saKj58urCi+EBH1XQxjs490wt0vVY453j /4gIA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To simplify the code, drop explicit and hard-coded size arguments from
strscpy() where the destination buffer has a fixed size and strscpy()
can automatically determine it using sizeof().

Reviewed-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/hisilicon/qm.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a951d2ef7833..c01966a4a33f 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2944,11 +2944,8 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 		.flags = UACCE_DEV_SVA,
 		.ops = &uacce_qm_ops,
 	};
-	int ret;
 
-	ret = strscpy(interface.name, dev_driver_string(&pdev->dev),
-		      sizeof(interface.name));
-	if (ret < 0)
+	if (strscpy(interface.name, dev_driver_string(&pdev->dev)) < 0)
 		return -ENAMETOOLONG;
 
 	uacce = uacce_alloc(&pdev->dev, &interface);
