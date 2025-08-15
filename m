Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6637210E3;
	Fri, 15 Aug 2025 05:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755235756; cv=none; b=Y+AGgnPsRVcCqI4dE6sXH1rhr/8agWIqY0F4OUVr+GGKAqQi0xC5R/T9cUCQ9gEXgFx9M5ihw03cjNezBDYQH+YbwmrJj1dg08FRxSlcbQ0XddgQiimc1+0xLGLz/FOk4yYc6nnTCQ18a+06BgLJe5aZmvgTVaAcUYb/sUaD2+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755235756; c=relaxed/simple;
	bh=/XAYOv4onJR62PLBFNvd8hre+c7yJYiQS/IDb5Nx+J4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMYZDaUTDrt1Yhg0lFb7jtHKqMMOR97pJLynsedYDLO+t6ZE6G0fN8hfaD+DwtpRiAtYHMmVK1nmQWG1c239xlJRJeIFUYQck8tuwIMEXSMUr8CkZEIbqMYtFTUkiepnDNFS/mjB0kcDwgBRpFlt7LoD6Xsf/OXHQPEBQaGmv/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=g4qYgRzm; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="g4qYgRzm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KolVN+Kf+xjXZURWyuqMGoPAKUXu62zPPtuevoWeXKo=; b=g4qYgRzmEMeOBNMTs2dTafhchU
	zcaAwE8qDO3V7gNpW9AV1hB34p2tr8XGtw9HhFuD4R0eYHKnVIAqKNwx5oGARv300JgHLDogSkrFh
	vEJ09EJm8Hd6SmpMk6NLUr+YCaEtPpDxgo8w/jODnDgUQGjPdNcmf2geGRXHaTPSjZGM9MPZo6oXg
	FVzs8tbagZh/JFxeENUzlhKqAvXnNwNFIfPCQuq4nXXAfzPPJPXOiSMnOXjzkjNJi8VsGeiAqHapl
	k9nU2Jh5+0lrMCLcjixa0HKMEWg1h0eXK+a3Fkn0f8LquW9bG17qqsWYylQX/IIvNHAkc2TG9XoZE
	u3GQBFSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ummkJ-00ETYr-1X;
	Fri, 15 Aug 2025 13:28:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Aug 2025 13:28:51 +0800
Date: Fri, 15 Aug 2025 13:28:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v11 18/24] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
Message-ID: <aJ7Fk6RpNc815Ivd@gondor.apana.org.au>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-19-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801043642.8103-19-kanchana.p.sridhar@intel.com>

On Thu, Jul 31, 2025 at 09:36:36PM -0700, Kanchana P Sridhar wrote:
>
> diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
> index ffffd88bbbad3..2325ee18e7a10 100644
> --- a/include/crypto/internal/acompress.h
> +++ b/include/crypto/internal/acompress.h
> @@ -28,6 +28,8 @@
>   *
>   * @compress:	Function performs a compress operation
>   * @decompress:	Function performs a de-compress operation
> + * @get_batch_size:	Maximum batch-size for batching compress/decompress
> + *			operations.
>   * @init:	Initialize the cryptographic transformation object.
>   *		This function is used to initialize the cryptographic
>   *		transformation object. This function is called only once at
> @@ -46,6 +48,7 @@
>  struct acomp_alg {
>  	int (*compress)(struct acomp_req *req);
>  	int (*decompress)(struct acomp_req *req);
> +	unsigned int (*get_batch_size)(void);

I can't imagine a situation where this needs to be dynamic.
Please just make it a static value rather than a callback function.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
