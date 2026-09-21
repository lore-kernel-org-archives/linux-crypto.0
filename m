Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37880331ED7;
	Mon, 21 Sep 2026 06:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971141; cv=none; b=EpSoltGXq42gmF3vrPAWf30YpIvrA3FLJ0Hd4kgsWVBa8BzueUctTpexquZctE78zMYUgWrAECkbO/V998FR5C7a1zFvg/G3h4b2JnQsgECsueFJ0VGOcHYCG75e0bOC4jzdG/s5+8nRv5mcsnVC/LBlzOkQKykvEy0gBtDW9Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971141; c=relaxed/simple;
	bh=2DoxzO+Uy0etZ3tZFD7fEgIeTx4jvqwUY8nGVXBZ/IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecYZBuuJrJ7nLFydBJvR2qk1m8NMlV+sp9qC3kwFQQvz9XY1grwPdPvj879dYz8fL/GdanxYiPoADNEbnYpItQyC/2qCGSqtOYkuwMEdszAKifWC5pLGl4t7qz4lyj3VaGH2zbNNg9bO1PrrNZP/xUTUgOWtY4Ak6YRIJpgEXNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qf1DYPkF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qf1DYPkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1531F0089A;
	Mon, 21 Sep 2026 06:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971137;
	bh=tGJjuB5FDt1K9AIeWq4wz0SBtVqBiDA3HJZunxdV8JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qf1DYPkFzruR4m+iWs+K3Pun64bbxCd/HwXpn3m3/6MY5Mwv7eNbZy+8rcpnFoqR4
	 +b1IhJh1zu9TMpLv05R8kEmYnouWaAFBKK1OhOBPLv7jRiMq7sOho3XW8Jg0vwMwiN
	 GKqPmpI8tqqqoPq0wsHMAwnO+oko+6k/+HH7n/Hkkbr0En296Fgflv5Yb5j3gkB0oK
	 lZ+0Wp1eeJJPG+2+wOu0YYlAVkmB7ABusOnS2/PcMYEFm4U0YLfo2nwQba9rqjOMKC
	 0wY79EQW0Xs71b2+mM+hR0Kl60xt6+m/OmmA2UtjjeSyCX1LM28GZ7UYFH0V0X4uCI
	 bBTvI1QkduaCw==
From: Thorsten Blum <blum@kernel.org>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"David C.C.M. Gall" <david.ccm.gall@googlemail.com>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] crypto: octeontx - use memcpy_and_pad() in aead_hmac_init()
Date: Mon, 21 Sep 2026 08:11:23 +0200
Message-ID: <20260921061120.29694-9-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921061120.29694-6-blum@kernel.org>
References: <20260921061120.29694-6-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=871; i=blum@kernel.org; h=from:subject; bh=2DoxzO+Uy0etZ3tZFD7fEgIeTx4jvqwUY8nGVXBZ/IY=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkbTq26MS9WPL2HudX1/ZTwW7ejHi+6EPDPZ9Gtf05rF M4+SYyM6ShlYRDjYpAVU2R5MOvHDN/SmspNJhE7YeawMoEMYeDiFICJnI9kZDgSuOGPQotQ2fJy 8exSi1sGN2LN5zb9PcX/M3W5VXHqnQyGf5pvBUID92btLEqT+5W08emNmRMrz8qkceX8VInrm5f 5jwMA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use memcpy_and_pad() instead of separate memcpy() and memset() calls to
simplify aead_hmac_init().

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index 096be42e9d03..1becaf77b10c 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -792,8 +792,7 @@ static int aead_hmac_init(struct crypto_aead *cipher,
 	ipad = ctx->ipad;
 	opad = ctx->opad;
 
-	memcpy(ipad, ctx->key, authkeylen);
-	memset(ipad + authkeylen, 0, bs - authkeylen);
+	memcpy_and_pad(ipad, bs, ctx->key, authkeylen, 0);
 	memcpy(opad, ipad, bs);
 
 	for (icount = 0; icount < bs; icount++) {
