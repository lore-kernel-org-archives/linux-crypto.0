Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BE0347529
	for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2026 09:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774430487; cv=none; b=pNTkXWaV433hT60VNp469RgHoikQgudcScFCKvAatnHs99QSSPzFTmlzyH0oXWR7R+mEAh6u214Zqx9KSQRRnFY3PIDNmLcRRSk8BMIYJRf0ArbNQpR2X+G+lbh1zjCG3x5kw+xwXYbSdYhWRr7Z1PqSvoUHtRxIg+O6hv4X4as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774430487; c=relaxed/simple;
	bh=yn0STF3JWslMIFaEtKs2oeohCikAWPAxZo1+m2aeTBA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pkyTuryrZnm3vSSlM1Y3yUW5G7hZ6a9TUcEXQVeqhiac4Y5sKobyncJSnAU49AZv95jsw3tbOW4r6rEXC2RCrlxSLoF0tV5A6V4jxyiqADQWAu6ZXFXMexb19p6JKaGgHhOXFKMJKnNcnn2KonpUhjNShIX/8ASzZPmGuFfG4F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZTA3QvyD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZTA3QvyD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	Cc:To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=3pkRqEmiS6zscwY2U3KrqngeGwVsgNDqgY23jea2wvw=; b=ZTA3Q
	vyDACKEWkhz0VxElJcWQ1ce8bUrWof7Zbx7HQa/mk0fllE96JqTVksa2hmgiubMoYFzqHIIrjvDB2
	7rKrd1lQKndm49wKFPz11dTThZeArcz7WB6370TedmdbNkakFPJAFUSCEg+q0164XrHnkC2ubRzie
	7OnYwVsc3erZyMjz+Q1hYqmyktahDsJqQowJiFCKsMUDm29fP9JnWcTiEEaK3kbO3eAQ0jU5SndYs
	vB7AvSSPVLD9nsILHR7K1LQqb0MmaBLA0CcMRiauQEjIKz7wYTUWK6o+sShR49AhhT8J0iwkjpsGx
	QWp217x9tsne7/z9jps2x5FlSmzOA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5K0x-000vl4-0g;
	Wed, 25 Mar 2026 17:21:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 25 Mar 2026 18:21:18 +0900
Date: Wed, 25 Mar 2026 18:21:18 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Taeyang Lee <0wn@theori.io>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
	Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>,
	Jungwon Lim <setuid0@theori.io>
Subject: [PATCH] crypto: authencesn - Copy high sequence number from src
 after out-of-place decryption
Message-ID: <acOpDrnN3cVfiASk@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When decrypting data that is not in-place (src != dst), there is
no need to save the high-order sequence bits in dst as it could
simply be re-copied from the source.

Reported-by: Taeyang Lee <0wn@theori.io>
Fixes: 104880a6b470 ("crypto: authencesn - Convert to new AEAD interface")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 542a978663b9..fae8c1dbf495 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -215,9 +215,12 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 		goto decrypt;
 
 	/* Move high-order bits of sequence number back. */
-	scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
-	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
-	scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
+	if (req->src == dst) {
+		scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
+		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
+		scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
+	} else
+		memcpy_sglist(dst, req->src, 8);
 
 	if (crypto_memneq(ihash, ohash, authsize))
 		return -EBADMSG;
@@ -273,10 +276,12 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	if (!authsize)
 		goto tail;
 
-	/* Move high-order bits of sequence number to the end. */
 	scatterwalk_map_and_copy(tmp, dst, 0, 8, 0);
 	scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
-	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
+	if (req->src == dst) {
+		/* Move high-order bits of sequence number to the end. */
+		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
+	}
 
 	sg_init_table(areq_ctx->dst, 2);
 	dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
