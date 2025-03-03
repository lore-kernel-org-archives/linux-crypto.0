Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AED148316;
	Mon,  3 Mar 2025 19:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741028910; cv=none; b=hReR2iVHw1Dp1JMsPTXdNDkbqUA61TR24alELv3bpfiSdpw2ASIT5agwDfZ/nOIophEtLfYJjNMQAWku5gAGxbhicJvACaVm603djFZpIoDn2rGM21nCfNIWoEmKpKUkpbbcTUikPIgqGxgp9MD5Q4FSGbzv1aV0AknWRn0AKvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741028910; c=relaxed/simple;
	bh=OdaCz1lN4L5zRYlJ62JZ3Igzlho5j0L3B1BtSNpw0lo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F9yKtHH/nFlnAS+l9JhPFpA/7RkrUQn05cJqPiyscmD/e1Cos0JAfmqGlpyOGKApZCTFKFMw1omkfCMWnAuCagaqLe2hV2eh91uHntAGoasWUED8VW2Q2Rd6vtNM3Vgk5r3Xmmp75zb3Zxjo/0N0FwHqWnUVQcnZ5G6cn90HlRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=NBxrVktW; arc=none smtp.client-ip=80.12.242.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="NBxrVktW"
Received: from fedora.home ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id pB98tUF9uZnsCpB9BtL73a; Mon, 03 Mar 2025 20:08:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1741028899;
	bh=Y2nPTpi3tNbwO7vst2oVl4JU/9ZN2dFKqd/bAjL7RF0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=NBxrVktWQADojleBfDoqQMhS1DhF/rvD6+UTL9FttSpBQlDgls1o9lXCAKb6H3oeg
	 9WN3Oy7C/Bfhohm58mrrdKN9XZftOogn5idma3f166Hy7dOZEd4HtD6koRk/Wq45IC
	 xpxD4LJKx54mDNM35QGrE5G2DqYoGP2VOuFLjZABuLrTeczvgWmvXCZ1n51H/0KVyD
	 t7mqgf98JR4NlYOgOfHe0Bodkgo4MkzxBdSpyGXLFLqHj75Ed123rrf1O+Gyruwje8
	 e8I/FglWESdS/BcycOP6WKUBxxPFkZk1Kkm+rAm4ACapks2Y1xXLNeE44zYB8sHdOU
	 8IBWllm2ECURQ==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 03 Mar 2025 20:08:19 +0100
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Gonglei <arei.gonglei@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: virtio - Erase some sensitive memory when it is freed
Date: Mon,  3 Mar 2025 20:08:04 +0100
Message-ID: <a18fc6cf356bc338c69b3cc44d7be8bd35c6d7d0.1741028854.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

virtcrypto_clear_request() does the same as the code here, but uses
kfree_sensitive() for one of the free operation.

So, better safe than sorry, use virtcrypto_clear_request() directly to
save a few lines of code and cleanly free the memory.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
I've no idea if this is needed or not, but it looks not consistent to me.

If safe as-is, maybe the kfree_sensitive() in virtcrypto_clear_request()
should be removed instead.
---
 drivers/crypto/virtio/virtio_crypto_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index d0278eb568b9..0d522049f595 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -480,10 +480,8 @@ static void virtcrypto_free_unused_reqs(struct virtio_crypto *vcrypto)
 
 	for (i = 0; i < vcrypto->max_data_queues; i++) {
 		vq = vcrypto->data_vq[i].vq;
-		while ((vc_req = virtqueue_detach_unused_buf(vq)) != NULL) {
-			kfree(vc_req->req_data);
-			kfree(vc_req->sgs);
-		}
+		while ((vc_req = virtqueue_detach_unused_buf(vq)) != NULL)
+			virtcrypto_clear_request(vc_req);
 		cond_resched();
 	}
 }
-- 
2.48.1

