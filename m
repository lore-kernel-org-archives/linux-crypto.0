Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC73302165;
	Sun,  1 Mar 2026 01:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329968; cv=none; b=LAf3sAy6Vbl9WB4iWaoGYQytsjJtuHcNqmG5OPeZhqLxk6EdA1yjlyG35YZhHOZR1tgrEJmS9UvVzyLDXh6ENUF+qno1f5FjRFKTQB087c6ungrJlQCQg2KRtdOS0fPAU1TbfjpaUYOCVTpDl4RPq2sWJcY2WMdamVYLSvT/3lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329968; c=relaxed/simple;
	bh=CExcrflG4IPXSPYOEFqwbJ8inTL/ydm6MkTRoSWNyzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lG86gfqJVLLuRopjNK2ItKDv/PE0lTO0d0AwfStE7335ZU0iZcOX1HNqovAJC8ndXd0Uq0EZUQkkVt4TUjU4GTkuzGA9FPZphS6YNFxyIA8xVHqMsv75POUtxBqLRfZY9b6y00Z5N5/IFwch6C7JCZTy6MiTn9uyseGOXHo6TBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qXHRrCmm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qXHRrCmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F252C19421;
	Sun,  1 Mar 2026 01:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329967;
	bh=CExcrflG4IPXSPYOEFqwbJ8inTL/ydm6MkTRoSWNyzI=;
	h=From:To:Cc:Subject:Date:From;
	b=qXHRrCmmXAwJbhk5VtxoTap0s/ox3djXS5ijDe0Tis/jm19gEg0rfwCThP/DFO4JS
	 QefK5ybiu8sYfn7l2Ayo+EjuoMYkcg7jk0x+f++qyg0/l/T/xxM6yYg+2Jr5Mm2BMq
	 GDqd/PiNzd7iV+njGd6PdJt5Xz99Jf0H1WFaT4Yt3VGSgM5EJ1wXZBfRpQikz4RIyw
	 l5WxxtSnvjbEnsKjYV1unGIGCwsSYmLDJQ7qAJad9YZ6JOPTV9R+wiwPZwV7UXLG1P
	 EmawZSWWi6z4EBzFpL8gqYTvVKGY8TegHlf7UHCtPJI/c0lnN6dJ8LsAHfJW4LFm64
	 0bffotWGem3aw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	maobibo@loongson.cn
Cc: Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: FAILED: Patch "crypto: virtio: Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:52:45 -0500
Message-ID: <20260301015246.1719369-1-sashal@kernel.org>
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

The patch below does not apply to the 5.15-stable tree.
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




