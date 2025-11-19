Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E311E1E1C;
	Wed, 19 Nov 2025 04:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763527123; cv=none; b=WUT1AoTEZg7G1yg8x8zkDIyketlnPKvRw1gjP6Ph6Y+JxotUgl8IeKivaHn1GL5OF2B/Nb9eBfKjh7U+2FU8UAuw+HsPEOzWyAb3UsW49oOFJBlMYaW/zhGUyrkOb5Ld82A3dCudzGC8qtheOZL1zwsWnD9Gypwp1kdsTqRrT0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763527123; c=relaxed/simple;
	bh=3iYnV2APAfKcWv3J6sIcxfy8P/u2uVbuCK+FxI4RvqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWy+Cz63t42yQRtOxSeyHrHoTJRkrETUklJMSlH5McevBksfFfeO2tahulVRJnQHZDx9rPfq0SnlOoprsONtE9pymD5VJt6C8elGYXIqefrcRc9OcSB8vzmyOw0b46ft/kIRNmvceidOFtAHd0q/bhmx6cdy/N4WvT/9oBYk2L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fBn/Ktyg; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fBn/Ktyg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=O/97SlunYFZGuq7T38VDsyylG1LcCUBunsdRAcz52CE=; 
	b=fBn/KtygmzSMxbtPbC4QrcLT4SWai8U9Aa+y0cA1f2wV2UjW0d12dtSi5JIu0XGxpTsTiDGhivB
	yi2okr87eBgjijIN+TDlPXgjyA0cHcInFcuMEv/4sjZexRVzNCFA1/095SYpWHVI/BDLPJMW+JUAS
	eTdL5thbjLe0HhTSAcUzIYuZqdtrFroPqtKatUjQnc2YnMA+2G7qA6n189WRkdBq5FAhh5ir7zj2i
	ofQzNkK2nZFpSGwD8QWFvZWqTUkG0JPxE6q5c+IHi7rm/TeUUKGNcojsUahsU2fZ2TiRBIQN3XuIl
	e1mpnzAfTf7y07sgH3u7DF4+BU2iuM2qq5NA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vLZxW-004DyL-1p;
	Wed, 19 Nov 2025 12:38:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Nov 2025 12:38:22 +0800
Date: Wed, 19 Nov 2025 12:38:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>
Subject: [v2 PATCH] crypto: drbg - Delete unused ctx from struct sdesc
Message-ID: <aR1JvnpTBomcKAMZ@gondor.apana.org.au>
References: <aRHCKMGDbWkXIY8f@kspp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRHCKMGDbWkXIY8f@kspp>

On Mon, Nov 10, 2025 at 07:44:56PM +0900, Gustavo A. R. Silva wrote:
>
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 511a27c91813..e9f9775c237f 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1442,9 +1442,12 @@ static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
>  
>  #if defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_HMAC)
>  struct sdesc {
> -	struct shash_desc shash;
> -	char ctx[];
> +	/* Must be last as it ends in a flexible-array member. */
> +	TRAILING_OVERLAP(struct shash_desc, shash, __ctx,
> +		char ctx[];
> +	);
>  };
> +static_assert(offsetof(struct sdesc, shash.__ctx) == offsetof(struct sdesc, ctx));

This isn't even used.  Just delete it:

---8<---
The ctx array in struct sdesc is never used.  Delete it as it's
bogus since the previous member ends with a flexible array.

Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 511a27c91813..1d433dae9955 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1443,7 +1443,6 @@ static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
 #if defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_HMAC)
 struct sdesc {
 	struct shash_desc shash;
-	char ctx[];
 };
 
 static int drbg_init_hash_kernel(struct drbg_state *drbg)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
