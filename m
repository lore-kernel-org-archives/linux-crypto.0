Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5337035E94F;
	Mon, 21 Sep 2026 06:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971134; cv=none; b=ZjuFepxSjizLMh41wNT6fnF4k03jhz+7fqc+zZaTxDi3ZpjTPULvBJQTm36kRJnIsNiUY1LrwxA658f+rvB8WDI1O2/Wac93xM6gX7ucaGUqKybYANtAr/d06Eef4D92eomq7Pm4vKzrCHpX5V7xqDee6g1ibf7g5NE2gH0LAKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971134; c=relaxed/simple;
	bh=h+sNQCTo/Hc5R0bACKQJMuhh/sA+vBcP2g3X9L0Ib2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYmo7I2DpJ5eMsuFfnSvzgl6iymRPDlZEFrsoe/VCtaKT1L4Cvx6ZlwOAwdx1MZ5GSRhAXCwAosXap4pHAwpPTXxjKsdKEIkyrU6PdmslC4TVxBIWgHgInEzSdaRFYd3jvxcVGFDAUQI03pI1NmGhpbKwamN9s/E7b932WMIgcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMAjv8vM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMAjv8vM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15861F00898;
	Mon, 21 Sep 2026 06:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971132;
	bh=8d8aSajBEkSCl37xD/gvNgyYlF4ktU+N0lkXEg+W1fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMAjv8vM2mDaJsflzjfBJuBLAQt8U0jHy6KOsNXKmRXJNosQTDBG64F4FwsDc4Z7H
	 KWZyCoaCfvu3pXljy5AO4AE8qvNBr5M78L+BCnWwVAB7ERLjbmzQTL8uKuS1K7oP3n
	 HvVN8d/PRDGmpo/zLf2UchKVcdJjNR8gM181hqThbxDMlU1hhbgajZo/Uf2m3tTpYV
	 Wfsrbll5YsR+z88ilrG2zVAoMiMxzLVzLtFNy7ooSC/M1XEEgMKgrFyVFZ8oalMIqb
	 B9FqTfz+YVoOJhX5Xw8dp6ZNH3yKywG3pT4W72fS/y34GY1swvaKu1Uz1UabP7DcqA
	 Dp1aFayQ2rh1A==
From: Thorsten Blum <blum@kernel.org>
To: Linus Walleij <linusw@kernel.org>,
	Imre Kaloz <kaloz@openwrt.org>,
	Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] crypto: ixp4xx - use memcpy_and_pad() in register_chain_var()
Date: Mon, 21 Sep 2026 08:11:22 +0200
Message-ID: <20260921061120.29694-8-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921061120.29694-6-blum@kernel.org>
References: <20260921061120.29694-6-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=850; i=blum@kernel.org; h=from:subject; bh=h+sNQCTo/Hc5R0bACKQJMuhh/sA+vBcP2g3X9L0Ib2o=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkbTq0wW3fgkt/vSrd731oUl23SNDp48e4XS33WZdq/r ktfeHTyUEcpC4MYF4OsmCLLg1k/ZviW1lRuMonYCTOHlQlkCAMXpwBMRDuJ4b8ny8LfKRWxB7Yp 2mS/m58cosG58lOXlt73ULtCbbEI20mMDMfzzU+4fGnk+Lg+iGNPrsCuWosDb89XPNqw/PwHvQ/ lZzkA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use memcpy_and_pad() instead of separate memcpy() and memset() calls to
simplify register_chain_var().

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
index fdda04672454..33e8e887a415 100644
--- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
+++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
@@ -707,8 +707,7 @@ static int register_chain_var(struct crypto_tfm *tfm, u8 xpad, u32 target,
 		return -EAGAIN;
 	}
 
-	memcpy(pad, key, key_len);
-	memset(pad + key_len, 0, HMAC_PAD_BLOCKLEN - key_len);
+	memcpy_and_pad(pad, HMAC_PAD_BLOCKLEN, key, key_len, 0);
 	for (i = 0; i < HMAC_PAD_BLOCKLEN; i++)
 		pad[i] ^= xpad;
 
