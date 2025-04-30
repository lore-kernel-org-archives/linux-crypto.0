Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58281E5B6F
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993192; cv=none; b=AwNkeK9bWsesUaseKi9cqMS+IjMR0aQYx6MKKxOyDKnFFZBW0T9HbiMT+AQCX/Pskj6t4l4eSEAk9ISG9Sg5H70mpEc10j8rbh0rDkwnfjUH+8Y0DnraZZwzixzrhnfVREY1UZFigHowCEYfE5uY56VX7e24nuk98GzLdXrZzx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993192; c=relaxed/simple;
	bh=ALF9qPUS5vaA3N8E8k5SzFAt7QUaPMqENaupJeXtzMk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=bzk4Z/ER5dOBPU764RmHvITLtCEDjL8FvAE05HR6mecLxkndBkOPTDQySPkdIHiGk6ifdRMrxU7t+fPDcWmf6FpJul5wwKvOI8LbfwQDci3ky1euhiNkZxE/dBRAFMVxupFFzc/zCCYSDRDEWtHi4tyUJyAnUMOcemH9Nn8OnwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PuZP+F16; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PuZP+F16"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EElinbQbqiQQl1WPU4oT4dV1pS7Ei2osLwBmNnnvQIQ=; b=PuZP+F16k29qyQ60EKu2YZQniV
	1wkQVIoVfSF9gl9VTrsSGvFs2jSkWtJQeERZEwfEFB0LqZFuD78mmkNN7SGkngGZnFh9cdFaOc9mi
	6sAusRc2FE4AnW7UUkRsnUxOAOejPsUXcEc3yLKnExQSTAxASQxkw6EEio9J7QLnV60YqPHFOC075
	5ihayjtr6moXRrfc0BhFaOdRCtkwDyWkNKghp2nxchy4DshbI0uu5eXdUV1xrYXn2BtsqE6jJhGXm
	fz6jthPoxTbl9yDinQnHU1pIIh9FHtkcu8htaNBWCLEtwGcq+zc4j05LAMONCIUbJhAeYUOf7zd04
	bcgm1+yA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0aQ-002AaN-2I;
	Wed, 30 Apr 2025 14:06:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:26 +0800
Date: Wed, 30 Apr 2025 14:06:26 +0800
Message-Id: <dbaff98b5fd78c3bbc962ee4b87db6924111157f.1745992998.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745992998.git.herbert@gondor.apana.org.au>
References: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 05/12] crypto: mips/sha256 - Export block functions as GPL
 only
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Export the block functions as GPL only, there is no reason
to let arbitrary modules use these internal functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/mips/cavium-octeon/crypto/octeon-sha256.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/cavium-octeon/crypto/octeon-sha256.c b/arch/mips/cavium-octeon/crypto/octeon-sha256.c
index f169054852bc..f93faaf1f4af 100644
--- a/arch/mips/cavium-octeon/crypto/octeon-sha256.c
+++ b/arch/mips/cavium-octeon/crypto/octeon-sha256.c
@@ -60,13 +60,13 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 	state64[3] = read_octeon_64bit_hash_dword(3);
 	octeon_crypto_disable(&cop2_state, flags);
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	return octeon_has_crypto();
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA-256 Secure Hash Algorithm (OCTEON)");
-- 
2.39.5

