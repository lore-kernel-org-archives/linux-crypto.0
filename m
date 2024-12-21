Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7FD2594AE;
	Sat, 21 Dec 2024 11:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734781101; cv=none; b=N38cbTj5lNxOlBsSaG20U36Yn9JAgeSKSfQ12g0OXe0bcou3kr4pOHgr/vmiDWi62RAY//b8DWTW9r0lpNd4M5AYSK2Hpme17UGgch4eq0cpNsQonpOByMlPHHXB0Wa8YBPX3XUcpqmES+F9+N64GxnZu65x5xogRVoRmLtBIbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734781101; c=relaxed/simple;
	bh=n50N6RmGrR5Pv0c6zzWWy51jisPc+uoycdB4pYb7PHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fSYDCq4zmciQ/M1vGWlUNURWLL6TPgFeHvIBEYOO+iJmp18my/gMzOD7+WL/2A3GEzolxjBS80DowrlnlRDZ0vGYxDvaUZjWbAJG2O5/zbU0IgzDndnTY4fdn56OTzS4mGW2Pi8WhV71SuyrQ1v9cDOIZ8nJwAwrr+BIsrqZd7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pZ8VGzYv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pZ8VGzYv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bQUIhxAkFMv4zgOFr0fbELlHZb6jERTJ/olL7lHSpiQ=; b=pZ8VGzYvFkFvpp/zbDpbS10vDs
	WiHBsDzQgCU/VvUvyq4x32+tFiQkzcGc+GKbBJ2vFB1YPj5LTYeN1irBapdglqedGMiD5LUXHAqYB
	Zqgu0KRvd++o6i1Sj/aDB4z8pPM8+xXktrOPWho1rro+2VPnVfrYEHb7OengIYcOl8TelXQLCd+5q
	/M+DA23z5DAfesBZntdMeEIZ1DIzKSqskfgBs4Z2jfaJboDiiB784OF0GwyacMIFHjXlYR97xLNOC
	0xoxYZE3tB+ccktlAxsEi+VV26w85hUW6yWoMOl8jqvw6mqf6VIs9vZodTq7DVYvT53MEqAKjfYY/
	R8rOuAiA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tOxb0-002QbR-28;
	Sat, 21 Dec 2024 19:37:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Dec 2024 19:37:55 +0800
Date: Sat, 21 Dec 2024 19:37:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexey Romanov <avromanov@salutedevices.com>
Cc: neil.armstrong@linaro.org, clabbe@baylibre.com, davem@davemloft.net,
	robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
	krzk+dt@kernel.org, conor+dt@kernel.org, khilman@baylibre.com,
	jbrunet@baylibre.com, martin.blumenstingl@googlemail.com,
	vadim.fedorenko@linux.dev, linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@salutedevices.com
Subject: Re: [PATCH v11 11/22] crypto: amlogic - Introduce hasher
Message-ID: <Z2aokzSrAHpJE_PG@gondor.apana.org.au>
References: <20241213140755.1298323-1-avromanov@salutedevices.com>
 <20241213140755.1298323-12-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213140755.1298323-12-avromanov@salutedevices.com>

On Fri, Dec 13, 2024 at 05:07:44PM +0300, Alexey Romanov wrote:
>
> +static int meson_sha_digest(struct ahash_request *req)
> +{
> +	struct crypto_wait wait;
> +	int ret;
> +
> +	crypto_init_wait(&wait);
> +	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
> +					CRYPTO_TFM_REQ_MAY_BACKLOG,
> +					crypto_req_done, &wait);
> +
> +	meson_sha_init(req);
> +
> +	ret = crypto_wait_req(meson_sha_update(req), &wait);

You cannot sleep in the digest function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
