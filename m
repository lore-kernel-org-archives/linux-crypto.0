Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3DB1C862C
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744455454; cv=none; b=r4jsZKN3CQTOy/ySgsl1cUWoOaL6g26okngQ/79gwF/cEIGw1J/eH1QyFkoaulPN6ODn2PuLeY6AYGYiw9NhQImxASm/UZJMrJT9mcq+Np/l9FG/80fKpHlEKebNL4AXoBv6hFWqr2Qmv/8VAfTUu8xTBZVIX1b5DVdYeFlRa9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744455454; c=relaxed/simple;
	bh=TICBul3ZVbzXcYd8XOyqDrPcDSmHoUfoXxe/lSts/U4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Rmsux99sShz025QZGmANXhcvZp0siYpzMWZPbqQjInP3CzbghTb1P8P32W9khb+en1bzCzb97aspPMAzXjqaC3a8yPn89G5hXEQowGA9XLk0xkc4+4yND3GZB7lE862xeIMu9EduJxxoJaMXg7AX1+xAgGrQzIytjaesbhKRAzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rqCiawnB; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rqCiawnB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=22NcjylCx8p1fMvXd0Y2Zf903nsMaK2PYykk0v3nR60=; b=rqCiawnByivU60HDM5sOM/zXKj
	WeM+dkZxPzqbBQjI9qMLgj8NnU5XN6H4Cvsy39aKmUWvk7/3PjiZjF147kKupnsSsZD/5PNhWmKrH
	PjHhHU0Maj/YhGhw1mZwWrUH1olqP8xFs6c2Mv8ggdhd01HYWfj+4v6fGRGvterm2SOXyq9WRkHE2
	xTar2ugnu1at4Hln7FZ4s+K08gDeb/ER+RtQsJxITMTJ44o4PiBJzbmtYj6t2j2DqlR2LRFL4mYgW
	JSxd1dBl2yBcL2q5LlXyHR6jnfiU2o3vkcdl5syH0MXCXHiXHy+SmSum+4q7M0fFHSExW5VWJbfwY
	6UZb08SA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YYA-00F5KQ-2u;
	Sat, 12 Apr 2025 18:57:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:57:26 +0800
Date: Sat, 12 Apr 2025 18:57:26 +0800
Message-Id: <eaa0a6cc57d9dd33e7db0651f4fa0fb4203115c6.1744455146.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744455146.git.herbert@gondor.apana.org.au>
References: <cover.1744455146.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/8] crypto: hash - Update HASH_MAX_DESCSIZE comment
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The biggest context is not sha3_generic (356), but sha-s390 (360).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/hash.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index b00ea8407f9c..58ac1423dc38 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -166,8 +166,8 @@ struct shash_desc {
 #define HASH_MAX_DIGESTSIZE	 64
 
 /*
- * Worst case is hmac(sha3-224-generic).  Its context is a nested 'shash_desc'
- * containing a 'struct sha3_state'.
+ * Worst case is hmac(sha-224-s390).  Its context is a nested 'shash_desc'
+ * containing a 'struct s390_sha_ctx'.
  */
 #define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
 #define MAX_SYNC_HASH_REQSIZE	HASH_MAX_DESCSIZE
-- 
2.39.5

