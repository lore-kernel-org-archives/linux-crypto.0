Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B76047D951;
	Thu,  1 Oct 2026 21:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790888715; cv=none; b=XQhYDvsLw5zaTEPO66aUZVPMDTVpNHhKiWvnFhWzKs9PgIaSddmtFnl3r0glHL7thLoANX5kN6bXbymQyFDb88sR25tfxYMtlYpFae822Yv3w4pi6lZpL3X/FGTX0GTnDe9Nc+Y/zDk3H5QFp5hJYtbrFmMUmY3Q5FYC8xDlgbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790888715; c=relaxed/simple;
	bh=Nz0LSI3aZYawMQnKQbqCra0lDUN5qofWzsmAg68O8io=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gZQwROXy+Ubjh5d0qt0lXtwuGcRDO3eN+L60Wlzepcpaew12b3WmLybEhKdZuHtLNL35f3ZO3QS/ZSZjh42abWHMAXk1gg+Bk0PWiHAeK04OfCTbFNLGRm+6m0taxaxmPBztvkOazRehNvlM53gr+XsuGOuWLvw9eHmoL6Siz5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjgu9TMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjgu9TMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB3A1F000FF;
	Thu,  1 Oct 2026 21:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790888714;
	bh=MaEMQ5X2bx5FhW9iOXMM3Gs1pceUqUDrW0W/Yi+E1tk=;
	h=From:To:Cc:Subject:Date;
	b=mjgu9TMbC00b5ykkzAq9efosTt5Zeec4nGpNGxqj5k6mXxAHZuEOMmlBfZshTTdE0
	 VUDOeTiCgspL1FcOekGab8a0+mb3GjxDsP2Ye8AIOfs5NJoiDR8KqZA427fA0gCQkk
	 aZQHr/uBsZ7uqFwWvOZAm5vuF2zmxC9rH3ZPhGyPc4Jz9aqURp4/Z2Tew5GG2wQvW1
	 uszgajNmWMXgqanOXWwlYAhFO+KT0WSQ9GUGh/0vmUeeipVTaOGNIDkieHyOHRxmO7
	 lyBfWCdmCIwAcZlFNpXP2Cf1CbaF44Z5yqVMNrjNMwQxAjlthzdKy/EDYC2Ak72vk5
	 NSvmih+dN5c0A==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: stm32 - use swap() in stm32_rng_probe()
Date: Thu,  1 Oct 2026 23:04:48 +0200
Message-ID: <20261001210450.37467-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1197; i=blum@kernel.org; h=from:subject; bh=Nz0LSI3aZYawMQnKQbqCra0lDUN5qofWzsmAg68O8io=; b=kA0DAAoWXqtxINjMdS4ByyZiAGq+yvKireINrPyi0y0O4zRoXZkaH6bDL64tXpx61Rlyk51U5 oh1BAAWCgAdFiEE4Jr4mE11fHmyNFi5XqtxINjMdS4FAmq+yvIACgkQXqtxINjMdS4AOwEA0uqR pwNEUqQcXK7n595liNdI+iJmFG5r9X9nX142apMA/0SKwEZZqEmSEn9+VduY/fA6+u8SXdxR1FQ RPibC7doD
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use swap() to simplify stm32_rng_probe().

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/stm32-rng.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index d3fc910f674a..b13361dcad12 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -569,18 +569,11 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 		return dev_err_probe(dev, -EINVAL, "Failed to get clocks: %d\n", ret);
 
 	if (priv->data->nb_clock == 2) {
-		const char *id = priv->clk_bulk[1].id;
-		struct clk *clk = priv->clk_bulk[1].clk;
-
 		if (!priv->clk_bulk[0].id || !priv->clk_bulk[1].id)
 			return dev_err_probe(dev, -EINVAL, "Missing clock name\n");
 
-		if (strcmp(priv->clk_bulk[0].id, "core")) {
-			priv->clk_bulk[1].id = priv->clk_bulk[0].id;
-			priv->clk_bulk[1].clk = priv->clk_bulk[0].clk;
-			priv->clk_bulk[0].id = id;
-			priv->clk_bulk[0].clk = clk;
-		}
+		if (strcmp(priv->clk_bulk[0].id, "core"))
+			swap(priv->clk_bulk[0], priv->clk_bulk[1]);
 	}
 
 	pm_runtime_set_autosuspend_delay(dev, 100);
