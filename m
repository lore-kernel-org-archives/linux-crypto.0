Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAAB44C76
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734792754; cv=none; b=NGlw25XOSlLGh15PUmD6csTq5dU8w5phVM8QwgxqfwUCUVkoW2qfLF6fYQaU4u6w7yC89XFK6EmRrPJub2lPIwPdW48WVsUzV0mwSq/YMsogMnxoBLuAGmLHXAQnC3B0cu3+06UVanQMZ92MtJgh40NBehjwnDxGUwvvmKUgRX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734792754; c=relaxed/simple;
	bh=gHdJ1xWf7CyoxMCesqZJNG6kmBxDHFGokr4Ks915W9I=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lWihdQGcEvQZ7+j5FS3T2MhLswEIshJFmrILkCIEisJsXgHTxptEdHQuL1XtwfFxylrSULg4uUN+gfrofP4qhlVpbnfw4UIzGTzF0XDb+1ZsiucLb5+t5yO5TGcV0NgDswZQHjJvSHaKGglpV0VjrL4G5nAZgOmlhkGhVF48iGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cHojJd7e; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cHojJd7e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sZ0/P7zPTiKPipgxg3S5MebDjclY7rtJBOThuVQYVEc=; b=cHojJd7eBigCeDoKE93aEtQvrP
	Gdhyk/qOUTy6z9kvXC2hwdPIS2w2Mgb2IQA+HOzoUcRCGReV2LBzCBejtEVAa+DKG08KJp7QPbiLt
	lPOwzQTwe3ceewfyiaLKsKzqi7/HaY+4fotsVju1ULGRutpz+flzpUXn00EGsG1cvGoL0GBUh2ECQ
	TSrOLNcf3p6cMWKPo1LkhdXx6IKvfpkDSllmv9oSEb+zdKck3n2c7DAbY8vvgwA/mf1js8y4oQHLe
	tfK3X9H1iNISdMJPGVZvBeuvO/aenohvEeJvMyGy224J9Hrlgmise/huuHoEGoEfpT191TDsH/RpQ
	0kHzqDEw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tP0dG-002RMZ-2N;
	Sat, 21 Dec 2024 22:52:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Dec 2024 22:52:27 +0800
Date: Sat, 21 Dec 2024 22:52:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: lib/aesgcm - Reduce stack usage in libaesgcm_init
Message-ID: <Z2bWK_JKxKvwOpTM@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The stack frame in libaesgcm_init triggers a size warning on x86-64.
Reduce it by making buf static.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/crypto/aesgcm.c b/lib/crypto/aesgcm.c
index 6bba6473fdf3..902e49410aaf 100644
--- a/lib/crypto/aesgcm.c
+++ b/lib/crypto/aesgcm.c
@@ -697,7 +697,7 @@ static int __init libaesgcm_init(void)
 		u8 tagbuf[AES_BLOCK_SIZE];
 		int plen = aesgcm_tv[i].plen;
 		struct aesgcm_ctx ctx;
-		u8 buf[sizeof(ptext12)];
+		static u8 buf[sizeof(ptext12)];
 
 		if (aesgcm_expandkey(&ctx, aesgcm_tv[i].key, aesgcm_tv[i].klen,
 				     aesgcm_tv[i].clen - plen)) {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
