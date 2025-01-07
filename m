Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CD52594A3;
	Tue,  7 Jan 2025 02:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215816; cv=none; b=l6f6BNIjOPz96ycV+P/t7PFDs35MiAjnaq7gXSRIOIW1tuwl+nepN2YaScKgQOA/kP1faZUBm913FSZAOik23ONpDdiq9uOvUmppgw3eNLYtfI2ePMZJgFSy3XYLINuQTKe61KW69QCWIgWZ5i7D6tgQM349FfY8AuEaCsPPalw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215816; c=relaxed/simple;
	bh=E3A8ZBOogyrsdOro+iZ7gY20PalIJ9rtaVfH+Pxsutw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ScecOBPaEUMPU9gM+fYkfze6/vLplTT4Rt64fPLiRHjECSMZLD29RDM+OgSuvnuciDRXQz6bUMdd9yse71C6hAxvjfUxMdOGDXR9SjRrVELvENH8mtnga+2U75rjKtKDkFvwBm2YO/WEM3vHyf0bq96pmKWZkojgpM/j2aow+xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kYAog8Oe; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kYAog8Oe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qh3ZeCqgmb8Xxxc1QylNLIzHsWn1fOEXXnA1O1xVUXU=; b=kYAog8Oe04V9w1rMayHKdU+tAU
	kWFxOd547psU4MzVgOBS1Tlaej61P5hcNmgfRAj6XlV4itb628Zj8cNI+1YSQsT7QdnssRIgvlIin
	4W4Wh3Fml9pc1JqrnVG6S2lgqJBx+0W4TvRE4X+Mfq3yD91b/zXytChKM1LbhVwTHpSagiYHPoCJO
	CVJ2Io4J01HodJaUDupQwKZqch8+FmAzQMQi93/NbTyXlogkh7MLyh7wbBHJYK3wXxu4P4yKq1NMx
	6Ex4FARWEBRNABHRJfBY56Inp+lKpcBFjPmfnhoYKQmrQ5Is3lmv7LUF4tWgXmZyb58CrPVt8Q5GS
	oz4aZH3Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tUykh-006WZ1-2F;
	Tue, 07 Jan 2025 10:04:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 07 Jan 2025 10:04:48 +0800
Date: Tue, 7 Jan 2025 10:04:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"yosryahmed@google.com" <yosryahmed@google.com>,
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
Message-ID: <Z3yLwMY7n7WfuoYR@gondor.apana.org.au>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-3-kanchana.p.sridhar@intel.com>
 <Z2_lAGctG0DDSCIH@gondor.apana.org.au>
 <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>

On Mon, Jan 06, 2025 at 05:37:07PM +0000, Sridhar, Kanchana P wrote:
>
> Internally, acomp_do_req_chain() would sequentially process the
> request chain by:

acomp_do_req_chain is just interim scaffolding.  It will disappear
once we convert the underlying algorithms to acomp and support
chaining natively.  For example, the ahash version looked like this:

https://lore.kernel.org/all/6fc95eb867115e898fb6cca4a9470d147a5587bd.1730021644.git.herbert@gondor.apana.org.au/

Its final form, the user will supply a chained request that goes
directly to the algorithm which can then process it in one go.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
