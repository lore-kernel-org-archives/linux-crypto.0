Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE38C2FF170;
	Thu,  2 Oct 2025 09:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759398346; cv=none; b=SmwrH1Qdvmm0ASkNm7QYvHCMxPArOYnbdZ3u2ADURevtA0ClzlPmgt6fGL1TTnthuW8jecYjZQwute1xJT3w9smM6rYFA9hl4D4eOtiz63TLbn6KxW+Pabvy9wDkk2E4SE77jsr0vOcD3wnurWxe8Coi7W4NVWgxFa4ubw9t03g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759398346; c=relaxed/simple;
	bh=7jUmaaufXtarhLrR+/Hd8NlSQdOWErxotzH6yX85L0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gK8YWR507PPOvKqkdkkZFRFKyzE/y+GkZe8cR05/LrwpHu3tyoF02XDM6aDFx+ZupVBXuw0SowO40vaioxzGVCiGQzQyHGFbzaUUwGSSfihiYvaqoRwqxBQWMg823EeiXIqctTxNKVGgVrtY1tSVZxcANVmX76YyOOSNcfpRDiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=E0GS3y7W; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="E0GS3y7W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	reply-to; bh=4jtXLdMURoMb2915FzMhIunTyPKQ2o/QHygtZYlc+E0=; b=E0GS3y7WLzrYLMWQ
	IkXyEbUPu+PQDuXnClfNFUamC2/zNiHjIC4IPKLTtTIu9/+JZKUJeIEaQQSsCVUPSHVqs4rbeNYJ0
	GlJE2KNgHhARM1JM4ncfOvUHurCZ34B18aNecdfkg8waUFxtdK/oXMOOcEkJkkb9fWAUc1WLx4Qly
	ZJSLjgtLWWkaJnnH8ZUWlerDU7MLyEZWOq0wFRCbN5i3gHYGL+EuOipMECAazKGqttotD/gBh1VOo
	AMwDZXIFT0j/rty3NTc4fNFDvo1FeffsWWdvkYx9D63hZlTt5X7/kzzPLzl2YG6/3UmEMcKvN8XAm
	M0HwLOaiRCSyTIchhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v4FsZ-009zIE-1R;
	Thu, 02 Oct 2025 17:45:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Oct 2025 17:45:39 +0800
Date: Thu, 2 Oct 2025 17:45:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dave Sun <sunyiqixm@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Elena Petrova <lenaptr@google.com>,
	Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: rng - Ensure set_ent is always present
Message-ID: <aN5JwxZFeAnZXA8n@gondor.apana.org.au>
References: <20250930032824.690214-1-sunyiqixm@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930032824.690214-1-sunyiqixm@gmail.com>

On Tue, Sep 30, 2025 at 11:28:24AM +0800, Dave Sun wrote:
> When CONFIG_CRYPTO_USER_API_RNG_CAVP is enable,
> algif_type_rng->setentropy = rng_setentropy.
> If we setsockopt on a af_alg socket binding a rng
> algorithm with ALG_SET_DRBG_ENTROPY opt, kernel will
> run to ->set_ent in rng_setentropy.
> 
> Since struct rng_alg like jent_alg dose not set set_ent
> which default value is 0, null-ptr-dereference will happen.
> 
> Check ->set_ent before call it.
> 
> Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
> ---
>  crypto/algif_rng.c | 3 +++
>  1 file changed, 3 insertions(+)

Thanks for the report.  I'd prefer to make set_ent always present:

---8<---
Ensure that set_ent is always set since only drbg provides it.

Fixes: 77ebdabe8de7 ("crypto: af_alg - add extra parameters for DRBG interface")
Reported-by: Yiqi Sun <sunyiqixm@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/rng.c b/crypto/rng.c
index b8ae6ebc091d..ee1768c5a400 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -168,6 +168,11 @@ int crypto_del_default_rng(void)
 EXPORT_SYMBOL_GPL(crypto_del_default_rng);
 #endif
 
+static void rng_default_set_ent(struct crypto_rng *tfm, const u8 *data,
+				unsigned int len)
+{
+}
+
 int crypto_register_rng(struct rng_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
@@ -179,6 +184,9 @@ int crypto_register_rng(struct rng_alg *alg)
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_RNG;
 
+	if (!alg->set_ent)
+		alg->set_ent = rng_default_set_ent;
+
 	return crypto_register_alg(base);
 }
 EXPORT_SYMBOL_GPL(crypto_register_rng);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
