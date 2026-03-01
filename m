Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8F42D9798;
	Sun,  1 Mar 2026 01:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329467; cv=none; b=UDKZTJHhap0xZN7toZUo9P+3hk/HrELR/N5tEHIi2ukIs4xNJ53IPIrIA7AngYEvke+TLzG+aalRTlRL1RvrGMYp2n0A9cwQ9SIr0LWx+9tIxkFt3NsV1smaHPd1bWcIB5YnB6MS4MjCKZf1K3Xsxu0KZgCs+9Gyp7uLwmaPTqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329467; c=relaxed/simple;
	bh=Bz3dRhD/8h/a5poanw0XLle94muCl2iGFZhvnYZGI/k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WNgvu9i1DiGpetb/JslGp37tIYYoPdZqKIeD1HMC4quqgvaepkWghsveAQ8gLMlXXoNUv5Fia186bIZgusMuTri6brWwyLDyu6HbgyomhCIjah6M9jwfPU7uBsWk4BJ5kb8ulU6sDo6gOqnE7dTGVwd8Y22SHpCmfVzYYXRBaHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+DId0lP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+DId0lP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A975C19424;
	Sun,  1 Mar 2026 01:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329467;
	bh=Bz3dRhD/8h/a5poanw0XLle94muCl2iGFZhvnYZGI/k=;
	h=From:To:Cc:Subject:Date:From;
	b=H+DId0lPhd7IgRHYF1bb8AKvlX4kZSjE3j2JVfE3kHfC0W4Q7rY8S7fQ/5gM5j80t
	 ZdSoy+JHRn/KvB67Xvbl8nFRYZX+4NlcW7u3rHRckgzsPOoN4E1ujC8PT8LRf9JG0Z
	 cjwXA0qu4C3UxktKXF0wmxkc+b9xbd0MQwNw2m8AeWFttt0AGHPzXAU0/nnOHzAHD3
	 x3kkchWSrbUGd+kLsctMDMtsQWtoi+owtqCNdvciYLyX8aqgq92UxRF8S4zL/hz+yb
	 n15wK3B0BiC1bmiq5v52XjkPg1jPHsOut+M5hBTVjS+Ei1EcwlGHBOGC+nf1SZ7fOC
	 xqnRSiY43Yzog==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	maobibo@loongson.cn
Cc: Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: FAILED: Patch "crypto: virtio: Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:44:25 -0500
Message-ID: <20260301014425.1706675-1-sashal@kernel.org>
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

The patch below does not apply to the 6.1-stable tree.
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




