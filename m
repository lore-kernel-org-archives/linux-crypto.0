Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4724A2D73AE
	for <linux-crypto@vger.kernel.org>; Sat, 28 Mar 2026 10:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774693290; cv=none; b=BgA2y4J48L1QQl/z8XkzlKqbyTgkzVYPfqz98yNCt2f0QeLOT0z9mnnQUODYzyBMn7j3y/8DnfkF5ule2rj8X6HcdiHBz45HAgAwvt3JfzC/EZya0Q5goIwQN31xZkdETIuffuCUe8wzyiUmweYmmIiDnyUHZDnhwjwd7kT/QP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774693290; c=relaxed/simple;
	bh=b1AvOAjOnFOHUoR7Bg3+EOMLozF3Osp3KSGbgJYNyp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXxiG/pRgNrBA/NjbOaV5aQ4qKHUMdNBibkgV56D5Gm8ZfQvu98IdLcIh3NGfzqWjNaPcwvIggPJrvOz1NwTjQfpJ+uhFQZY8ja1KeJyfU91XPzD/ELj/LWdeYBsuj22hE/aqG1YNpNeB181/xUuMxKwFmAB++TeXYZLczAKGr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fk7a7F+B; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fk7a7F+B"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774693287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zr9JyyQ2oSaC5o8BZfrTVXPneBP79fge+m+s47PINqA=;
	b=Fk7a7F+BFqH1FcjzrlmwdjKEv0plNvS9GQLBRno4AFm1GiPI+sbVbL1AJWRZz2qJNR6aOg
	Ws02+cH2BCcb5J2f5iXGGl43WYUfLnEHVtyqH1eWwkW6aeoOKg6weof0Np0iZFQX93R2PF
	IC/E18tzKVh2OPELi7toXVR+3A49tR8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: img-hash - drop redundant return variable
Date: Sat, 28 Mar 2026 11:20:46 +0100
Message-ID: <20260328102043.85271-6-thorsten.blum@linux.dev>
In-Reply-To: <20260328102043.85271-4-thorsten.blum@linux.dev>
References: <20260328102043.85271-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1091; i=thorsten.blum@linux.dev; h=from:subject; bh=b1AvOAjOnFOHUoR7Bg3+EOMLozF3Osp3KSGbgJYNyp8=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnHVzc12rEpWq4za74WfkOY6/zO3xseubH+zsqskkrcm xy9K3VdRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAEwkvZ2RYenn6NlszzrXcWor vH6lWWnypmnTJFPH2bwsLt7v5ic1STIyvFAufGwzQVlUkKHCxlnsz6nr9wMNi7IjTHceN44QMpr OAgA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In img_hash_digest(), remove the redundant return variable 'err' and
return img_hash_handle_queue() directly.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/img-hash.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index f2d00b1d6b24..c0467185ee42 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -629,7 +629,6 @@ static int img_hash_digest(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct img_hash_ctx *tctx = crypto_ahash_ctx(tfm);
 	struct img_hash_request_ctx *ctx = ahash_request_ctx(req);
-	int err;
 
 	spin_lock(&img_hash.lock);
 	if (!tctx->hdev)
@@ -666,9 +665,7 @@ static int img_hash_digest(struct ahash_request *req)
 	ctx->sgfirst = req->src;
 	ctx->nents = sg_nents(ctx->sg);
 
-	err = img_hash_handle_queue(ctx->hdev, req);
-
-	return err;
+	return img_hash_handle_queue(ctx->hdev, req);
 }
 
 static int img_hash_cra_init(struct crypto_tfm *tfm, const char *alg_name)
