Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0888389DE5;
	Mon, 12 Jan 2026 19:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245809; cv=none; b=Iuv6Csd2NaVxjI5GpwJjV+rlxdtBqqQuc8GVKPpCBP7d7lIyTuGCdi6pxZEu2WruqYtKM/+nWQN3lSztuUzMGJnjf6bKeXtGKCIiJpy5mh8xIl6I1kHkbdHl3AO4rgTFT/fropc/zYLTtJ0S+Kl3L3FxTVuY621UqQg61jVjNLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245809; c=relaxed/simple;
	bh=zZjTigRkrr+RJfey+6vJW4bfvWaLAxFdbVVJ4sVGLrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCol0r3aSn0iH34KvXlxy15jBsNZB9my/HbWT3Av63TihX0sjCFuvTN2Bv/Ehwj6KB9lpg/AG/ztmHV4Bs1TXm2WrlSban7EoJ2pilDsEiQT39Pd2252Kymf2poxprsflrpJQKktxekIAj0tN+vq6qmq9iTCBvliHz2VH4GuMwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qfFo8JDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfFo8JDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157D1C19422;
	Mon, 12 Jan 2026 19:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245809;
	bh=zZjTigRkrr+RJfey+6vJW4bfvWaLAxFdbVVJ4sVGLrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfFo8JDsoztKnqQM8LDVsG/RZYZxuwTk6m5qZdjQd/xXiyEc7egrbByJjtgR4sZdu
	 RcpNZKXOvWe5RDLB7hOVlH6OXua6/OEZPnBLFISFOa3J9MSrW455FqrBKQI77CQJcs
	 y9tlA15wqYgSNGZRxDqsKIsEYbUvlHRl/M6y7e+iul2Ov7gxDV2ezDzKhpNPivrM9P
	 zwOHwRjPkvT69tX3CGSI6iww5CkwpdRRVVEkHnpxQ2h5oHalu2FfFBkGaWRFvW3rVB
	 uvUHQfOkJvB3PC+Xs0dSKIdnrH6Xj+YQwsz98IhE5tYp8ma1ZcTvtU9SKRX/Kgvx9M
	 vIGAYuZKdialA==
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
Subject: [PATCH v2 21/35] net: phy: mscc: macsec: Use new AES library API
Date: Mon, 12 Jan 2026 11:20:19 -0800
Message-ID: <20260112192035.10427-22-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
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

Note that in addition to the change in the key preparation function and
the key struct type itself, the change in the type of the key struct
results in aes_encrypt() (which is temporarily a type-generic macro)
calling the new encryption function rather than the old one.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/net/phy/mscc/mscc_macsec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index 4f39ba63a9a9..9a38a29cf397 100644
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
+	aes_encrypt(&aes, hkey, input);
+	memzero_explicit(&aes, sizeof(aes));
 	return 0;
 }
 
 static int vsc8584_macsec_transformation(struct phy_device *phydev,
 					 struct macsec_flow *flow,
-- 
2.52.0

