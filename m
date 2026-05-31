Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B842DA765;
	Sun, 31 May 2026 19:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780255383; cv=none; b=dnJtqr4uq/sE+SK7c4G4ZikH4kRNt0YyRPGcuqjR0/Pl0ywTWjq5LSjjhM12GS9kkcz9PBc8hSnXriHA7NDXlxoc/toJOEJ3Wp6kCdHAMEnWZ0Sb2HxxOby8CXFH9MZkJHd1OVakw0cqyLwlgFfox7zR4T/E6om8FSyit8d7YXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780255383; c=relaxed/simple;
	bh=qvn/gXsoTTq4QWX5QXXeQZOdby6RxSxxTycPzPhsUf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/kesaOw8Xyrl31SK1LMim2LvwfRgbm0naSLpK2V3v1VuTRqhJCB3rbOv4IjgInogHJbl6gUgTVKoYqtORYdDwYOzqPRSb9Zz7T1yRxC03rwGMYN+jH3MNYubWA/gOjX398nGAm0OWBdIMW2IlLlnAdF7D1SnNsMGaMQVRDaAPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltmEov7K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltmEov7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAD41F0089A;
	Sun, 31 May 2026 19:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780255382;
	bh=/mY3enrm8GFK36qU/nkkjB0lXkdJWeRdwxvRsf3AZR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltmEov7KkF/Do5u+UnehUfhpQB0vhC4ehOVE26KxpoRda66YHqhEZ/IFdLqcYvSYe
	 hYsIgbcO32GH0dYftrVPDh/cndTBRy+foG+1Tc9JyaYFUdF3c+hcE+hr+9rsn5fCg6
	 kWSv0HqoiMo+hLwJmvo9HenJkZJcqPbaOIVFZS/uz45ElS3PQxPJnR6Z7zGxeeE3su
	 gIR1X2ZEI6RceK6E3UDl+OYRy38hgo6cwnPEJNcwFiHnCTDUUKqAnwTmtLr9WHZkUp
	 r8R8eqm2KXURnTBGBfVOHT+yIhoYszGGGXK8AWpPxZlkNosieru1r0xdH0PGMyjtVk
	 OjvNgE08seixQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Mounika Botcha <mounika.botcha@amd.com>,
	Harsh Jain <h.jain@amd.com>,
	Olivia Mackall <olivia@selenic.com>,
	Michal Simek <michal.simek@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/4] crypto: xilinx-trng - Fix return value of xtrng_hwrng_trng_read()
Date: Sun, 31 May 2026 12:17:36 -0700
Message-ID: <20260531191738.55843-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260531191738.55843-1-ebiggers@kernel.org>
References: <20260531191738.55843-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implementations of hwrng::read are expected to return the number of
bytes generated.  Update xtrng_hwrng_trng_read() to match that.

Fixes: 8979744aca80 ("crypto: xilinx - Add TRNG driver for Versal")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/xilinx/xilinx-trng.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index a35643baa489..a30b0b3b3685 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -237,22 +237,25 @@ static int xtrng_random_bytes_generate(struct xilinx_rng *rng, u8 *rand_buf_ptr,
 
 static int xtrng_hwrng_trng_read(struct hwrng *hwrng, void *data, size_t max, bool wait)
 {
 	u8 buf[TRNG_SEC_STRENGTH_BYTES];
 	struct xilinx_rng *rng;
-	int ret = -EINVAL, i = 0;
+	int ret = 0, i = 0;
 
 	rng = container_of(hwrng, struct xilinx_rng, trng);
 	while (i < max) {
 		ret = xtrng_random_bytes_generate(rng, buf, TRNG_SEC_STRENGTH_BYTES, wait);
-		if (ret < 0)
+		if (ret < 0) {
+			if (i == 0)
+				return ret;
 			break;
+		}
 
 		memcpy(data + i, buf, min_t(int, ret, (max - i)));
 		i += min_t(int, ret, (max - i));
 	}
-	return ret;
+	return i;
 }
 
 static int xtrng_hwrng_register(struct hwrng *trng)
 {
 	int ret;
-- 
2.54.0

