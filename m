Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51F7223323;
	Sat, 29 Aug 2026 13:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788010472; cv=none; b=OaWmEDkFtsMGRbqFFt7jwgT9GWkse58rtioqiW97W/HTKb4IphgzwJ46wWcLFjDdVoYk15EfG1L5JG5AND2DOQa3fsoNNa6NwxynP/FaCeSv5nzAf4nfYQHmPEYGu6UzYa7WnarF0C2r14zHm7jRj6P+jzSiJn5sYrT2XfcwPJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788010472; c=relaxed/simple;
	bh=sj2FbP662UfTlUjAdQZKBbfB9RMpolU9yUOO3V3+jlU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XnqTJyVO5eOogoAueEcRIEglO41awTvTq+tnEz32BwKluMA1hBFPA8SDMzZ3t9pU/m1uJm+3E1bCGipB6wrl7KN3y1HuskqIg1yYGuGAlxqJCyVVcyuuFnbL+hb6Zs3qphLM7U8dLjh3oo88UyUxtFHdqxKZ+/BCv1TxPl8Jsoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=EVUy7K8Y; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="EVUy7K8Y"
Received: from PC-202605011814.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4bcbd04cd;
	Sat, 29 Aug 2026 21:34:15 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: mario.limonciello@amd.com
Cc: runyu.xiao@seu.edu.cn,
	jianhao.xu@seu.edu.cn,
	thomas.lendacky@amd.com,
	john.allen@amd.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] crypto: ccp: Initialize DBC ioctl mutex before registering device
Date: Sat, 29 Aug 2026 21:34:10 +0800
Message-Id: <20260829133410.1708684-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa04dba607d03a1kunmfc30c173d0b66
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGUkZVh0dTh9JSk8ZGU4eS1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpPSE
	xVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=EVUy7K8Y0chtFRbLbueu1YAq6XDxThYcLXwKbGy5mEqnpsHYndNEA1VpNtQdXW0TzmeqAgPXVASqTrb/IngOctDFkhF42206XLCferCdsOO9WLzQiTxsR36lRxDTz4DE6O9SCelHnGfLhQB0Gdj+D2WSkHxhqnbW2yhV5vBrdUk=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=yd9YtTllAlHctJiIZ5KUYqP4tsI/lD2hZypzZeaVt/g=;
	h=date:mime-version:subject:message-id:from;

dbc_dev_init() registers the DBC misc device before initializing
ioctl_mutex. Once misc_register() publishes the device, userspace can
open it and invoke dbc_ioctl() while the mutex is still uninitialized.

Initialize ioctl_mutex before calling misc_register() so the published
ioctl callback always sees an initialized mutex.

Fixes: c04cf9e14f10 ("crypto: ccp - Add support for fetching a nonce for dynamic boost control")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Assisted-by: Codex:GPT-5
---
 drivers/crypto/ccp/dbc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
index 410084a90..00c864413 100644
--- a/drivers/crypto/ccp/dbc.c
+++ b/drivers/crypto/ccp/dbc.c
@@ -240,12 +240,12 @@ int dbc_dev_init(struct psp_device *psp)
 	dbc_dev->char_dev.name = "dbc";
 	dbc_dev->char_dev.fops = &dbc_fops;
 	dbc_dev->char_dev.mode = 0600;
+	mutex_init(&dbc_dev->ioctl_mutex);
+
 	ret = misc_register(&dbc_dev->char_dev);
 	if (ret)
 		goto cleanup_mbox;
 
-	mutex_init(&dbc_dev->ioctl_mutex);
-
 	return 0;
 
 cleanup_mbox:
