Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964540;
	b=09IRcdK1myQbHK39ONm/GwizoqhFrblzi2yuS3JJftzTomH2mZiJWjUKJ95dOqMs1R0R
	 IMyqG4Ez3urEkgiqn/OexEdgM1rmAn6RxVFIIoe7DQ/tpARb3xt4UicsBuFYxoqp/XWWt
	 ad89XXLSinpKFXF/3cSvqopf6EcMtcWEnU2MAwK3O2gUJHOgM0XCIKSlnJFhrLzkdgEXZ
	 fr/TUv3Icy8to6RHrvf/Z5BtI2UrN6OrcWZjF4PQZuG6fUkZc+2QE8URwFeGmSvofLdUR
	 1GLxixdEowzAPj4YritsctR7DaxkEJBN7rtL8RYHFU11aD8rDMd0+kyw/J9cpN0hw/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964540;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=MCaTR8rPxVnrVGGweS6NQjmizGycGr26V+tX5BeqXXo=;
	b=GpSprgcunKIscsd5W3qiKJiqYH7SchQTO9Xe00IFgRiZYWhQE06QDULWN5ebKZcDsxD9
	 aA4kdn5yVL3vw82d/sLABerrWriJcp6bS3En5WwsvKShkih8jq6N26waNXBnvIy8Xi4CR
	 1dZTOyfZg/sayPfhZ9086tLL8oen/yOFrLApnatodB8KtzlvFa11KodEXf5YFITfOZQyR
	 MvAuC3FPqKcXlidXguHJ1YL0fXGpCjczAKBBxGeFWP0HsMBRldh+BQRQdooBAEhG05S/h
	 B5O+YfEJyFL1ZWFO1hwKOvIdo7mHdhWNwpk1PZSPiMY0q5g/jVqYRCL45mDpUXgsU1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="k4U5X/2a";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A6F606A329;
	Fri,  6 Nov 2026 11:28:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08A6F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=k4U5X/2a
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=MCaTR8rPxVnrVGGweS6NQjmizGycGr26V+tX5BeqXXo=; 
	b=k4U5X/2aJwDNneqR7YxooqJsH0QfkRzgkNFXxIG9434vhZl1MU58vRayu+ei1PGAVKScPJFKAuw
	YkSidAPFDEs9EPpoft0HSBZUdprxq6euMM8EZ9Np9S+9o7PQyEY1wdsNghuNJXGhtfY3EEzE1sQmd
	Hdv0RDbiiGzfoDtze+Luyd/EW4JBjo4xjptu0g+ZA1h40KHJhu9bJsQmL7Tmk4QTxtWT+oHNBb21W
	rxgr+6fc9h1Ha9Ss99UxeuF0LU3Gshn4SfXGDtE4JxeDfVbWMWaZ9dScDRt1/UoA8dRORmws9XJiZ
	HJWnd+ryGp3MsPIenTwdWZ6gQ3fIurVMgaxA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPI7p-0000000Br7G-388n;
	Fri, 06 Nov 2026 19:28:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:28:53 +0800
Date: Fri, 6 Nov 2026 19:28:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: m-amirpour <ampr.mhd@gmail.com>
Cc: keyrings@vger.kernel.org, dhowells@redhat.com, lukas@wunner.de,
	ignat@linux.win, davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: asymmetric_keys: Fix PKCS#7 selftest error
 reporting
Message-ID: <au259V7gyNDh1j3Z@gondor.apana.org.au>
References: <20261017210513.135540-1-ampr.mhd@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017210513.135540-1-ampr.mhd@gmail.com>

On Sun, Oct 18, 2026 at 12:35:13AM +0330, m-amirpour wrote:
> From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
> 
> pkcs7_parse_message() returns an error pointer on failure, but the
> selftest prints ret, which still contains the result of the previous
> x509_load_certificate_list() call.
> 
> Print the parser's error pointer with %pe so that a failure reports
> the actual parsing error.
> 
> Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
> ---
>  crypto/asymmetric_keys/selftest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
