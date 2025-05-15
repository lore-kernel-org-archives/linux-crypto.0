Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AAB1DF97D
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 08:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747298051; cv=none; b=FBjfVE88xbyzSN3vabDIgJTvwr6j/UP1OItZbhpO7GcIr4BaAwtpxSgRPgJl9Da0dyMKMiFgMRShfbqvLM43l8SrsSobTWW+YfV5em+l+cxLh9Yzw5E2DyHlAQEAslsOEcUABjHL9gSrEfrzIA981Pxk0Wa6zFXvWH0V0I7Q8ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747298051; c=relaxed/simple;
	bh=3x3OqQpZONfNmAOxuChncSA5wVZEapCE7dlrqRdjjGU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sha8evG5gwD8tBBn/sWJp+U56jgxHnnSO44isTXNVzWf31SIZtLDyiwmOY1IK7ksVoFy69yPjGwQtz9U7+H69TH97cR0+W4O/qsruidnks6JDt53qyGX0d2iNgkwgHd6VPaDiQq7+ZXCPTkUryrCCEbrJdAhL2Eaq18mexS+Svc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UtQhcub5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UtQhcub5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VZv8GBSBQESUJlZIBJnzPmdqWJbNAFRSEGoJxOmpoGA=; b=UtQhcub5ETDJKI9dPWbcQk3R1W
	oG+WjbsmwMoEJGqm7RjlRfFfYDMp10N/yY8YFtR++Rs+TjF2MhY3Z4Gawv4QKR2zAy5ztiEQgFJ66
	a4EgmSz0szUMzyjA6uAl+No5ezw+d1UW7h/hsE4/417UEOX4YAKuH3holcJgyHpia5DAAxWlxWx6z
	L6Q/SlF06OfmkQboUnRAqi88n4ycabpAyj9FxTnQxjNqMYuE7DeswDGFkP4TSn5p+yK+QPGUVNFUC
	6lkh639v04nnR1J5kCcvLJIBTBC/jOLm8D7evX9HRse7yPdwJDOCxhWXH5d1b1uoGXtVYkedaJW6M
	B+EvkYbA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFU2W-006GRF-0y;
	Thu, 15 May 2025 16:34:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 16:34:04 +0800
Date: Thu, 15 May 2025 16:34:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: xts - Only add ecb if it is not already there
Message-ID: <aCWm_B_0eP11Y5Mh@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Only add ecb to the cipher name if it isn't already ecb.

Also use memcmp instead of strncmp since these strings are all
stored in an array of length CRYPTO_MAX_ALG_NAME.

Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/xts.c b/crypto/xts.c
index 1a9edd55a3a2..3da8f5e053d6 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -363,7 +363,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
 				   cipher_name, 0, mask);
-	if (err == -ENOENT) {
+	if (err == -ENOENT && memcmp(cipher_name, "ecb(", 4)) {
 		err = -ENAMETOOLONG;
 		if (snprintf(name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
@@ -397,7 +397,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	/* Alas we screwed up the naming so we have to mangle the
 	 * cipher name.
 	 */
-	if (!strncmp(cipher_name, "ecb(", 4)) {
+	if (!memcmp(cipher_name, "ecb(", 4)) {
 		int len;
 
 		len = strscpy(name, cipher_name + 4, sizeof(name));
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
