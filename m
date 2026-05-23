Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F5E29DB6E
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779549116; cv=none; b=lbPQD6LyX+g8ZXOfVNQoOoZYT4q43Bnwy78XNwNzyY09ZSQ5uh6+5qKxr/FKwrFrJyagPZNT3SQ1uv5TBmi/5D0ZtWyd9E+/O/UsEPfWHPu1VEEKUOMkyK+tHxRvqx2RNch/JZGExs2CTBb60YjxtRwvoAv7x4DsHMK+sRkmYOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779549116; c=relaxed/simple;
	bh=mhZ5EgYm1uEO8wYkbnknTvEBKv+Yz2a/FMmsfjr4Qfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECKoYwTpq+RPW+NKDAzeCTPZk3VoIF3YkGwfTjk56rSFXdTrKOupTlWBsqyJPnvIo7QCKdSxy4h1HfwlsNgKgJIV/brKLOkurCQq7dICix2Mm0yYhY+WLK2+xeUPge0twkL3bFzeXlUhty4tx3UuwQ42cDQDN2N7Dj9xq9tDQis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bgj8APO6; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bgj8APO6"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4891d7164ddso41561045e9.3
        for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 08:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779549114; x=1780153914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cw7XVcaORy+d/dFYODK+UOJC8GePay1GtMpoNR5qLgs=;
        b=bgj8APO6qmhkcJ6z3WJTrqZZ+mI1ArCcEY4KVDF2OPwrrsvA19Nn+ERz+rdLua9CY6
         3FMwtgPa7vBpkWdIPcOvTHCnIZ8PkLusNK/NJ/YNFizal5MSimV0lc08R4kdPIWyJL2a
         7mr2uFsoJRncUdQjRFDxDpkWFxG0por0ABt4ZHgqdb4vXdQJq1oNIji4Wbe9XziqkVfn
         ol0w2mtRUbwXHuWoFyYLxZJa6cmL3z3srzfm+0bq2SLtqkvKn+/jVRacIDeQa7fptJRA
         tz/ZxpOUeJPRCMgrCQlQPQ9MzVe44z1vraqD/ujy6sfdvU8Ip68UxYAZucg8UZpRai2z
         kEfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779549114; x=1780153914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cw7XVcaORy+d/dFYODK+UOJC8GePay1GtMpoNR5qLgs=;
        b=PAYfYT3bA8FHKJHqT2HUGCeBMgI9LDioqKVfGtjDcgsFfiIb+2zQ4fcLv+SVpULtRb
         7awhmL16+qact4zSNAcw4HlBS4H5gGNzkZybil3c096Ai5SrLyqnI9Gn4+o7baxRb9Um
         AjrT3V4fCQC3s9F/o4tWKvWP+1x7ejxH01uy6mma1yEDRn4kyIiu7/fKi/jz+3g8uHSd
         PDCCkHy9LekuUO6d6UO7PxDIBnmVTGyZXvWWiM3Gqol/UA9O7WUA16DMM8F7uhks1dhD
         GQTJS8nDRef3VZjhBKY+pDlrCNnLMwbP32I6KK0D2YL8Mc8/jx7XzZp6vNsN0aSBIt5W
         HFhA==
X-Forwarded-Encrypted: i=1; AFNElJ80/atZz31FiOei2EdPqQcgdRTfTEiw9Qskkon0rYuqRlq2lvsoZVfhavTTlWA8X0BjgXHVpLk9+ZuBuVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRAOylyVqT1Hgd9uFZ+W7LmKPpO36Ha38EMyUIcZJTiAlEfUcj
	LBo9A1bE3d3uhjFaL+XLWaSB6BW5W0JY5jFhUnsjINmvruN6rIUTBfMh
