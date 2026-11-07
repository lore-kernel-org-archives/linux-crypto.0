Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794055187;
	b=u0IKsa8ifC+0z2uFnV3Qi32S34raRX7PgYLN3CELrt6Z4wpileDgGvg6m/MZZGIi395B
	 hubTQZdx75a4cp+eAeQQFyVmv8dgE45rCCauDxX0NrxfWSfEypaWPk/6VuxxHI1fEM5op
	 fBFq76mJO2iVT2ACZxu0Zpe7ozUdiZb/23XjR/paoRPvVi50FKSm1HBrgkxN5o9hcmASG
	 bN+QDvTMEUPlUaeNrC4cTcrtFAgcNjvouvPOc8ANuDr6sYfgznAA5WFI/CnpMfJfWxUdH
	 XGzFiBbWGb4wHODcjEmfAiOhUMslWt1601q8fuRercq2jNdroYIIIvdSIjEIJqb50fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794055187;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=MtZkoKUjowTG2Upsi1vq8iBJI9ISeGB6pNGvPLOId3M=;
	b=i+L9m9nNTdsGpi2RQktLs5saAjGCzN73q/rrCIsQmQFZ3wYAp9Q017WHY94UBIE05tDV
	 +dsVMizPfhpe/QKG6Iz0iATxGc3KEIKUyPhNvf9EIZzDGdX2rVcktW3VVz7bMyCCg0lA1
	 zUIdZT7eoliOWsUodQJJiUoycP9xy5Mloa5pfi2UQrG81CHLJmnTJTELO4dmDgR0y0cOv
	 gzSHwnTZeetIlXVqS7xb1ppsW8LSZYZQQR4QdKm6olH6TlNykAFojulvSjolzZ2rTeh+/
	 TH6DhZ0z1NntFjkoyCrbRf/ESUHQg3G9RZIxOPPit28kpmZKTPhCMisPaxl2ZRpIhQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CjhW8Wmb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BD0606A32C;
	Sat,  7 Nov 2026 12:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CjhW8Wmb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC0D1F0089F;
	Sat,  7 Nov 2026 12:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055186;
	bh=MtZkoKUjowTG2Upsi1vq8iBJI9ISeGB6pNGvPLOId3M=;
	h=From:Date:Subject:To:Cc;
	b=CjhW8Wmb0boCh1WJST1slzCVLToBYih13WYsAgLLCpeNLO+FUvuQBNYRAAggVPISu
	 7sS/gM+JIsfasPuXGvBQcrRMgGFR//ayTrGbSrKUeL1s3AYTNV651QD40DECNpu3gU
	 GJjSMd6R3QjlqBboryxcJS8p95wyM7Cd7jGH7wkhtrfc6g44nM/jUyE/AHoyJTnEn4
	 2wDhJwORRWuSq6mxzsLHgxC9emWOoYewJ4G/KHFE5sQ+eLb1oq10dd45CCp14BqWiK
	 S4HPeKRRYo0C+Jq7BoInQ2BnLdX9+r1vbCmDuwE8nMedPu6zvLUP3bH/637kc9tErK
	 o1d+BffcdDHYQ==
From: Joshua Crofts <crofts@kernel.org>
Date: Sat, 07 Nov 2026 13:39:43 +0100
Subject: [PATCH] crypto: omap-sham: remove redundant
 pm_runtime_dont_use_autosuspend() calls
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-crypto-dont-use-autosuspend-removal-v1-1-62696ad3ff0e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3NQQ6CMBBA0auQWTsJLQrqVYiLQgdtop1mpiUSw
 t1tXL7N/zsoSSCFe7OD0Bo0cKwwpwbml4tPwuCrwba2N6YdcJYtZUbPMWNRQlcya9FE0aPQh1f
 3xs4uV385d7dh6qGWktASvv/L+DiOHzCy6ht1AAAA
X-Change-ID: 20261107-crypto-dont-use-autosuspend-removal-32f8d54397b6
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Joshua Crofts <crofts@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794055185; l=1297;
 i=crofts@kernel.org; s=20261015; h=from:subject:message-id;
 bh=DZSdqhiD5oCGCq66lcad98q7o8oDJxYQC9Z6fM9UOfw=;
 b=CBN8az44Z0BR6sKeQ1S2sZLSTtJOwDrLIsN8gaWeor6BtJhNgmFcGtO7ZChG9fotcYUFchz2c
 7hb9tChgs6CA+iu1hEjt3tYOw/0tO8sHJ7ELkBle7Sgzkzx/bHHqlHu
X-Developer-Key: i=crofts@kernel.org; a=ed25519;
 pk=RTDOoVwgeL4oFdASj9U+cxJuIjXuXk73zkjnGOJKbEo=

Since commit d1706f9da9f4 ("PM: runtime: call pm_runtime_dont_use_autosuspend() on reinit()"),
driver core is now responsible for undoing any
pm_runtime_use_autosuspend() calls on driver exit.

Remove the redundant function calls.

Signed-off-by: Joshua Crofts <crofts@kernel.org>
---
 drivers/crypto/omap-sham.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 5e739415a010..72182f190084 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2109,7 +2109,6 @@ static int omap_sham_probe(struct platform_device *pdev)
 	list_del(&dd->list);
 	spin_unlock_bh(&sham.lock);
 err_pm:
-	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_disable(dev);
 	if (!dd->polling_mode)
 		dma_release_channel(dd->dma_lch);
@@ -2131,7 +2130,6 @@ static void omap_sham_remove(struct platform_device *pdev)
 	omap_sham_unregister_algs(dd->pdata);
 	crypto_engine_exit(dd->engine);
 	cancel_work_sync(&dd->done_task);
-	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	if (!dd->polling_mode)

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261107-crypto-dont-use-autosuspend-removal-32f8d54397b6

Best regards,
-- 
Joshua Crofts

