Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE1E195;
	Sat, 14 Jun 2025 00:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749859532; cv=none; b=F8X4RQdTqiWGYCLGs2XgV2uw/Mbbg+cC13rlIaFSV2IydUuqx8h2V8Ihfm0np48Mo1XYEoc0o31vAAVXmBv31LmCnkBtxpT9tUIb5wGX4zr0tayjwZLoVpZvdYWZRnx/sPaiqz66bJ+MxxZAGnjp83VUhLNWTjTGl/fENGx7G1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749859532; c=relaxed/simple;
	bh=H5w145svL9nD4MH3xVlTF5B1o8n9qcI7nSL6AjSPvEc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nnMiQ8YJYvfD+0a2V5wz/Akva6dF1VzqaV0C37LJNH1ud6KP9tRSpo9YKmvUyFUdodd0oyepn5EltSVLwMZi1QEMZxsnUsl0hiLGmolB+c67KpitSqr165dceJFvF/nTqykUX9vhQW3dB+8a7PFjCA9TB6ASwZr7SLMlVaDuJsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=VfJAjbIJ; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="VfJAjbIJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=yRYoeJ7ZBLsFcQYXYz2a1BqOYHOwVX9w3w22zNi8Rjc=; b=VfJAjbIJ3ViqSq8k
	qkcvCMOdc3CmJ0vMFXxKG2y9zW/P3PU29Uik2SEOfgYPJ88ujsLKvzzilvT0I+a1AlQCzvhTHR1aG
	Dy0B4LDPEdoeqj96qaWUQ8cgggm4EmE/9iUi21dzlz3yfLWWD3nyfGUudAmssVC0NA9U6xOchwAIP
	MEoAqzYGv9jQFt0XHPTighe5iIZglel2CKal7qwafRsdvogf8tF7QUOk2rgp09Ove6VGdlWGY5ZM3
	CnxzDGzaxQQv2UhAnjLVE2wBcYPrjl5j6DxxAqY3dAAZsacL7kBIH8gbD/aIHPfTezgCDgHxajHE6
	FgiItT54BPuyeE3C+g==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1uQEOR-009aBD-0v;
	Sat, 14 Jun 2025 00:05:07 +0000
From: linux@treblig.org
To: arei.gonglei@huawei.com,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] virtio-crypto: Remove unused virtcrypto functions
Date: Sat, 14 Jun 2025 01:05:05 +0100
Message-ID: <20250614000505.596563-1-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

virtcrypto_devmgr_get_first() and virtcrypto_dev_in_use() were added in
2016 by
commit dbaf0624ffa5 ("crypto: add virtio-crypto driver")

but have remained unused.

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/crypto/virtio/virtio_crypto_common.h |  2 --
 drivers/crypto/virtio/virtio_crypto_mgr.c    | 36 --------------------
 2 files changed, 38 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index 7059bbe5a2eb..19c934af3df6 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -113,8 +113,6 @@ struct virtio_crypto_request {
 int virtcrypto_devmgr_add_dev(struct virtio_crypto *vcrypto_dev);
 struct list_head *virtcrypto_devmgr_get_head(void);
 void virtcrypto_devmgr_rm_dev(struct virtio_crypto *vcrypto_dev);
-struct virtio_crypto *virtcrypto_devmgr_get_first(void);
-int virtcrypto_dev_in_use(struct virtio_crypto *vcrypto_dev);
 int virtcrypto_dev_get(struct virtio_crypto *vcrypto_dev);
 void virtcrypto_dev_put(struct virtio_crypto *vcrypto_dev);
 int virtcrypto_dev_started(struct virtio_crypto *vcrypto_dev);
diff --git a/drivers/crypto/virtio/virtio_crypto_mgr.c b/drivers/crypto/virtio/virtio_crypto_mgr.c
index bddbd8ebfebe..06c74fa132cd 100644
--- a/drivers/crypto/virtio/virtio_crypto_mgr.c
+++ b/drivers/crypto/virtio/virtio_crypto_mgr.c
@@ -81,42 +81,6 @@ void virtcrypto_devmgr_rm_dev(struct virtio_crypto *vcrypto_dev)
 	mutex_unlock(&table_lock);
 }
 
-/*
- * virtcrypto_devmgr_get_first()
- *
- * Function returns the first virtio crypto device from the acceleration
- * framework.
- *
- * To be used by virtio crypto device specific drivers.
- *
- * Return: pointer to vcrypto_dev or NULL if not found.
- */
-struct virtio_crypto *virtcrypto_devmgr_get_first(void)
-{
-	struct virtio_crypto *dev = NULL;
-
-	mutex_lock(&table_lock);
-	if (!list_empty(&virtio_crypto_table))
-		dev = list_first_entry(&virtio_crypto_table,
-					struct virtio_crypto,
-				    list);
-	mutex_unlock(&table_lock);
-	return dev;
-}
-
-/*
- * virtcrypto_dev_in_use() - Check whether vcrypto_dev is currently in use
- * @vcrypto_dev: Pointer to virtio crypto device.
- *
- * To be used by virtio crypto device specific drivers.
- *
- * Return: 1 when device is in use, 0 otherwise.
- */
-int virtcrypto_dev_in_use(struct virtio_crypto *vcrypto_dev)
-{
-	return atomic_read(&vcrypto_dev->ref_count) != 0;
-}
-
 /*
  * virtcrypto_dev_get() - Increment vcrypto_dev reference count
  * @vcrypto_dev: Pointer to virtio crypto device.
-- 
2.49.0

