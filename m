Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9675E22126C;
	Sun,  1 Mar 2026 01:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772327839; cv=none; b=mLEOdhL1QZqGU6hhmtoDojqMpwAHXys7RD1DOkrK44AVDbE9e1LkPnKNlTzjgeL6A1LzAET6JNCuGrLEWa6AWWqOo+k39a2ve7qzddc1eSfXcKjDbb6xJFjhFh9GSSJdIXmj4LfPoplH6hVwsq5A92C+sZ9a4Eg7koVCitEPipU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772327839; c=relaxed/simple;
	bh=SmYZNoL83ueWHvcHP6d0xtIzCplL/2b4jmkDJ43bvnE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H79vkVJlBHCRETORV+u/UAG/5whWClOJMwvN1DtrnNc94QQeu+E0A4sW3C67dVde1uc/B535CSS/dORj4KmVwLE+uAfNaA1pLT32MLpWscSKq6kuH/2Wxoh5kE134hSOIr1bugj4r180HxouWU/oajsK0LGPBL0aZwinAc92pNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VB3ZHnTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VB3ZHnTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1F4C2BC86;
	Sun,  1 Mar 2026 01:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772327839;
	bh=SmYZNoL83ueWHvcHP6d0xtIzCplL/2b4jmkDJ43bvnE=;
	h=From:To:Cc:Subject:Date:From;
	b=VB3ZHnTCEYW7jO/HRvxq/N3i6WmBJTn/G8YSBxNay3G2tHMyjYUVxlXmY3zX4fVPP
	 MLJdTfZJ/dlvwVOPoUp4QmDo8qgzULwdDKc2tSni8mPjY6IiotZulnsVeh8g0jwr5k
	 FQJh87zOXYgf1lcOLzvRuKkt1i7EtNnh52dlVFXSKfplBz1+KNWtydiQUs61BgSqfi
	 5U6KixFTab+XJ0rW7ewOeeC4WQK1D8pJOvDqcztDD2i0ELce0Yy3r4Y9SJtvB+y3Ok
	 DX1rsVoDHSmIKuCPyQ3zofrsIiEgaZtnX6V62Z/NXj1fLvfV9O0ZtuzxaljaMZHtLV
	 S4m2waJ4o/+Kg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	maobibo@loongson.cn
Cc: Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: FAILED: Patch "crypto: virtio: Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req" failed to apply to 6.18-stable tree
Date: Sat, 28 Feb 2026 20:17:17 -0500
Message-ID: <20260301011717.1671186-1-sashal@kernel.org>
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

The patch below does not apply to the 6.18-stable tree.
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




