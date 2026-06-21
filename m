Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EAA2236E0;
	Sun, 21 Jun 2026 02:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782009861; cv=none; b=mw2pztXMYwsIGf0uZiR7ym99zRyJ27Rz10giv0cskD/lYz6Cu/c5qkNZwdRtifb8t2ncNCumanTvrOLII4Pqu+tUmg7E5wksGqXqd/5OgZTg09YCL+kxhblZlIzra2k1aHklPepA7Xjky0J9oaC5vWOARXPDGQNGfr1ZavDBNgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782009861; c=relaxed/simple;
	bh=B7A3X8+3YYiR5HQ4ddUjnvGEH2m0YR3OBhjZX2A8Wx8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=fceq5KT9L8A+qF3Jk5CH7F4YL9MFVtrzbJJkbrIErF1FaUwbpZfnfK1JJgqse1M6mUFFMB5skNnGgzTU93HSH8IlzDmsCYJAzs3yYdm6Whj9zAAQUyTnwtHYIql1oMYL8wRNL3IwqQ2NTB3dBipdnig+xXZB8xRKLjrYFWUbG+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jf+oU/k2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jf+oU/k2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 630A0C2BCB0;
	Sun, 21 Jun 2026 02:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782009861;
	bh=B7A3X8+3YYiR5HQ4ddUjnvGEH2m0YR3OBhjZX2A8Wx8=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=jf+oU/k2CO6Ugm1opWOPoO1s1copBH/H4fzz/MraPGQu0LbfhSFfKMbDvLL5k5CWN
	 UOGWDLoUhfTo1jiXrTnwslDtTUs58XuRDh3/fle7sDEHD2tDRkN3V8HT/fPE8hVWGG
	 Lh4FXDsyUSFNzPTeZCfwP3mTATbDo7SdFTqdKhZfpE95rAmTzfwUvjdWVGGUUjvLOp
	 wsiMljnBYhVuRI3OUXcxtgfjy+d3gE13gTotwJgWvSvzjLoczWjNUACCi0ujGGd3B8
	 kBNgf3q5eszz1UOFSm6zOXn0czc9SUVD8ydddzxooBjLWBL7ILMs10IjhHFVkqHttD
	 88afasBZgMM/A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57792CDB466;
	Sun, 21 Jun 2026 02:44:21 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 20 Jun 2026 21:44:21 -0500
Subject: [PATCH] crypto: virtio - bound the device-reported akcipher result
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260620-b4-disp-27caeeac-v1-1-956e8f9c4f01@proton.me>
X-B4-Tracking: v=1; b=H4sIAARQN2oC/x3MPQqAMAxA4atIZgM1aKteRRz6k2oWlRZEKN7d4
 vgN7xXInIQzzE2BxLdkOY+Krm3A7/bYGCVUAynSSpNC12OQfCEZb5mtx8GNTptJUwwBanYljvL
 8y2V93w+3juuhYgAAAA==
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Gonglei <arei.gonglei@huawei.com>
Cc: virtualization@lists.linux.dev, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782009860; l=1847;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=K5bqL5COT6HbKY+VbfoFkNOHOfOlTVi0faKIoOEwSgo=;
 b=BDix6qItkKUTJhCborvwgWf3bRJovdNnpvoxyhH7JiTwBa1C8J+VIIlIv5YFTHks9mN5rLhSz
 Ph+K3Bc3rkkDNBygB4QMIKrummLos5aw43vCFA+9v3iHmDDaUHHOj1Z
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

length

virtio_crypto_dataq_akcipher_callback() sets the result length from the
device-reported response length without bounding it to the destination
buffer, which was allocated for the original request length.
sg_copy_from_buffer() then reads that many bytes from the destination
buffer; a backend reporting a larger length over-reads adjacent kernel
heap into the caller's scatterlist (an out-of-bounds read).

Clamp the reported length to the originally requested destination length.
A conforming device reports no more than that, so valid results are
unaffected.

Fixes: a36bd0ad9fbf ("virtio-crypto: adjust dst_len at ops callback")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index d8d452cac391..64ea141f018c 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -88,7 +88,8 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
 	}
 
 	/* actual length may be less than dst buffer */
-	akcipher_req->dst_len = len - sizeof(vc_req->status);
+	akcipher_req->dst_len = min_t(unsigned int, len - sizeof(vc_req->status),
+				      akcipher_req->dst_len);
 	sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
 			    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
 	virtio_crypto_akcipher_finalize_req(vc_akcipher_req, akcipher_req, error);

---
base-commit: 1a3746ccbb0a97bed3c06ccde6b880013b1dddc1
change-id: 20260620-b4-disp-27caeeac-5b8b67962fdd

Best regards,
-- 
Bryam Vargas <hexlabsecurity@proton.me>


