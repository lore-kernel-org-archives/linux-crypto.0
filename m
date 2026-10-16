Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BD838B14B;
	Fri, 16 Oct 2026 10:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792147044; cv=none; b=D7A85CYQlLxnXqmALAH5dq3i3qFkSOLdaUoVf9B/ml9lHhy12JKbLzS0MP+z3Iag7Ug6H/lFPab/9EMWnoOqs1bfkNUYXp78iMMQgJH1FhLv5JBPK9oRiU1Xz8qTYA1oN8W0hFVBfu8eO+1oUpO3jikc8fo2BCI8e3b3kwH2+10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792147044; c=relaxed/simple;
	bh=U/zsYIFNWot17p0deMnHXJr6Q80A3cLi1A4erXmjbes=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hvpR+z28Ukwpenf35Pq56s7G3rOCD799uD85quucYTkWd53rVNY7FnsSCWzVb1k7Hn0HtTA5+xzit4rzlFL+712bWPHWWcBF61dcQr3ID8Vgp13g6isjv7cZ6Z3tsXz9oJVyrgrTlmxToC4MJRtZz9yFHPkQfbl3ueMJ88lzNEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bsgNZvBV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bsgNZvBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC161F000C4;
	Fri, 16 Oct 2026 10:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792147043;
	bh=1Dg/1ir7HT06b/ZEkKFmtVaUrGgv3eZCS+P11wu3YQs=;
	h=From:To:Cc:Subject:Date;
	b=bsgNZvBVdvFx2rgzJQ/Y8pPq1HMiH1zOwt4f3l9IYIxomLVFfh9KFJxX03WeIWb5V
	 a9nR+Fo5jdmHVJDfQPy58fUdIhSUMmAO/aNKKBnWmabWUTF1IcO/XGri1xTpntdTzf
	 oMkFWHwpDO4yS4YM7spHxQ1c6VPi3tIK7zYKnccEyuZJSkw0XGKJ1Ov9DMju/gXAge
	 VXYalYVyPhDatbpwOFe3lcI5EWyHkz45CPjxA9Z9k/evFqjx1vw9fss2B3MEz2xl9Y
	 f9RMHBZvOd2KUkJ78S4wOAolpS4oRwlMJjbqdLh9WdDr5e05bZOjOBZezBNGYVHyKa
	 ahe+XLVXFX5fA==
From: Thorsten Blum <blum@kernel.org>
To: Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Amos Kong <akong@redhat.com>
Cc: Thorsten Blum <blum@kernel.org>,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: virtio - prevent use-after-free after a failed restore
Date: Fri, 16 Oct 2026 12:36:40 +0200
Message-ID: <20261016103640.4989-2-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1605; i=blum@kernel.org; h=from:subject; bh=U/zsYIFNWot17p0deMnHXJr6Q80A3cLi1A4erXmjbes=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkX/1kcV+s7verCVMM0Lf7SW4fUZ4pHvFx3aXPJBOMYk atnD2TydJSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEQj8wMvxZ1VBeajXf/7nE nMi4T3a16zjv3NiTy7AtPoupKrp29w5Ghv5zWpZxq7WTynPMJY+X+zxZYHXq+Sfh3nvGJXHGPWf zWQA=
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

remove_common() frees the driver data during freeze, but does not clear
vdev->priv, which points to freed memory. If probe_common() then fails
during restore, a later remove or freeze can dereference the dangling
pointer.

Clear vdev->priv on the probe_common() error cleanup path and before
freeing the driver data in remove_common(). Also reset the device and
return early from remove_common() if vdev->priv is already NULL for a
safe teardown after a failed restore.

Fixes: 08e53fbdb85c ("virtio-rng: support multiple virtio-rng devices")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 5e83ffa105e4..a9ff520975a7 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -190,6 +190,7 @@ static int probe_common(struct virtio_device *vdev)
 err_find:
 	ida_free(&rng_index_ida, index);
 err_ida:
+	vdev->priv = NULL;
 	kfree(vi);
 	return err;
 }
@@ -198,6 +199,11 @@ static void remove_common(struct virtio_device *vdev)
 {
 	struct virtrng_info *vi = vdev->priv;
 
+	if (!vi) {
+		virtio_reset_device(vdev);
+		return;
+	}
+
 	vi->hwrng_removed = true;
 	vi->data_avail = 0;
 	vi->data_idx = 0;
@@ -207,6 +213,7 @@ static void remove_common(struct virtio_device *vdev)
 	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
 	ida_free(&rng_index_ida, vi->index);
+	vdev->priv = NULL;
 	kfree(vi);
 }
 
