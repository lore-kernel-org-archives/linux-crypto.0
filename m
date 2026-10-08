Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0EB4908A8;
	Thu,  8 Oct 2026 09:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791452276; cv=none; b=g8s16Fs+xkm3RX7G1qPWo8UfMRchuflET+bCBALfZEgK53gVDtrbTO3cejkQeFPT06RQBzjkWKzkL+8jKwtsH3409gmI+8RRS5Aw/pAZpxNnCn+orx/0Z042fsx/tsP9md7wkTcZK5TIVPf+d3PsusY1jIZs8KhIYUvs1ndYbvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791452276; c=relaxed/simple;
	bh=LIzDhFJ2sEcX8erKvfHAlfKm6YOYUd7Zosu9ldd2/po=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IrjrQqZ1SBikieL48rS9HE/bpBMy6mGFS/tQtTqsc4ripE/9PSRAmaJzGAaHJIQhC7TceikUffkyg7pS/4uHrpqxuFg6VyZyYOtgRzOV9yYPx4YbVzuSQAQwQ+LCJ5Pos/W5oaEFTGVTDybjD6fQY1cvKUnod2N1qaT74fdnUTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdMjdlBu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdMjdlBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FD01F000FF;
	Thu,  8 Oct 2026 09:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791452274;
	bh=oeE97OM4GL2/16lUMhzDgf2hcEkXVhsahCqxO3mLEdQ=;
	h=From:To:Cc:Subject:Date;
	b=JdMjdlBu1tITP18i8Lix/cYXZFha8NKaZaGR5b8lf8oK5inTEZ3KQ1ufsz1XkSVb/
	 sDuol+0bNnN8v/zu11hHePjkdQAC5o+u5enbEDF/OZaKA9ZQMOX6ypZo/V6QpXYs7G
	 1iMGIoyKIaHAKSLrhNDaoNED5zupSYnCA6RJVLWjiJaT+F/W8JS3wvwvMYXvwHXW1F
	 eVVeFn3qazJMXPcL+pqG5/t/MBdyx6exr3xELZPFOy060lXgPcanz4PUfgkGssn5/4
	 gH/bAeT5/jLUNq14Fbnc1y+NpWqyXKTUS/DqxGG5XarMLZzS+NSEqah1hHGlsrUnJg
	 PSn7j9H2cy/UQ==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thorsten Blum <blum@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Kees Cook <kees@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: amd - use PMBASE_OFFSET consistently
Date: Thu,  8 Oct 2026 11:37:37 +0200
Message-ID: <20261008093737.180712-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1039; i=blum@kernel.org; h=from:subject; bh=LIzDhFJ2sEcX8erKvfHAlfKm6YOYUd7Zosu9ldd2/po=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnHUxL1u/4U3fW2XsWW/Zj3oeWnMy13xHRik5wrY2+qH /vUyh7WUcrCIMbFICumyPJg1o8ZvqU1lZtMInbCzGFlAhnCwMUpABO5+JDhv1NB85ytF4pqXWa/ Zb2+uD38QOgm7fcZj3ylE9tE3oqnMjAyXLpqsP0Fk8VD52+NN6cfqJDrUkmaZ6l9KO226xS7Dba irAA=
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use PMBASE_OFFSET instead of the hard-coded 0xF0 and add the missing
space to the ioport_map() error message.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/amd-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index fb5422612182..ef177c99515d 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -158,14 +158,14 @@ static int __init amd_rng_mod_init(void)
 
 	if (!request_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE, DRV_NAME)) {
 		dev_err(&pdev->dev, DRV_NAME " region 0x%x already in use!\n",
-			pmbase + 0xF0);
+			pmbase + PMBASE_OFFSET);
 		err = -EBUSY;
 		goto out;
 	}
 
 	priv->iobase = ioport_map(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 	if (!priv->iobase) {
-		pr_err(DRV_NAME "Cannot map ioport\n");
+		pr_err(DRV_NAME " cannot map ioport\n");
 		err = -EINVAL;
 		goto err;
 	}

base-commit: 666d66df25253070cb297cb920b0bcfcfe5eb871
