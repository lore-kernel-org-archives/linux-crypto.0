Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45FD4D8DBD;
	Mon, 28 Sep 2026 14:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790604559; cv=none; b=BD5F9i/yd2b31YhIaxGBCL+vC8CZLQlLe9+NjRz5nPQ9cvLVIbCKuHcwmGQiQMWk5vit1bhUH2HWDBJ97NaO47f+IKueGujCiAkcb17DuJojW6DNfEPzzCssgskIm8HzkIHu5/20UzhahqaBFgqqJIkUz/G5oVjvegwPPFI59HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790604559; c=relaxed/simple;
	bh=2aYzSd0Te0F1sEOZfIzbd72egCva4/9kHzntGInLvTA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=mtTO1nw6NTGTTFr7LadPF/DQgsbCE7e2VrYq7xS+iWoG3/+m2uGQN7ocnDJ65XihgR09qS9tXvTg31U9PpHNFMYBoSMJfLtI4sYEwTqqt1ZAgtW8S6rZXhozT1DTFp6mwzM7qhNS+x78mOZaAuPwMFNQzVONfZlVYwxRVvQrA2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCgLveVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCgLveVh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56A87C2BCB3;
	Mon, 28 Sep 2026 14:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790604559;
	bh=2aYzSd0Te0F1sEOZfIzbd72egCva4/9kHzntGInLvTA=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=FCgLveVhknP4y49M4Ab84aoV09MX82P8YKgzRniUWBLEKzQhJBJn+iY7UxLYDYKCi
	 JoOVWpM1izVcFLWlLrZPyYAb7KKXpW96r2Yrv09p+zzs4b5vEXeJRB9IuW8Dldgg8Y
	 xbM+9TnqLEmSuMu5p8XaSihBQ5K+s7H82S223HxnLcrOXIiv63SQ+2dJ1cJmeQCmFc
	 1Uwsi+WZnSyKcJRTh9u+VCzGrmjwxtYNNgR21fJ8w0G0iQxOQ78YW2zIQ6cRR3qpVw
	 BNhC9JqaZwK6/Uiie5O6s5hCjE6iy80thXbhnhKlbM5YyoyZ4yNVl6Vcrc1Zp1VsHT
	 aAwX7yclWSRYQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33585CA5FA5;
	Mon, 28 Sep 2026 14:09:19 +0000 (UTC)
From: Vincent Jardin via B4 Relay <devnull+vjardin.free.fr@kernel.org>
Date: Mon, 28 Sep 2026 16:09:16 +0200
Subject: [PATCH] crypto: caam/qi,qi2 - set plain_keylen for skcipher
 descriptors
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-for-upstream-caam-qi-plain-keylen-v1-1-6edb56649cf9@free.fr>
X-B4-Tracking: v=1; b=H4sIAAt1umoC/x2NwQ6CMBAFf4Xs2U1oD7T4K8ZDgYduwFK3YCSEf
 7fxMslcZg7KUEGma3WQ4iNZlljEXCrqnyE+wDIUJ1vbpm6t53FR3lJeFeHFfSh4C6c5SOQJ+4z
 IzsJ3jTFw3lHpJMUo3//jdj/PH/OaIRBzAAAA
To: =?utf-8?q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
 Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vincent Jardin <vjardin@free.fr>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790604557; l=2087;
 i=vjardin@free.fr; s=20260525; h=from:subject:message-id;
 bh=QDDTvtj++xXIso5yDNVOmdUEzAvrdil+dSqHLZL9pTY=;
 b=5putLZlLd+7hbZ9ZnG1Ls3k50acyXFDRr9A7KEm1OAwn7pwd9DHiGP8GDfNw3DHUvScB1xS4M
 X+1Hgp5PC9HApzvzZJto6dtdGBUgzIxLA9RdowDebMWf49Hw0KkJ/od
X-Developer-Key: i=vjardin@free.fr; a=ed25519;
 pk=hppgLeFpGpKOi7LNwGEZ4jOYofJCoGd4Jf1ltAabiLw=
X-Endpoint-Received: by B4 Relay for vjardin@free.fr/20260525 with
 auth_id=871
X-Original-From: Vincent Jardin <vjardin@free.fr>
Reply-To: vjardin@free.fr

From: Vincent Jardin <vjardin@free.fr>

Since the commit 66b9a095f7f9
  ("crypto: caam - Add support of paes algorithm")

The shared descriptor then loads a zero-length key and the SEC decodes
the inlined key bytes as commands.

Test: with CONFIG_CRYPTO_SELFTESTS on LX2160A every skcipher but xts fails:

  dpaa2_caam dpseci.0: 40000307: DECO: desc idx 3: Invalid LOAD Command
  alg: skcipher: ctr-aes-caam-qi2 encryption failed on test vector 0; expected_error=0, actual_error=-22, cfg="in-place (one sglist)"

caamalg_qi.c is compile-tested only.

Fixes: 66b9a095f7f9 ("crypto: caam - Add support of paes algorithm")
Signed-off-by: Vincent Jardin <vjardin@free.fr>
---
 drivers/crypto/caam/caamalg_qi.c  | 2 ++
 drivers/crypto/caam/caamalg_qi2.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index aa779caacfe5..2f2682c8bcd8 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -637,6 +637,8 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
+	ctx->cdata.plain_keylen = keylen;
+	ctx->cdata.key_cmd_opt = 0;
 
 	/* skcipher encrypt, decrypt shared descriptors */
 	cnstr_shdsc_skcipher_encap(ctx->sh_desc_enc, &ctx->cdata, ivsize,
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 6b47bcc16a50..d52706931285 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -961,6 +961,8 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
+	ctx->cdata.plain_keylen = keylen;
+	ctx->cdata.key_cmd_opt = 0;
 
 	/* skcipher_encrypt shared descriptor */
 	flc = &ctx->flc[ENCRYPT];

---
base-commit: 10396a2d6d41d594975b6ece712278570c3c970c
change-id: 20260928-for-upstream-caam-qi-plain-keylen-72e8b611e787

Best regards,
-- 
Vincent Jardin <vjardin@free.fr>


