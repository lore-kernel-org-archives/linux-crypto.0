Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969321EE7DD
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772292; cv=none; b=HWpWapZq17v2vAXFwHlo8dAF1o8Iz1rG/JjaioSGjUPoyv37RZ6la4Mb/yCyEoxcOl2m3uuq5o0eQd1uXFSlJTXMZcc83iapmdnoQgdY8O5my59dWt+zun/RFnR0vLBYSGFMbFrbvnunvL9i+jugGodz0Nvc1OKQ/4/AutrKglA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772292; c=relaxed/simple;
	bh=dnZAK361vmWixKcZ7acGRjvfLvttpdJxa1vRNfoj5IE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYzf6NZoZFT2ZM7jEOujrAQ9tgIDymr+IMSyzJBI0ruRU08/VSjW/p4DI1/rtbYyVHLFLQuAKeLQrKd/2oxvtuupNEoAUDCb3dtPj97Q1y8KwhTKA6B3e6QsvAVfmPFASrXxvf7mqvbiZRmUm/L5mKDg/KDxwhgmKTV0/ioUhnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PUEGMvVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PUEGMvVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23546C4CECE
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772292;
	bh=dnZAK361vmWixKcZ7acGRjvfLvttpdJxa1vRNfoj5IE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=PUEGMvVtN7BaRuL59lUDOjAG7JYDy7LGoFRHtP+MQVNPrwk1VPQWfTpy3P/OBHByy
	 4YFKiJ0tH1yTN2IkFetJ8UZX/AKrVh9VfjiY3qX/Dhj0Ac78GN1QrliwGuWJ0c1sBf
	 MBzW2F7lXRV1f6ExkrgYp+rSsIDAglQo8cDPK/Ta9jzbx9O4nNKJNOiVsO4xHha2mj
	 r4m3SH6OslKSPYO5Or15px6Qhb0eJ5mLhuR8seRh26u0vuXF93SLy/+J9gg3pF/eaz
	 BOVzsQ5jJAKUVWJu3LmXB4UKcMXzmaskO27IIOqL9A0FBKdd41kyqnujsAA1TTWONm
	 C7lSvDPBxSCDA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 07/29] crypto: skcipher - optimize initializing skcipher_walk fields
Date: Sat, 21 Dec 2024 01:10:34 -0800
Message-ID: <20241221091056.282098-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The helper functions like crypto_skcipher_blocksize() take in a pointer
to a tfm object, but they actually return properties of the algorithm.
As the Linux kernel is compiled with -fno-strict-aliasing, the compiler
has to assume that the writes to struct skcipher_walk could clobber the
tfm's pointer to its algorithm.  Thus it gets repeatedly reloaded in the
generated code.  Therefore, replace the use of these helper functions
with staightforward accesses to the struct fields.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index e54d1ad46566..7ef2e4ddf07a 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -306,12 +306,12 @@ static int skcipher_walk_first(struct skcipher_walk *walk)
 }
 
 int skcipher_walk_virt(struct skcipher_walk *walk,
 		       struct skcipher_request *req, bool atomic)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	const struct skcipher_alg *alg =
+		crypto_skcipher_alg(crypto_skcipher_reqtfm(req));
 
 	might_sleep_if(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 
 	walk->total = req->cryptlen;
 	walk->nbytes = 0;
@@ -326,13 +326,13 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
 		return 0;
 
 	scatterwalk_start(&walk->in, req->src);
 	scatterwalk_start(&walk->out, req->dst);
 
-	walk->blocksize = crypto_skcipher_blocksize(tfm);
-	walk->ivsize = crypto_skcipher_ivsize(tfm);
-	walk->alignmask = crypto_skcipher_alignmask(tfm);
+	walk->blocksize = alg->base.cra_blocksize;
+	walk->ivsize = alg->co.ivsize;
+	walk->alignmask = alg->base.cra_alignmask;
 
 	if (alg->co.base.cra_type != &crypto_skcipher_type)
 		walk->stride = alg->co.chunksize;
 	else
 		walk->stride = alg->walksize;
@@ -342,11 +342,11 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
 EXPORT_SYMBOL_GPL(skcipher_walk_virt);
 
 static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 				     struct aead_request *req, bool atomic)
 {
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const struct aead_alg *alg = crypto_aead_alg(crypto_aead_reqtfm(req));
 
 	walk->nbytes = 0;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
 	if ((req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) && !atomic)
@@ -364,14 +364,14 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 	scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
 
 	scatterwalk_done(&walk->in, 0, walk->total);
 	scatterwalk_done(&walk->out, 0, walk->total);
 
-	walk->blocksize = crypto_aead_blocksize(tfm);
-	walk->stride = crypto_aead_chunksize(tfm);
-	walk->ivsize = crypto_aead_ivsize(tfm);
-	walk->alignmask = crypto_aead_alignmask(tfm);
+	walk->blocksize = alg->base.cra_blocksize;
+	walk->stride = alg->chunksize;
+	walk->ivsize = alg->ivsize;
+	walk->alignmask = alg->base.cra_alignmask;
 
 	return skcipher_walk_first(walk);
 }
 
 int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
-- 
2.47.1

