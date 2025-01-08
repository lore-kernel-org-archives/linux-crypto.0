Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66C025949C;
	Wed,  8 Jan 2025 01:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736300352; cv=none; b=gapooo8uUk6ksMjttZTR2+C8kcj+xu+YmD5EFc5t/WgGqqeO/rOlzstaDaezsdK7JybG1I8sfFaLIM4wOJ/8H1cjlTvUhLVSAGiVKn7NGdlWJaqtMJXVTlYYxTzzr1DB3ZDugX4dFxErlcfcQFPQp8ifRTAuTzFTpPRVaRzMqrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736300352; c=relaxed/simple;
	bh=G2DnabXe3PCdgXlb8CYtSyv125GbyMyOqHLMi70H/8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EnrZUxkEAM2HsWPoE06Fsznnz+incjE9Huphl7NatmmnnnzRVoKJPI8D2o7Agzu4eSZF3mWGwH3cgg/1bRrmoKAau6fRTQcqcjh5yOyhfA4a5AehxGYClTDf7iN+CxVjXK8GvqHBbuCIxSMDWy/RZlIHdxXOIpAifbvqp+rTMpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CGWfTnnI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CGWfTnnI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WTRyKpQLZt+wxeGKYjKq847cfqdgXgNFoNJzOXTtRLY=; b=CGWfTnnI+Ww32FDuEam6YExJZi
	bvdtPrHBdL8StkL72xr+umP3c5ScEa5l73xvxY/ml8Zl3xwH4QIIK5rIU6Z7wINVJhcXhlResqEyD
	VXE1t90+jPCFzdMDmG4jTIriU8kwPp7MI+VLCipJT1jRHYUGUrL9QyERItAbdwhpftrc/kwqDaQvg
	SRg4Fktscihlxi/1+XxAG3d6VKECC0WNfrz1XFVtcTVu9/0tei6HeSgA7dAJItWdaHQzc6uG8nP7Q
	26wKjctkaO1YPH+Bcya8zHZjGcGDDIja7ODnOe/N/NMNkxSrWV/00nOj1+ALk5P1wo0phG0O7nsI1
	oKdFDgbQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tVKp6-006wlD-1w;
	Wed, 08 Jan 2025 09:38:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 Jan 2025 09:38:49 +0800
Date: Wed, 8 Jan 2025 09:38:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosryahmed@google.com>, Eric Biggers <ebiggers@kernel.org>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
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
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Message-ID: <Z33XKZozGeNM0uxr@gondor.apana.org.au>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-3-kanchana.p.sridhar@intel.com>
 <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
 <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
 <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>

On Mon, Jan 06, 2025 at 07:10:53PM -0800, Yosry Ahmed wrote:
>
> The main problem is memory usage. Zswap needs a PAGE_SIZE*2-sized
> buffer for each request on each CPU. We preallocate these buffers to
> avoid trying to allocate this much memory in the reclaim path (i.e.
> potentially allocating two pages to reclaim one).

What if we allowed each acomp request to take a whole folio?
That would mean you'd only need to allocate one request per
folio, regardless of how big it is.

Eric, we could do something similar with ahash.  Allow the
user to supply a folio (or scatterlist entry) instead of a
single page, and then cut it up based on a unit-size supplied
by the user (e.g., 512 bytes for sector-based users).  That
would mean just a single request object as long as your input
is a folio or something similar.

Is this something that you could use in fs/verity? You'd still
need to allocate enough memory to store the output hashes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
