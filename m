Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4662DEB97;
	Mon,  5 May 2025 23:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486137; cv=none; b=QIq7zsDzsEl3tMUJUbg0suzme13ZHA24IHw0H4iJtdnB7W3vFA5B35/33K14PQqrab3avPAa9v9R+zBnen9CjoCkKzGi7qNj5ctN6XTpFS2rMvmcZ80lX6ZlpgGeb5aUf4Wf8Xgzj3pWZ+26Zsl+gdK/XlWx2dEKjJdWDkg5yxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486137; c=relaxed/simple;
	bh=1POYf0LwGw6uahw9yIbWbRozUWFElzKFLk8W9wbKX/0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QclX0ZTs36htxyW9BDQrc+l+PdQTHmgDP9XHrq8C7afQjaXzo6yW7cP5OHaHLESFVWNXytEUPJnF5Vp2ngYJN26KkTeHFjVPPEk1kWot8SYCeUxv9IPAIpwaeSB5m9LXnvIn4fQmQDqQhMSA7EMoZomOfn3JyJwzofxk2oYygPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h0Y4C8l4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h0Y4C8l4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29BFC4CEED;
	Mon,  5 May 2025 23:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486136;
	bh=1POYf0LwGw6uahw9yIbWbRozUWFElzKFLk8W9wbKX/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0Y4C8l4cNVl9SA0/iDB7fwC/nw11kiEdpioaUagTkt3mkYE5oynCWTBTK/968CWL
	 73vPYFjrX4orNhVUMbUQDMON9q+lSVLqpn/P2zzkGSM2U9LrBxxCTeH+kjrw6Dlnu7
	 lUzBOZVxygu3gojhBiLhj7lNwLkRMVHkG8yMMEg/mA481lJfToJuHlD6KJolVqXQuR
	 sx0bleNGj+DLTKBYhb6iK4vjWhEX86OuNPVdbFwVPgbAWlBtT+SiKYBYmHQX4eMNHe
	 299D33xAFp3TmXKTCRNPL4yPIBlLrWikg/X0N3dwwhj3TOibbhNeHEwyrCXmvinADJ
	 /ry2xudBXApcA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 170/294] crypto: ahash - Set default reqsize from ahash_alg
Date: Mon,  5 May 2025 18:54:30 -0400
Message-Id: <20250505225634.2688578-170-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 9e01aaa1033d6e40f8d7cf4f20931a61ce9e3f04 ]

Add a reqsize field to struct ahash_alg and use it to set the
default reqsize so that algorithms with a static reqsize are
not forced to create an init_tfm function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ahash.c        | 4 ++++
 include/crypto/hash.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 709ef09407991..6168f3532f552 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -427,6 +427,7 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	hash->setkey = ahash_nosetkey;
 
 	crypto_ahash_set_statesize(hash, alg->halg.statesize);
+	crypto_ahash_set_reqsize(hash, alg->reqsize);
 
 	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
 		return crypto_init_shash_ops_async(tfm);
@@ -599,6 +600,9 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	if (alg->halg.statesize == 0)
 		return -EINVAL;
 
+	if (alg->reqsize && alg->reqsize < alg->halg.statesize)
+		return -EINVAL;
+
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index f7c2a22cd776d..c0d472fdc82e6 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -153,6 +153,7 @@ struct ahash_request {
  *	      This is a counterpart to @init_tfm, used to remove
  *	      various changes set in @init_tfm.
  * @clone_tfm: Copy transform into new object, may allocate memory.
+ * @reqsize: Size of the request context.
  * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
@@ -169,6 +170,8 @@ struct ahash_alg {
 	void (*exit_tfm)(struct crypto_ahash *tfm);
 	int (*clone_tfm)(struct crypto_ahash *dst, struct crypto_ahash *src);
 
+	unsigned int reqsize;
+
 	struct hash_alg_common halg;
 };
 
-- 
2.39.5

