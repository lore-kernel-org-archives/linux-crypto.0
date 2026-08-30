Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5732EFD9B;
	Sun, 30 Aug 2026 22:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788127364; cv=none; b=aDMtQvrrm2JcUCgI7AmL7r829b7Jtr7nPY+Nt3KWQe1ePAIUoVecs3c8Y9M9gLD3cS3ekUPxIrbeBcPEUw1iTgq7M+IqXffVt5bohmT2dR5T0R2i/ielLP71O+i/usm33ml8Zu+5O43JIYo4qXLAVKnhhx9EkdEbBcs78vY+C6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788127364; c=relaxed/simple;
	bh=Mqkb2QdjsRcFTzYR7WIzAtuJXRfrfDnrycy2XpUQ+Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fP5vokhDZObEfjFdNT422yQnIcDoT6vRSjChFpVc2w4dD0SydGxve+GfdFTPqob1U2V18RQi+XWGgM2+d2Ua5qXkivUbgKJxyfhjgu0LIIB6IVttO9LZ3lSvuvcmGMttkzl4PPDuNNf3OyH9qEhI9KQIYkK1imtIQTMVmaCzvMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPTQ2HWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPTQ2HWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2061F00A3D;
	Sun, 30 Aug 2026 22:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788127363;
	bh=My24ANp40jmBDq80Z0CdsIMh6prDFOBZaleFla7Ra20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPTQ2HWgnKry00xuyO+whUv0zKJ5o3zp0UvxnBjU088YABthtBbXcOX2U8SQDAQ2C
	 dWtw6crlivEywLpejrNXtfKtFX0jHo58rvTunD0zrBMvQFjjpSLq88sJhJdVLqVL6A
	 o9SH4LPoskjT6Ct+enirH1CGrlPo723JfN4sHsJeKKkGTWfGkgjXH7i13SRYRlxTqN
	 Agqmp0KF2OGBI3YhLQhcKobpGV3a2uzUqifK0L8y4ZfDbAuqBq9pa59pBeCwOdS3WY
	 iKXtEhglMqbGi3W50tXJAKlUsiBV29fTbEzhf4guZ3+AsKoTyJWHK2TPWi9gyLadkX
	 NykFhRJei6hJQ==
From: Thorsten Blum <blum@kernel.org>
To: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thorsten Blum <blum@kernel.org>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Guenter Roeck <linux@roeck-us.net>,
	Wensheng Wang <wenswang@yeah.net>,
	Frank Li <Frank.Li@nxp.com>,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Colin Huang <u8813345@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Dixit Parmar <dixitparmar19@gmail.com>,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Eddie James <eajames@linux.ibm.com>,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] crypto: atmel-ecc - add support for atecc608a
Date: Mon, 31 Aug 2026 00:01:52 +0200
Message-ID: <20260830220151.21469-4-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260830220151.21469-3-blum@kernel.org>
References: <20260830220151.21469-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1293; i=blum@kernel.org; h=from:subject; bh=Mqkb2QdjsRcFTzYR7WIzAtuJXRfrfDnrycy2XpUQ+Vs=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlTVgT8FBbP3yItpTBRZbaCTOf0uCutB+q2LGtNvM1SV z7/nMfPjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZjIwy+MDGefTsh37LjwYOsK 0cqGs6YGvy8WqO56kHKkduqbr/f03YoY/kr92+B67xL3jtJm87LPX255HU5+UsOgzbWqUNVQOMH 3EhcA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

The driver already supports the ATECC508A and ATECC608B and uses only
commands shared by these devices.

Microchip documents the ATECC608B as a backwards-compatible, functional
drop-in replacement for the ATECC608A, with the same device structure
and command interface [1]. Therefore, add support for the ATECC608A.

ATECC608A hardware was not available for testing.

Signed-off-by: Thorsten Blum <blum@kernel.org>
Link: https://ww1.microchip.com/downloads/en/Appnotes/Migrating-from-the-ATECC608A-to-the-ATECC608B-DS40002237A.pdf [1]
---
 drivers/crypto/atmel-ecc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 075f38a67935..0904bb47fd0a 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -348,6 +348,7 @@ static void atmel_ecc_remove(struct i2c_client *client)
 
 static const struct of_device_id atmel_ecc_dt_ids[] = {
 	{ .compatible = "atmel,atecc508a", },
+	{ .compatible = "atmel,atecc608a", },
 	{ .compatible = "atmel,atecc608b", },
 	{ }
 };
@@ -355,6 +356,7 @@ MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
 
 static const struct i2c_device_id atmel_ecc_id[] = {
 	{ .name = "atecc508a" },
+	{ .name = "atecc608a" },
 	{ .name = "atecc608b" },
 	{ }
 };
