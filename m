Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB04280CD5;
	Sun,  1 Mar 2026 01:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328282; cv=none; b=DJhd09UZwO3w5CizCIX1hQ9H2+gMrauek6OogYDIGTkvjUvbG94JDioJjAsAnyKocS9nhbJLZximhmHWiHViTC2UbNiaZtl0btMy28xFfmzd/KAkukigbSm+XC8bsWcPxSi3X/QB7iRcfn6E3Jx6BlZxGCiCghw3ZrKOuFPlCjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328282; c=relaxed/simple;
	bh=J23oACXd5l6XFKJAZU461esYc/nGqoFBeh9273Ao9Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nAy7q5ZPD934dBD4iteFtTryVxBmwSU+XsuRLiktNstnGjedBq+I49ALKQH72ldQZw2eKpuUFzS/dEC1ChH9PPW0XCVW25LueN9DgZQ9ziFBI/nXQvvRoJvCokLUMYbMJrHPNa/sY9xF+ehlPV518MigSE/+ytej8S/X5+Uajwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N0nN8PDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N0nN8PDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1421FC19421;
	Sun,  1 Mar 2026 01:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328282;
	bh=J23oACXd5l6XFKJAZU461esYc/nGqoFBeh9273Ao9Ro=;
	h=From:To:Cc:Subject:Date:From;
	b=N0nN8PDeEuLWZ2FHYk3to3HSiGNzhlzj9vhahQ75vlYpjLD6I3pqungPaXenv8HsG
	 RobHu7b278Z4IqkVr5LStmTHe29uFMS6UDhdARIq/RotUEnsmCQJRWTMlSK0HTbZru
	 AcdgHHExiXzqDZEuLc6/PXsTlPQo8fXwEMcEqcUVEUGt0GeByZLtd6PY84pqkTzbbs
	 Kty93Ex7ZYBtYCIA4d7WLEMvGFQNJ+2xABx4IZye0OFAl1nDE2ujwqG/rr6+zNPCUA
	 d2sjS19XqQfMJpCH4XDOk2hCK7JRFqp33JI/hoMAgPB1brddyRwVLm45DeFy7hYs4o
	 XaLL+WxX00UQA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	maobibo@loongson.cn
Cc: Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: FAILED: Patch "crypto: virtio: Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:24:40 -0500
Message-ID: <20260301012440.1681604-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From a389d431053935366b88a8fbf271f1a564b9a44e Mon Sep 17 00:00:00 2001
From: Bibo Mao <maobibo@loongson.cn>
Date: Tue, 13 Jan 2026 11:05:55 +0800
Subject: [PATCH] crypto: virtio: Remove duplicated virtqueue_kick in
 virtio_crypto_skcipher_crypt_req

With function virtio_crypto_skcipher_crypt_req(), there is already
virtqueue_kick() call with spinlock held in function
__virtio_crypto_skcipher_do_req(). Remove duplicated virtqueue_kick()
function call here.

Fixes: d79b5d0bbf2e ("crypto: virtio - support crypto engine framework")
Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20260113030556.3522533-3-maobibo@loongson.cn>
---
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index 1b3fb21a2a7de..11053d1786d4d 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -541,8 +541,6 @@ int virtio_crypto_skcipher_crypt_req(
 	if (ret < 0)
 		return ret;
 
-	virtqueue_kick(data_vq->vq);
-
 	return 0;
 }
 
-- 
2.51.0




