Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B27221265;
	Thu, 26 Mar 2026 00:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774484208; cv=none; b=CaNqwApdXuxiLoqQiOKgO5rG8aWG17Gmph2hUMq5E4ople9G84xkVER13rEtTJKx16Igp4aw3TQ+yZ4GCbHQnd/E3i0znsPo80NYbSxcOagwzs/7IaOKUEOczoqzT3mKh9zJaArBP8W4eOkU7Ss84SyOCsN2GFpmu69gTBtCuX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774484208; c=relaxed/simple;
	bh=sojBVU+n/lh4z69QXDRmOJO6HdoihT5ieXlPORpissI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuKAYbcoepjg6Z8wIwc+PH60fmEFoDFq5N4tnR4KNeVA/wh83zDtPOhBOCoo4tngUb97qR5kki6zmTBi9igvJbTvSwoQuZDesl/bP3d+M3JJw6LtIa56QGhyblpb3I3833FURpEDoa0KyTp14KqgoJh/LPIqjjGZucZaywKLPHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PbUAcGHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PbUAcGHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC11C4CEF7;
	Thu, 26 Mar 2026 00:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774484208;
	bh=sojBVU+n/lh4z69QXDRmOJO6HdoihT5ieXlPORpissI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbUAcGHVHXoaqKIPMjTJwR1z7MBiLmOsKv/CW8+7yQEqLDLZwj6+NRUNSPs9BLg+d
	 GKK+VgfsYoQlaIJupWAWrlGAxCCsTT8tsDYBAyCpieZ+YiWQtSSTpxZGEiQF/8raAQ
	 Kj7t7dpLexlVCju3uCXHaKpTYphZDuLmY2lsvmXQgN6L3qFycgX76/a8HVH+Rapdqa
	 CYTzohbK/qHd0U4baL1CPxQfwV3pXS93xg9Lw/U8Zr7ctfgN9HImb3Q8AOOifg5hV1
	 N2e+rW+wYkvP63tUs6cq1pDhgOcQkqlWlotp1k6M3k9lstBJa7o6lK4xpDNOTGLecr
	 0XsN3BWFsj/Bw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Stephan Mueller <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 05/11] crypto: hisilicon/hpre - Use crypto_stdrng_get_bytes()
Date: Wed, 25 Mar 2026 17:15:01 -0700
Message-ID: <20260326001507.66500-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260326001507.66500-1-ebiggers@kernel.org>
References: <20260326001507.66500-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the sequence of crypto_get_default_rng(),
crypto_rng_get_bytes(), and crypto_put_default_rng() with the equivalent
helper function crypto_stdrng_get_bytes().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 839c1f677143..09077abbf6ad 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1325,21 +1325,13 @@ static bool hpre_key_is_zero(const char *key, unsigned short key_sz)
 static int ecdh_gen_privkey(struct hpre_ctx *ctx, struct ecdh *params)
 {
 	struct device *dev = ctx->dev;
 	int ret;
 
-	ret = crypto_get_default_rng();
-	if (ret) {
-		dev_err(dev, "failed to get default rng, ret = %d!\n", ret);
-		return ret;
-	}
-
-	ret = crypto_rng_get_bytes(crypto_default_rng, (u8 *)params->key,
-				   params->key_size);
-	crypto_put_default_rng();
+	ret = crypto_stdrng_get_bytes(params->key, params->key_size);
 	if (ret)
-		dev_err(dev, "failed to get rng, ret = %d!\n", ret);
+		dev_err(dev, "failed to get random bytes, ret = %d!\n", ret);
 
 	return ret;
 }
 
 static int hpre_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
-- 
2.53.0

