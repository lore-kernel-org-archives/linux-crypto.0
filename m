Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804AF57266A;
	Wed, 23 Sep 2026 20:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790194430; cv=none; b=MrJ7YtE0TnOpB28p2qdYH3XPLWredNb23uMLjp7bz3sS+2fERlj3dG28fLu4csod4BTLYUFaP+VvijtxM2I5JcLY0j2C9llNgFgKpyNDkIcwuuH20j0ahvLVnYtd4SsNHjI5HEXcjLYE4tDNBOzwF9lxf+6bipQWzyyAkJYau4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790194430; c=relaxed/simple;
	bh=mtpq7mgmr0G/o19t8NxFClbAQzt5B9ZA1JK9DteCGCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dl7vERSwvpKZlI6N3KpFTyxKTsbuYFTAsd1Uxb8+4c4kw/q86vfiPrRQPQfNAADb/Z51yxI17FIqGF7SZDbJ1TUmapg5W73DTzAIskWHkjWAhth0rnI/xKHwBX27O+aKHZUMQvs4btaCIU1GGe4zsWRJ7NHR3ddGufFiGiPVcVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mHXoB9+d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mHXoB9+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092381F000FF;
	Wed, 23 Sep 2026 20:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790194401;
	bh=XT9Xi9VdFMLfLT2A3igC5xaODMPYyjfYVhRup4jeIlI=;
	h=From:To:Cc:Subject:Date;
	b=mHXoB9+dzHVyY1aMhuzo0Dwap1WG0MxPHjPEuxIW04MuYhHvg7UIxcm7b+gQEWshg
	 mCHeYzjJznx66IghgGlEcSLCkH5HJDQ6rVOqhmMTd7lSBWLoIee2wrhCfDl3im81c8
	 2TwjeBuSTKkpnsJPYDYQp4LWAhzLnaUe452zoomfYJbbAOxIFxTkxi8v3gSbcn/LkL
	 7bb7hYJMNbpNZ+8mye+XmnpMrLfkasHxtYsW98+NFXLi8Chx62ZXRVLsRHi3h5RYEo
	 DY5LKqAzLIfPhM6yvnzFrtH9YWlaGtJTCQcUg3scR6vLFgCQiRp8K721cKI+XApyGG
	 hGGiDotNfwtoA==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Kees Cook <kees@kernel.org>,
	Corentin LABBE <clabbe.montjoie@gmail.com>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: amd - report partial reads in non-blocking mode
Date: Wed, 23 Sep 2026 22:12:58 +0200
Message-ID: <20260923201259.90336-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=866; i=blum@kernel.org; h=from:subject; bh=mtpq7mgmr0G/o19t8NxFClbAQzt5B9ZA1JK9DteCGCw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlbjE4HeFscXxPm47tlcWr4RvmW8mn+Jw56p8X/v2G69 6v+FK/1HaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRDToM/5T+slv8aJvOv+S/ kdsvf66Pn5c23F1or86t/5vptItz1TSGvxLNfYrNN/INOjecNc3c6Za+NG/G3dtMvkvWPHRneTc ngBcA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

amd_rng_read() returns 0 if no more data is available, even if some data
was already copied to the output buffer. Return the number of copied
bytes instead.

Fixes: 85962d2248fa ("hwrng: amd - Convert to new hwrng read() API")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/amd-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 42a18fd41050..9d53f4c3e5bd 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -80,7 +80,7 @@ static int amd_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 				if (timeout-- == 0)
 					return read;
 			} else {
-				return 0;
+				return read;
 			}
 		} else {
 			*data = ioread32(priv->iobase + RNGDATA);
