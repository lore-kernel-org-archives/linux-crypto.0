Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E582F3C37;
	Sun,  1 Mar 2026 02:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330563; cv=none; b=S2qArL87z0oKTgw8ujLZ0ruGDNHCcj10fwiJYDFnHjDEk96ftrVe/BA0wI7RPsNTnJkL7Di7vqoWSOZ4py+EUH9yqmNka7PCCgyygnjYheedSQIrGMuq4guAkV9iQeTaAqnGRy1quFXfECsOQ8Udbp9TclkvJpD8CUMER+z3ILo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330563; c=relaxed/simple;
	bh=LDxGwsraqImVTWWZcy0nwDq6ZA8+w5j/0XYs9b1qwGI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tHZtUzeF0omm6hCjOY8+75g38xf1R7Jtp/Ff+nxTuw3yIiT4uzUfJPuutJLMFOSK5vQoMtY/nj6LbzdQhn+JSiY5yjGnD9jzt/yohGFz0ZqxU6TmUjFfXpn+Ikp1ik6MnDMrt+lNhUJ9MhIP0D9xkVS1c6+yoDwDm+UQcwJ/ohM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dD/fye6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dD/fye6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BE0C19421;
	Sun,  1 Mar 2026 02:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330562;
	bh=LDxGwsraqImVTWWZcy0nwDq6ZA8+w5j/0XYs9b1qwGI=;
	h=From:To:Cc:Subject:Date:From;
	b=dD/fye6MUkgwLDcP5rzekp3+3MdJuqat1AL3fmepNoCBRUAKu7bV9FWSrztAFRmC+
	 azCg/wMQDPDizXAulAChRIK4fi9iqtz+Gg7iq9Qq+YSIk6FGrR7PbIEf0fxKUvnjXu
	 zfe2Yf8RTJ3vLdyGMVg1POGBxw2AMNd/fx2LMc0QiEXQ97wFmf047QgnB/Qk0UmTgN
	 2DXP+DH+kteTxVvRxc2jTJUNsvfSaKcYsqxpwf776nOJsCfdNmkWgIlOTzEYyWi2oZ
	 b9RJDa/cHH86zd0+Cazh9Tz4bcTRSLJpGyhLrbGbm1e5MloPYnbb3goQ2940WsM8y9
	 GSAwndj9Ccmwg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	maobibo@loongson.cn
Cc: Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: FAILED: Patch "crypto: virtio: Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:02:40 -0500
Message-ID: <20260301020241.1730575-1-sashal@kernel.org>
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

The patch below does not apply to the 5.10-stable tree.
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




