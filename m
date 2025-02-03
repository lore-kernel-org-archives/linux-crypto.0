Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [176.9.242.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154F01D5176
	for <linux-crypto@vger.kernel.org>; Mon,  3 Feb 2025 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.242.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738590541; cv=none; b=u6WZLUqFQhNZAJJV4l04btH6cV2dNfL0XN/e1sVgM2Acz3TBhgJmMDYgom4MetZ3d3ugeNkQcXrLev+ulATsXMxq7S1g8Z1r9IcWp4gztAC/f3bbkBVyTObyWk4OMm5w4eclbau4N4l5zwXJZsUGr8KONFJHHKamxYSCR94V09w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738590541; c=relaxed/simple;
	bh=7Yj9Nkm7KcLp91tQFPdDp+Sb6/ZXbAJR5+Vf2prQEnc=;
	h=Message-ID:In-Reply-To:References:From:Date:Subject:To:Cc; b=rlx8aZIjVDcQJkv/6YQgkKsccUkMRqci+LrraMAsaS6F9S2JGkO+k1ecaaenIMoA4sEAG0j3rIptS7k5KXm2p3EZb7RD1qXCamVn3IPT6ghOxmHoSNLZvocRSiJFbc2Pt2jPGA6LFJqqGX+RwzDEdW6hyFSPpq3cSKYMTt3s0j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=176.9.242.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id DF915101E6A40;
	Mon,  3 Feb 2025 14:48:57 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by h08.hostsharing.net (Postfix) with ESMTPSA id A6CBB6087DD7;
	Mon,  3 Feb 2025 14:48:57 +0100 (CET)
X-Mailbox-Line: From b71a77500027637d7a20c77823709d010416ef2c Mon Sep 17 00:00:00 2001
Message-ID: <b71a77500027637d7a20c77823709d010416ef2c.1738562694.git.lukas@wunner.de>
In-Reply-To: <cover.1738562694.git.lukas@wunner.de>
References: <cover.1738562694.git.lukas@wunner.de>
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 3 Feb 2025 14:37:03 +0100
Subject: [PATCH 3/5] crypto: virtio - Drop superfluous ctx->tfm backpointer
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Gonglei <arei.gonglei@huawei.com>
Cc: zhenwei pi <pizhenwei@bytedance.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio Perez <eperezma@redhat.com>, linux-crypto@vger.kernel.org, virtualization@lists.linux.dev
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

struct virtio_crypto_[as]kcipher_ctx contains a backpointer to struct
crypto_[as]kcipher which is superfluous in two ways:

First, it's not used anywhere.  Second, the context is embedded into
struct crypto_tfm, so one could just use container_of() to get from the
context to crypto_tfm and from there to crypto_[as]kcipher.

Drop the superfluous backpointer.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 5 -----
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 4 ----
 2 files changed, 9 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index 7fdf32c79909..aa8255786d6c 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -26,7 +26,6 @@ struct virtio_crypto_rsa_ctx {
 
 struct virtio_crypto_akcipher_ctx {
 	struct virtio_crypto *vcrypto;
-	struct crypto_akcipher *tfm;
 	bool session_valid;
 	__u64 session_id;
 	union {
@@ -447,10 +446,6 @@ static unsigned int virtio_crypto_rsa_max_size(struct crypto_akcipher *tfm)
 
 static int virtio_crypto_rsa_init_tfm(struct crypto_akcipher *tfm)
 {
-	struct virtio_crypto_akcipher_ctx *ctx = akcipher_tfm_ctx(tfm);
-
-	ctx->tfm = tfm;
-
 	akcipher_set_reqsize(tfm,
 			     sizeof(struct virtio_crypto_akcipher_request));
 
diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index 23c41d87d835..495fc655a51c 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -17,7 +17,6 @@
 
 struct virtio_crypto_skcipher_ctx {
 	struct virtio_crypto *vcrypto;
-	struct crypto_skcipher *tfm;
 
 	struct virtio_crypto_sym_session_info enc_sess_info;
 	struct virtio_crypto_sym_session_info dec_sess_info;
@@ -515,10 +514,7 @@ static int virtio_crypto_skcipher_decrypt(struct skcipher_request *req)
 
 static int virtio_crypto_skcipher_init(struct crypto_skcipher *tfm)
 {
-	struct virtio_crypto_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct virtio_crypto_sym_request));
-	ctx->tfm = tfm;
 
 	return 0;
 }
-- 
2.43.0

