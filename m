Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5334CA5B
	for <linux-crypto@vger.kernel.org>; Fri, 15 Nov 2024 01:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731634151; cv=none; b=llnd7hVUBnLl8endfXXNIZL+fnWB+cCXLZSd3kR/mNYZChrfErRQgDS/fBBSOAUuqRsZGUyYKdfkgqCh+1PAfHecZUYeywgA3xwy+H+lKvmxsJSmKUNmtaSGRd0efTnQ8+iAJLVQsHcTRqrW/Nqbc171zqty0TI+pGhD4gwXeos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731634151; c=relaxed/simple;
	bh=mJruIYCuIn9dgb/2s4BsuChEgvvMfvFs/BOfHMZM740=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=K2wM5oq4Bsw0i3J5zTewvQWsXbQyD5bdhsdU0now7CkXAGM19nmqelRP200PYc7QV8/iEFS9tculCqftr2wLxsXfvE7QL3pe5ffzyGCTrbf/KOnbF1SbxxAOasydLI+OMs9J3GdO5w0Lnms3TWZAhDXg3YAgeQcPiNoQGmOUIZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rASwCIS0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rASwCIS0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BsGxYrudz0IEAupLOMEVIIiN+m4DjerWCEgLT1tVwgw=; b=rASwCIS0mcnqf/DxTv4UOE/c2g
	AhT+ZwmVggjzhdEGNBj2frAql76Q3C12eTKRXlbaQrFc97DmOMRGLjYBI/idcf3lVqdfy+SF4txIl
	9vgNPA8iEQekWxYpirRcrTQE5YxtjwMIq9zPStwgNDdA49ktjVA60ed8n4Dc/07EfT01rUH9iBXN2
	PARSiOq2UoAy8RAkEUmDkGvVdx/gix++pDEQS/Quh2u7qS4Etkv0IZ8gyPhVlsouviJxtV9D/gHDe
	DqH8cZgXiXAeosdm7Q2y80u874HSjP3dQTNBOvcGtrXn4SxOSTUZ8g18aBNIctqfp/6umKhJGI8Jv
	88IwW5CQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBl8w-00Gw9Z-2J;
	Fri, 15 Nov 2024 09:29:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Nov 2024 09:29:02 +0800
Date: Fri, 15 Nov 2024 09:29:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH 1/2] crypto: api - Fix boot-up self-test race
Message-ID: <Zzaj3v7uJDPartDY@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

During the boot process self-tests are postponed so that all
algorithms are registered when the test starts.  In the event
that algorithms are still being registered during these tests,
which can occur either because the algorithm is registered at
late_initcall, or because a self-test itself triggers the creation
of an instance, some self-tests may never start at all.

Fix this by setting the flag at the start of crypto_start_tests.

Note that this race is theoretical and has never been observed
in practice.

Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency failures")
Signed-off-by: Herbert Xu <herbert.xu@redhat.com>
---
 crypto/algapi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 004d27e41315..c067412d909a 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1022,6 +1022,8 @@ static void __init crypto_start_tests(void)
 	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
 		return;
 
+	set_crypto_boot_test_finished();
+
 	for (;;) {
 		struct crypto_larval *larval = NULL;
 		struct crypto_alg *q;
@@ -1053,8 +1055,6 @@ static void __init crypto_start_tests(void)
 		if (!larval)
 			break;
 	}
-
-	set_crypto_boot_test_finished();
 }
 
 static int __init crypto_algapi_init(void)
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
