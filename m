Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92D6238C03;
	Thu, 11 Dec 2025 01:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765416057; cv=none; b=Kvp8aBaWMIHuzXoMJObp3IEw20ekX4PwsXpetYBCBfPlMevYc1o6wUi/4ky2dQvyRos6bAfV4rvujdSwz5lmVVsEYZwi5RxH0Gs824fvcgqoo/Jrscp2Q+4qRwD4r4bvBG5b0suiwd8ORwRIcOcE7zy3dNC6ASjygQN4hWBxgO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765416057; c=relaxed/simple;
	bh=RPL2gSQ0HITBtieNdVNXNO558EclThGmelYePZPJ90M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P78K3UHinI+Bq4zF/9lQmDWoCmhOlatTgULdyyniG+l9nPPN1kTXU8fJ8WqgszLeM5fvngWn7sTNVUj9dnOGrsWcHNSz/62m434odC1pk7vDChtPnrCzH+V75aFZK3qYJmutmu0QhCzmnTHe+wCOTjhJ4StEPg6Hp1GORIEkNz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FfUh8vuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfUh8vuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65757C19422;
	Thu, 11 Dec 2025 01:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765416056;
	bh=RPL2gSQ0HITBtieNdVNXNO558EclThGmelYePZPJ90M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfUh8vucvxNnIFf/LTHchKtqKOdIIGXBkma40oZVP0OFlR6T7RfwOkonLGBxT3o15
	 gKCuKY0wp50ex7EkGdEGKKrNG301pIq+h9Eadd5GlGmV5WgJjxmEAkmdzarYQ8RUde
	 p+0hlY/kx87AWssVjB7wuDgRO+dVUcpM5zilhI1BOtcLmSIbAtA45BMyJsM6tuwxup
	 dHVP7xFp79e789OPQ/F0oQsFyNW8c6fwHa2G6z53K8TtrRIZ4Rd3oteVe9oPgozqtI
	 lweIf+z/gDrIk7SLogY0WxNbPeSg5xyw624e2xMhqGJ3FF0Q/ZnEmexWxo70L3BG2F
	 WTeKL3bN6Q8ZA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 08/12] crypto: adiantum - Use memcpy_{to,from}_sglist()
Date: Wed, 10 Dec 2025 17:18:40 -0800
Message-ID: <20251211011846.8179-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251211011846.8179-1-ebiggers@kernel.org>
References: <20251211011846.8179-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Call the newer, easier-to-read functions memcpy_to_sglist() and
memcpy_from_sglist() directly instead of calling
scatterwalk_map_and_copy().  No change in behavior.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/adiantum.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 519e95228ad8..6d882f926ab0 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -425,12 +425,12 @@ static int adiantum_finish(struct skcipher_request *req)
 		kunmap_local(virt);
 	} else {
 		/* Slow path that works for any destination scatterlist */
 		adiantum_hash_message(req, dst, &digest);
 		le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
-		scatterwalk_map_and_copy(&rctx->rbuf.bignum, dst,
-					 bulk_len, sizeof(le128), 1);
+		memcpy_to_sglist(dst, bulk_len, &rctx->rbuf.bignum,
+				 sizeof(le128));
 	}
 	return 0;
 }
 
 static void adiantum_streamcipher_done(void *data, int err)
@@ -475,12 +475,12 @@ static int adiantum_crypt(struct skcipher_request *req, bool enc)
 		memcpy(&rctx->rbuf.bignum, virt + bulk_len, sizeof(le128));
 		kunmap_local(virt);
 	} else {
 		/* Slow path that works for any source scatterlist */
 		adiantum_hash_message(req, src, &digest);
-		scatterwalk_map_and_copy(&rctx->rbuf.bignum, src,
-					 bulk_len, sizeof(le128), 0);
+		memcpy_from_sglist(&rctx->rbuf.bignum, src, bulk_len,
+				   sizeof(le128));
 	}
 	le128_add(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &rctx->header_hash);
 	le128_add(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
 
 	/* If encrypting, encrypt P_M with the block cipher to get C_M */
-- 
2.52.0

