Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793724653;
	b=xp0lMB0BkZJ3lQLV2tUXNzzyHPsI+CCSXH6cB0L9bAyZ/nmRQgxTasHTR+Gc5OlUwtd4
	 hJIUwtNsidg5V+ZDnAXE2bAvasAmuIsGrD8qDlHdGTKKhc94vhG1uuDDc9Dg7C+fqmKLB
	 a0rHIvJCJ096OIKx58mz1ydswDUQ48EpIUoaNZi2/9veMIukUsbWOS9v6a0CE/1p4AB1D
	 F7JOCFe1gKkUUQ9h9A3UwOpjvs8LJTVd+tvD7u3SN3PfJcPENqCRJ6VUMkzQ55+//5KRt
	 ZSNPQ03zih9zMPzWEyh6SB1Klrcl7MxQYpIF2pE2VPYQR+Lv4+D8NepdmawbQOHGwLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=T0MdgYHzsRH4kxPjwor1jkXEA0NefoPgKMh7fjMX4d4=;
	b=xfd0XMDItw9StHPe1WYFYHc7WS5CUnUm0W+3mjgSp9wN71ft7uoxWUV5V9wy149WC7Go
	 8dNJkYBncnch0i3CklIsjXVwhaZEBTnku6MkL4St2ENnWbjHphfUZaKG9Lv1I9AsAjLiO
	 ehUZ8KKowsXuexKL6hA5JikhMS7D5MNVEADYs85ZDvPLZId3YPX1i3n2wPV0FEtqxgoUc
	 V5sAmTePPP81rviP5voQEiWF3hQB5i/lGs0qz7uzY/E+FpCZHlPoWPTpa5TKCd7ETYZLm
	 VokEn6zuOG0gUF7rEslHaGL5mawVK1iKkcaDE8r8jcgwIN5Q/7x6iMTvvMPBM9WS2og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IyTZvUeK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2066A606A328;
	Tue,  3 Nov 2026 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IyTZvUeK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2331F000C1;
	Tue,  3 Nov 2026 16:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793724652;
	bh=T0MdgYHzsRH4kxPjwor1jkXEA0NefoPgKMh7fjMX4d4=;
	h=From:To:Cc:Subject:Date;
	b=IyTZvUeKSC3i87pXakCT8ZcKslktZD0HoBXth1o2d8yAPiWnKQGPPAPbFI9Pln4UU
	 ZcsNKAD+2HEoXihjb+n8+hbqSuWa2u1YQTCU6gLx2t3QSvFKBYmfb4ML3uiJ1IewPF
	 Z6reVvqJgJBBgYVjK7yeu8T/Z0PqX3xOoXTrcWtZV7xTOz0AiSlnmMAp//lrEGhpdW
	 nzBrVU8NFsiz8fUxNoBRomkgHyHnsf85/MqTQt4RvUfKg3YPBFQe2iQ0bEB+ob6sIg
	 rN1N/e+/HJ6TEEWS9Q7vdV53CO++IHfrImS9B93aXrexBnrJSFnLw0xHKi31GJHtj6
	 QfaTz5FI3eqsw==
From: Thorsten Blum <blum@kernel.org>
To: Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thorsten Blum <blum@kernel.org>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] hwrng: virtio - simplify probe_common()
Date: Tue,  3 Nov 2026 17:50:27 +0100
Message-ID: <20261103165026.454333-3-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1756; i=blum@kernel.org; h=from:subject; bh=7vAcmwTXoMnz/TTSwXkQj85HnUd4ygQ3LK8TaMQgFGc=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmvBC59n3bzVue7p6YtFz4pBn6WmuJ7k7Exic8tLG258 XfjwqLqjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZiI6SGG32yXTAL8sl/qnWDf 0rV5ftdBnZtKi7e7urM9uzJ3XpzqigCGf5qCB2pX8f5munZsKutuZr84tzOHDnVbKS9LPdVhoMH 1hAcA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Drop the redundant NULL initialization since vi is immediately
reassigned. Drop the redundant index variable and use vi->index
directly. Also call ida_free() directly and consolidate the error
cleanup paths.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 45d87c0614a5..f5e8e6093e27 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -150,17 +150,17 @@ static void virtio_cleanup(struct hwrng *rng)
 
 static int probe_common(struct virtio_device *vdev)
 {
-	int err, index;
-	struct virtrng_info *vi = NULL;
+	int err;
+	struct virtrng_info *vi;
 
 	vi = kzalloc_obj(struct virtrng_info);
 	if (!vi)
 		return -ENOMEM;
 
-	vi->index = index = ida_alloc(&rng_index_ida, GFP_KERNEL);
-	if (index < 0) {
-		err = index;
-		goto err_ida;
+	vi->index = ida_alloc(&rng_index_ida, GFP_KERNEL);
+	if (vi->index < 0) {
+		err = vi->index;
+		goto err;
 	}
 	snprintf(vi->name, sizeof(vi->name), "virtio_rng.%d", vi->index);
 	init_completion(&vi->have_data);
@@ -177,7 +177,8 @@ static int probe_common(struct virtio_device *vdev)
 	vi->vq = virtio_find_single_vq(vdev, random_recv_done, "input");
 	if (IS_ERR(vi->vq)) {
 		err = PTR_ERR(vi->vq);
-		goto err_find;
+		ida_free(&rng_index_ida, vi->index);
+		goto err;
 	}
 
 	virtio_device_ready(vdev);
@@ -187,9 +188,7 @@ static int probe_common(struct virtio_device *vdev)
 
 	return 0;
 
-err_find:
-	ida_free(&rng_index_ida, index);
-err_ida:
+err:
 	vdev->priv = NULL;
 	kfree(vi);
 	return err;
