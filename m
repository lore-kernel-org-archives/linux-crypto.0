Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 654392F3C2A;
	Tue, 13 Jan 2026 03:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768273564; cv=none; b=Wq03uyHDJhbvXXK0Aj/NRb21B0erIydPRWmAhQypYoVzMS3YDNgIg1rKDbUSthlmGMarcYJor1Fdup8PRAXLvk9P+Zx8NW/V8fTDApioknjXQ83C/MvkCV/M3z6yFYlwwISQjQFUvxmnbt92IpC/e/eMM7466DuCzQmOi9zIB/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768273564; c=relaxed/simple;
	bh=ZZ5dAi3AfOggJDka4CE+KurcbK6DTubg2tviWMscVzw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EXT7tE+P9cs9rIfrSszqFjBHzwk4y8OZogBY6xJLixiP2SaBzZxvPT+qWBWeSI+nkVYvL+h7MVaSsSh48xY2LLBTAu+ZoMY0IHs51bnLvqHspjxnJzBjvNH2F6xLzQ2rJOdGu+Wlq8PXvYZrxg+QjGm8lo6AszTPTIi6K1eGSqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxKMKZtmVpUDAIAA--.26356S3;
	Tue, 13 Jan 2026 11:06:01 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxLMKVtmVp734cAA--.56671S5;
	Tue, 13 Jan 2026 11:05:59 +0800 (CST)
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
Subject: [PATCH v5 3/3] crypto: virtio: Replace package id with numa node id
Date: Tue, 13 Jan 2026 11:05:56 +0800
Message-Id: <20260113030556.3522533-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260113030556.3522533-1-maobibo@loongson.cn>
References: <20260113030556.3522533-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxLMKVtmVp734cAA--.56671S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With multiple virtio crypto devices supported with different NUMA
nodes, when crypto session is created, it will search virtio crypto
device with the same numa node of current CPU.

Here API topology_physical_package_id() is replaced with cpu_to_node()
since package id is physical concept, and one package id have multiple
memory numa id.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/crypto/virtio/virtio_crypto_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index 19c934af3df6..e559bdadf4f9 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -135,7 +135,7 @@ static inline int virtio_crypto_get_current_node(void)
 	int cpu, node;
 
 	cpu = get_cpu();
-	node = topology_physical_package_id(cpu);
+	node = cpu_to_node(cpu);
 	put_cpu();
 
 	return node;
-- 
2.39.3

