Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB623D7D9E;
	Thu, 26 Feb 2026 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772117177; cv=none; b=QaRgSKECLbXKymFMmvAq0xKqSqHQXjFX2SZeDmgldV0iRNmtC5vymShXxGP+b0CUrZCZF/u8sc4Ibs7Fs4h7+TBwFcb7cNKnYt7ZTjWFknd/RnpND9x/AAOK9A7rJr8j3EHaBy9TlvFVLAP987ug6qTepSRtM4KFiWgyHrtiWPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772117177; c=relaxed/simple;
	bh=ZY0vIEF9e/lYHWqUxGvcUmBjwFOq11AFQ3s6/woygAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogBhaY1eiOVEHnO8iicUir9+KAQ75iEaHgxsfvlnRN2Z+kfvKY8n+RsDmTqurLZEyb1Fsc7ilvrDAgwE21uSXvz0iUTuF/neaoEgN/5yjhiIBSUkMFxHrJkpTVbw59AB/C93qK+pYrYflJANJE4DJ+b8lfgJS+uZ/ORrowT3ksM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9E3C19422;
	Thu, 26 Feb 2026 14:46:15 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/5] crypto: Clean up CRYPTO_SHA256 usage
Date: Thu, 26 Feb 2026 15:46:06 +0100
Message-ID: <bf8e1c229b36fc5349e29701e962d0dfd4fd21b6.1772116160.git.geert+renesas@glider.be>
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

NFS, Ceph, SMB, and Btrfs stopped using this SHA-256 implementation in
commits c2c90a8b2620626c ("nfsd: use SHA-256 library API instead of
crypto_shash API"), 27c0a7b05d13a0dc ("libceph: Use HMAC-SHA256 library
instead of crypto_shash"), 924067ef183bd17f ("ksmbd: Use HMAC-SHA256
library for message signing and key generation"), and fe11ac191ce0ad91
("btrfs: switch to library APIs for checksums").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 crypto/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8bc95e69faa5557a..c84fda3acdbda57c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -963,7 +963,6 @@ config CRYPTO_SHA256
 	  10118-3), including HMAC support.
 
 	  This is required for IPsec AH (XFRM_AH) and IPsec ESP (XFRM_ESP).
-	  Used by the btrfs filesystem, Ceph, NFS, and SMB.
 
 config CRYPTO_SHA512
 	tristate "SHA-384 and SHA-512"
-- 
2.43.0

