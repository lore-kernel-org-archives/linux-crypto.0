Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C37818FDDB;
	Wed,  5 Jun 2024 09:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717579346; cv=none; b=csyFqMvnHd3FuoqwSk41VUoMHfnzsINoQpIyZXtAd4Y1ZFC+A/ZeM3f1k8lxjGlqXoOtuGEZ2aFvFAzcqrzfluvzaLkfM+tRGBOes8VVSZ0h/r/UFQOxTKUmRXj7h7/ijevpvOncd4NEoNe6H8qBcEevLV3ussJSzHhVKCRPLBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717579346; c=relaxed/simple;
	bh=40MnSADK3LWoDP9m99HaEsUKolss8c5YNiBEQPdzTDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oKN/Oz/qTmmib52/Zt87Z9xn1hSqlIQsxXwPUKXz0BGZnWimuyqmtAxlSlQ7Y5BxtUu0/cGs4bEwZDpNCrIhCaQFfrqB5VpmsfB6qREzjgu6Ct9fMyGlpwl4l7dlsAuqDIroKlO+AcNWZSLZ18ryrIYy+tfMP5fC+MDLQ6OKCvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sEmqZ-005tGG-1C;
	Wed, 05 Jun 2024 17:22:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 05 Jun 2024 17:22:21 +0800
Date: Wed, 5 Jun 2024 17:22:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <ZmAuTceqwZlRJqHx@gondor.apana.org.au>
References: <20240603183731.108986-1-ebiggers@kernel.org>
 <20240603183731.108986-7-ebiggers@kernel.org>
 <Zl7gYOMyscYDKZ8_@gondor.apana.org.au>
 <20240604184220.GC1566@sol.localdomain>
 <ZmAthcxC8V3V3sm3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmAthcxC8V3V3sm3@gondor.apana.org.au>

Hi Eric:

I really appreciate your suggestion of having the user driving
multi-request hashing as opposed to the bodge that we had before.
I think that is the perfect way of doing this, similar to how we
handled TCP segmentation with TSO.

However, I really dislike the idea of shoehorning this into shash.
I know you really like shash, but I think there are some clear
benefits to be had by coupling this with ahash.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
