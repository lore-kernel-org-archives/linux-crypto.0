Received: from mta0.migadu.com (out-17.mta0.migadu.com [91.218.175.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5905B5187E6
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 15:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904264; cv=none; b=OvPOnA9ViTmTLGeXepzPrCGXhBd7cRWwgHFQdQPsynoGTPMdrckCjzGhFbKN4gNV+tmeCuw0Y52d4/eONgdbI0wYnoVq21dW2u5WQkeWcG4bIcqz04dfwd1R1uf1njDbIrJXUGoEwBG5GtFL/oxQP0vUxQpzxEagtlW0Y+6ivkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904264; c=relaxed/simple;
	bh=FFUgdh8idoo7uPYiHxk4YzUlj0DtXIIOClOikNHRtTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+a+zV9y5hQHi9TRHEyzRn/XLV9DV7BOplNTdiFNwAdp1wC/oeHsx1EkG8UPAoKFv5DSKjGLU60YVfKoto23BHoSFApGUDH0sh2qkePiUse9m0AjqgCAtsuz6GDlGu3dg2Fe6eYdrZk5ZLj5CtfMEHElq5swZMP9iVSEm4EfRh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uDdPwzp1; arc=none smtp.client-ip=91.218.175.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uDdPwzp1"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FFUgdh8idoo7uPYiHxk4YzUlj0DtXIIOClOikNHRtTI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791904257; v=1; x=1792509057;
 b=uDdPwzp1nZ2H0MxTE4jLkJq1QzZbVrM9V8AQ4PiH38KsRVrZ/REP/9cgY/TB+JBWCYTD4UbL
 DY6JD6tIoArrMBFiAVpSTFmK0G+APxsYf7dKijpyPl4WPoxKGBG5LYbcOxCojceEla/Ses5jSPD
 Paj3VDozNRvFMme1/7hoxzp4=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id a950323d0bec7872;
	Tue, 13 Oct 2026 15:10:57 +0000
X-Mizu-Trace-ID: a950323d0bec7872
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	chengming.zhou@linux.dev,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	terrelln@fb.com,
	yosry@kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	senozhatsky@chromium.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 2/3] crypto: acomp - enforce MAX_SYNC_COMP_REQSIZE
Date: Tue, 13 Oct 2026 08:09:36 -0700
Message-ID: <20261013151007.2093943-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013151007.2093943-1-usama.arif@linux.dev>
References: <20261013151007.2093943-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

Enforce the limit MAX_SYNC_COMP_REQSIZE when an acomp tfm is
initialised.  All existing algorithms obey this limit.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 crypto/acompress.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 4de1a2ad577f2..c8b4b8589769e 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -92,10 +92,6 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 		if (IS_ERR(fb))
 			return PTR_ERR(fb);
 
-		err = -EINVAL;
-		if (crypto_acomp_reqsize(fb) > MAX_SYNC_COMP_REQSIZE)
-			goto out_free_fb;
-
 		tfm->fb = crypto_acomp_tfm(fb);
 	}
 
@@ -105,15 +101,19 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->base.exit = crypto_acomp_exit_tfm;
 
-	if (!alg->init)
-		return 0;
-
-	err = alg->init(acomp);
-	if (err)
+	if (alg->init && ((err = alg->init(acomp))))
 		goto out_free_fb;
 
+	err = -EINVAL;
+	if (!acomp_is_async(acomp) &&
+	    crypto_acomp_reqsize(acomp) > MAX_SYNC_COMP_REQSIZE)
+		goto out_exit_tfm;
+
 	return 0;
 
+out_exit_tfm:
+	if (alg->exit)
+		alg->exit(acomp);
 out_free_fb:
 	crypto_free_acomp(fb);
 	return err;
-- 
2.53.0-Meta

