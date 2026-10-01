Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8EF48642A;
	Thu,  1 Oct 2026 21:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790889404; cv=none; b=qLw/fqmEilcTy9VGdUd0xvCY64oJwyUbZVu5K96P+qIya3UJTIdQPf5ijGPFMhf2eAIq+y9bmo6JfZhjSChvjVs+NRSVxkHkM3D9OYl0kO180bdHA4xwiShxZw3kDrvU88QEodh3HoUVCYs7ZQhtN6aG04uXRNIxl6ff69qw2Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790889404; c=relaxed/simple;
	bh=I6yVwfx+zM9opQQWnAvcPhamuhdJnFuPIZhE011Wj+M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mqJVvArbKzpwWKPbeJ+sRUKQ2ZHNjwCp8h5xwmmujOdEe9nVr2e0sadYrjo3xVngYuV7pOrUf/hkT5AhHlQquwG+8n7HyRhHWGdFXhXf5XuyDjTI/dtBxRhF9+lRsxhHXqtXnHuJNkyr3rs5CCCEnwlBamFSVHBmFSFANRmuniw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=acxTcB7s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="acxTcB7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7621F000FF;
	Thu,  1 Oct 2026 21:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790889389;
	bh=zSnUGGsqliXZtVPf5Iq/8Ik1fxyeA3/3zV4qlHUuLAA=;
	h=From:To:Cc:Subject:Date;
	b=acxTcB7s+ZX69fXTAmC7+mtGdOYqretKx/g2Jj52GrMbffhHEmyNsLISJIJMEiK8W
	 Ehxa2Pi3+gyWg5o+D2nmLQv8LxgtSa918yU197Nt17tUgWzO5/8WxyTgtOfnGred3s
	 TYM9Vy7qww2oGoOJ6LMEnWChlcc//pdKxFJfxV+BN6uFyisbUb8xLgmQBMqV1iGEI5
	 aK+POpb4zU3iEJ7UBfnNTPGnLjwfdlhajpH98HZNA7V6rCDTyYs8/E1rRB5Sz2Fg7d
	 ++shZcNveIURBsXc23XhuuehtecAH0nVLLi9seRKGU4EwyELx547W5MZhRGzOE3Ptp
	 eJdNnJ7R8ZUsQ==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Linus Walleij <linusw@kernel.org>,
	Can Peng <pengcan@kylinos.cn>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: stm32 - reuse clock rate in stm32_rng_clock_freq_restrain()
Date: Thu,  1 Oct 2026 23:16:10 +0200
Message-ID: <20261001211612.38124-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=816; i=blum@kernel.org; h=from:subject; bh=I6yVwfx+zM9opQQWnAvcPhamuhdJnFuPIZhE011Wj+M=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFn7zs6Ruv6M4+2dqdlyR2ezVlv/uKxsnV8jcIztl96eq T0L37/92VHKwiDGxSArpsjyYNaPGb6lNZWbTCJ2wsxhZQIZwsDFKQATyfBmZLih+/AMH3tkjfef YOmny4ojis8q7LDfwaQj+sV9gaTf+0kM/8t9NnOw1TVXP1WR/mvHs6KmftnMhlmnL16SMn06vfj pJwYA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Reuse clock_rate and avoid calling clk_get_rate() again. Remove the
extra space before the colon while at it.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/stm32-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index d3fc910f674a..319944d92b82 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -277,7 +277,7 @@ static uint stm32_rng_clock_freq_restrain(struct hwrng *rng)
 	while ((clock_rate >> clock_div) > priv->data->max_clock_rate)
 		clock_div++;
 
-	pr_debug("RNG clk rate : %lu\n", clk_get_rate(priv->clk_bulk[0].clk) >> clock_div);
+	pr_debug("RNG clk rate: %lu\n", clock_rate >> clock_div);
 
 	return clock_div;
 }
