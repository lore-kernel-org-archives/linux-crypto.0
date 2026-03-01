Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C70621CC58;
	Sun,  1 Mar 2026 01:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772327700; cv=none; b=t+p5zyar1AvlQHYO7a/UHa4zcuhwmnTmDYlbrsMd+NUk8o2GYG/y70u+e0ZB3k0NPRLwn9AiaZapR1hlmWR5d6pl5DeU1Q8K9QYEKwLxs1yRfEPtcJEyWozxCqOo/XSVTphbGUYWHDyo8C6B5g/eK6UtoOjiLZm0BCaavUG9CDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772327700; c=relaxed/simple;
	bh=CXTtYOJAx/qq6YG6jNMyPqDPLX2euDcjsCXurEWMEI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ODvk0ZAWFi3x14AMyKneVQ/2K3iuCgOXzc7keOvt1nnA6NqD945g2U1BmHX1o6DBFnpQZAblxfW4PKKic5qI1WwkFSzkXxdntt7Wg1VQuBSJBsqFqv3TNH1awT25SUDJ/PQqk+72iQ8J3tRsJPO0pxmi/grkdJ4JOBCmPJFdxGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=athV3J3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="athV3J3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77092C19421;
	Sun,  1 Mar 2026 01:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772327700;
	bh=CXTtYOJAx/qq6YG6jNMyPqDPLX2euDcjsCXurEWMEI8=;
	h=From:To:Cc:Subject:Date:From;
	b=athV3J3vRHeAsFqa9wwW/KqOFdre9x2fU4CxIUjdOpCbr9h+b4hZYz0awJ7FuWZG+
	 ZIXAhs0V+MjuXDFESOB5lgsLCKEDahAMHgm5SWrERrhCCa8c4N+QHBqFriJV8Vl/pb
	 iKzu0FTyps5MGn4fZJH/jjXvZfYs+VbDcsjoop6Vb0Idg1wcPlo/7P/fk3JXBPY+hw
	 +2SAO/kXIWXzu+qyw/lZ/7VmumiGPP0l4gugJK7aMWOniyVvqcm0b4P/ZU5d/10p/u
	 itiEafzK06unUEbTwApJE0sew8dpAV9aFhhOlB5tINIHKDXsjb4vcK+6rr9zpqVp9P
	 mkqgaS+z0bB4w==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	maobibo@loongson.cn
Cc: Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: FAILED: Patch "crypto: virtio: Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req" failed to apply to 6.19-stable tree
Date: Sat, 28 Feb 2026 20:14:58 -0500
Message-ID: <20260301011458.1667727-1-sashal@kernel.org>
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

The patch below does not apply to the 6.19-stable tree.
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




