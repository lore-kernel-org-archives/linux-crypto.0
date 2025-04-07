Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E003C230BE3
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744021267; cv=none; b=trlaLJK+LnVhNk1KGJ1xLqShFVzrvlRXBHfykz+0K315OuM69fqF4S4CvB4FVdw8dImj3LLEdxREecka6YR2ApkNUg01gJ327ru3jZmJasibn/TYgWmAe4eS8fsvxVErWGrFEkpbC8xPv8FilHrk2ycEUtFlZEKqug6MqzRl6Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744021267; c=relaxed/simple;
	bh=9z13El3WLTq8ZPzfmODB69twlAtFg/HKzUcU4ZqN1dE=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=szIeDwii90HpJ/nq0XkY3SxWGDYM3iBfKwHYOA9VQHy4VAi48i5oVMOXXVJTbYzwAJQM1ayevMe4xohW+k8A8g22PB9gtD2p0li40JMbdMMBCOs3Tkwqh9cRbGzl+MdBzhuo4JAYvlqv/5rHp/PaHqpgXLiGPi0ipMOOGEYRgxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=I15lwbBB; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="I15lwbBB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6qnutAKvOmfh9d7Y4qdzWEw67ruDSNNeLBCA82wqwG4=; b=I15lwbBBfmpgAtyauo/DJAxQQp
	eIZdbe7cfFoA5bOt+M1NlVk4Tet7GZa80odnJo5v2RZUbZkJhrQEyTSETr9Oz4Akz1y37q7kril8t
	XDzSGmxH6W5gQsWAskEsNWOcoRKHhS5bWEAu9EM6GDHla7kybhZxYcWhE/kh9VkFwkn9hxzY9SUD7
	t3ps2Nyo0VwTj/YOaFj/j9phWhbsmSsPNnvjlxYoOXS4L/Fk66tCu4LdBaTl3XQwIOrZmgZY4QC5n
	UPHj6lWo/9m42rU+DhrSiKG/aDSeCWKiaoWUKyxdHHCXGj6AaKyJYR34HT9YXXhyiuT7lPFqaMFIf
	se2txeVg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jbC-00DTZN-0P;
	Mon, 07 Apr 2025 18:21:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:21:02 +0800
Date: Mon, 07 Apr 2025 18:21:02 +0800
Message-Id: <1ac9d6c87fda00d0bdff38982e7d4ccbb5fe1f7a.1744021074.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744021074.git.herbert@gondor.apana.org.au>
References: <cover.1744021074.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/7] crypto: acomp - Use cra_reqsize
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the common reqsize if present.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 869c926d3986..e9406eb8fcf4 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -109,7 +109,7 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
-	acomp->reqsize = alg->reqsize;
+	acomp->reqsize = alg->base.cra_reqsize ?: alg->reqsize;
 
 	acomp->base.exit = crypto_acomp_exit_tfm;
 
-- 
2.39.5

