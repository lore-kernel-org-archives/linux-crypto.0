Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694C5457E4E;
	Tue, 29 Sep 2026 20:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790713750; cv=none; b=APT5apFh/1EfvQ09Ko36K1ZL05t9P4kFmbZCZqjIgF9HiKdTJAfm5H6gRsNxsKcv+MP2+ZYnfmrUJ4R6h6+mrK1qgZSNVZl258o/MQAtXhEdh6Wq8WYUEpTfVX8Y3vq0Agba4U89YB7LgiaBxx7ET3Oatq6+F9qYNatEDt7NYwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790713750; c=relaxed/simple;
	bh=SyXMYews0Mx8ucqGclKc74ANNPUn6Hx8qatCb5mwCUo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Fg4lzaR3D3nQC/oTA5xyUFMG3YiFCcQdH8l80A3UktLfb0ShMjOhZyJRo4D17aF9cP9uT8Eh0yCeJB3E4O9Wsd7xmIqTD2z0QKrmTO7Mj4tqHi5JUxEpyjUkBt+5KEKywr6qoVtmyjhZDmQa83ms76QZvGquiNLvEX+2asX95pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XGd/wmLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XGd/wmLz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6F27C4AF0B;
	Tue, 29 Sep 2026 20:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790713750;
	bh=SyXMYews0Mx8ucqGclKc74ANNPUn6Hx8qatCb5mwCUo=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=XGd/wmLzKKNgBMF8QvKA9cMklr5SBRtyYdHrZWeX0vXP2HxzRkTtPYGcUbMOF3/LU
	 KrbUmze3g81zLjXIJ+O23WVp0oYU23xz2M4HpqC79DpzpigjbqY7rtd0NYwzHjPGky
	 lxQN46vfdRM4rNHDszt6N6eUleIEYr/dUlCSA/NxbhEUohHdgIv/gtecN92Wo0feTX
	 pvB7ilcA6SjXAn33tTqrqEQRAgV9rJjke4AQ1g+I8IBqy/RK8V1uTFO+hwOZr8qhg3
	 8uK0I7/s2clyj84T7hUpu6YU+jxuRwpMHhNDWDq6YWkafVy0/XRhpBx2+R7zP23yKg
	 TOTk95iSzZVpw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C93CA5FAC;
	Tue, 29 Sep 2026 20:29:09 +0000 (UTC)
From: Vincent Jardin via B4 Relay <devnull+vjardin.free.fr@kernel.org>
Date: Tue, 29 Sep 2026 22:29:04 +0200
Subject: [PATCH v2] crypto: caam/qi2 - lower the algorithm priority
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-for-upstream-caam-qi2-priority-v2-1-bf0559ebf574@free.fr>
X-B4-Tracking: v=1; b=H4sIAI8fvGoC/42NQQ6CMBBFr0Jm7Zi2KKIr72FYtGUqs5DCFImEc
 HcrJ3Dzk/cX762QSJgS3IoVhGZOHPsM5lCA72z/JOQ2MxhlKnU1NYYo+B7SJGRf6G2ekQ0OwlF
 4WvBSlUq7mlxpK8iSQSjwZw88mswdpynKsvdm/Xv/Vs8aFdLJ1nQOSrfO34MQHYNAs23bF5JcH
 UTKAAAA
To: =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, 
 Sahil Malhotra <sahil.malhotra@nxp.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Gaurav Jain <gaurav.jain@nxp.com>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vincent Jardin <vjardin@free.fr>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790713748; l=1690;
 i=vjardin@free.fr; s=20260525; h=from:subject:message-id;
 bh=v2jbJT9sn3iczfB+b+TBO4PuJmCjQ6+uYBnlDjvWIVA=;
 b=oJ93oGUfFGXWLM3SIPI1o1aNpDaGvy2MEtcxuQjfNTM5ZgAl1XZzlfffYVvkcEzLnkVAIMBiH
 JWlG4FVetQMBDmsw/NCUXgxtFhAeIdaaD+X6QMQ22MbKz2Cupo9C1kr
X-Developer-Key: i=vjardin@free.fr; a=ed25519;
 pk=hppgLeFpGpKOi7LNwGEZ4jOYofJCoGd4Jf1ltAabiLw=
X-Endpoint-Received: by B4 Relay for vjardin@free.fr/20260525 with
 auth_id=871
X-Original-From: Vincent Jardin <vjardin@free.fr>
Reply-To: vjardin@free.fr

From: Vincent Jardin <vjardin@free.fr>

Lower the priority to 100, as done for QAT in commit
  8024774190a5 ("crypto: qat - lower priority for skcipher and aead algorithms").

The SEC stays reachable by driver name, and user space can raise its
priority through the crypto_user interface.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Link: https://lore.kernel.org/r/aruvJECCDNdguMdw@gondor.apana.org.au
Signed-off-by: Vincent Jardin <vjardin@free.fr>
---
v2 lowers the priority to 100, as was done for QAT, and leaves the
choice to user space through crypto_user.
---
Changes in v2:
- Drop both the dpaa2_caam.priority module parameter and the
  fsl,qi2-crypto-priority DT property
- Lower the default priority to 100, user space adjust it with
  crypto_user (Herbert).
- No policy in the device tree (Krzysztof, Eric).
- Link to v1: https://lore.kernel.org/r/20260928-for-upstream-caam-qi2-priority-v1-0-e4a8e5f01dbc@free.fr
---
 drivers/crypto/caam/caamalg_qi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 6b47bcc16a50..d3cb2bd5c41d 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -26,7 +26,7 @@
 #include <crypto/xts.h>
 #include <linux/unaligned.h>
 
-#define CAAM_CRA_PRIORITY	2000
+#define CAAM_CRA_PRIORITY	100
 
 /* max key is sum of AES_MAX_KEY_SIZE, max split key size */
 #define CAAM_MAX_KEY_SIZE	(AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE + \

---
base-commit: 67aefeccc4101a93627f36abbd049f191b54f903
change-id: 20260928-for-upstream-caam-qi2-priority-76301b8eb3a6

Best regards,
-- 
Vincent Jardin <vjardin@free.fr>


