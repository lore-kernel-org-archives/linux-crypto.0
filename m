Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3683C18E023
	for <linux-crypto@vger.kernel.org>; Sat, 15 Mar 2025 08:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742026823; cv=none; b=bFJ4yQ6aRDsizNqW6jIakER7VxNnGSqsl4KKwAXSv6t1wxPC9R3XUgygY9204Lm/xf+rCCFMCHLG0F8y65k+Ns44z6fed37yeudtcIm1BEbipBRF7iCLxYJnXYcpzsD84lvdoBDB6hywxKQk9LoMPxXDq52CtHO4e6LGwyh0ksw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742026823; c=relaxed/simple;
	bh=egJTY7+D6DYO5KHqYDQrZcGakyrWRMxFls1SphJLVaU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UPUnZzkVaCTzIBZVWm9ePOJktVf83jMCFEO6nUTt8wnIHMHssZ4/j8GL23RWlrjNOmShrVrDEz45JOtImg/8Q8k5EwDSyOmTbI9iuZ/FoGmLcC9YVOugpW+7Qt7geJ1C02YB2r6e2ZeuD1XsKqMAkRDDjKUYUbwuXpReh8MFAB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ONO4+trX; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ONO4+trX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eErOw75KAdJiABA2j1FVGSvrf2rL7WyGXrFgJ2+IPPg=; b=ONO4+trXTXSLns+mEBXUKPIUXC
	sKkwINmULOf9a7k3XnrZub7tl9LBtyXVg+dMpN8GxpBLd5hPOIriUh5SS2nQX45byBS/vZVhuqG8E
	uD6JP8yiz6fGVYKI+6J4G5MrJ7fxeJq+eZ4tAqIdCwiPFM7a6jtdlUk266GrLbUacn1wworcbPyCJ
	FWJEQSNCJX5YtG+HELsXhWzUWzS21Ln99WSzktnBl/A/bG6Ga61wtOMF/0dRd24aPUuyGtBK/ieH4
	FvDC6ywU4qNw9q+PAM3lbeQIwh5sh/RhGv1RMU15lAocgX5auh30UJ8ptCkLBZytKHqgq8mnzw0TK
	XWL7BuXw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttMki-006nVd-13;
	Sat, 15 Mar 2025 16:20:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 16:20:16 +0800
Date: Sat, 15 Mar 2025 16:20:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: padlock - Use zero page instead of stack buffer
Message-ID: <Z9U4QKTQlZASDYRY@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Use desc instead of a stack buffer in the final function.  This
fixes a compiler warning about buf being uninitialised.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index 6865c7f1fc1a..db9e84c0c9fb 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -125,7 +125,7 @@ static int padlock_sha1_finup(struct shash_desc *desc, const u8 *in,
 
 static int padlock_sha1_final(struct shash_desc *desc, u8 *out)
 {
-	u8 buf[4];
+	const u8 *buf = (void *)desc;
 
 	return padlock_sha1_finup(desc, buf, 0, out);
 }
@@ -186,7 +186,7 @@ static int padlock_sha256_finup(struct shash_desc *desc, const u8 *in,
 
 static int padlock_sha256_final(struct shash_desc *desc, u8 *out)
 {
-	u8 buf[4];
+	const u8 *buf = (void *)desc;
 
 	return padlock_sha256_finup(desc, buf, 0, out);
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
