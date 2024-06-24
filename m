Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AFD91A2C1C;
	Mon, 24 Jun 2024 23:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719271384; cv=none; b=A5L194EiY0hpGSR+Hv9XDyi7/oAViINGqGveHKh0Emd8leXdnCh6zHKqEFZrjSFE6sWpnwkWnv3GmCGUvyRsH43VhdQBEsvSVJjFQmZwz108tgIYJHzA6WmbnptWYenfYNngZtLqQ5Aky/g8vmIaa2SgKrgWfYAGyC7tt0pvLbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719271384; c=relaxed/simple;
	bh=2dYzk+Vphu9QcyP6sHBUGi650SCMFm21mzEIEJP+Rz8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c1GbqAWOluyprFPoxbOn48Rh7NtILK6vtirpTI1fl/2whw9/fBiFQwsIMHIzR2nbsGyf5IT/jjldeOI5s+HqvgoDm3NClqmBU8levCbXOPY5uP4Ja5VOLMY+XpRM1ZBIT6fZhRiZYIa4+fuCjxK1YaoJnoMaApb7iK5sbr243Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25D66339;
	Mon, 24 Jun 2024 16:23:27 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44D803F766;
	Mon, 24 Jun 2024 16:23:00 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Ryan Walklin <ryan@testtoast.com>,
	Philippe Simons <simons.philippe@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	devicetree@vger.kernel.org
Subject: [PATCH v2 3/4] crypto: sun8i-ce - add Allwinner H616 support
Date: Tue, 25 Jun 2024 00:21:09 +0100
Message-Id: <20240624232110.9817-4-andre.przywara@arm.com>
X-Mailer: git-send-email 2.39.4
In-Reply-To: <20240624232110.9817-1-andre.przywara@arm.com>
References: <20240624232110.9817-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The crypto engine in the Allwinner H616 is very similar to the H6, but
needs the base address for the task descriptor and the addresses within
it to be expressed in words, not in bytes.

Add a new variant struct entry for the H616, and set the new flag to
mark the use of 34 bit addresses. Also the internal 32K oscillator is
required for TRNG operation, so specify all four clocks.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Tested-by: Ryan Walklin <ryan@testtoast.com>
Tested-by: Philippe Simons <simons.philippe@gmail.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 6d45c1e559f7d..e55e58e164db3 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -92,6 +92,30 @@ static const struct ce_variant ce_h6_variant = {
 	.trng = CE_ALG_TRNG_V2,
 };
 
+static const struct ce_variant ce_h616_variant = {
+	.alg_cipher = { CE_ALG_AES, CE_ALG_DES, CE_ALG_3DES,
+	},
+	.alg_hash = { CE_ALG_MD5, CE_ALG_SHA1, CE_ALG_SHA224, CE_ALG_SHA256,
+		CE_ALG_SHA384, CE_ALG_SHA512
+	},
+	.op_mode = { CE_OP_ECB, CE_OP_CBC
+	},
+	.cipher_t_dlen_in_bytes = true,
+	.hash_t_dlen_in_bits = true,
+	.prng_t_dlen_in_bytes = true,
+	.trng_t_dlen_in_bytes = true,
+	.needs_word_addresses = true,
+	.ce_clks = {
+		{ "bus", 0, 200000000 },
+		{ "mod", 300000000, 0 },
+		{ "ram", 0, 400000000 },
+		{ "trng", 0, 0 },
+		},
+	.esr = ESR_H6,
+	.prng = CE_ALG_PRNG_V2,
+	.trng = CE_ALG_TRNG_V2,
+};
+
 static const struct ce_variant ce_a64_variant = {
 	.alg_cipher = { CE_ALG_AES, CE_ALG_DES, CE_ALG_3DES,
 	},
@@ -1097,6 +1121,8 @@ static const struct of_device_id sun8i_ce_crypto_of_match_table[] = {
 	  .data = &ce_h5_variant },
 	{ .compatible = "allwinner,sun50i-h6-crypto",
 	  .data = &ce_h6_variant },
+	{ .compatible = "allwinner,sun50i-h616-crypto",
+	  .data = &ce_h616_variant },
 	{}
 };
 MODULE_DEVICE_TABLE(of, sun8i_ce_crypto_of_match_table);
-- 
2.39.4

