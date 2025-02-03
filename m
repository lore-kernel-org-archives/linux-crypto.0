Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5201F1E87B
	for <linux-crypto@vger.kernel.org>; Mon,  3 Feb 2025 13:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738590003; cv=none; b=tJTf1TmWgDLcohRaN/eux+WjjaP9Yhq0V/uzqKrFjndZ9lF0K5e4Nqy0d+loR1JRn+XwMT0y61SbnbPC1ueEtnZDw1AMGmqPFUlw7uZHgu8f29l8P/gsZTqNK3MU5RfK6MM27V8srv2dcPoOh14sZHRSYHaBe9B81sJxxJ+AdQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738590003; c=relaxed/simple;
	bh=oVqWY7Tted2qyDFxXmx89UKxolO8UUWaXot3x7Fn5qQ=;
	h=Message-ID:From:Date:Subject:To:Cc; b=DoY4YWPVkZI/oYPF63KrQBsqNv/eFtFpa4sCwrEKF7OKOqVTZGW+6xUx0pValmnsRsDsIgMcgw2rxpsq0brG/vswllZxvwlhQkfjLTvKzwzN/Rm1NyHJ8b6yugl620P/kLGTmtlWOGiIorDT3IJfIawYNm54fN0ajDGh7tVoe4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id 293A710192649;
	Mon,  3 Feb 2025 14:39:58 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by h08.hostsharing.net (Postfix) with ESMTPSA id F00896068241;
	Mon,  3 Feb 2025 14:39:57 +0100 (CET)
X-Mailbox-Line: From c59352d994d01f23d364632efec0a7fea70c4503 Mon Sep 17 00:00:00 2001
Message-ID: <cover.1738562694.git.lukas@wunner.de>
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 3 Feb 2025 14:37:00 +0100
Subject: [PATCH 0/5] crypto virtio cleanups
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Gonglei <arei.gonglei@huawei.com>
Cc: zhenwei pi <pizhenwei@bytedance.com>, lei he <helei.sig11@bytedance.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio Perez <eperezma@redhat.com>, linux-crypto@vger.kernel.org, virtualization@lists.linux.dev
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Here's an assortment of trivial crypto virtio cleanups
which I accumulated while working on commit 5b553e06b321
("crypto: virtio - Drop sign/verify operations").

I've used qemu + libgcrypt backend to ascertain that all
boot-time crypto selftests still pass after these changes.
I've also verified that a KEYCTL_PKEY_ENCRYPT operation
using virtio-pkcs1-rsa produces correct output.

Thanks!

Lukas Wunner (5):
  crypto: virtio - Fix kernel-doc of virtcrypto_dev_stop()
  crypto: virtio - Simplify RSA key size caching
  crypto: virtio - Drop superfluous ctx->tfm backpointer
  crypto: virtio - Drop superfluous [as]kcipher_ctx pointer
  crypto: virtio - Drop superfluous [as]kcipher_req pointer

 .../virtio/virtio_crypto_akcipher_algs.c      | 41 ++++++++-----------
 drivers/crypto/virtio/virtio_crypto_mgr.c     |  2 +-
 .../virtio/virtio_crypto_skcipher_algs.c      | 17 ++------
 3 files changed, 21 insertions(+), 39 deletions(-)

-- 
2.43.0

