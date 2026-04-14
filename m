Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAEA3ECBE2
	for <linux-crypto@vger.kernel.org>; Tue, 14 Apr 2026 15:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776181757; cv=none; b=hJg794bOBtt4dSm7ZPdAd2RO0eM0bb18VR8hpBX/7xKqlB1Oszk5HqClH+5yTGg7HRjlXu3h4NkPzv8tBeXksJH/dOe/AIWBU6zCWWbaTRRWMdcJ5gu07pgcIuBPruta4gB53YVhB8CUTYoy6Hitq/aCnito7/rx2HLXtDXCSQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776181757; c=relaxed/simple;
	bh=n5IsfSvnrPVD4uB+hqVze4rRUsdyQwzst7qfAMlJ/B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7YeJfuQBKWS6GDpghW9bvQ1CAPXKw9zFdyxDkvCgW/X+O6WAKh8a4uw21bXnMW2jvDE0ILDF0sZeblNkOpe1XX/wlCCi5ipKLCeMilssFcZmAoTfc2eMyz8MCdXoHOWgRfSiHE+0LrorddgVX1TxJqy7rfErDonUe958j7uM5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=maUosKMC; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="maUosKMC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776181753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EvsJVJbCCUKOEKS1D7OFE1Zq21OjUOHry61QdlDM9+Q=;
	b=maUosKMCwE7iN2MeXTlemn42HhRZ25//NWOM90idkCKKMaVmnVoC4VcTgBufMdkthhh4OT
	o3delW/ad3gUufJNzlSzThjXHOWDALhcQNNfNTTFZ6woylgJD73f/Bk1bn/iU9PMH1vjFI
	T7Isd1NPeYF7SdpeLb7scO5gPXRgbfE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: blake2s - use memcpy_and_pad in __blake2s_init
Date: Tue, 14 Apr 2026 17:49:04 +0200
Message-ID: <20260414154902.344182-4-thorsten.blum@linux.dev>
In-Reply-To: <20260414154902.344182-3-thorsten.blum@linux.dev>
References: <20260414154902.344182-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=883; i=thorsten.blum@linux.dev; h=from:subject; bh=n5IsfSvnrPVD4uB+hqVze4rRUsdyQwzst7qfAMlJ/B8=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJn3Et+390m6OW5zZfroYvzn/Z6q7mMXrogfU+9bHxM1T zVuvrRDRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAEzk6UWG/7W1v5Y3bmsXrMsy 2SGjbaF4r/77kcrXUxwWB310ZnsXXcbI0PPhw4Gey8ULFx9inBL5nOfwz68bnl1b8XZr9zzfvP0 vY7gA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use memcpy_and_pad() instead of memcpy() followed by memset() to
simplify __blake2s_init(). Use sizeof(ctx->buf) instead of the macro
BLAKE2S_BLOCK_SIZE.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 include/crypto/blake2s.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/crypto/blake2s.h b/include/crypto/blake2s.h
index 648cb7824358..f0e0ce0b30a5 100644
--- a/include/crypto/blake2s.h
+++ b/include/crypto/blake2s.h
@@ -70,9 +70,8 @@ static inline void __blake2s_init(struct blake2s_ctx *ctx, size_t outlen,
 	ctx->buflen = 0;
 	ctx->outlen = outlen;
 	if (keylen) {
-		memcpy(ctx->buf, key, keylen);
-		memset(&ctx->buf[keylen], 0, BLAKE2S_BLOCK_SIZE - keylen);
-		ctx->buflen = BLAKE2S_BLOCK_SIZE;
+		memcpy_and_pad(ctx->buf, sizeof(ctx->buf), key, keylen, 0);
+		ctx->buflen = sizeof(ctx->buf);
 	}
 }
 
