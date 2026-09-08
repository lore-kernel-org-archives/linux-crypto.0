Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A4D356766;
	Tue,  8 Sep 2026 19:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788894010; cv=none; b=YEqMSfgbqLAJLOOxKJjhFSjOaV5ftf3yFyYyjdH5xSZYiYQmrLvBG/Su61t94G+BlKZSTzK3N5HUTxZFFbV/4VkTk8LztSQH37piHE7DOum2OgJSycQgk8X10vnmqa4/aj2dSlJNeZuzgRjNwYmQGwcxjKSmcNVXOMLv9jzRFh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788894010; c=relaxed/simple;
	bh=8+uza+k5pHXZ0MWaODzess7JwDpGQss7ZmEM/0YU67c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U4gCCDaD2NRPfvmeU2MCLYc/b/Accq3zXoZzj30wgqGEV19lAtDXlDaARcNc5TIVDc0mC4OIWNuFvZtN1i769T5TMCo5sjLP2mIGdc0IKCXIBGjapQXWfEFhAFXAfTmq1mSlvggb1XcUmZ4x+YubczMo2IUZFoFAPG1+mD0aRtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/cQyMPR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/cQyMPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DA21F00A3A;
	Tue,  8 Sep 2026 19:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788894009;
	bh=HFouBrDvOF7lxX1bdyzrKECZyS1XzB2v6ceuwETk4Kg=;
	h=From:To:Cc:Subject:Date;
	b=N/cQyMPRycKSXLy03V/MOuTeh9ticoR1otYyI4v1VNPuECDDaNiE/lvwOLw66QzO9
	 MSYQR6nOWjY/uAr6c49z/h/VlHo35cIp7zHDWpzs2aj5Ju9766NKEnvuepN/CuaakM
	 xTrOMM2wI8/8Gi88R+EWPuMBjhMdhk8k+ZeV13J5NcxALqmhuTFkjG2nUUK4y6MrYG
	 JxpWsnBmGDtKa1RlGkdq908lZMJSt6qKghNdXAIh89fC3Z2fW70H1SewcyuhtGLHgc
	 Hm7e9vGqGUZ+00xuiGX8AI24w5odN5DOJAoqhowRnmXeiMn/Yq+Y37ToG4F2XovWw+
	 wO0a7HXNDR63g==
From: Thorsten Blum <blum@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michal Simek <michal.simek@amd.com>,
	Harsh Jain <h.jain@amd.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: xilinx - use kfree_sensitive() in cleanup paths
Date: Tue,  8 Sep 2026 21:00:00 +0200
Message-ID: <20260908190002.403337-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1288; i=blum@kernel.org; h=from:subject; bh=8+uza+k5pHXZ0MWaODzess7JwDpGQss7ZmEM/0YU67c=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkLoo0CiyRj8rY+n699qSJvlcx8kT13lgS2nnkRdX2y6 XqlqTvWdJSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEZC8wMszkezo9ymSrMJNc M1/9rChW1YbeqfyVD+r65OoceuX9Ehj+CgRJyx/LzGpmryv5ffVQx8wZkU3i3gwW+97v9p2WuW4 dKwA=
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

In zynqmp_aes_aead_cipher() and versal_aes_aead_cipher(), replace
memzero_explicit() followed by kfree() with kfree_sensitive() to
simplify the code.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index ebee37dddb1f..d9bd6dcd23a6 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -230,10 +230,8 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	}
 
 freemem:
-	memzero_explicit(kbuf, dma_size);
-	kfree(kbuf);
-	memzero_explicit(dmabuf, sizeof(struct zynqmp_aead_hw_req) + GCM_AES_IV_SIZE);
-	kfree(dmabuf);
+	kfree_sensitive(kbuf);
+	kfree_sensitive(dmabuf);
 
 	return ret;
 }
@@ -364,11 +362,9 @@ static int versal_aes_aead_cipher(struct aead_request *req)
 	if (unlikely(dma_addr_hw_req))
 		dma_unmap_single(dev, dma_addr_hw_req, dmabuf_size, DMA_BIDIRECTIONAL);
 buf2_free:
-	memzero_explicit(dmabuf, dmabuf_size);
-	kfree(dmabuf);
+	kfree_sensitive(dmabuf);
 buf1_free:
-	memzero_explicit(kbuf, kbuf_size);
-	kfree(kbuf);
+	kfree_sensitive(kbuf);
 err:
 	return ret;
 }
