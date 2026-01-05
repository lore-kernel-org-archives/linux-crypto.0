Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E679632AAB3;
	Mon,  5 Jan 2026 05:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590105; cv=none; b=DwWfar2SOLJhtXjhH3gNZm5jq5Oy2hfxORTs11mPPx7Uw/IWtPNg7f/8Wo3oHdeJq+8xsixjOrDPQMqqBxiQsePoy40YaS2RNM487STn1FqvlWArZFNAtuXNRZfQNyt8pKC3gJNj/xmh3gEmeVMGAf90PkMK1gVQPHKMfQtqaGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590105; c=relaxed/simple;
	bh=QrYuLwUNu/mVSc/Yo9MLheYVuGpn5hYaMt0fTaKLTGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmH4hZmDv3rpQ4NnIwZq6Rwi4xRmqNJ79hRKB90RnlcFSMghhjHArHbrPaCHR2wrTrgZtaFBQd/B2FJXUklnnnG1uFDhSOcM7H7jT10Vqcp0Eq+TYlYXaqGN++N8JV0tZfOulxyCgS9ZVPuR44pmRLm20kotSvlo+fgMiDRgvLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G3G0Bk0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G3G0Bk0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DBAC19425;
	Mon,  5 Jan 2026 05:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590104;
	bh=QrYuLwUNu/mVSc/Yo9MLheYVuGpn5hYaMt0fTaKLTGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3G0Bk0G56Ktu3wG+6a9uAZH1lAOba80s4ElWn2pJFGgFmNV/Cvh+Z4L4klecwAfJ
	 4A4jYZkIX5u/TAbMBp2/t6kvMz1vfkfl6kK8wTbdYEMZzD48byZukOJjTQls80D1Xy
	 4WkndmU3Qn4EkS0p+n03CEKYzEJ0P2Wu+x5eAaKoh0QJtMhWu243+nRHSrwnSBLnET
	 /USJVwZLIvP7OD84paOmDdk+WrENSjRQUTX3tIVS55nIybRN4WLxj52YLt7MKHOYg9
	 LR99hxKJTTahowUoQL9JPYKxznndT0rryjV8qUaCJhK4rY0IHuWnAW46qVo1Gxtx6a
	 1WQW7lG89tSYQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 21/36] net: phy: mscc: macsec: Use new AES library API
Date: Sun,  4 Jan 2026 21:12:54 -0800
Message-ID: <20260105051311.1607207-22-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260105051311.1607207-1-ebiggers@kernel.org>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch from the old AES library functions (which use struct
crypto_aes_ctx) to the new ones (which use struct aes_enckey).  This
eliminates the unnecessary computation and caching of the decryption
round keys.  The new AES en/decryption functions are also much faster
and use AES instructions when supported by the CPU.

Note: aes_encrypt_new() will be renamed to aes_encrypt() once all
callers of the old aes_encrypt() have been updated.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/net/phy/mscc/mscc_macsec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index 4f39ba63a9a9..bcb7f5a4a8fd 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -502,19 +502,19 @@ static u32 vsc8584_macsec_flow_context_id(struct macsec_flow *flow)
 
 /* Derive the AES key to get a key for the hash autentication */
 static int vsc8584_macsec_derive_key(const u8 *key, u16 key_len, u8 hkey[16])
 {
 	const u8 input[AES_BLOCK_SIZE] = {0};
-	struct crypto_aes_ctx ctx;
+	struct aes_enckey aes;
 	int ret;
 
-	ret = aes_expandkey(&ctx, key, key_len);
+	ret = aes_prepareenckey(&aes, key, key_len);
 	if (ret)
 		return ret;
 
-	aes_encrypt(&ctx, hkey, input);
-	memzero_explicit(&ctx, sizeof(ctx));
+	aes_encrypt_new(&aes, hkey, input);
+	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
 static int vsc8584_macsec_transformation(struct phy_device *phydev,
 					 struct macsec_flow *flow,
-- 
2.52.0

