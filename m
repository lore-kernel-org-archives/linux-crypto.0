Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB1B2E63C
	for <linux-crypto@vger.kernel.org>; Fri, 26 Dec 2025 00:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766709518; cv=none; b=bq6HAPoHGkMBAaVs8bD5G3vu7+eYvqKkfmMtViw0pTNHPz/BKTX7anrSVHXtDa5gD1akGpOoexjDHDmpvxJShHrh+K7IQNlzFox+LpOnRbSBlNAOnVbRhGf8EUkfcnOStdAxhlPAKlXR0B4bevwovfKFqoFzM0LgExEjxEBMjx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766709518; c=relaxed/simple;
	bh=xVNxNiqdsWnu2sbONYkEuqBQ/o7hOnYLNVYwKLE75HI=;
	h=Date:Message-ID:In-Reply-To:References:From:Subject:To:Cc; b=CVRiSjt7PvIZ7rs1bsgftib15u0J4SdiAY5JT0JjMWJq4DN8+A5Sw9twmL061oYGZJKQRREqGTplnMmWfeo7W9fpPn/RgXLRfkbPI0rtgFuZ9Apr2qwpwVZwGuyk1ZqTaKvAJLt8A81Gzze/DcAtfLqUI8PLooz9u4FimGBviA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Ew/F23Le; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Ew/F23Le"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Cc:To:Subject:From:References:In-Reply-To:
	Message-ID:Date:cc:to:subject:message-id:date:from:content-type:mime-version:
	reply-to; bh=bBJXp324EjRbt4hdgARc7ZA8O7oMICZ/6QuN6KbeNhM=; b=Ew/F23LeOGuuGCLG
	qGNEujZohz/8w/0tYB5ZUrouGVDPGJcMOHlRqFYMNjU4Tjt9ZEbA96nu4XP/4b7ZDoLgpBNlLDL25
	MdvBcBRhUb7zNV0W151bBNywY40iE2UVPG9blNVCjQkvr7JHK7ad3yTyuqgFZm7SmQx45VlI4xVR+
	8K+OoJGZGTLNTOv0Clbp9/N4wgwPiVRvuitAIBgEJ3sYGfupAmS8VlvB8hFMq8QLJBpgrmMQqVu4g
	dSZVHpKWUnXf/VzkpAJnnx+hn6xPVGy1gqxRjOxRfcdB8nfGMxl9PIR3qEgJrzHXzbRPJfNUUsBtj
	7rKrUGiggMvuoucBSQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vYvqf-00CY83-38;
	Fri, 26 Dec 2025 08:38:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Dec 2025 08:38:29 +0800
Date: Fri, 26 Dec 2025 08:38:29 +0800
Message-ID: <9aab007e003c291a549a0b1794854d5d83f9da27.1766709379.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1766709379.git.herbert@gondor.apana.org.au>
References: <cover.1766709379.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/3] crypto: acomp - Add trivial segmentation wrapper
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add a trivial segmentation wrapper that only supports compression
with a segment count of exactly one.

The reason is that the first user zswap will only allocate the
extra memory if the underlying algorithm supports segmentation,
and otherwise only one segment will be given at a time.

Having this wrapper means that the same calling convention can
be used for all algorithms, regardless of segmentation support.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c         | 25 ++++++++++++++++++++++---
 include/crypto/acompress.h |  1 +
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e3..d97a90a5ee46 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -170,8 +170,13 @@ static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
 
 	state->compl = req->base.complete;
 	state->data = req->base.data;
+	state->unit_size = req->unit_size;
+	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
+					  CRYPTO_ACOMP_REQ_DST_VIRT);
+
 	req->base.complete = cplt;
 	req->base.data = state;
+	req->unit_size = 0;
 }
 
 static void acomp_restore_req(struct acomp_req *req)
@@ -180,6 +185,7 @@ static void acomp_restore_req(struct acomp_req *req)
 
 	req->base.complete = state->compl;
 	req->base.data = state->data;
+	req->unit_size = state->unit_size;
 }
 
 static void acomp_reqchain_virt(struct acomp_req *req)
@@ -198,9 +204,6 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 {
 	struct acomp_req_chain *state = &req->chain;
 
-	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
-					  CRYPTO_ACOMP_REQ_DST_VIRT);
-
 	if (acomp_request_src_isvirt(req)) {
 		unsigned int slen = req->slen;
 		const u8 *svirt = req->svirt;
@@ -248,6 +251,10 @@ static int acomp_reqchain_finish(struct acomp_req *req, int err)
 {
 	acomp_reqchain_virt(req);
 	acomp_restore_req(req);
+
+	if (req->unit_size)
+		req->dst->length = err ?: req->dlen;
+
 	return err;
 }
 
@@ -272,6 +279,9 @@ static int acomp_do_req_chain(struct acomp_req *req, bool comp)
 {
 	int err;
 
+	if (req->unit_size && req->slen > req->unit_size)
+		return -ENOSYS;
+
 	acomp_save_req(req, acomp_reqchain_done);
 
 	err = acomp_do_one_req(req, comp);
@@ -287,6 +297,13 @@ int crypto_acomp_compress(struct acomp_req *req)
 
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
+	if (req->unit_size) {
+		if (!acomp_request_issg(req))
+			return -EINVAL;
+		if (crypto_acomp_req_seg(tfm))
+			return crypto_acomp_reqtfm(req)->compress(req);
+		return acomp_do_req_chain(req, true);
+	}
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
 		return crypto_acomp_reqtfm(req)->compress(req);
 	return acomp_do_req_chain(req, true);
@@ -299,6 +316,8 @@ int crypto_acomp_decompress(struct acomp_req *req)
 
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
+	if (req->unit_size)
+		return -ENOSYS;
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
 		return crypto_acomp_reqtfm(req)->decompress(req);
 	return acomp_do_req_chain(req, false);
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 0f1334168f1b..965eab7738ba 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -67,6 +67,7 @@ struct acomp_req_chain {
 		struct folio *dfolio;
 	};
 	u32 flags;
+	u32 unit_size;
 };
 
 /**
-- 
2.47.3

