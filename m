Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2BA1E411D
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 11:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733223789; cv=none; b=VQAYHptx5VhkFOCjM5uSd4avd+j5f9Bj1E/VhmAF2vBqEHQRuCe3Ih3NAAY10/yfKSRlIybaBaLS9nkFUhFP+XRF50LQvgsvUI061KrnIJVykzl+mZxuowQ7EMh+JbXIC9DGsoodhWV69w65QIB2OBMKk2BnDtZobHMaGFqfCUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733223789; c=relaxed/simple;
	bh=HWMQCj01jHX4+s5mWusey4esbb+DqmOUgYumbOZlkCw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qScfpa66zz9No/sZ3hLg/pgmEBao9RlI8/bHlN2rsNqb6Aj4nnpHuAowYWPDvch5dPG34Hl2tVnVHSmjlUfsZWqQTdLS/wJ59U9KXPDjVCgWw7Q60PXbY1qy2i/u/wOLx+mnPMFf9ZkYL9FDJA258TOcGdRZQuD4smthXvrKWoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFyUFMI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFyUFMI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FED4C4CECF;
	Tue,  3 Dec 2024 11:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733223788;
	bh=HWMQCj01jHX4+s5mWusey4esbb+DqmOUgYumbOZlkCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFyUFMI7yBR73deP3Ew55VC0dgfs1oOIeHUkNetY44JYP++Fs5FS2GRPLP/Cnn7ww
	 bObnG8aFCRx5adlAjSQ+6XRR+G+tLkl22bW3wl55TSCOOTj66XGtUhiNmNY0+kDCoD
	 ir6KLFLtB8ySgQBAmKPd8cWLhEs5XgKuhPiexUI8cX/z6bWEIODB/eDQ1oRlLaXeNE
	 KWWsPnVsQ5qoCtw9EQyWmPjW0XlGPJGdccEs3H1ZYH5Hrj5o1rRL/radX0jw05RAwU
	 1mcyHvt4uiYSfqR2rnBDiku4MizwZ2tktoHuJO+iC2mAdt3INvYU7ZVhuZ5lUWuCgn
	 byRAGuqwik7pA==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 06/10] nvme: always include <linux/key.h>
Date: Tue,  3 Dec 2024 12:02:34 +0100
Message-Id: <20241203110238.128630-8-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20241203110238.128630-1-hare@kernel.org>
References: <20241203110238.128630-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To avoid build errors when NVME_KEYRING is not set.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/nvme/common/keyring.c | 1 -
 drivers/nvme/host/tcp.c       | 1 -
 drivers/nvme/target/tcp.c     | 1 -
 include/linux/nvme-keyring.h  | 2 ++
 4 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/common/keyring.c b/drivers/nvme/common/keyring.c
index 8cb253fcd586..32d16c53133b 100644
--- a/drivers/nvme/common/keyring.c
+++ b/drivers/nvme/common/keyring.c
@@ -5,7 +5,6 @@
 
 #include <linux/module.h>
 #include <linux/seq_file.h>
-#include <linux/key.h>
 #include <linux/key-type.h>
 #include <keys/user-type.h>
 #include <linux/nvme.h>
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 3e416af2659f..b5e11a0f7ba8 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -8,7 +8,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-#include <linux/key.h>
 #include <linux/nvme-tcp.h>
 #include <linux/nvme-keyring.h>
 #include <net/sock.h>
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 7c51c2a8c109..fa59a7996efa 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -8,7 +8,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-#include <linux/key.h>
 #include <linux/nvme-tcp.h>
 #include <linux/nvme-keyring.h>
 #include <net/sock.h>
diff --git a/include/linux/nvme-keyring.h b/include/linux/nvme-keyring.h
index f7bbcbeb4b13..ab8971afa973 100644
--- a/include/linux/nvme-keyring.h
+++ b/include/linux/nvme-keyring.h
@@ -6,6 +6,8 @@
 #ifndef _NVME_KEYRING_H
 #define _NVME_KEYRING_H
 
+#include <linux/key.h>
+
 #if IS_ENABLED(CONFIG_NVME_KEYRING)
 
 struct key *nvme_tls_psk_refresh(struct key *keyring,
-- 
2.35.3

