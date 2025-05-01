Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54962248AE
	for <linux-crypto@vger.kernel.org>; Thu,  1 May 2025 12:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746103058; cv=none; b=hadD1rwLNN7FrpM9V+SgszRa5yqP7QyUb8bRC0WMTlrhBEIkpdV0DG5A9mQdq/Du68MdiNNspOB5gVzTZSeJkqdNDGw81DZ5TsW8INymDZ26rnfdIDJaJ/lIVnYV2rr+6TE/9hwz7u6pZV4pM2vmOrkRfzZlFPh99qjxVO8QHCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746103058; c=relaxed/simple;
	bh=W2HUkw3YBx7Qd1iCrjXGH8Jo8OA9m64ohF6kXNHkwVc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=aEDA1D6nS4IPyrXxVqLOH8ZHyzZcodckciW+IEnUUJK1hcJ7BuY7ndHPGTbPtMFGNjPVwBc6t02FB1UPKArsd2+gt7fRiKVDSfZUhthjTgOmWd4SQbIyA7Og5ZNPxa8b5b3qxReU/MkoH/dF3mA1cqaiG+fvtDj+ePUohvi+OXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=U0vVjg3i; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="U0vVjg3i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5dIz5b7WcCLt4p5i2lsHoHnuE2nLHmE0hnLqMFtnS2E=; b=U0vVjg3if4wsiv2fwmaU1GHtWi
	W6Gf3PXSZvMYpIZkz2AH4gXJyQil4GHomDADoIBiJdphiHVCndMCj3LIzsf6+wVSwOU4DO1y3giMa
	pmBVBr5yzqgiS7mYiOJBN9Zl0KtjgKhGQV8koutmOgLHRqpCVeY5G91fSci+gJuFO+0UnaGHRTw2r
	NI7jbB8RKMpTtAhBsALUgrAndrIkbU3vjZGhtI0tr8JnXH6VDdSxWBiARgFbTrmDQ7joadY1TP5t6
	EbJsUTWAt3QSPCZlqc5MrU6msx8HqKiWHVdxvGqOMUQAhJ0gm72cP/j1MrKjh4qhPxli/9ocpJ0EO
	JT1oeD9A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uATAQ-002bEr-1h;
	Thu, 01 May 2025 20:37:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 May 2025 20:37:30 +0800
Date: Thu, 01 May 2025 20:37:30 +0800
Message-Id: <e4ca39a0ada7deaaf86dd1a40a717b30cc3e462f.1746102673.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746102673.git.herbert@gondor.apana.org.au>
References: <cover.1746102673.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/4] crypto: acomp - Clone folios properly
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The folios contain references to the request itself so they must
be setup again in the cloned request.

Fixes: 5f3437e9c89e ("crypto: acomp - Simplify folio handling")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c         | 18 ++++++++++++++++++
 include/crypto/acompress.h |  8 ++------
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 9dea76ed4513..6ecbfc49bfa8 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -566,5 +566,23 @@ int acomp_walk_virt(struct acomp_walk *__restrict walk,
 }
 EXPORT_SYMBOL_GPL(acomp_walk_virt);
 
+struct acomp_req *acomp_request_clone(struct acomp_req *req,
+				      size_t total, gfp_t gfp)
+{
+	struct acomp_req *nreq;
+
+	nreq = container_of(crypto_request_clone(&req->base, total, gfp),
+			    struct acomp_req, base);
+	if (nreq == req)
+		return req;
+
+	if (req->src == &req->chain.ssg)
+		nreq->src = &nreq->chain.ssg;
+	if (req->dst == &req->chain.dsg)
+		nreq->dst = &nreq->chain.dsg;
+	return nreq;
+}
+EXPORT_SYMBOL_GPL(acomp_request_clone);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous compression type");
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index f1812e92d3e3..9eacb9fa375d 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -551,11 +551,7 @@ static inline struct acomp_req *acomp_request_on_stack_init(
 	return req;
 }
 
-static inline struct acomp_req *acomp_request_clone(struct acomp_req *req,
-						    size_t total, gfp_t gfp)
-{
-	return container_of(crypto_request_clone(&req->base, total, gfp),
-			    struct acomp_req, base);
-}
+struct acomp_req *acomp_request_clone(struct acomp_req *req,
+				      size_t total, gfp_t gfp);
 
 #endif
-- 
2.39.5

