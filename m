Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4022036FE
	for <linux-crypto@vger.kernel.org>; Mon,  2 Dec 2024 14:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733149823; cv=none; b=UwUxbU9GkcXSLlQxHNfyslUXbdWjnhZf1IVAPh7Ieta1LyL6sKRx11QxJ2irYKCnjsmFDZpAODHbHMOVS0JONrnd78phFe+COedonLC/1228JEZUUlndxEoBm7ecDoQSxhViXhAnw5QZ5VetHmpMf6YMsGWt3BmB5jhBk7akHbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733149823; c=relaxed/simple;
	bh=9JeXcUycqg7OBCWWoqnUUbdjnZuT/EKlo2YBlO3bWyk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gZNjLfAgcn/zY3Qno6mndyyh5cGKcZQ6zwQ3brbS0aKIA3iwp0IxKD9pz+Sn/9eMb0LHY1g7ZDh0hI1FPVaOaA4/L0WKFqzxTh/HylSKJHESwUlg0I4pE8rmf8V43eWr0i9Hjp0AN7U7Frq7BNsAZPr9BF8fF8nejkr+YbrI3YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKlStGQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKlStGQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C729C4CED1;
	Mon,  2 Dec 2024 14:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733149823;
	bh=9JeXcUycqg7OBCWWoqnUUbdjnZuT/EKlo2YBlO3bWyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKlStGQYXemxJ1VKQLmiNSgH1ujc/FhIKctIv1+fPL7LL5SdDJklHHwbZF8ggqv3A
	 EudIpEvFbF+dXfJV6I+T0sybHhQBqyWkvvDsWaAwk4PNfwUPIchhQPxHyQXMskaayI
	 GGM8Dq35VVDi1hrcJ+3KX/EjC9Icm/MKz8f8sZ1El4bmG3lsdz1hlYz09z6wsDXr7B
	 /qVDF1NeqXCLCSQ6EvnaB2BI6dDFspnSJGBAsbhCmdDPCsrX1z2YlGb5Izj5VlD5GB
	 lRi/u6G4RQGZwqyZFqrD5/UjOD407qlEcb0UoBOjoEtIJAvFuwPjlO/nKvjJwsSAjM
	 bgzOfiv8ooujQ==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 06/10] nvme: always include <linux/key.h>
Date: Mon,  2 Dec 2024 15:29:55 +0100
Message-Id: <20241202142959.81321-7-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20241202142959.81321-1-hare@kernel.org>
References: <20241202142959.81321-1-hare@kernel.org>
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
index 351a02b1bbc3..009bee8e8090 100644
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

