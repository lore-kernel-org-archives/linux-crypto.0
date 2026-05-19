Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9262D3E0C73
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 08:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779179830; cv=none; b=U3UtcPuWEhs7k9Q9R9prVB0zmeNkUF7TQDK6XPM6+ZbGvVwdDjv7May3DZTMp3tKwgfHCheK9nRzMVLr+53RtRMczRo6lQOy1QKYJgcoTzO5LEsJDwWT/V9jFaW6Cv+d8q8GBr7+PH8CBLFllECJq2JTzDrDlgMnfu/InND65jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779179830; c=relaxed/simple;
	bh=GCvQcOIc7uJYALg92V3wlUU/hVuUxO2oyTfTVg30Ho4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eZgV3kAVj5k/4dGGD/r6K1AOXokLSDN1JsLKp2OcJ/ySJWNAVLQzdUu5H8BVqnC9jHrLdp9jTx2cLHrXDVX12Ch3dWXxTQIs4yXYYxBQL4eO66sU9ht1uKsClsNZkgHOckU0jHC8eepkQJNe30oxsi8XqCgmPmu7H52aTO9ye/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pduDY5g8; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pduDY5g8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779179825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9mcQY7rZXuAtUqvNRCppzSTuyCCLaeN800BOjkfvpJs=;
	b=pduDY5g8kpduMdZtx4SPIX1LvWO4t11VXAecXC+QH0u125UDk81tjlkBeZpyQjCLRgh9Rb
	Ki7xbws8y5g25/UbEAc9wrikpgFD4NaF0H2ooigozKJJJqhLVsG6dbgYdrVN5s+arE2oNU
	iAnwhPAwzp5IG4HuDkn/lDV6uSsRZWg=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ecrdsa - remove empty sig_alg exit callback
Date: Tue, 19 May 2026 10:36:32 +0200
Message-ID: <20260519083630.147673-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=953; i=thorsten.blum@linux.dev; h=from:subject; bh=GCvQcOIc7uJYALg92V3wlUU/hVuUxO2oyTfTVg30Ho4=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFk8inyW9feWMpktyJ9Q4NPX8jms/2cE04zOH7xli29mL HnOpb+zo5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACbyaxUjw5KvzPbepz1X1zM9 1N2bcTK29bfm3GiOmdr7m1IM/M3ynjL8lfCaf5g1fv70/XMdvk2UjJ3edz6y/a9E5Zrgyb+sEgr s2AA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

ecrdsa_exit_tfm() is empty, and sig_alg .exit is optional. The
corresponding .init callback is not set either, so there is nothing to
release in .exit.

Remove the empty function and leave .exit unset.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/ecrdsa.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/crypto/ecrdsa.c b/crypto/ecrdsa.c
index 2c0602f0cd40..4fb9906b47a8 100644
--- a/crypto/ecrdsa.c
+++ b/crypto/ecrdsa.c
@@ -259,16 +259,11 @@ static unsigned int ecrdsa_max_size(struct crypto_sig *tfm)
 	return 2 * ctx->pub_key.ndigits * sizeof(u64);
 }
 
-static void ecrdsa_exit_tfm(struct crypto_sig *tfm)
-{
-}
-
 static struct sig_alg ecrdsa_alg = {
 	.verify		= ecrdsa_verify,
 	.set_pub_key	= ecrdsa_set_pub_key,
 	.key_size	= ecrdsa_key_size,
 	.max_size	= ecrdsa_max_size,
-	.exit		= ecrdsa_exit_tfm,
 	.base = {
 		.cra_name	 = "ecrdsa",
 		.cra_driver_name = "ecrdsa-generic",
