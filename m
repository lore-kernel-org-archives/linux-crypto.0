Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6771822FE07
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 09:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744018419; cv=none; b=VlXrNl6Mb/oQSdcAFRqeftA/g8hANuen7xJ0vFLDx+JPfSLAZsnNpe61V8cX6XCZAiiKbAljvWb3BX3ANVYPDXJ3Hw91Ov1EFyAyYQ3Q5E+Gb3cXtWL1ZnFMvNp0CZkyYGxrd2PJ6R8fevrV3MKGd8C65+ftDiZqFROKumLoDPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744018419; c=relaxed/simple;
	bh=WUxOZvadLtgkPIz6Xp2EtMpEfbERQGn8icbPPFy7830=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=QMcU9lU5PS/UFJIiQe2sqa5NDhFKhOKSFLg/r2f28bvXVpepf0dPpz4VIlDEFpsmRvtnAQCdEqUih+9kROhpdfNq6u4sZQxAyKEj/bPniZV44mPey5vU/AUhD7ztW4HR0LeYpinZlt18ajawI+hlbg3XUVR9isE7d+D/act8FVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JKjWjXwJ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JKjWjXwJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tQon+Yp20tZZlVMJBlYpZznZt+FTgcyNGSbHVn2edS0=; b=JKjWjXwJqiyUXAYjnu82a6Vsfv
	xGu9Cn+5mQMzQ5m7HDfMVY1tMOPP112YER1TUmEQy73FYbYV8cVgxiimIPg/o2zE+uAAOgx/7JdKN
	WMCii6JA4YPMSgb3+UPwJrCBwk0Ec3lXknEbEoyB0l/o3ZO3i7STOflh13mZi7juVzERktp3SHxsT
	XqtAOcSLqiSLTwm0/vMmMJG6r3Sh4qjIhURPsHez18SR3YS1lB2rZ1R7CCwkutrBl82DDxfLv7BQ/
	Ii3/H905FUlxQp+ICRAgJfcHAbMVRgWi6ZWcRS6yO0pG/eMlJJeqyIvMstXHlurRsmjy27XfIXEpG
	LuCcfeZA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1irE-00DR0P-0A;
	Mon, 07 Apr 2025 17:33:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 17:33:32 +0800
Date: Mon, 07 Apr 2025 17:33:32 +0800
Message-Id: <06c1b24589e9df902e201216f010e69b68c39439.1744018301.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744018301.git.herbert@gondor.apana.org.au>
References: <cover.1744018301.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/5] crypto: deflate - Remove request chaining
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove request chaining support from deflate.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/deflate.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index bc76c343a0cf..57d7af4dfdfb 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -111,7 +111,6 @@ static int deflate_compress(struct acomp_req *req)
 {
 	struct crypto_acomp_stream *s;
 	struct deflate_stream *ds;
-	struct acomp_req *r2;
 	int err;
 
 	s = crypto_acomp_lock_stream_bh(&deflate_streams);
@@ -126,12 +125,6 @@ static int deflate_compress(struct acomp_req *req)
 	}
 
 	err = deflate_compress_one(req, ds);
-	req->base.err = err;
-
-	list_for_each_entry(r2, &req->base.list, base.list) {
-		zlib_deflateReset(&ds->stream);
-		r2->base.err = deflate_compress_one(r2, ds);
-	}
 
 out:
 	crypto_acomp_unlock_stream_bh(s);
@@ -199,7 +192,6 @@ static int deflate_decompress(struct acomp_req *req)
 {
 	struct crypto_acomp_stream *s;
 	struct deflate_stream *ds;
-	struct acomp_req *r2;
 	int err;
 
 	s = crypto_acomp_lock_stream_bh(&deflate_streams);
@@ -212,12 +204,6 @@ static int deflate_decompress(struct acomp_req *req)
 	}
 
 	err = deflate_decompress_one(req, ds);
-	req->base.err = err;
-
-	list_for_each_entry(r2, &req->base.list, base.list) {
-		zlib_inflateReset(&ds->stream);
-		r2->base.err = deflate_decompress_one(r2, ds);
-	}
 
 out:
 	crypto_acomp_unlock_stream_bh(s);
-- 
2.39.5

