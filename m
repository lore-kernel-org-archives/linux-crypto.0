Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59B23E9580;
	Thu, 26 Feb 2026 14:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772117182; cv=none; b=nFm8vX5k+0OGAAPGoK2xmgP1ouxphxRcBHKbp7Biii4BrQRIeiFUsq08w8r3cLqHlsb9/188pk6SnrL00E2WrYGLHejSWT+Lia7dgTp+/kcQnunyHIWpxJ2S7bd0mcF4B6pSKUZp4v2OjgUBxrdhFe5xD3e/KGpp3hmU9pbB+rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772117182; c=relaxed/simple;
	bh=sFFfItmaKIbkDnrCPQAQMxVftGsTIbo583JAPwG/djw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPII6Ak5x1MLpJ2QCLq2QmE835kJJ/38s3oFdUY68OhUTjoT2dJH3X2dxVnSfCWrYtZBpaxdpjYNgtXnkdOL/zY9N9inSeEgsuvF8+p8S/1I6zSTYE5nze3fSLTfSwjDILFMj+SjvwPdyo+1yUHKh5LRGQQDo1rWMgcjaL5v7hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FF8C116C6;
	Thu, 26 Feb 2026 14:46:20 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5/5] crypto: Clean up CRYPTO_CRC32 usage
Date: Thu, 26 Feb 2026 15:46:09 +0100
Message-ID: <0f76ebf05bb1b6ca50db97988f9ac20944534b4c.1772116160.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1772116160.git.geert+renesas@glider.be>
References: <cover.1772116160.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

F2fs and RoCEv2 stopped using this CRC32 implementation in commits
3ca4bec40ee211cd ("f2fs: switch to using the crc32 library") and
ccca5e8aa1457231 ("RDMA/rxe: switch to using the crc32 library").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 crypto/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5e66de2948ed02f9..b4bb85e8e2261209 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1060,8 +1060,6 @@ config CRYPTO_CRC32
 	help
 	  CRC32 CRC algorithm (IEEE 802.3)
 
-	  Used by RoCEv2 and f2fs.
-
 endmenu
 
 menu "Compression"
-- 
2.43.0