X-Gm-Gg: Acq92OFX+4NWUZJ7FUz5s0rMdN6m1KqsyiVW8QYWmRvi9fF3m29YpNoMCILIkOMDMwK
	EgOpkW8ZOTcA8EMWLNylYUKuUGZm8YdkbOsTpgwyer6hxQB0oivevbuKHT3hwWy134vCmq0Hl/B
	JeDYK4PlCPlrEmCVmYmVzBioukH0up6N2xXvHAlFaC562nuNeycfwQnTPBB4OWYNOlHlKEgiGVB
	1RhDss8rONaAI2ZOE7U0DzDBd6U8cUsdFkleXS4mMFIW1EpuWdJ0DVuoRmMcBDzDsPhzx/VlUTX
	cfB+ILZax4TtKFXoKnic7IxrYqgRJ832lWJMCZwJWnjZDkudzH8mtvh1Af6YhpGXCl/O65yTfHx
	QuTKXt8TYUVYYkBLqt7vi/JSi7NhAUF6fSow7y76Q4NZf0ILDL9OuVnsULxAySw6eIHxH5EX8hj
	7Q+y74Dd0wIjQ4teTQIPyOaulFmW5Ft+nC
X-Received: by 2002:a05:600c:1d11:b0:48a:5574:3a5d with SMTP id 5b1f17b1804b1-4904248ac81mr111740575e9.7.1779549113577;
        Sat, 23 May 2026 08:11:53 -0700 (PDT)
Received: from mini.main.internal ([2a02:908:c211:cd18:36:c98d:902c:348d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d7167dsm12629156f8f.35.2026.05.23.08.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 08:11:52 -0700 (PDT)
From: Goetz Goerisch <ggoerisch@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ggoerisch@gmail.com,
	herbert@gondor.apana.org.au,
	herve.codina@bootlin.com,
	linux-crypto@vger.kernel.org,
	miquel.raynal@bootlin.com,
	paul.louvel@bootlin.com,
	sashal@kernel.org,
	stable@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 3/5] crypto: talitos - stop using crypto_ahash::init
Date: Sat, 23 May 2026 17:10:46 +0200
Message-ID: <20260523151048.14914-4-ggoerisch@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260523151048.14914-1-ggoerisch@gmail.com>
References: <2026052212-aged-amply-7bd8@gregkh>
 <20260523151048.14914-1-ggoerisch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

commit 9826d1d6ed5f86cb3d61610b3b1fe31e96a40418 upstream.

The function pointer crypto_ahash::init is an internal implementation
detail of the ahash API that exists to help it support both ahash and
shash algorithms.  With an upcoming refactoring of how the ahash API
supports shash algorithms, this field will be removed.

Some drivers are invoking crypto_ahash::init to call into their own
code, which is unnecessary and inefficient.  The talitos driver is one
of those drivers.  Make it just call its own code directly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/talitos.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4ca4fbd227bc..a941ec08817e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2119,13 +2119,14 @@ static int ahash_finup(struct ahash_request *areq)
 
 static int ahash_digest(struct ahash_request *areq)
 {
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(areq);
-
-	ahash->init(areq);
-	req_ctx->last = 1;
+	ahash_init(areq);
+	return ahash_finup(areq);
+}
 
-	return ahash_process_req(areq, areq->nbytes);
+static int ahash_digest_sha224_swinit(struct ahash_request *areq)
+{
+	ahash_init_sha224_swinit(areq);
+	return ahash_finup(areq);
 }
 
 static int ahash_export(struct ahash_request *areq, void *out)
@@ -3242,6 +3243,8 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		    (!strcmp(alg->cra_name, "sha224") ||
 		     !strcmp(alg->cra_name, "hmac(sha224)"))) {
 			t_alg->algt.alg.hash.init = ahash_init_sha224_swinit;
+			t_alg->algt.alg.hash.digest =
+				ahash_digest_sha224_swinit;
 			t_alg->algt.desc_hdr_template =
 					DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
 					DESC_HDR_SEL0_MDEUA |
-- 
2.54.0

