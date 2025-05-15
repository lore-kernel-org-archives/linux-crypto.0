Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E4629616C
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 05:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747288496; cv=none; b=b3Bht7gf8C+h1azyiq1J1oxhLLmOvafwq+ZyvJNPC2iCU8qY6PiR3Fz2n22WI6Tze3oYnnA9spi7uN72EtS0ePsu9ycHglx9ERRMswz20P+pbifEi2ZysbmV4zqHMARAKTRlg+ZH8jjHCimwb2T4CCck3ia5JuhK8i9fqgr3irc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747288496; c=relaxed/simple;
	bh=II20/rpbcI0LTGpt7lICuhEPZCxcYFJ63Rnrv1Eg7kg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=qzxqjhc4TW8P88NRPzv7tCxgfwE88fNfl1soVs7i3lKGbJPJY6nCoYZ0N+Q6rVFXoX9Iy0aAkr71jkh+gg268G+TBIH5zUXVEvX+wteo0lkPKegVI9qbom3ud8z9r0Wb4RuXK8q8Pwa/O/I3/bTiJnEFJ3oXAcdjdATbmQ2+AbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=n47tJaVI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="n47tJaVI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=d8myHK+thtMJZ1PZgnpn4hqqWKKiBORHcPsenDRSBQY=; b=n47tJaVIjboOAlxzTiBFm4b+I9
	sOK/IXcQ4m9YNyvM0KCb3PSjCbeV3Iaqu29zy4INBRZGMLOIdKeGk+lFWuaGOsrPTwnfuh+9TZd9B
	OMN6M99dK7DWALg5ANwVLTypOxFXMUjZWoG8cHIH78vYwnmu58lu43XBLz2D602NSWDv01YjbhPgn
	o1zMC9Tuale/CmG8Cfl2m/Ih2o93wLCf5aAdY0B1eoqr7HyfL5HFscDChXoXMaY1Lz8oea0gM0SpC
	3VkfFugdLpVHMm/X0qEm/wRa/8XQwd/ziZi69BpYUAiQZaIKAy96ypoO7VQvrZcANPBkPPiNM6AGa
	tx+uG5Vg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFRYP-006Ecr-1Y;
	Thu, 15 May 2025 13:54:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 13:54:49 +0800
Date: Thu, 15 May 2025 13:54:49 +0800
Message-Id: <c9a0f91f11df042a9eb689e86bc96e4693d0b1a1.1747288315.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747288315.git.herbert@gondor.apana.org.au>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 08/11] crypto: testmgr - Ignore EEXIST on shash allocation
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Soon hmac will support ahash.  For compatibility hmac still supports
shash so it is possible for two hmac algorithms to be registered at
the same time.  The shash algorithm will have the driver name
"hmac-shash(XXX-driver)".  Due to a quirk in the API, there is no way
to locate the shash algorithm using the name "hmac(XXX-driver)".  It
has to be addressed as either "hmac(XXX)" or "hmac-shash(XXX-driver)".

Looking it up with "hmac(XXX-driver)" will simply trigger the creation
of another instance, and on the second instantiation this will fail
with EEXIST.

Catch the error EEXIST along with ENOENT since it is expected.

If a real shash algorithm came this way, it would be addressed using
the proper name "hmac-shash(XXX-driver)".

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index fc28000c27f5..ee682ad50e34 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1869,7 +1869,7 @@ static int alloc_shash(const char *driver, u32 type, u32 mask,
 
 	tfm = crypto_alloc_shash(driver, type, mask);
 	if (IS_ERR(tfm)) {
-		if (PTR_ERR(tfm) == -ENOENT) {
+		if (PTR_ERR(tfm) == -ENOENT || PTR_ERR(tfm) == -EEXIST) {
 			/*
 			 * This algorithm is only available through the ahash
 			 * API, not the shash API, so skip the shash tests.
-- 
2.39.5

