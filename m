Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6208035E94F;
	Mon, 21 Sep 2026 06:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971144; cv=none; b=P5KSq2aCuzkPxJrswrjuCtkGEVIA5fN4ZkMXpFXB7kX6hT5hY2Bd6MuTHC0a/YkD20+n3krdWX6XN9yLRax0aBZhlS9qq+2guorv+/Yqt6Y7WwBpUJM0SU5WktwfS2h+EtdfBfKwFGM9rQ8ON+Zd3TjfutLhw+MfNBNPul3+Ah8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971144; c=relaxed/simple;
	bh=ACy+YQ3iyh2evo41tGYpz97RGCA6GMNR4R06V5hdA1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEvVLOMMAM/OOMCaIo5f8kY0hvlyuiuwR6NR31luNbCmCFcFU8nEp3THwKt+JihB6yA0Sy+xrZNXWth3XHYxk4OnthOcxzLty50mCDz3yIzFePuOC0CP6bBbCGZ2tLkEKpHXQ4I0rCeL0MsIoxbULna3B8g0cewUl9pUDcwGWRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBS4d8ME; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBS4d8ME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5AC1F00893;
	Mon, 21 Sep 2026 06:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971143;
	bh=lAJd+sOJseCSgxBjRLUvMwEPFV6rvFP5nMJebwDDBA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IBS4d8MEItAxl2iGs1lqc7W6Vex+H7QbvyxtyWI7YIGegShsVJyszRq0XtxrJUSt9
	 Er8BxnpeSIDsxV+pYpYwIaiRmzll0v5LTs8+v6pGaa502H7+SitqcqCrsBI3HyNuMM
	 RwS9uT+StQUHqx3KCpxRaNBBI6kjfaCnnzSYroD3TyHgOb4zaIigWZ16+Bv0IOH5Lt
	 MVOv8p47yMM5QA37PgA/yTJMU6wIwFlfR2Ir0pFAAQ2KYmEpBOikGxv+28RcqB+5e9
	 mb87sgI0XjJIcWkjmp0vf5GxgrdWjrnKaCVbQcZ9CTafXlIHrfiW4tkDsBvm3B8x+/
	 /9FPjPNHPDi7w==
From: Thorsten Blum <blum@kernel.org>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"David C.C.M. Gall" <david.ccm.gall@googlemail.com>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] crypto: octeontx2 - use memcpy_and_pad() in aead_hmac_init()
Date: Mon, 21 Sep 2026 08:11:24 +0200
Message-ID: <20260921061120.29694-10-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921061120.29694-6-blum@kernel.org>
References: <20260921061120.29694-6-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=881; i=blum@kernel.org; h=from:subject; bh=ACy+YQ3iyh2evo41tGYpz97RGCA6GMNR4R06V5hdA1g=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkbTq0Rm7qBbZqn5uEFJ5ZkybZ07uaVrwsQjH/dNvlp+ dXl0ipXO0pZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAi+hsZGZ4esH66TiL11TFZ 5m2Jmw4LvPwa+P3u2S0J87064uQLXj1nZOi8UX/couyUz4tn+e9f26Zc5ftxZnaaovXFb62LrG1 YExkB
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use memcpy_and_pad() instead of separate memcpy() and memset() calls to
simplify aead_hmac_init().

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
index 8d9f394d6b50..65ad29f1e47c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -882,8 +882,7 @@ static int aead_hmac_init(struct crypto_aead *cipher,
 	ipad = ctx->ipad;
 	opad = ctx->opad;
 
-	memcpy(ipad, ctx->key, authkeylen);
-	memset(ipad + authkeylen, 0, bs - authkeylen);
+	memcpy_and_pad(ipad, bs, ctx->key, authkeylen, 0);
 	memcpy(opad, ipad, bs);
 
 	for (icount = 0; icount < bs; icount++) {
