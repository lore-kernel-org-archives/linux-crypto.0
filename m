Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5960E4A68A4;
	Thu, 15 Oct 2026 10:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792060799; cv=none; b=gobJUa/pQdOs29cn8UhsaKHxh+XV1WfrgYQjYiE5QZlrzWJtOTxrsXsdjT1f4PfAbi+T1gJuHF2cuQhD1mJ17N8H+WtHd/JPAV32e/UOw+F0u9I1teS7gPPQLjA6dU5VQYQjjD4BVeSzq+gaVi7ODENATCT/trGK/zWb4aLOP+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792060799; c=relaxed/simple;
	bh=pNkeB7LwluY5D7uZJfYgiZMrJ17TPzer5di3y4Zkq1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HEOxeC2g7YsA3YcwSCc9luEJ+2Too0dtaBi+69vpGI06eauJ3R6L4NE12dPnytpSkTNV6VLcu7VLBiYXzaEhX0UfVxUn0GUj7rmbgVrx2S4DOuu7fO/UESIy8gBcoOfJlebgODXpKlWytyPqzcTG5LCtuWEVPIiuW0QRFHH0I8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0fn9WZu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0fn9WZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687FE1F000C4;
	Thu, 15 Oct 2026 10:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792060798;
	bh=uYrSPGZn9BPCIcJJkcc3APCkmaxhzxeFcJMAhfp06Ho=;
	h=From:To:Cc:Subject:Date;
	b=c0fn9WZuPDH/wnkeg6m2ZgcIuQ4Sb2u3NA6hIHDCjAZCbfXs90JaY6YQHr53LySGQ
	 waPtpwZTW9X7iYDI1sz7rRscApdqUlwewA5TEQx+HwE/OxnTd5I2NJwZNMHScJDela
	 7dbWO4pnDfjChI4GzMeEIi9ynQQzlOS40rCrWUG96qmvD0vpj4q/d8tEsXJE6oXvYO
	 BNNZi87QwTVFoBg50C3QdW3QbT8oV1w4P5PZUVSImuqlNczAvDdK0sXyGt5tPDpEon
	 CMmVA2UHmJx+pWM7IRL14p+CWgGuMwV9sUQFAy2mBiBxEj6/7Ho2l6ydXYI47m8U/K
	 pJf1QCGvIEomg==
From: Thorsten Blum <blum@kernel.org>
To: Hadar Gat <hadar.gat@arm.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: cctrng - fix destination offset in cctrng_read()
Date: Thu, 15 Oct 2026 12:39:34 +0200
Message-ID: <20261015103933.337335-2-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1075; i=blum@kernel.org; h=from:subject; bh=pNkeB7LwluY5D7uZJfYgiZMrJ17TPzer5di3y4Zkq1E=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkX1qYGTjDjLvpn7aPp05XW/0Z+8bQ5uydI5/P+9ZJs1 uZevc62o5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACbyPIvhn4VGit37HPnYVZUv X/JysfNnbc2eXZLjapVqxzprm2A7I8P/UqvKlY6dm+9++qN2NefmMs9/66Pixee0Pbxo0fT3wVJ 5NgA=
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

cctrng_read() copies random data in two steps when a read wraps around
the end of the circular buffer.

Use the correct destination offset for the second copy instead of
overwriting the start of the destination buffer.

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/cctrng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index a6925211c3b5..e070581237e5 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -237,7 +237,7 @@ static int cctrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 		cnt_w = CIRC_CNT(drvdata->circ.head,
 				 drvdata->circ.tail, CCTRNG_DATA_BUF_WORDS);
 		size = min((cnt_w<<2), left);
-		memcpy(data, &(buf[drvdata->circ.tail]), size);
+		memcpy(data + copied, &buf[drvdata->circ.tail], size);
 		copied += size;
 		circ_idx_inc(&drvdata->circ.tail, size);
 	}
