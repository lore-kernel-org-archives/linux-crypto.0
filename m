Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09891B218E;
	Fri, 15 Nov 2024 11:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731670858; cv=none; b=Lzx4F+U88M8gFfAjsxvppbpPohvAvy3zRQmGXu2tmX8xF3etH4Ztrkt1lk45p+GJk+DUa4381rb0pKnVYr8ZUIWbkCs9OICbwq5fp95L8AvjZ1PSAYo2UwB4cwz9MOlPlpT+tCFmURWkdrtZdIVxTTsT97GIdPn8QkQdhiDTjyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731670858; c=relaxed/simple;
	bh=12bdiEiKv483zwlqqKVHS9k/riIHEl2XgpK5E95xqNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Za2317RoX7yCB68KVXkStTrtM0s/ayC8v50URAwLhFHPBI0VdPBAAX9tebEUQJRiUWiVwPTgBLTtjqwjhVriLqoYiBHXHtNx5cP5rhJj+98iAyS6mQ/KKwDLyEJBaOb7EmKj7UoGV/dVB8aOaAr5zZMuab+hqk10DQllPyihlXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=tCLhJN8t; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="tCLhJN8t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=U+8swLwqF2X83AK80kvODCLIKsVeONdbEHVvDm0uwjk=; b=tCLhJN8tAY3prXd8p6rS+OVy+Y
	j+bYIBxLt8CwVkBOQ2qcUGG3PZ1iL67tud/C76A34ge7MHGs8q7sGhbGLQW0eW/G7W/2bh3J+rm8i
	e6f79azl0SzqPmQOpVvFAh1jiDIgXzxanvBLkVD1OWA+RljuigUAUaA63fceQX+DTDgX4CMI3fmcv
	hy93AUtjqmnq5J4Diks1LGLMt6hX+Nsz1QtWjE5wGZU8HDyPOxAIP79/Plxm1EMXUzgslNEsCM1/P
	GPqn9t1ougoVP1Ue+a2E+d4Kn3+nJcDQGLW4F+KHHJgiH+BA7JkuhUdSzeep4SN3A9AqCAEY6k6tc
	fhw+gixA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBugk-00H1lk-2q;
	Fri, 15 Nov 2024 19:40:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Nov 2024 19:40:34 +0800
Date: Fri, 15 Nov 2024 19:40:34 +0800
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
Subject: Re: [PATCH v10 11/22] crypto: amlogic - Introduce hasher
Message-ID: <ZzczMlpfC33yjQ0j@gondor.apana.org.au>
References: <20241108102907.1788584-1-avromanov@salutedevices.com>
 <20241108102907.1788584-12-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108102907.1788584-12-avromanov@salutedevices.com>

On Fri, Nov 08, 2024 at 01:28:56PM +0300, Alexey Romanov wrote:
>
> +struct meson_hasher_req_ctx {
> +	u8 state[SHA256_DIGEST_SIZE + 16] ____cacheline_aligned;
> +	u8 partial[SHA256_BLOCK_SIZE] ____cacheline_aligned;
> +	unsigned int partial_size ____cacheline_aligned;

Is this alignment for DMA? If so you cannot use ___cachealign_aligned
to achieve what you want.

Instead of this check out the crypto_ahash_ctx_dma helper.  For
an example driver doing this for DMA, you could look at caam.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
