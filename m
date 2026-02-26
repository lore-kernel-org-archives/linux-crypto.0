Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBAF3D9045;
	Thu, 26 Feb 2026 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772117175; cv=none; b=FdsFCLW26PhEhhXoXaqY2ndrj6X3zK7rgV0sOfFDepki5yVSc2b4gvLQxKJetG57pEouSEBb2txbidnszrUUlrcQjMoKUjKGoyhRU8dix+QiS8T22Pc+NFTf3pVBYxNp0dkS4D9DM/Fn7PpTkGtlPiMqePv2Uh8ltB8fY7GoGk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772117175; c=relaxed/simple;
	bh=kR1hjMinjNvTwkQ2I8iZSR/aiZt5ZceOZNw87uJHnC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5x+EBqnbRuYTJhilce6NSopLwC0YbysItB4otpxAiFcDmUeKnyFkaIeLYaAC1HTUIENWV1foIQc1TIea0o/Tlu9YM6JZLHDxd5eLoD6XRN4tIdrjGv4zShnNJz6ZJPKH9CHQYEe+QDA+pVaTPV26DhEVmpWprymjMGKeGdQ11o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556A3C19422;
	Thu, 26 Feb 2026 14:46:14 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/5] crypto: Clean up CRYPTO_BLAKE2B usage
Date: Thu, 26 Feb 2026 15:46:05 +0100
Message-ID: <98b983d2f2bddf0e5e8e1c970446c3c64527ef89.1772116160.git.geert+renesas@glider.be>
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

Btrfs stopped using this BLAKE2b implementations in commit
fe11ac191ce0ad91 ("btrfs: switch to library APIs for checksums").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 crypto/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e2b4106ac961eb52..8bc95e69faa5557a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -876,8 +876,6 @@ config CRYPTO_BLAKE2B
 	  - blake2b-384
 	  - blake2b-512
 
-	  Used by the btrfs filesystem.
-
 	  See https://blake2.net for further information.
 
 config CRYPTO_CMAC
-- 
2.43.0

