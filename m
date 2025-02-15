Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158E61537AC
	for <linux-crypto@vger.kernel.org>; Sat, 15 Feb 2025 00:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739581082; cv=none; b=cIv5sGPIkKpMdahe0k8qKgtW3e9/4l8Jeok3VaaENDLVu/w3A8o6yLNdQuwbCJR9gleYaYJQ4kybPU/EDshw/KNFLxMBf+PPtuhuXDXx+Hgs5d09gsR+XgeNUIDoUvpQf4CTUJhg13mGDpEafzbMpG3X0JfAQMgwE9ycuo5KGDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739581082; c=relaxed/simple;
	bh=7EkgeRkqQSKVjMmkjv8maCXbXIfoNO1G6FYyiRqjw/c=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mGq1KKEK3VyTmBgCXobBRtsynppMx2G2PHRevvKEydt73EvnYLt7S23B/G1aP9+fC+2597duK1kOcLZRcTzHXVjpPw0UTdZDISKaF/vimnYmVKx11m6zeuqfFZ3ngFnKP8bIWetPrKNoUyvsaIUdb/JttNmzu21LpqMJ2WyfpSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dUFCciIU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dUFCciIU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KA/h3qwOfcGJivcngbCDsIeZby/i1K8XRBlXUF18m3c=; b=dUFCciIUDdONlQaAnMTjnn/Q8W
	LiHcL+rTgObUjcanc8GL0+yzJpFVYTMHfV/zKIOSvQ2ozXI1ghx1Bx6uOrg4MA9W5i+CpVO2mUbm3
	QP4IgSvu27g1i2F7rPeZonep+woSqCYuG86igrTB6o9DJ0lg4DEsS97s7XV18GIrywSX9fZb3yQ3v
	R6hOUrsYqmnTNpmZJjaq5h4x2ECihaEt5DakXvVTebRCviCIJq6mqfpC7CKUB8k6F4HLTXvIGCgev
	6isAy21maXpOGSTi6aTSts+2shsABT46wGvVQEbApoHRiMz5W7DHJ3cYzt2TlQ0Ocx6FzhO+nG0pw
	8P04l9pg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tj6II-000TH1-2R;
	Sat, 15 Feb 2025 08:57:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Feb 2025 08:57:51 +0800
Date: Sat, 15 Feb 2025 08:57:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: skcipher - Zap type in crypto_alloc_sync_skcipher
Message-ID: <Z6_mj5mfTrB3X23s@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The type needs to be zeroed as otherwise the user could use it to
allocate an asynchronous sync skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index e3751cc88b76..cdf0f11c7eaa 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -682,6 +682,7 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 
 	/* Only sync algorithms allowed. */
 	mask |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE;
+	type &= ~(CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE);
 
 	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
