Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3014B23D294;
	Tue, 13 Jan 2026 03:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768273563; cv=none; b=WNvweiKJ/KZ1P7W56c2cvX74bD3AghcOOQA6B8r/k+/GF/TNT42KZyWBG5J4foTk/LaIefe8cX6nfHXpAUx02GXJPxkx2gko2SdCeTd8oVC+6bmwnAC7a9qnRHXmpZC87ZE91DT9CFBqIouUvFguYdrg2Zly9a3UEWVVGjGKjbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768273563; c=relaxed/simple;
	bh=GZVFLvhaseMrUG9aixy412i7VVA96RLEKsruXzwHOK0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WT65o2KPnwF1qDTu9cxza5KcVqxNKia79cPRtGgrnaMRvmWIjVvi454VlSUTCjiA90DYhOxRg/M1zltFIsIGi/BKp0qeExtQfgYTBUShqKHzf4enTaa+TPMoXqa0vdjNFhPrNxSOLVMyPyKXUz8oItqIWsjfkj7ArU4NXL+ageE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxAfGWtmVpOzAIAA--.26695S3;
	Tue, 13 Jan 2026 11:05:58 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxLMKVtmVp734cAA--.56671S2;
	Tue, 13 Jan 2026 11:05:57 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Gonglei <arei.gonglei@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	wangyangxin <wangyangxin1@huawei.com>
Cc: virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/3] crypto: virtio: Some bugfix and enhancement
Date: Tue, 13 Jan 2026 11:05:53 +0800
Message-Id: <20260113030556.3522533-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxLMKVtmVp734cAA--.56671S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

There is problem when multiple processes add encrypt/decrypt requests
with virtio crypto device and spinlock is missing with command response
handling. Also there is duplicated virtqueue_kick() without lock hold.

Here these two issues are fixed, also there is code cleanup, such as use
logical numa id rather than physical package id when checking matched
virtio device with current CPU.

---
v4 ... v5:
  1. Only add bugfix patches and remove code cleanup patches.

v3 ... v4:
  1. Remove patch 10 which adds ECB AES algo, since application and qemu
     backend emulation is not ready for ECB AES algo.
  2. Add Cc stable tag with patch 2 which removes duplicated
     virtqueue_kick() without lock hold.

v2 ... v3:
  1. Remove NULL checking with req_data where kfree() is called, since
     NULL pointer is workable with kfree() API.
  2. In patch 7 and patch 8, req_data and IV buffer which are preallocated
     are sensitive data, memzero_explicit() is used even on error path
     handling.
  3. Remove duplicated virtqueue_kick() in new patch 2, since it is
     already called in previous __virtio_crypto_skcipher_do_req().

v1 ... v2:
  1. Add Fixes tag with patch 1.
  2. Add new patch 2 - patch 9 to add ecb aes algo support.
---
Bibo Mao (3):
  crypto: virtio: Add spinlock protection with virtqueue notification
  crypto: virtio: Remove duplicated virtqueue_kick in
    virtio_crypto_skcipher_crypt_req
  crypto: virtio: Replace package id with numa node id

 drivers/crypto/virtio/virtio_crypto_common.h        | 2 +-
 drivers/crypto/virtio/virtio_crypto_core.c          | 5 +++++
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 2 --
 3 files changed, 6 insertions(+), 3 deletions(-)


base-commit: 9c7ef209cd0f7c1a92ed61eed3e835d6e4abc66c
-- 
2.39.3

