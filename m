Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A432F2EEE94;
	Fri, 17 Jul 2026 07:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784274338; cv=none; b=sExJ+Svv7HJvMH2w97M2vYI+CLCgHKEYC9YLhDBNQ9uS36ivYkNmSv3FigFdPMXMLW31y+Ljyfg8tyTs4sgWpGENVBo2pF0UzYAtmj4x5RRW6jE5b1xVghea8wRBc/qQd4csJyaPkSQMiVL7r4HQZzu3OWPUPIYYRh0HdaXBHQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784274338; c=relaxed/simple;
	bh=wMwMzb/E8bpvHWyoLwAsjrOKGxAhEc4/y2WQhOKEALg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J8oEy1I+Iu5uUFc01mu3v8xenxaDR3+607LVzJ6PYCaGvs5l2OV2gW5NfDpJawVVkCt0454SUYbMqNRFyAsTPbcrtM/p8CdcpPbYBOXrUz+Bpyn9yqax4nPl6zzF9W2j5E+y6/+Vu3Y5x36h0CEirAmbhhQ4i6hMQbRkYNOfwZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qFS3WRgf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qFS3WRgf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=zXLlo12uGh+Q43CGcDppKId8OmLaUv2wT03uxv6KRcI=; 
	b=qFS3WRgfQ75IjLIkKY4mwsrNIAcKUG005CDrQV5D8CtWn20F0oxQclbKQL7qPnaIFqgGj0kjuzb
	laqsxGyC3B1OpP9Quvmd1W8AvICQhFYXFs9B+y/QLhF1zhd1fACFIXxn0ouintf6ijeJ1zcobNTw7
	t5Mt1dERYEwqxgE0o7IryPo51qq4PfltkHtI/VIB7jemyre23nUh8H2Gnn8F8kAY8BBpRRigLfAeY
	8ZKd5Uy52zA73uR18gXytRgHT1IHcVLljHqYlxXB1w3WvOI94nYooGOCw6FpcYbUrvnNRF054sfJc
	8cDh3sIQ3ZPhL9mXdoeP9mTnJg6kzgbHMktw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdG0-0000000ENR6-0V3T;
	Fri, 17 Jul 2026 15:45:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 17:45:16 +1000
Date: Fri, 17 Jul 2026 17:45:16 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	brgl@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5 1/7] crypto: qce - Fix HMAC self-test failures for
 empty messages
Message-ID: <alndjORIwYXPxU-C@gondor.apana.org.au>
References: <20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com>
 <20260706-qce-fix-self-tests-v5-1-86f461ff1829@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706-qce-fix-self-tests-v5-1-86f461ff1829@oss.qualcomm.com>

On Mon, Jul 06, 2026 at 03:53:52PM +0200, Bartosz Golaszewski wrote:
>
> @@ -280,6 +299,8 @@ static int qce_ahash_final(struct ahash_request *req)
>  		if (tmpl->hash_zero)
>  			memcpy(req->result, tmpl->hash_zero,
>  					tmpl->alg.ahash.halg.digestsize);
> +		else if (IS_SHA_HMAC(rctx->flags))
> +			return qce_ahash_hmac_zero(req);
>  		return 0;
>  	}

This is still broken because the user can import a non-zero partial
hash state with no buffer held for your hardware.  So you need to make
the driver able to handle the case of finalization with no extra
data.

The easiest is to re-import the partial hash state into the fallback
and finalize that instead.

IOW change this so that it handles all zero-length finalizations and
not just the empty hash case.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
