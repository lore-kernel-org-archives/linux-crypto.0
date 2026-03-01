Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B3A29B793;
	Sun,  1 Mar 2026 01:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328934; cv=none; b=UMXkkXkJzV/ukSBhiTWzYldUGi1+4FxNfEy9/sgG2o/Wflnhbb+tDMjfCmMmT83OM1rRPjlIwiK3AQ0DqLphWJ2mSvR2UOO/HkZoFVNyciPoj++9dys6tf7afOEJC+6Z+XQxXx83DJ7QtUdXcdCC3JCspg5e96+K0EMYPsTp0Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328934; c=relaxed/simple;
	bh=f44CCvzcFsCEUiWVTexGj8h1YBDZoxypY0yPh5a0HsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VcVVcSd801fct4Er7QJpT6e0aQ6TjPFZxNnk9lXoqcqzm3aWFKfI2UosZ4vFlfkzLHBcQgbKVDgkAakHVkPdu1LaUp7eb4tDHQGEoL+ACMn59fmUFwHCXOl6xN1GKGpDOKHT/s1XIr2oZjHDBd9MvW0dK1fMfNHVFede7LO+7u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OoWH36N/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OoWH36N/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1370C19421;
	Sun,  1 Mar 2026 01:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328934;
	bh=f44CCvzcFsCEUiWVTexGj8h1YBDZoxypY0yPh5a0HsY=;
	h=From:To:Cc:Subject:Date:From;
	b=OoWH36N/bUQRrWFtTAJFIeDud/ER7aaIMKt+RsIiPMjQFEPy3XfzixSLOxDWQiiL8
	 cPLEk5WBD700lWkr2UTk08FB1fPfuDp6KhazES+bJxPe6keBq6RSfk7QZvfmeoNSJR
	 5Uye5YbHUn/jlzgIlGHTmJpJdON3dyN3Sc01rZYF5Kibz/jrGjNkUaMUwD8PnqOFjS
	 Z8b0qgxHHpqK7a+A6L/wlspRBAAXPGKpYyILuuEhXIt6OKjFdfl9unBOs8oChlld+H
	 ayyJzIZpC+NewEJIkJqn6NQ4HyLKKZsHwpCQjE/iQjyty4aER9s+adfUqnCzqn+qW4
	 ZFWLGT9xc9OvQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	maobibo@loongson.cn
Cc: Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: FAILED: Patch "crypto: virtio: Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:35:32 -0500
Message-ID: <20260301013532.1695261-1-sashal@kernel.org>
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

The patch below does not apply to the 6.6-stable tree.
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




