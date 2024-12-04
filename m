Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3120BEADA;
	Wed,  4 Dec 2024 01:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733276547; cv=none; b=D597WxJYPS1BbgzvIjgRKO9NxrsLjCzex3lOo2GZwucrHYI2WFNTp6s5ZOX0aiYb7JWTwgszoESPxlEzxxjiOf0YfF8paYetVyAsFUQ0rOU9x2uf4KrnHpUQuZeDTpeZlCUNtulSA7ls1g9iCqx/b1HkpQhAI8gAeWeVhualVg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733276547; c=relaxed/simple;
	bh=i515qrN+o0Y2z+dHBSVxbSEQvqfs+eKhveR5GlSIk+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fY2eRr0H8c+Smp225OUC9UxCAOVB7aFX4M0tQ2dL1uOyUMVz71VtyI0gcdWq66ARV13IeeDDteomcV0fz1pnh8TJXW7Vg+4kZbNBLeZmBCNqSJxEVSs6iw2rJeDJ7mNAPI3AFCPOGdSBQdNp08kcMvJy7n/BuJ0C2f9W+jIO+og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gaOrulX2; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gaOrulX2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3xrjkPPSEAkSa3WwcdPGjAiriHQqDB0jIWGmrmCx1tU=; b=gaOrulX2iAl1bw+sotyIbP4wCO
	K2GXLH7VGD+kH8eVws+7zsX+f8RiiRcutQYuFxNtEvAV9qY8enCbNUXyGuspGSDCimja29Q3x+7jI
	QX6Aj+Uhp79DM01JTEzbLed2jkTzRywQ7hQF7gHpif6Kuo9hNehIPV5jRchasS9UPa7391HkTXf+W
	bTvfJENlP2yOlcqCClOCrRMKwjzid+hUlHczhyswdOXR6AQEYgGsldJqjLUcoYYUbfTd8AjiZMHei
	5ZSb9KZATf2oqwyOycMUFoy4/WLFyWxHzu6eFJ90AM68bwq03qx1R7uEE41Vitw7p5mH+xEZYZ0V5
	MD2BST/g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tIeP0-003Lnb-2j;
	Wed, 04 Dec 2024 09:42:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Dec 2024 09:42:06 +0800
Date: Wed, 4 Dec 2024 09:42:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"ying.huang@intel.com" <ying.huang@intel.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
Message-ID: <Z0-zboLmrybOt8pv@gondor.apana.org.au>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-10-kanchana.p.sridhar@intel.com>
 <CAKEwX=PmKWH4Z4Py9Jti9fcD6qCYJBBRrDF48qdmo8-i+LzzfA@mail.gmail.com>
 <SJ0PR11MB56783454B5985ACD48744772C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <Z066p53LoISwqkmX@gondor.apana.org.au>
 <SJ0PR11MB5678AAEF4F62773847E6307FC9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbui2MTkkGA6_+RDA0oZW2m3rMnUTKp1Fp6tPqp2QLgKw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkbui2MTkkGA6_+RDA0oZW2m3rMnUTKp1Fp6tPqp2QLgKw@mail.gmail.com>

On Tue, Dec 03, 2024 at 01:44:00PM -0800, Yosry Ahmed wrote:
>
> Does this mean that instead of zswap breaking down the folio into
> SWAP_CRYPTO_BATCH_SIZE -sized batches, we pass all the pages to the
> crypto layer and let it do the batching as it pleases?

You provide as much (or little) as you're comfortable with.  Just
treat the acomp API as one that can take as much as you want to
give it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
