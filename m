Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5516B386C21;
	Thu, 24 Sep 2026 09:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790242464; cv=none; b=rx2ooS3zfnlnri2Cd1BiCyLWzVktBOo9B5e48ZkxMeFHsgEO/2v7jIRFnUcJ+52WUs5bFqITBo5n8EDRopQXtvpm/yC9ansoJKW4RjNvzFOM9I10pnuv4vaQTo+wRFYqcnJWl0mxgqGNWuHK9EAJrBwCWrbzvn8QnnDUCIj+tHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790242464; c=relaxed/simple;
	bh=xo0DDDKcUbFWdrfXFsOqJj6WtQ7ZhkywMQGZSJ5NBhc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uxco/evdBoksOBIFhN/C4TFaCF8l/wWZcBQr5/xE+j/D29oK+XbGZxENZ1mERkvwwe/GpwIvYd0W+o8sREhA3G/zLOXA698Vp4lnda3MyBwXczn6je4ZIDI1ec+bh506mFYYg7UdR5PkCWJ8jrThQj9osL9A+7skb+lz7PkuKIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4y+tgP6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4y+tgP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54C51F000FF;
	Thu, 24 Sep 2026 09:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790242462;
	bh=psjurhsMaMi8rVj+TV4mvkos7Pu+6gAV9+t2NFW7hZQ=;
	h=From:To:Cc:Subject:Date;
	b=Y4y+tgP6qvVhsBg0NoIudKUFpntYyvT1nurFBjCQwzOHuI8GQhIqikCEJJ5dxBLzm
	 /8mkz7BSZcUa7s1xtSI2CegSqlmqSeykOpqz8CvTZG0ZI/QrWkCdOLts6e1eNDZIF8
	 mQotkjSfKpH++0cQbtiiLoPvGVX9bFLFN2xnBNcDPhfYeEGd55JZLDgjg/WmmMRBpU
	 L4TfdO8bSf/H2CD8b835bR+QZdVwNxkmiUjjB72e0l3/iLbAUplQu0t5F377kE1Fm8
	 Qql3hLdw+xmaPWH/yBfvFWhvuS2ZPl9fTWa7T26TmfLMk1LWNokXv/IqBfr8HQj0Nx
	 dD16RaKiF7YaQ==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Olivier Sobrie <olivier.sobrie@silexinsight.com>,
	Waleed Ziad <waleed94ziad@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: ba431 - fix reported byte count
Date: Thu, 24 Sep 2026 11:33:59 +0200
Message-ID: <20260924093401.113713-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=908; i=blum@kernel.org; h=from:subject; bh=xo0DDDKcUbFWdrfXFsOqJj6WtQ7ZhkywMQGZSJ5NBhc=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlb3nWG3px1KKjcwzMl8UbjBbGAozZxO5oULu3qdeedf SBm766NHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRoBhGhkv/1oldehHLlvQ+ mj9yu7RU1+0HM19k7XqUxPPQsnq/tSDD/8DJZwMjGcoXtHV7+H2dIPc4qWOzquW5VO7bW2r5K/r PMAIA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use the size of the buffer element instead of the pointer size to report
the number of bytes read. Since data is a u32 pointer and sizeof(data)
is 8 bytes on 64-bit systems, using the pointer size reports twice the
number of bytes actually read.

Fixes: 0289e9be5dc2 ("hwrng: ba431 - add support for BA431 hwrng")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/ba431-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/ba431-rng.c b/drivers/char/hw_random/ba431-rng.c
index b0a39032c610..810c8cd5629a 100644
--- a/drivers/char/hw_random/ba431-rng.c
+++ b/drivers/char/hw_random/ba431-rng.c
@@ -147,7 +147,7 @@ static int ba431_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		}
 	}
 
-	n *= sizeof(data);
+	n *= sizeof(*data);
 	return (n || !wait) ? n : -EIO;
 }
 
