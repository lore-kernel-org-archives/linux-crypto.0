Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9227725B0B9;
	Sun, 30 Aug 2026 01:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788054700; cv=none; b=XUu9/ZCyVr4XEy9u5hgR1N4hl/DVWni4HHRUROFzugWj5mYEy9lYYlsldD1N3GHXdrNpj7NJkLaGk0KQeFLvbjfIdqTGUoXB37Dahu8JO7q43J0eRzRWQsHcw488oN6bSp2GXrzrx2N0X0rvwf1Emder7VQWkDDxQf5zH2DIdRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788054700; c=relaxed/simple;
	bh=u+jOu82T2Vpuxz80KFOge2EQ0q7wFuyLh5VGuv89T6E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nw+Y+3niYhHdtrLkLFtRpMHInw9C0wZLA5fsxsM+ujmcNhvaGQoDDpOVcjXbZVOE2xez9t+DosCJ+kR+G79BIP2RXuaX+z1uZmVQ7O0ZByNwmFyd5otFbYrOupLMrQKYmcPVJy6yCKSmnTNrJ9okOFTNVbDazMUHKYdRkCircXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=kWP/Ii4E; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="kWP/Ii4E"
Received: from PC-202605011814.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4bd15770c;
	Sun, 30 Aug 2026 09:51:30 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: mario.limonciello@amd.com
Cc: thomas.lendacky@amd.com,
	john.allen@amd.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	runyu.xiao@seu.edu.cn,
	jianhao.xu@seu.edu.cn
Subject: [PATCH v2] crypto: ccp: Initialize DBC ioctl mutex before registering device
Date: Sun, 30 Aug 2026 09:51:04 +0800
Message-Id: <20260830015104.2040153-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260829133410.1708684-1-runyu.xiao@seu.edu.cn>
References: <20260829133410.1708684-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0505d59dd03a1kunmd7826b21e7dac
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTE0dVkJLSxkdQxhISx9MGVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpPSE
	xVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=kWP/Ii4EvbygR3rSFVn2CU7Yne0IWqlLSJDa3ujGm+YvViahMS7aJ9b0Hh7JXe4MdkqI6r5z5jdc+cH3/RFI+LShcyQztX3SSQ5C2jikmUB+aQiSpTqlX0Cup595xlEkV8367/jtGtup4Gr0XiNH5jjteiexQgj0Va5BZCfj3xM=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=y740TBYuiOL4j25V3xrb8r9hhghIl4Frs7wek9rWvUk=;
	h=date:mime-version:subject:message-id:from;

dbc_dev_init() registers the DBC misc device before initializing
ioctl_mutex. Once misc_register() publishes the device, userspace can
open it and invoke dbc_ioctl() while the mutex is still uninitialized.

Initialize ioctl_mutex before calling misc_register() so the published
ioctl callback always sees an initialized mutex.

Fixes: c04cf9e14f10 ("crypto: ccp - Add support for fetching a nonce for dynamic boost control")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260829133410.1708684-1-runyu.xiao@seu.edu.cn/
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Assisted-by: Codex:GPT-5
---
v2:
- Move mutex initialization before setting up the misc device, as suggested
  by Tom Lendacky.

 drivers/crypto/ccp/dbc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
index 410084a9039c..4db49a14550c 100644
--- a/drivers/crypto/ccp/dbc.c
+++ b/drivers/crypto/ccp/dbc.c
@@ -235,6 +235,8 @@ int dbc_dev_init(struct psp_device *psp)
 		goto cleanup_mbox;
 	}
 
+	mutex_init(&dbc_dev->ioctl_mutex);
+
 	dbc_dev->char_dev.minor = MISC_DYNAMIC_MINOR;
 	dbc_dev->char_dev.name = "dbc";
 	dbc_dev->char_dev.fops = &dbc_fops;
@@ -243,8 +245,6 @@ int dbc_dev_init(struct psp_device *psp)
 	if (ret)
 		goto cleanup_mbox;
 
-	mutex_init(&dbc_dev->ioctl_mutex);
-
 	return 0;
 
 cleanup_mbox:
