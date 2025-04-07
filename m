Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5655E22B8BD
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020699; cv=none; b=PIwixM7LtVsxt5qtRbJxcX7SwT694iv2aol26bvrG34/E/I+16SBkhOb0rSJmBWl+KNxnOxSwTkCdFGiO9TE7ke0eKi1hxtH63XMtFOMLC0f+A0OaI6ffYdFGuppehnZF7V5o9DynrVSiqxCG0xjqQMsSfXtut+W1vHoXLopM8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020699; c=relaxed/simple;
	bh=mAiP4urg3AVun3S1xKgHb9Mkt7R+Ob4MeTbRpeN2Vb4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Vmlgnioawrar3Sp0sm3+odvfRJ3iSICuUwYziwXbpF/5nQdKeLKFNtdU7+5T37uPxWio717eIMtE5nxubCAPjHhq1kWUcN2jNYm7AlglVbPmQ7RNgCaCIgb+QgWwvm2dpMBkSTt03QwWjgOOu0GYIrQD/+BDnB4DfiEx2PIB3bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JUw6SRhF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JUw6SRhF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BfIYpwG92CbNGQiK/a0+oDUQE4+etx5QupT1pgI+Cxg=; b=JUw6SRhFcngx9VOnNm6wD3Ueru
	1QvgqjC63ryfvLA4jhHO6YsFTfdw6DuXpxmcb6CMNHgN1h5VLQ0s7Y4X+QU2QTuW7HG0ceft2ydbP
	QyR0Mgm9SFGguu4dpSq+q/qGLV0V9XLd+2dIQj/n6ETGiPgYmk1J5v4LPpQu35xS+ZGsS50Qg2ytz
	wyfx5mbogk/a7sBun48zRedGpO0/ef33QrUj6h9HzzLoG3XiHG1FHlcPuXfSax3CJ64wY+NgILdHk
	z6xY8dkf7JsnzgrhUKn//Oj3GbJjSGYhVXAHQIh+NhDY3qSZAygvk3cYUtI359jzmHITpO0xPTA7N
	iJrFYPWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jS1-00DTPr-17;
	Mon, 07 Apr 2025 18:11:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:11:33 +0800
Date: Mon, 07 Apr 2025 18:11:33 +0800
Message-Id: <4636885919935f7db91ee7a9346ca1dd728e5184.1744020575.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744020575.git.herbert@gondor.apana.org.au>
References: <cover.1744020575.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/4] crypto: ctr - Remove unnecessary header inclusions
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Now that the broken drivers have been fixed, remove the unnecessary
inclusions from crypto/ctr.h.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/ctr.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/crypto/ctr.h b/include/crypto/ctr.h
index c41685874f00..06984a26c8cf 100644
--- a/include/crypto/ctr.h
+++ b/include/crypto/ctr.h
@@ -8,9 +8,6 @@
 #ifndef _CRYPTO_CTR_H
 #define _CRYPTO_CTR_H
 
-#include <crypto/algapi.h>
-#include <crypto/internal/skcipher.h>
-
 #define CTR_RFC3686_NONCE_SIZE 4
 #define CTR_RFC3686_IV_SIZE 8
 #define CTR_RFC3686_BLOCK_SIZE 16
-- 
2.39.5

